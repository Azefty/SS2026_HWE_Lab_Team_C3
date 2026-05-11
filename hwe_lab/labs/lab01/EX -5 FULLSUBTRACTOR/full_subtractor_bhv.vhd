
library IEEE;
use IEEE.std_logic_1164.all;

entity full_subtractor_bhv is
    port(
        a    : in  std_logic;
        b    : in  std_logic;
        bin  : in  std_logic;
        diff : out std_logic;
        bout : out std_logic
    );
end full_subtractor_bhv;

architecture behavioral of full_subtractor_bhv is
begin
    diff <= a xor b xor bin;
    bout <= ((not a) and b) or
            ((not a) and bin) or
            (b and bin);
end behavioral;
