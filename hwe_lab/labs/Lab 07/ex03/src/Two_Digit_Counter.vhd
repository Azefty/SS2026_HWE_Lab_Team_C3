entity Two_Digit_Counter is
    port (
        CLK100MHZ : in  bit;
        sw        : in  bit_vector(1 downto 0);
        seg       : out bit_vector(6 downto 0);
        an        : out bit_vector(7 downto 0);
        dp        : out bit
    );
end Two_Digit_Counter;

architecture Behavioral of Two_Digit_Counter is

    component clk_divider is
        generic (
            N : integer := 100000000
        );
        port (
            CLK   : in  bit;
            CLK_N : out bit
        );
    end component;

    signal count_clk            : bit := '0';
    signal previous_count_clk   : bit := '0';

    signal display_clk          : bit := '0';
    signal previous_display_clk : bit := '0';

    signal unit_digit : integer range 0 to 9 := 0;
    signal ten_digit  : integer range 0 to 9 := 0;

    signal active_digit  : bit := '0';
    signal current_digit : integer range 0 to 9 := 0;

begin

    -- Clock divider for counting
    -- 100 MHz / 100000000 = 1 Hz
    count_clock_divider : clk_divider
        generic map (
            N => 100000000
        )
        port map (
            CLK   => CLK100MHZ,
            CLK_N => count_clk
        );

    -- Clock divider for display multiplexing
    -- 100 MHz / 100,000 = 1 kHz
    display_clock_divider : clk_divider
        generic map (
            N => 100000
        )
        port map (
            CLK   => CLK100MHZ,
            CLK_N => display_clk
        );

    -- Main clocked process
    process(CLK100MHZ)
    begin
        if CLK100MHZ'event and CLK100MHZ = '1' then

            -- SW1 = used for clear
            if sw(1) = '1' then
                unit_digit <= 0;
                ten_digit  <= 0;

            else

                -- Detecting rising edge of count_clk
                if previous_count_clk = '0' and count_clk = '1' then

                    -- SW0 = Start/Stop
                    if sw(0) = '1' then

                        if unit_digit = 9 then
                            unit_digit <= 0;

                            if ten_digit = 9 then
                                ten_digit <= 0;
                            else
                                ten_digit <= ten_digit + 1;
                            end if;

                        else
                            unit_digit <= unit_digit + 1;
                        end if;

                    end if;

                end if;

            end if;

            -- Detecting rising edge of display_clk
            -- Toggle between unit digit and ten digit
            if previous_display_clk = '0' and display_clk = '1' then
                active_digit <= not active_digit;
            end if;

            -- Store previous values for edge detection
            previous_count_clk   <= count_clk;
            previous_display_clk <= display_clk;

        end if;
    end process;

    -- Select which digit is displayed
    process(active_digit, unit_digit, ten_digit)
    begin
        if active_digit = '0' then

            -- Unit digit on AN0
            current_digit <= unit_digit;
            an <= "11111110";

        else

            -- Ten digit on AN1
            current_digit <= ten_digit;
            an <= "11111101";

        end if;
    end process;

    -- Seven-segment decoder
    -- seg(6 downto 0) = g f e d c b a
    -- Active-low:
    -- 0 =  ON
    -- 1 = OFF
    process(current_digit)
    begin
        case current_digit is

            when 0 =>
                seg <= "1000000";

            when 1 =>
                seg <= "1111001";

            when 2 =>
                seg <= "0100100";

            when 3 =>
                seg <= "0110000";

            when 4 =>
                seg <= "0011001";

            when 5 =>
                seg <= "0010010";

            when 6 =>
                seg <= "0000010";

            when 7 =>
                seg <= "1111000";

            when 8 =>
                seg <= "0000000";

            when 9 =>
                seg <= "0010000";

            when others =>
                seg <= "1111111";

        end case;
    end process;

    -- Decimal point OFF
    dp <= '1';

end Behavioral;
