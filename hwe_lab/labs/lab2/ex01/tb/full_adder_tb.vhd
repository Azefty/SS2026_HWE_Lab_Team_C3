library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder_tb is
end entity full_adder_tb;

architecture sim of full_adder_tb is

    component full_adder is
        port (
            A    : in  STD_LOGIC;
            B    : in  STD_LOGIC;
            Cin  : in  STD_LOGIC;
            S    : out STD_LOGIC;
            Cout : out STD_LOGIC
        );
    end component;

    signal A, B, Cin : STD_LOGIC := '0';
    signal S, Cout   : STD_LOGIC;

begin

    DUT : full_adder
        port map (A => A, B => B, Cin => Cin, S => S, Cout => Cout);

    stim_proc : process
    begin
        A <= '0'; B <= '0'; Cin <= '0'; wait for 20 ns;
        assert (S='0' and Cout='0') report "FAIL 0+0+0" severity error;

        A <= '0'; B <= '0'; Cin <= '1'; wait for 20 ns;
        assert (S='1' and Cout='0') report "FAIL 0+0+1" severity error;

        A <= '0'; B <= '1'; Cin <= '0'; wait for 20 ns;
        assert (S='1' and Cout='0') report "FAIL 0+1+0" severity error;

        A <= '0'; B <= '1'; Cin <= '1'; wait for 20 ns;
        assert (S='0' and Cout='1') report "FAIL 0+1+1" severity error;

        A <= '1'; B <= '0'; Cin <= '0'; wait for 20 ns;
        assert (S='1' and Cout='0') report "FAIL 1+0+0" severity error;

        A <= '1'; B <= '0'; Cin <= '1'; wait for 20 ns;
        assert (S='0' and Cout='1') report "FAIL 1+0+1" severity error;

        A <= '1'; B <= '1'; Cin <= '0'; wait for 20 ns;
        assert (S='0' and Cout='1') report "FAIL 1+1+0" severity error;

        A <= '1'; B <= '1'; Cin <= '1'; wait for 20 ns;
        assert (S='1' and Cout='1') report "FAIL 1+1+1" severity error;

        report "full_adder_tb: ALL TESTS PASSED" severity note;
        wait;
    end process;

end architecture sim;