
library IEEE;
use IEEE.std_logic_1164.all;

entity half_subtractor_bhv_tb is
end half_subtractor_bhv_tb;

architecture tb of half_subtractor_bhv_tb is

    signal a, b  : std_logic := '0';
    signal diff, bout : std_logic;

begin

    DUT: entity work.half_subtractor_bhv
        port map(
            a    => a,
            b    => b,
            diff => diff,
            bout => bout
        );

    stim_proc: process
    begin
     a <= '0'; b <= '0'; wait for 25 ps;
     a <= '0'; b <= '1'; wait for 25 ps;
     a <= '1'; b <= '0'; wait for 25 ps;
     a <= '1'; b <= '1'; wait for 25 ps;

        wait;
    end process;

end tb;
