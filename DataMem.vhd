----------------------------------------------------------------------------------
-- Module Name: DataMem - Behavioral
-- Project Name: MiniPIC24 - Project 6
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DataMem is
    Port ( Clk : in  STD_LOGIC;
           Wr : in  STD_LOGIC;
           Addr : in  STD_LOGIC_VECTOR (4 downto 0);
           DataIn : in  STD_LOGIC_VECTOR (15 downto 0);
           INW0 : in  STD_LOGIC_VECTOR (15 downto 0);
           INW1 : in  STD_LOGIC_VECTOR (15 downto 0);
           DataOut : out  STD_LOGIC_VECTOR (15 downto 0);
           OUTW0 : out  STD_LOGIC_VECTOR (15 downto 0) := x"0000");
end DataMem;

architecture Behavioral of DataMem is
    type RAM16x16 is array (0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
    signal RAM : RAM16x16 := (others => (others => '0'));
    signal MemData : STD_LOGIC_VECTOR(15 downto 0);
begin

    process(Clk)
    begin
        if rising_edge(Clk) then
            if Wr = '1' then
                if Addr(4) = '0' then
                    RAM(conv_integer(Addr(3 downto 0))) <= DataIn;
                elsif Addr(4) = '1' and Addr(3 downto 0) = "0010" then -- I/O 0x1024 OUTW0
                    OUTW0 <= DataIn;
                end if;
            end if;
        end if;
    end process;

    MemData <= RAM(conv_integer(Addr(3 downto 0)));

    -- Read multiplexing
    process(Addr, MemData, INW0, INW1)
    begin
        if Addr(4) = '0' then
            DataOut <= MemData;
        else
            if Addr(3 downto 0) = "0000" then -- 0x1020 INW0
                DataOut <= INW0;
            elsif Addr(3 downto 0) = "0001" then -- 0x1022 INW1
                DataOut <= INW1;
            else
                DataOut <= x"0000";
            end if;
        end if;
    end process;

end Behavioral;
