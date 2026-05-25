library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BCD_adder_tb is
end entity BCD_adder_tb;

architecture sim of BCD_adder_tb is

    component BCD_adder is
        port (
            A    : in  STD_LOGIC_VECTOR(3 downto 0);
            B    : in  STD_LOGIC_VECTOR(3 downto 0);
            Cin  : in  STD_LOGIC;
            S    : out STD_LOGIC_VECTOR(3 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    signal A, B : STD_LOGIC_VECTOR(3 downto 0);
    signal Cin  : STD_LOGIC := '0';
    signal S    : STD_LOGIC_VECTOR(3 downto 0);
    signal Cout : STD_LOGIC;

begin

    DUT : BCD_adder
        port map (A => A, B => B, Cin => Cin, S => S, Cout => Cout);

    stim_proc : process
        variable total, bcd_s, bcd_c : integer;
    begin
        Cin <= '0';

        for i in 0 to 9 loop
            for j in 0 to 9 loop
                A <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, 4));
                B <= STD_LOGIC_VECTOR(TO_UNSIGNED(j, 4));
                wait for 20 ns;
                total := i + j;
                bcd_c := total / 10;
                bcd_s := total mod 10;
                assert TO_INTEGER(UNSIGNED(S)) = bcd_s
                    report "FAIL S: " & integer'image(i) &
                           "+" & integer'image(j) severity error;
                assert TO_INTEGER(UNSIGNED'("" & Cout)) = bcd_c
                    report "FAIL Cout: " & integer'image(i) &
                           "+" & integer'image(j) severity error;
            end loop;
        end loop;

        -- Extra test: 9+9+1 = 19
        Cin <= '1';
        A <= "1001"; B <= "1001"; wait for 20 ns;
        assert (TO_INTEGER(UNSIGNED(S)) = 9 and Cout = '1')
            report "FAIL 9+9+1" severity error;

        report "BCD_adder_tb: ALL TESTS PASSED" severity note;
        wait;
    end process;

end architecture sim;