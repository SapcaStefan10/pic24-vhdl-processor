----------------------------------------------------------------------------------
-- Module Name: PC_Update - Behavioral
-- Project Name: MiniPIC24 - Project 6
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC_Update is
    Port ( N : in  STD_LOGIC;
           OV : in  STD_LOGIC;
           Z : in  STD_LOGIC;
           C : in  STD_LOGIC;
           Slit16 : in  STD_LOGIC_VECTOR (4 downto 0);
           BranchType : in  STD_LOGIC_VECTOR (2 downto 0);
           Branch : in  STD_LOGIC;
           PC : in  STD_LOGIC_VECTOR (5 downto 0);
           New_PC : out  STD_LOGIC_VECTOR (5 downto 0));
end PC_Update;

architecture Behavioral of PC_Update is
    signal Deplasament : STD_LOGIC_VECTOR (5 downto 0);
    signal BranchTaken : STD_LOGIC;
begin
    -- Sign extend / scale 5-bit displacement to 6-bit byte offset (even numbers)
    Deplasament <= Slit16(4) & Slit16(4 downto 0);

    BranchTaken <= '1' when (Branch = '1' and (
                       (BranchType = "000" and OV = '1') or -- BRA OV, Expr
                       (BranchType = "001" and C = '1')  or -- BRA C, Expr
                       (BranchType = "010" and Z = '1')  or -- BRA Z, Expr
                       (BranchType = "011" and N = '1')  or -- BRA N, Expr
                       (BranchType = "111")                 -- BRA Expr
                   )) else '0';

    New_PC <= (PC + 2 + Deplasament) when BranchTaken = '1' else (PC + 2);

end Behavioral;
