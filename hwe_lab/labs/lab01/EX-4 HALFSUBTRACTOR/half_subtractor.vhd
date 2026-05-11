
library IEEE;
use IEEE.std_logic_1164.all;

entity half_subtractor_bhv is
    port(
        a    : in  std_logic;
        b    : in  std_logic;
        diff : out std_logic;
        bout : out std_logic
    );
end half_subtractor_bhv;

architecture behavioral of half_subtractor_bhv is
begin
    diff <= a xor b;
    bout <= (not a) and b;
end behavioral;
