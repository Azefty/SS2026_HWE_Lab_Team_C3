library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CR_add_sub is
    port (
        A   : in  STD_LOGIC_VECTOR(3 downto 0);
        B   : in  STD_LOGIC_VECTOR(3 downto 0);
        Sub : in  STD_LOGIC;
        S   : out STD_LOGIC_VECTOR(3 downto 0);
        Cout: out STD_LOGIC
    );
end entity CR_add_sub;

architecture structural of CR_add_sub is

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

    signal B_op : STD_LOGIC_VECTOR(3 downto 0);

begin

    B_op(0) <= B(0) XOR Sub;
    B_op(1) <= B(1) XOR Sub;
    B_op(2) <= B(2) XOR Sub;
    B_op(3) <= B(3) XOR Sub;

    ADDER : CR_adder
        generic map (N => 4)
        port map (
            A    => A,
            B    => B_op,
            Cin  => Sub,
            S    => S,
            Cout => Cout
        );

end architecture structural;