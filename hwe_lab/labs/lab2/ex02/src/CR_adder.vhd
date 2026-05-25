library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CR_adder is
    generic (
        N : integer := 4
    );
    port (
        A    : in  STD_LOGIC_VECTOR(N-1 downto 0);
        B    : in  STD_LOGIC_VECTOR(N-1 downto 0);
        Cin  : in  STD_LOGIC;
        S    : out STD_LOGIC_VECTOR(N-1 downto 0);
        Cout : out STD_LOGIC
    );
end entity CR_adder;

architecture structural of CR_adder is

    component full_adder is
        port (
            A    : in  STD_LOGIC;
            B    : in  STD_LOGIC;
            Cin  : in  STD_LOGIC;
            S    : out STD_LOGIC;
            Cout : out STD_LOGIC
        );
    end component;

    signal c : STD_LOGIC_VECTOR(N downto 0);

begin

    c(0) <= Cin;

    gen_fa : for i in 0 to N-1 generate
        FA_i : full_adder
            port map (
                A    => A(i),
                B    => B(i),
                Cin  => c(i),
                S    => S(i),
                Cout => c(i+1)
            );
    end generate;

    Cout <= c(N);

end architecture structural;