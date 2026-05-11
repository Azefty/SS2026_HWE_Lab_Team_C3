library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder_bhv_tb is
end full_adder_bhv_tb;

architecture tb of full_adder_bhv_tb is

    
    signal a, b, cin : std_logic := '0';
    signal sum, cout : std_logic;

begin

    DUT: entity work.full_adder_bhv
        port map(
            a    => a,
            b    => b,
            cin  => cin,
            sum  => sum,
            cout => cout
        );

   
    stim_proc: process
    begin
        
        a <= '0'; b <= '0'; cin <= '0'; wait for 10 ps;
        a <= '0'; b <= '0'; cin <= '1'; wait for 10 ps;
        a <= '0'; b <= '1'; cin <= '0'; wait for 10 ps;
        a <= '0'; b <= '1'; cin <= '1'; wait for 10 ps;
        a <= '1'; b <= '0'; cin <= '0'; wait for 10 ps;
        a <= '1'; b <= '0'; cin <= '1'; wait for 10 ps;
        a <= '1'; b <= '1'; cin <= '0'; wait for 10 ps;
        a <= '1'; b <= '1'; cin <= '1'; wait for 10 ps;

        wait; 
    end process;

end tb;