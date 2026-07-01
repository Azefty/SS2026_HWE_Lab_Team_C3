----------------------------------------------------------------------------------
-- Lab 05 Exercise 02
-- 4-bit Adder/Subtractor for Nexys A7-100T
-- A      = SW3..SW0
-- B      = SW7..SW4
-- MODE   = SW8   ('0' = add, '1' = subtract)
-- Result = LED3..LED0
-- Carry/Borrow = LED4
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Adder_Subtractor is
    port (
        sw  : in  std_logic_vector(8 downto 0);
        led : out std_logic_vector(4 downto 0)
    );
end Adder_Subtractor;

architecture Behavioral of Adder_Subtractor is
    signal A      : unsigned(3 downto 0);
    signal B      : unsigned(3 downto 0);
    signal result : unsigned(4 downto 0);
begin
    A <= unsigned(sw(3 downto 0));
    B <= unsigned(sw(7 downto 4));

    process(A, B, sw)
    begin
        if sw(8) = '0' then
            -- Addition: LED4 is carry-out
            result <= ('0' & A) + ('0' & B);
        else
            -- Subtraction: LED4 is borrow flag
            -- If A >= B, output A-B and borrow=0
            -- If A < B, output wrapped 4-bit result and borrow=1
            if A >= B then
                result <= ('0' & (A - B));
            else
                result <= ('1' & (A - B));
            end if;
        end if;
    end process;

    led <= std_logic_vector(result);
end Behavioral;
