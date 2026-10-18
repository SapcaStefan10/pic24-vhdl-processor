----------------------------------------------------------------------------------
-- Module Name: MUX_Reg_Dest - Behavioral
-- Project Name: MiniPIC24 - Project 6
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_Reg_Dest is
    Port ( I0 : in  STD_LOGIC_VECTOR (3 downto 0);  -- Instr(3 downto 0)
           I1 : in  STD_LOGIC_VECTOR (3 downto 0);  -- Instr(10 downto 7)
           I2 : in  STD_LOGIC_VECTOR (3 downto 0);  -- Instr(7 downto 4)
           Sel : in  STD_LOGIC_VECTOR (1 downto 0);
           Y : out  STD_LOGIC_VECTOR (3 downto 0));
end MUX_Reg_Dest;

architecture Behavioral of MUX_Reg_Dest is
begin
    with Sel select
        Y <= I0 when "00",
             I1 when "01",
             I2 when "10",
             I0 when others;
end Behavioral;
