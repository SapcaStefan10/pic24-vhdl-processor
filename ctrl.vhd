----------------------------------------------------------------------------------
-- Module Name: ctrl - Behavioral
-- Project Name: MiniPIC24 - Project 6
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ctrl is
    Port ( OP : in  STD_LOGIC_VECTOR (7 downto 0); -- Instr(23 downto 16)
           CE_NF : out  STD_LOGIC;
           CE_OVF : out  STD_LOGIC;
           CE_ZF : out  STD_LOGIC;
           CE_CF : out  STD_LOGIC;
           ALUOP : out  STD_LOGIC_VECTOR (2 downto 0);
           MemWr : out  STD_LOGIC;
           Mem2Reg : out  STD_LOGIC;
           RegWr : out  STD_LOGIC;
           Branch : out  STD_LOGIC;
           RegDest : out  STD_LOGIC_VECTOR (1 downto 0);
           BranchType : out  STD_LOGIC_VECTOR (2 downto 0));
end ctrl;

architecture Behavioral of ctrl is
begin
    process(OP)
    begin
        -- Default values
        CE_NF      <= '0';
        CE_OVF     <= '0';
        CE_ZF      <= '0';
        CE_CF      <= '0';
        ALUOP      <= "000";
        MemWr      <= '0';
        Mem2Reg    <= '0';
        RegWr      <= '0';
        Branch     <= '0';
        RegDest    <= "00";
        BranchType <= "111";

        case OP(7 downto 4) is
            when "0100" => -- ADD Wb, Ws, Wd (0x40) or ADD #lit10, Wn (0x46)
                if OP = x"46" then -- ADD #lit10, Wn
                    CE_NF   <= '1';
                    CE_OVF  <= '1';
                    CE_ZF   <= '1';
                    CE_CF   <= '1';
                    ALUOP   <= "101";
                    RegWr   <= '1';
                    RegDest <= "00"; -- Wn in bits 3..0
                else -- ADD Wb, Ws, Wd
                    CE_NF   <= '1';
                    CE_OVF  <= '1';
                    CE_ZF   <= '1';
                    CE_CF   <= '1';
                    ALUOP   <= "000";
                    RegWr   <= '1';
                    RegDest <= "01"; -- Wd in bits 10..7
                end if;

            when "0101" => -- SUB Wb, Ws, Wd (0x50)
                CE_NF   <= '1';
                CE_OVF  <= '1';
                CE_ZF   <= '1';
                CE_CF   <= '1';
                ALUOP   <= "001";
                RegWr   <= '1';
                RegDest <= "01";

            when "0110" => -- AND Wb, Ws, Wd (0x60)
                CE_NF   <= '1';
                CE_OVF  <= '0';
                CE_ZF   <= '1';
                CE_CF   <= '0';
                ALUOP   <= "010";
                RegWr   <= '1';
                RegDest <= "01";

            when "0111" => -- IOR Wb, Ws, Wd (0x70)
                CE_NF   <= '1';
                CE_OVF  <= '0';
                CE_ZF   <= '1';
                CE_CF   <= '0';
                ALUOP   <= "011";
                RegWr   <= '1';
                RegDest <= "01";

            when "1000" => -- MOV
                if OP(3) = '0' then -- MOV f, Wnd (0x80)
                    RegWr   <= '1';
                    RegDest <= "00"; -- Wnd in bits 3..0
                    Mem2Reg <= '1';
                else -- MOV Wns, f (0x88)
                    MemWr   <= '1';
                end if;

            when "0011" => -- Branches
                Branch <= '1';
                case OP(3 downto 0) is
                    when x"0"   => BranchType <= "000"; -- BRA OV
                    when x"1"   => BranchType <= "001"; -- BRA C
                    when x"2"   => BranchType <= "010"; -- BRA Z
                    when x"3"   => BranchType <= "011"; -- BRA N
                    when others => BranchType <= "111"; -- BRA Expr
                end case;

            when "1110" => -- Specific instructions (0xE1, 0xE7, 0xEB)
                if OP = x"E7" then -- FF1L Ws, Wnd
                    CE_CF   <= '1';
                    ALUOP   <= "100";
                    RegWr   <= '1';
                    RegDest <= "10"; -- Wnd in bits 7..4
                elsif OP = x"E1" then -- INC2 Ws, Wd
                    CE_NF   <= '1';
                    CE_OVF  <= '1';
                    CE_ZF   <= '1';
                    CE_CF   <= '1';
                    ALUOP   <= "110";
                    RegWr   <= '1';
                    RegDest <= "10"; -- Wd in bits 7..4
                elsif OP = x"EB" then -- SETM Wd
                    ALUOP   <= "111";
                    RegWr   <= '1';
                    RegDest <= "01"; -- Wd in bits 10..7
                end if;

            when others =>
                null;
        end case;
    end process;
end Behavioral;
