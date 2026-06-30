library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
    port (
        A : in  STD_LOGIC;
        B : in  STD_LOGIC;
        S : out STD_LOGIC;
        C : out STD_LOGIC
    );
end entity half_adder;

architecture structural of half_adder is
begin
    S <= A XOR B;
    C <= A AND B;
end architecture structural;