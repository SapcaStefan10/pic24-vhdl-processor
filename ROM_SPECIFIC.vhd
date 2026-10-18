----------------------------------------------------------------------------------
-- Module Name: ROM_SPECIFIC - Behavioral
-- Program ROM sequence for testing Project 6 specific instructions:
-- FF1L Ws, Wnd | ADD #lit10, Wn | INC2 Ws, Wd | SETM Wd
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM_SPECIFIC is
    Port ( Addr : in  STD_LOGIC_VECTOR (4 downto 0);
           Data : out  STD_LOGIC_VECTOR (23 downto 0));
end ROM_SPECIFIC;

architecture Behavioral of ROM_SPECIFIC is
    type tROM is array (0 to 31) of STD_LOGIC_VECTOR(23 downto 0);
    constant ROM : tROM := (
        0 => x"808101", -- MOV 0x1020, W1 (INW0=0x0080 -> bit 7 is '1')
        1 => x"E70021", -- FF1L W1, W2    -> W2 = 0x0008
        2 => x"4600A2", -- ADD #10, W2   -> W2 = 8 + 10 = 18 (0x0012)
        3 => x"E10032", -- INC2 W2, W3   -> W3 = 18 + 2 = 20 (0x0014)
        4 => x"EB8200", -- SETM W4       -> W4 = 0xFFFF
        5 => x"888123", -- MOV W3, 0x1024 -> OUTW0 = 0x0014
        6 => x"370000", -- BRA LOOP
        others => x"000000"
    );
begin
    Data <= ROM(conv_integer(Addr));
end Behavioral;
