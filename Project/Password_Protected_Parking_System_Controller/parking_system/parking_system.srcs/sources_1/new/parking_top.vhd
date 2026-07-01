library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce_pulse is
    generic (
        STABLE_COUNT : natural := 2000000
    );
    Port (
        clk    : in  STD_LOGIC;
        btn_in : in  STD_LOGIC;
        pulse  : out STD_LOGIC
    );
end debounce_pulse;

architecture Behavioral of debounce_pulse is
    signal sync0  : STD_LOGIC := '0';
    signal sync1  : STD_LOGIC := '0';
    signal stable : STD_LOGIC := '0';
    signal count  : natural range 0 to STABLE_COUNT := 0;
begin

    process(clk)
    begin
        if rising_edge(clk) then
            sync0 <= btn_in;
            sync1 <= sync0;
            pulse <= '0';

            if sync1 /= stable then
                if count = STABLE_COUNT then
                    stable <= sync1;
                    count <= 0;

                    if sync1 = '1' then
                        pulse <= '1';
                    end if;
                else
                    count <= count + 1;
                end if;
            else
                count <= 0;
            end if;
        end if;
    end process;

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity parking_top is
    generic (
        DB_COUNT : natural := 2000000
    );
    Port (
        CLK100MHZ : in STD_LOGIC;

        BTNU : in STD_LOGIC; -- Entry
        BTND : in STD_LOGIC; -- Exit
        BTNC : in STD_LOGIC; -- Reset
        BTNL : in STD_LOGIC; -- Verify password

        SW : in STD_LOGIC_VECTOR(3 downto 0); -- Password input

        LED : out STD_LOGIC_VECTOR(15 downto 0);

        CA : out STD_LOGIC;
        CB : out STD_LOGIC;
        CC : out STD_LOGIC;
        CD : out STD_LOGIC;
        CE : out STD_LOGIC;
        CF : out STD_LOGIC;
        CG : out STD_LOGIC;
        DP : out STD_LOGIC;

        AN : out STD_LOGIC_VECTOR(7 downto 0)
    );
end parking_top;

architecture Behavioral of parking_top is

    constant AUTHORIZED_CODE : STD_LOGIC_VECTOR(3 downto 0) := "1010";

    signal entry_pulse  : STD_LOGIC;
    signal exit_pulse   : STD_LOGIC;
    signal reset_pulse  : STD_LOGIC;
    signal verify_pulse : STD_LOGIC;

    signal occupied  : integer range 0 to 15 := 0;
    signal available : integer range 0 to 15 := 15;

    signal access_granted  : STD_LOGIC := '0';
    signal access_rejected : STD_LOGIC := '0';

    signal refresh_counter : integer range 0 to 99999 := 0;
    signal display_select  : integer range 0 to 2 := 0;

    signal ones_digit : integer range 0 to 9 := 5;
    signal tens_digit : integer range 0 to 1 := 1;

    signal seg : STD_LOGIC_VECTOR(6 downto 0);

    -- Active-low seven-segment encoding
    function digit_to_seg(digit : integer) return STD_LOGIC_VECTOR is
    begin
        case digit is
            when 0 => return "0000001";
            when 1 => return "1001111";
            when 2 => return "0010010";
            when 3 => return "0000110";
            when 4 => return "1001100";
            when 5 => return "0100100";
            when 6 => return "0100000";
            when 7 => return "0001111";
            when 8 => return "0000000";
            when 9 => return "0000100";
            when others => return "1111111";
        end case;
    end function;

    function letter_to_seg(letter : character) return STD_LOGIC_VECTOR is
    begin
        case letter is
            when 'A' => return "0001000"; -- Accepted
            when 'E' => return "0110000"; -- Error / wrong password
            when others => return "1111111"; -- Blank
        end case;
    end function;

begin

    entry_db : entity work.debounce_pulse
        generic map (
            STABLE_COUNT => DB_COUNT
        )
        port map (
            clk    => CLK100MHZ,
            btn_in => BTNU,
            pulse  => entry_pulse
        );

    exit_db : entity work.debounce_pulse
        generic map (
            STABLE_COUNT => DB_COUNT
        )
        port map (
            clk    => CLK100MHZ,
            btn_in => BTND,
            pulse  => exit_pulse
        );

    reset_db : entity work.debounce_pulse
        generic map (
            STABLE_COUNT => DB_COUNT
        )
        port map (
            clk    => CLK100MHZ,
            btn_in => BTNC,
            pulse  => reset_pulse
        );

    verify_db : entity work.debounce_pulse
        generic map (
            STABLE_COUNT => DB_COUNT
        )
        port map (
            clk    => CLK100MHZ,
            btn_in => BTNL,
            pulse  => verify_pulse
        );

    -- Main parking and password logic
    process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then

            if reset_pulse = '1' then
                occupied <= 0;
                access_granted <= '0';
                access_rejected <= '0';

            else

                -- Password check
                if verify_pulse = '1' then
                    if SW = AUTHORIZED_CODE and occupied < 15 then
                        access_granted <= '1';
                        access_rejected <= '0';
                    elsif occupied < 15 then
                        access_granted <= '0';
                        access_rejected <= '1';
                    else
                        access_granted <= '0';
                        access_rejected <= '0';
                    end if;
                end if;

                -- Entry only works after correct password
                if entry_pulse = '1' and exit_pulse = '0' then
                    if occupied < 15 and access_granted = '1' then
                        occupied <= occupied + 1;
                        access_granted <= '0';
                        access_rejected <= '0';
                    elsif occupied < 15 then
                        access_rejected <= '1';
                    end if;

                -- Exit does not need password
                elsif exit_pulse = '1' and entry_pulse = '0' then
                    if occupied > 0 then
                        occupied <= occupied - 1;
                    end if;
                end if;

            end if;
        end if;
    end process;

    available <= 15 - occupied;

    ones_digit <= available mod 10;
    tens_digit <= available / 10;

    -- Display refresh
    process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
            if refresh_counter = 99999 then
                refresh_counter <= 0;

                if display_select = 2 then
                    display_select <= 0;
                else
                    display_select <= display_select + 1;
                end if;

            else
                refresh_counter <= refresh_counter + 1;
            end if;
        end if;
    end process;

    -- Right two digits show available spaces.
    -- Leftmost digit shows A or E only.
    process(display_select, ones_digit, tens_digit, available, access_granted, access_rejected)
    begin
        AN <= "11111111";
        seg <= "1111111";

        case display_select is

            -- Rightmost digit: ones
            when 0 =>
                AN <= "11111110"; -- AN0
                seg <= digit_to_seg(ones_digit);

            -- Second digit from right: tens
            when 1 =>
                if available >= 10 then
                    AN <= "11111101"; -- AN1
                    seg <= digit_to_seg(tens_digit);
                else
                    AN <= "11111111";
                    seg <= "1111111";
                end if;

            -- Leftmost digit: access status
            when others =>
                if access_rejected = '1' then
                    AN <= "01111111"; -- AN7
                    seg <= letter_to_seg('E');
                elsif access_granted = '1' then
                    AN <= "01111111"; -- AN7
                    seg <= letter_to_seg('A');
                else
                    AN <= "11111111";
                    seg <= "1111111";
                end if;

        end case;
    end process;

    CA <= seg(6);
    CB <= seg(5);
    CC <= seg(4);
    CD <= seg(3);
    CE <= seg(2);
    CF <= seg(1);
    CG <= seg(0);
    DP <= '1';

    -- LED status
    LED(0) <= '1' when occupied < 15 else '0'; -- Space available
    LED(1) <= '1' when occupied = 15 else '0'; -- Parking full
    LED(2) <= access_granted;                  -- Password accepted
    LED(3) <= access_rejected;                 -- Password rejected
    LED(15 downto 4) <= (others => '0');

end Behavioral;