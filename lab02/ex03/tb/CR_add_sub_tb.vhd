library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CR_add_sub_tb is
end entity CR_add_sub_tb;

architecture sim of CR_add_sub_tb is

    component CR_add_sub is
        port (
            A    : in  STD_LOGIC_VECTOR(3 downto 0);
            B    : in  STD_LOGIC_VECTOR(3 downto 0);
            Sub  : in  STD_LOGIC;
            S    : out STD_LOGIC_VECTOR(3 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    signal A, B : STD_LOGIC_VECTOR(3 downto 0);
    signal Sub  : STD_LOGIC;
    signal S    : STD_LOGIC_VECTOR(3 downto 0);
    signal Cout : STD_LOGIC;

begin

    DUT : CR_add_sub
        port map (A => A, B => B, Sub => Sub, S => S, Cout => Cout);

    stim_proc : process
    begin
        -- ADDITION tests (Sub=0)
        Sub <= '0';

        A <= "0011"; B <= "0101"; wait for 20 ns;
        assert S = "1000" report "FAIL ADD 3+5" severity error;

        A <= "0111"; B <= "0111"; wait for 20 ns;
        assert S = "1110" report "FAIL ADD 7+7" severity error;

        A <= "1111"; B <= "0001"; wait for 20 ns;
        assert (Cout='1' and S="0000")
            report "FAIL ADD 15+1" severity error;

        -- SUBTRACTION tests (Sub=1)
        Sub <= '1';

        A <= "0101"; B <= "0011"; wait for 20 ns;
        assert S = "0010" report "FAIL SUB 5-3" severity error;

        A <= "1000"; B <= "1000"; wait for 20 ns;
        assert S = "0000" report "FAIL SUB 8-8" severity error;

        A <= "1111"; B <= "0001"; wait for 20 ns;
        assert S = "1110" report "FAIL SUB 15-1" severity error;

        A <= "0000"; B <= "0001"; wait for 20 ns;
        assert S = "1111" report "FAIL SUB 0-1" severity error;

        report "CR_add_sub_tb: ALL TESTS PASSED" severity note;
        wait;
    end process;

end architecture sim;