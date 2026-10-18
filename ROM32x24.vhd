----------------------------------------------------------------------------------
-- Module Name: ROM32x24 - Behavioral
-- Project Name: MiniPIC24 - Project 6
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ROM32x24 is
    Port ( Addr : in  STD_LOGIC_VECTOR (4 downto 0);
           Data : out  STD_LOGIC_VECTOR (23 downto 0));
end ROM32x24;

architecture Behavioral of ROM32x24 is
    type tROM is array (0 to 31) of STD_LOGIC_VECTOR(23 downto 0);

    -- Default Program: Sequence ALL testing common & project 6 specific instructions
    constant ROM : tROM := (
        0  => x"808101", -- MOV 0x1020, W1 (INW0)
        1  => x"808112", -- MOV 0x1022, W2 (INW1)
        2  => x"400182", -- ADD W1, W2, W3
        3  => x"500202", -- SUB W1, W2, W4
        4  => x"600282", -- AND W1, W2, W5
        5  => x"700302", -- IOR W1, W2, W6
        6  => x"E70071", -- FF1L W1, W7    (Find First 1 from Left in W1, store in W7)
        7  => x"460051", -- ADD #5, W1    (W1 <= W1 + 5)
        8  => x"E10082", -- INC2 W2, W8   (W8 <= W2 + 2)
        9  => x"EB8480", -- SETM W9       (W9 <= 0xFFFF)
        10 => x"888123", -- MOV W3, 0x1024 (Write W3 to OUTW0)
        11 => x"370000", -- BRA LOOP (Infinite loop at address 11)
        others => x"000000"
    );
begin
    Data <= ROM(conv_integer(Addr));
end Behavioral;
