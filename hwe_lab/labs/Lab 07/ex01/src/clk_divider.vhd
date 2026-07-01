entity clk_divider is
    generic (
        N : integer := 100000000
    );
    port (
        CLK   : in  bit;
        CLK_N : out bit
    );
end clk_divider;

architecture Behavioral of clk_divider is

    signal counter     : integer range 0 to N - 1 := 0;
    signal divided_clk : bit := '0';

begin

    -- connecting intternal port to output
    CLK_N <= divided_clk;

    process(CLK)
    begin
        if CLK'event and CLK = '1' then

            -- Count from 0 to N-1
            if counter = N - 1 then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;

            -- CLK_N is HIGH for half of the period
            -- and LOW for the other half.
            -- So the output frequency is CLK / N.
            if counter < N / 2 then
                divided_clk <= '1';
            else
                divided_clk <= '0';
            end if;

        end if;
    end process;

end Behavioral;
