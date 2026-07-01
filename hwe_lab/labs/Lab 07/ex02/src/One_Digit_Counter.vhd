-- One Digit Decimal Counter (0-9)
-- Displays current count on the rightmost 7-segment digit of Nexys A7-100T
-- Uses clk_divider from Exercise 01 to generate a 1 Hz counting clock

entity One_Digit_Counter is
    port (
        CLK        : in  bit;                    
        START_STOP : in  bit;                    -- '1' = counting, '0' = paused (SW0)
        CLEAR      : in  bit;                    -- '1' = reset count to 0  (BTNC)
        seg        : out bit_vector(6 downto 0); -- 7-segment display (active-low)
        dp         : out bit;                    -- Decimal point (off)
        an         : out bit_vector(7 downto 0)  -- Anode select (AN0 only active)
    );
end One_Digit_Counter;

architecture Behavioral of One_Digit_Counter is

    signal clk_1hz : bit;                        -- 1 Hz clock from divider
    signal count   : integer range 0 to 9 := 0; -- Current count value (0-9)

begin


    clk_div : entity work.clk_divider
        generic map (N => 100000000)
        port map (
            CLK   => CLK,
            CLK_N => clk_1hz
        );


    counter_proc : process(clk_1hz, CLEAR)
    begin
        if CLEAR = '1' then
            
            count <= 0;
        elsif clk_1hz'event and clk_1hz = '1' then
            if START_STOP = '1' then
                
                if count = 9 then
                    count <= 0;
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;


    seg_proc : process(count)
    begin
        case count is
            when 0 => seg <= "1000000"; 
            when 1 => seg <= "1111001"; 
            when 2 => seg <= "0100100"; 
            when 3 => seg <= "0110000"; 
            when 4 => seg <= "0011001"; 
            when 5 => seg <= "0010010"; 
            when 6 => seg <= "0000010"; 
            when 7 => seg <= "1111000"; 
            when 8 => seg <= "0000000"; 
            when 9 => seg <= "0010000"; 
            when others => seg <= "1111111"; 
        end case;
    end process;

    
    dp <= '1';

    
    an <= "11111110";

end Behavioral;
