library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BCD_adder is
    port (
        A    : in  STD_LOGIC_VECTOR(3 downto 0);
        B    : in  STD_LOGIC_VECTOR(3 downto 0);
        Cin  : in  STD_LOGIC;
        S    : out STD_LOGIC_VECTOR(3 downto 0);
        Cout : out STD_LOGIC
    );
end entity BCD_adder;

architecture structural of BCD_adder is

    component CR_adder is
        generic (N : integer := 4);
        port (
            A    : in  STD_LOGIC_VECTOR(N-1 downto 0);
            B    : in  STD_LOGIC_VECTOR(N-1 downto 0);
            Cin  : in  STD_LOGIC;
            S    : out STD_LOGIC_VECTOR(N-1 downto 0);
            Cout : out STD_LOGIC
        );
    end component;

    signal sum1       : STD_LOGIC_VECTOR(3 downto 0);
    signal cout1      : STD_LOGIC;
    signal bcd_carry  : STD_LOGIC;
    signal correction : STD_LOGIC_VECTOR(3 downto 0);
    signal sum2       : STD_LOGIC_VECTOR(3 downto 0);
    signal cout2      : STD_LOGIC;

begin

    ADDER1 : CR_adder
        generic map (N => 4)
        port map (
            A    => A,
            B    => B,
            Cin  => Cin,
            S    => sum1,
            Cout => cout1
        );

    bcd_carry <= cout1
                 OR (sum1(3) AND sum1(2))
                 OR (sum1(3) AND sum1(1));

    correction <= "0110" when bcd_carry = '1' else "0000";

    ADDER2 : CR_adder
        generic map (N => 4)
        port map (
            A    => sum1,
            B    => correction,
            Cin  => '0',
            S    => sum2,
            Cout => cout2
        );

    S    <= sum2;
    Cout <= bcd_carry;

end architecture structural;