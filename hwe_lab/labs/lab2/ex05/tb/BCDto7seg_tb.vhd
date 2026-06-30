library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BCDto7seg_tb is
end entity BCDto7seg_tb;

architecture sim of BCDto7seg_tb is

    component BCDto7seg is
        port (
            BCD : in  STD_LOGIC_VECTOR(3 downto 0);
            seg : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    signal BCD : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal seg : STD_LOGIC_VECTOR(6 downto 0);

begin

    DUT : BCDto7seg
        port map (BCD => BCD, seg => seg);

    stim_proc : process
    begin
        BCD <= "0000"; wait for 20 ns;
        assert seg = "0111111" report "FAIL 0" severity error;

        BCD <= "0001"; wait for 20 ns;
        assert seg = "0000110" report "FAIL 1" severity error;

        BCD <= "0010"; wait for 20 ns;
        assert seg = "1011011" report "FAIL 2" severity error;

        BCD <= "0011"; wait for 20 ns;
        assert seg = "1001111" report "FAIL 3" severity error;

        BCD <= "0100"; wait for 20 ns;
        assert seg = "1100110" report "FAIL 4" severity error;

        BCD <= "0101"; wait for 20 ns;
        assert seg = "1101101" report "FAIL 5" severity error;

        BCD <= "0110"; wait for 20 ns;
        assert seg = "1111101" report "FAIL 6" severity error;

        BCD <= "0111"; wait for 20 ns;
        assert seg = "0000111" report "FAIL 7" severity error;

        BCD <= "1000"; wait for 20 ns;
        assert seg = "1111111" report "FAIL 8" severity error;

        BCD <= "1001"; wait for 20 ns;
        assert seg = "1101111" report "FAIL 9" severity error;

        BCD <= "1010"; wait for 20 ns;
        assert seg = "0000000" report "FAIL invalid" severity error;

        report "BCDto7seg_tb: ALL TESTS PASSED" severity note;
        wait;
    end process;

end architecture sim;