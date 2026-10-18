----------------------------------------------------------------------------------
-- Module Name: ProgCnt - Behavioral
-- Project Name: MiniPIC24 - Project 6
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgCnt is
    Port ( Clk : in  STD_LOGIC;
           New_PC : in  STD_LOGIC_VECTOR (5 downto 0);
           PC : out  STD_LOGIC_VECTOR (5 downto 0) := "000000");
end ProgCnt;

architecture Behavioral of ProgCnt is
begin
    process(Clk)
    begin
        if rising_edge(Clk) then
            PC <= New_PC;
        end if;
    end process;
end Behavioral;
