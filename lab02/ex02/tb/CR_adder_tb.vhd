library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CR_adder_tb is
end entity CR_adder_tb;

architecture sim of CR_adder_tb is

    component CR_adder is
        generic (N : integer := 4);
        port (
            A    : in  STD_LOGIC_VECTOR(3 downto 0);
            B    : in  STD_LOGIC_VECTOR(3 downto 0);
            Cin  : in  STD_LOGIC;
            S    : out STD_LOGIC_VECTOR(3 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    signal A, B : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal Cin  : STD_LOGIC := '0';
    signal S    : STD_LOGIC_VECTOR(3 downto 0);
    signal Cout : STD_LOGIC;

begin

    DUT : CR_adder
        generic map (N => 4)
        port map (A => A, B => B, Cin => Cin, S => S, Cout => Cout);

    stim_proc : process
        variable sum_v    : integer;
        variable result_v : STD_LOGIC_VECTOR(4 downto 0);
    begin
        A <= "0000"; B <= "0000"; Cin <= '0'; wait for 20 ns;
        assert (Cout & S = "00000") report "FAIL 0+0" severity error;

        A <= "0111"; B <= "1000"; Cin <= '0'; wait for 20 ns;
        assert (Cout & S = "01111") report "FAIL 7+8" severity error;

        A <= "1111"; B <= "0001"; Cin <= '0'; wait for 20 ns;
        assert (Cout & S = "10000") report "FAIL 15+1" severity error;

        A <= "1111"; B <= "1111"; Cin <= '1'; wait for 20 ns;
        assert (Cout & S = "11111") report "FAIL 15+15+1" severity error;

        for i in 0 to 15 loop
            for j in 0 to 15 loop
                A   <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, 4));
                B   <= STD_LOGIC_VECTOR(TO_UNSIGNED(j, 4));
                Cin <= '0';
                wait for 10 ns;
                sum_v    := i + j;
                result_v := STD_LOGIC_VECTOR(TO_UNSIGNED(sum_v, 5));
                assert (Cout & S = result_v)
                    report "FAIL A=" & integer'image(i) &
                           " B=" & integer'image(j) severity error;
            end loop;
        end loop;

        report "CR_adder_tb: ALL TESTS PASSED" severity note;
        wait;
    end process;

end architecture sim;