----------------------------------------------------------------------------------
-- Module Name: tb_PIC24_SPECIFIC - Behavioral
-- Testbench for Project 6 Specific Instructions sequence (ROM_SPECIFIC)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_PIC24_SPECIFIC is
end tb_PIC24_SPECIFIC;

architecture Behavioral of tb_PIC24_SPECIFIC is

    component PIC24
        Port ( Clk : in  STD_LOGIC;
               INW0 : in  STD_LOGIC_VECTOR (15 downto 0);
               INW1 : in  STD_LOGIC_VECTOR (15 downto 0);
               OUTW0 : out  STD_LOGIC_VECTOR (15 downto 0));
    end component;

    signal Clk : STD_LOGIC := '0';
    signal INW0 : STD_LOGIC_VECTOR(15 downto 0) := x"0080";
    signal INW1 : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
    signal OUTW0 : STD_LOGIC_VECTOR(15 downto 0);

    constant Clk_period : time := 20 ns;

begin

    uut: PIC24 port map (
        Clk => Clk,
        INW0 => INW0,
        INW1 => INW1,
        OUTW0 => OUTW0
    );

    Clk_process :process
    begin
        Clk <= '0';
        wait for Clk_period/2;
        Clk <= '1';
        wait for Clk_period/2;
    end process;

    stim_proc: process
    begin
        INW0 <= x"0080"; -- Bit 7 set -> FF1L output should be 8
        wait for 400 ns;
        wait;
    end process;

end Behavioral;
