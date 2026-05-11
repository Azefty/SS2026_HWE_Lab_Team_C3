
library IEEE;
use IEEE.std_logic_1164.all;
entity full_adder_bhv is
  port (a,b,cin : in std_logic;
        sum, cout : out std_logic
);
end full_adder_bhv;
architecture behavioral of full_adder_bhv is
begin
   sum <= a xor b xor cin;
    cout <= (a and b) or (b and cin) or (a and cin);
end behavioral;