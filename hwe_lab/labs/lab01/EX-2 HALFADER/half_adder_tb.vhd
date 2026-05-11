
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity half_adder_tb is
end half_adder_tb;


architecture Behavioral of half_adder_tb is

    
    component half_adder
        Port (
            A : in  STD_LOGIC;
            B : in  STD_LOGIC;
            S : out STD_LOGIC;
            C : out STD_LOGIC
        );
    end component;

    
    signal A : STD_LOGIC := '0';
    signal B : STD_LOGIC := '0';
    signal S : STD_LOGIC;
    signal C : STD_LOGIC;

begin

    
    UUT: half_adder
        port map (
            A => A,
            B => B,
            S => S,
            C => C
        );

    
    stim_proc: process
    begin

        A <= '0'; B <= '0'; wait for 25 ps;
        A <= '0'; B <= '1'; wait for 25 ps;
        A <= '1'; B <= '0'; wait for 25 ps;
        A <= '1'; B <= '1'; wait for 25 ps;

        wait; 

    end process;

end Behavioral;
