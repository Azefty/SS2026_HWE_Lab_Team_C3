entity clk_divider_tb is
end clk_divider_tb;

architecture Testbench of clk_divider_tb is

    constant TEST_N : integer := 4;

    signal CLK      : bit := '0';
    signal CLK_N    : bit := '0';
    signal finished : bit := '0';

begin

    -- Unit under test
    uut : entity work.clk_divider
        generic map (
            N => TEST_N
        )
        port map (
            CLK   => CLK,
            CLK_N => CLK_N
        );

    -- Generating 100MHz for clock divider
    -- Period = 10 ns
    clock_process : process
    begin
        while finished = '0' loop
            CLK <= '0';
            wait for 5 ns;

            CLK <= '1';
            wait for 5 ns;
        end loop;

        wait;
    end process;

    -- Test process
    test_process : process
    begin

        -- running some clock cycles
        wait for 200 ns;

        finished <= '1';

        wait;
    end process;

end Testbench;
