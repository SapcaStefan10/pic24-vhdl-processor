----------------------------------------------------------------------------------
-- Module Name: ROM_N - Behavioral
-- Program ROM sequence for testing N (Negative) Flag and BRA N, Expr
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM_N is
    Port ( Addr : in  STD_LOGIC_VECTOR (4 downto 0);
           Data : out  STD_LOGIC_VECTOR (23 downto 0));
end ROM_N;

architecture Behavioral of ROM_N is
    type tROM is array (0 to 31) of STD_LOGIC_VECTOR(23 downto 0);
    constant ROM : tROM := (
        0 => x"808101", -- MOV 0x1020, W1 (INW0=0x0002)
        1 => x"808112", -- MOV 0x1022, W2 (INW1=0x0005)
        2 => x"500182", -- SUB W1, W2, W3 -> W3=0xFFFD (N=1)
        3 => x"330002", -- BRA N, +2 (Jump over instruction 4 to instruction 6)
        4 => x"888121", -- MOV W1, 0x1024 (Skipped)
        5 => x"370000", -- BRA STOP
        6 => x"888123", -- MOV W3, 0x1024 (Executed when N=1)
        7 => x"370000", -- BRA LOOP
        others => x"000000"
    );
begin
    Data <= ROM(conv_integer(Addr));
end Behavioral;
