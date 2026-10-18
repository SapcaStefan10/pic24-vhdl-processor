----------------------------------------------------------------------------------
-- Module Name: MUX2V16 - Behavioral
-- Project Name: MiniPIC24 - Project 6
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2V16 is
    Port ( I0 : in  STD_LOGIC_VECTOR (15 downto 0);
           I1 : in  STD_LOGIC_VECTOR (15 downto 0);
           Sel : in  STD_LOGIC;
           Y : out  STD_LOGIC_VECTOR (15 downto 0));
end MUX2V16;

architecture Behavioral of MUX2V16 is
begin
    Y <= I0 when Sel = '0' else I1;
end Behavioral;
