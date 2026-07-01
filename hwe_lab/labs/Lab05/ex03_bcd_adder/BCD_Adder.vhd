----------------------------------------------------------------------------------
-- Lab 05 Exercise 03
-- 4-bit BCD Adder for Nexys A7-100T
-- A = SW3..SW0, B = SW7..SW4
-- Shows the BCD digit on one 7-segment display
-- Carry is shown on LED0
-- Seven-segment signals are active-low on Nexys A7
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BCD_Adder is
    port (
        sw  : in  std_logic_vector(7 downto 0);
        seg : out std_logic_vector(6 downto 0); -- CA,CB,CC,CD,CE,CF,CG
        an  : out std_logic_vector(7 downto 0);
        led : out std_logic_vector(0 downto 0)
    );
end BCD_Adder;

architecture Behavioral of BCD_Adder is
    signal A       : unsigned(3 downto 0);
    signal B       : unsigned(3 downto 0);
    signal sum5    : unsigned(4 downto 0);
    signal digit   : unsigned(3 downto 0);
    signal carry   : std_logic;
begin
    A <= unsigned(sw(3 downto 0));
    B <= unsigned(sw(7 downto 4));
    sum5 <= ('0' & A) + ('0' & B);

    process(sum5)
    begin
        if sum5 > 9 then
            digit <= sum5(3 downto 0) + 6; -- BCD correction gives ones digit
            carry <= '1';
        else
            digit <= sum5(3 downto 0);
            carry <= '0';
        end if;
    end process;

    -- Enable only rightmost digit AN0, disable the others
    -- Nexys A7 anodes are active-low
    an <= "11111110";
    led(0) <= carry;

    -- Active-low 7-segment decoder: seg = CA CB CC CD CE CF CG
    process(digit)
    begin
        case digit is
            when "0000" => seg <= "0000001"; -- 0
            when "0001" => seg <= "1001111"; -- 1
            when "0010" => seg <= "0010010"; -- 2
            when "0011" => seg <= "0000110"; -- 3
            when "0100" => seg <= "1001100"; -- 4
            when "0101" => seg <= "0100100"; -- 5
            when "0110" => seg <= "0100000"; -- 6
            when "0111" => seg <= "0001111"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0000100"; -- 9
            when others => seg <= "1111111"; -- blank
        end case;
    end process;
end Behavioral;
