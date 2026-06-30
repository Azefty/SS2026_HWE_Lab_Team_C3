library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BCDto7seg is
    port (
        BCD : in  STD_LOGIC_VECTOR(3 downto 0);
        seg : out STD_LOGIC_VECTOR(6 downto 0)
    );
end entity BCDto7seg;

architecture dataflow of BCDto7seg is
begin
    with BCD select
        seg <= "0111111" when "0000",
               "0000110" when "0001",
               "1011011" when "0010",
               "1001111" when "0011",
               "1100110" when "0100",
               "1101101" when "0101",
               "1111101" when "0110",
               "0000111" when "0111",
               "1111111" when "1000",
               "1101111" when "1001",
               "0000000" when others;
end architecture dataflow;