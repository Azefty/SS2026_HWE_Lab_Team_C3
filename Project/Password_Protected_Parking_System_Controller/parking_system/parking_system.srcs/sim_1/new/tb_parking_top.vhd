library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_parking_top is
end tb_parking_top;

architecture sim of tb_parking_top is

    signal CLK100MHZ : STD_LOGIC := '0';

    signal BTNU : STD_LOGIC := '0'; -- Entry
    signal BTND : STD_LOGIC := '0'; -- Exit
    signal BTNC : STD_LOGIC := '0'; -- Reset
    signal BTNL : STD_LOGIC := '0'; -- Verify

    signal SW : STD_LOGIC_VECTOR(3 downto 0) := "0000";

    signal LED : STD_LOGIC_VECTOR(15 downto 0);

    signal CA : STD_LOGIC;
    signal CB : STD_LOGIC;
    signal CC : STD_LOGIC;
    signal CD : STD_LOGIC;
    signal CE : STD_LOGIC;
    signal CF : STD_LOGIC;
    signal CG : STD_LOGIC;
    signal DP : STD_LOGIC;

    signal AN : STD_LOGIC_VECTOR(7 downto 0);

    constant CLK_PERIOD : time := 10 ns;

    procedure press_button(signal btn : out STD_LOGIC) is
    begin
        btn <= '1';
        wait for 200 ns;
        btn <= '0';
        wait for 200 ns;
    end procedure;

begin

    -- 100 MHz clock
    CLK100MHZ <= not CLK100MHZ after CLK_PERIOD / 2;

    -- Unit under test
    uut : entity work.parking_top
        generic map (
            DB_COUNT => 5
        )
        port map (
            CLK100MHZ => CLK100MHZ,

            BTNU => BTNU,
            BTND => BTND,
            BTNC => BTNC,
            BTNL => BTNL,

            SW => SW,

            LED => LED,

            CA => CA,
            CB => CB,
            CC => CC,
            CD => CD,
            CE => CE,
            CF => CF,
            CG => CG,
            DP => DP,

            AN => AN
        );

    stim_proc : process
    begin

        wait for 100 ns;

        -- Reset
        press_button(BTNC);
        wait for 200 ns;

        assert LED(0) = '1'
            report "Error: Space available LED should be ON after reset"
            severity error;

        assert LED(1) = '0'
            report "Error: Full LED should be OFF after reset"
            severity error;

        -- Wrong password test
        SW <= "0011";
        wait for 100 ns;

        press_button(BTNL);
        wait for 200 ns;

        assert LED(3) = '1'
            report "Error: Wrong password was not rejected"
            severity error;

        -- Try entry with wrong password
        press_button(BTNU);
        wait for 200 ns;

        assert LED(0) = '1'
            report "Error: Entry should not change available status after wrong password"
            severity error;

        assert LED(1) = '0'
            report "Error: Parking should not be full after wrong password entry attempt"
            severity error;

        -- Correct password test
        SW <= "1010";
        wait for 100 ns;

        press_button(BTNL);
        wait for 200 ns;

        assert LED(2) = '1'
            report "Error: Correct password was not accepted"
            severity error;

        assert LED(3) = '0'
            report "Error: Reject LED should be OFF after correct password"
            severity error;

        -- Entry after correct password
        press_button(BTNU);
        wait for 200 ns;

        assert LED(2) = '0'
            report "Error: Access should clear after one entry"
            severity error;

        -- Exit test
        press_button(BTND);
        wait for 200 ns;

        assert LED(0) = '1'
            report "Error: Space available LED should be ON after exit"
            severity error;

        -- Fill the parking lot
        for i in 1 to 15 loop
            SW <= "1010";
            wait for 50 ns;
            press_button(BTNL);
            wait for 100 ns;
            press_button(BTNU);
            wait for 100 ns;
        end loop;

        wait for 500 ns;

        assert LED(0) = '0'
            report "Error: Space available LED should be OFF when full"
            severity error;

        assert LED(1) = '1'
            report "Error: Full LED should be ON when parking is full"
            severity error;

        -- Try to enter when full
        SW <= "1010";
        wait for 100 ns;
        press_button(BTNL);
        wait for 100 ns;
        press_button(BTNU);
        wait for 200 ns;

        assert LED(1) = '1'
            report "Error: Parking should remain full after extra entry attempt"
            severity error;

        -- Reset again
        press_button(BTNC);
        wait for 200 ns;

        assert LED(0) = '1'
            report "Error: Space available LED should be ON after final reset"
            severity error;

        assert LED(1) = '0'
            report "Error: Full LED should be OFF after final reset"
            severity error;

        report "Password protected parking system simulation completed successfully." severity note;

        wait;

    end process;

end sim;