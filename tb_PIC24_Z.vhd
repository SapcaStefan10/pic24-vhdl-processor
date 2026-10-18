----------------------------------------------------------------------------------
-- Module Name: tb_PIC24_Z - Behavioral
-- Testbench for Zero Flag sequence (ROM_Z)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_PIC24_Z is
end tb_PIC24_Z;

architecture Behavioral of tb_PIC24_Z is

    component PIC24
        Port ( Clk : in  STD_LOGIC;
               INW0 : in  STD_LOGIC_VECTOR (15 downto 0);
               INW1 : in  STD_LOGIC_VECTOR (15 downto 0);
               OUTW0 : out  STD_LOGIC_VECTOR (15 downto 0));
    end component;

    signal Clk : STD_LOGIC := '0';
    signal INW0 : STD_LOGIC_VECTOR(15 downto 0) := x"FFFF";
    signal INW1 : STD_LOGIC_VECTOR(15 downto 0) := x"0001";
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
        INW0 <= x"FFFF";
        INW1 <= x"0001";
        wait for 300 ns;
        wait;
    end process;

end Behavioral;
