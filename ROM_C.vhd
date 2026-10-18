----------------------------------------------------------------------------------
-- Module Name: ROM_C - Behavioral
-- Program ROM sequence for testing C (Carry) Flag and BRA C, Expr
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM_C is
    Port ( Addr : in  STD_LOGIC_VECTOR (4 downto 0);
           Data : out  STD_LOGIC_VECTOR (23 downto 0));
end ROM_C;

architecture Behavioral of ROM_C is
    type tROM is array (0 to 31) of STD_LOGIC_VECTOR(23 downto 0);
    constant ROM : tROM := (
        0 => x"808101", -- MOV 0x1020, W1 (INW0=0xFFFF)
        1 => x"808112", -- MOV 0x1022, W2 (INW1=0x0001)
        2 => x"400182", -- ADD W1, W2, W3 -> W3=0x0000, Carry C=1
        3 => x"310002", -- BRA C, +2 (Jump over instruction 4 to instruction 6)
        4 => x"888121", -- MOV W1, 0x1024 (Skipped)
        5 => x"370000", -- BRA STOP
        6 => x"888122", -- MOV W2, 0x1024 (Executed when C=1)
        7 => x"370000", -- BRA LOOP
        others => x"000000"
    );
begin
    Data <= ROM(conv_integer(Addr));
end Behavioral;
