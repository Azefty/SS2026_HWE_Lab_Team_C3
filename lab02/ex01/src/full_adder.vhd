library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    port (
        A    : in  STD_LOGIC;
        B    : in  STD_LOGIC;
        Cin  : in  STD_LOGIC;
        S    : out STD_LOGIC;
        Cout : out STD_LOGIC
    );
end entity full_adder;

architecture structural of full_adder is

    component half_adder is
        port (
            A : in  STD_LOGIC;
            B : in  STD_LOGIC;
            S : out STD_LOGIC;
            C : out STD_LOGIC
        );
    end component;

    signal s1 : STD_LOGIC;
    signal c1 : STD_LOGIC;
    signal c2 : STD_LOGIC;

begin

    HA1 : half_adder
        port map (A => A, B => B, S => s1, C => c1);

    HA2 : half_adder
        port map (A => s1, B => Cin, S => S, C => c2);

    Cout <= c1 OR c2;

end architecture structural;