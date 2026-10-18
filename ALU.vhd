----------------------------------------------------------------------------------
-- Module Name: ALU - Behavioral
-- Project Name: MiniPIC24 - Project 6
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port ( Clk : in  STD_LOGIC;
           RdData1 : in  STD_LOGIC_VECTOR (15 downto 0);
           RdData2 : in  STD_LOGIC_VECTOR (15 downto 0);
           ALUOP : in  STD_LOGIC_VECTOR (2 downto 0);
           N_EN : in  STD_LOGIC;
           OV_EN : in  STD_LOGIC;
           Z_EN : in  STD_LOGIC;
           C_EN : in  STD_LOGIC;
           lit10 : in  STD_LOGIC_VECTOR (9 downto 0);
           Y : out  STD_LOGIC_VECTOR (15 downto 0);
           N : out  STD_LOGIC := '0';
           OV : out  STD_LOGIC := '0';
           Z : out  STD_LOGIC := '0';
           C : out  STD_LOGIC := '0');
end ALU;

architecture Behavioral of ALU is
    signal sY : STD_LOGIC_VECTOR(15 downto 0);
    signal result_ext : STD_LOGIC_VECTOR(16 downto 0);

    signal N_calc  : STD_LOGIC;
    signal OV_calc : STD_LOGIC;
    signal Z_calc  : STD_LOGIC;
    signal C_calc  : STD_LOGIC;

    signal N_reg  : STD_LOGIC := '0';
    signal OV_reg : STD_LOGIC := '0';
    signal Z_reg  : STD_LOGIC := '0';
    signal C_reg  : STD_LOGIC := '0';

    signal op_lit10 : STD_LOGIC_VECTOR(15 downto 0);
    signal ff1l_val : STD_LOGIC_VECTOR(15 downto 0);
    signal ff1l_c   : STD_LOGIC;
begin

    op_lit10 <= "000000" & lit10;

    -- FF1L Logic (Find First One from Left)
    process(RdData1)
    begin
        if RdData1(15) = '1' then
            ff1l_val <= x"0010"; ff1l_c <= '0';
        elsif RdData1(14) = '1' then
            ff1l_val <= x"000F"; ff1l_c <= '0';
        elsif RdData1(13) = '1' then
            ff1l_val <= x"000E"; ff1l_c <= '0';
        elsif RdData1(12) = '1' then
            ff1l_val <= x"000D"; ff1l_c <= '0';
        elsif RdData1(11) = '1' then
            ff1l_val <= x"000C"; ff1l_c <= '0';
        elsif RdData1(10) = '1' then
            ff1l_val <= x"000B"; ff1l_c <= '0';
        elsif RdData1(9) = '1' then
            ff1l_val <= x"000A"; ff1l_c <= '0';
        elsif RdData1(8) = '1' then
            ff1l_val <= x"0009"; ff1l_c <= '0';
        elsif RdData1(7) = '1' then
            ff1l_val <= x"0008"; ff1l_c <= '0';
        elsif RdData1(6) = '1' then
            ff1l_val <= x"0007"; ff1l_c <= '0';
        elsif RdData1(5) = '1' then
            ff1l_val <= x"0006"; ff1l_c <= '0';
        elsif RdData1(4) = '1' then
            ff1l_val <= x"0005"; ff1l_c <= '0';
        elsif RdData1(3) = '1' then
            ff1l_val <= x"0004"; ff1l_c <= '0';
        elsif RdData1(2) = '1' then
            ff1l_val <= x"0003"; ff1l_c <= '0';
        elsif RdData1(1) = '1' then
            ff1l_val <= x"0002"; ff1l_c <= '0';
        elsif RdData1(0) = '1' then
            ff1l_val <= x"0001"; ff1l_c <= '0';
        else
            ff1l_val <= x"0000"; ff1l_c <= '1'; -- Carry = 1 if no 1s found
        end if;
    end process;

    -- Core ALU Operation Selection
    process(ALUOP, RdData1, RdData2, op_lit10, ff1l_val, ff1l_c)
        variable add_res  : STD_LOGIC_VECTOR(16 downto 0);
        variable sub_res  : STD_LOGIC_VECTOR(16 downto 0);
        variable lit_res  : STD_LOGIC_VECTOR(16 downto 0);
        variable inc2_res : STD_LOGIC_VECTOR(16 downto 0);
    begin
        add_res  := ('0' & RdData1) + ('0' & RdData2);
        sub_res  := ('0' & RdData1) - ('0' & RdData2);
        lit_res  := ('0' & RdData1) + ('0' & op_lit10);
        inc2_res := ('0' & RdData1) + 2;

        case ALUOP is
            when "000" => -- ADD
                sY      <= add_res(15 downto 0);
                C_calc  <= add_res(16);
                N_calc  <= add_res(15);
                Z_calc  <= '1' when add_res(15 downto 0) = x"0000" else '0';
                OV_calc <= '1' when (RdData1(15) = RdData2(15)) and (add_res(15) /= RdData1(15)) else '0';

            when "001" => -- SUB
                sY      <= sub_res(15 downto 0);
                C_calc  <= '1' when RdData1 >= RdData2 else '0'; -- Carry set if no borrow
                N_calc  <= sub_res(15);
                Z_calc  <= '1' when sub_res(15 downto 0) = x"0000" else '0';
                OV_calc <= '1' when (RdData1(15) /= RdData2(15)) and (sub_res(15) /= RdData1(15)) else '0';

            when "010" => -- AND
                sY      <= RdData1 and RdData2;
                C_calc  <= '0';
                N_calc  <= RdData1(15) and RdData2(15);
                Z_calc  <= '1' when (RdData1 and RdData2) = x"0000" else '0';
                OV_calc <= '0';

            when "011" => -- IOR
                sY      <= RdData1 or RdData2;
                C_calc  <= '0';
                N_calc  <= RdData1(15) or RdData2(15);
                Z_calc  <= '1' when (RdData1 or RdData2) = x"0000" else '0';
                OV_calc <= '0';

            when "100" => -- FF1L
                sY      <= ff1l_val;
                C_calc  <= ff1l_c;
                N_calc  <= '0';
                Z_calc  <= '1' when ff1l_val = x"0000" else '0';
                OV_calc <= '0';

            when "101" => -- ADD #lit10, Wn
                sY      <= lit_res(15 downto 0);
                C_calc  <= lit_res(16);
                N_calc  <= lit_res(15);
                Z_calc  <= '1' when lit_res(15 downto 0) = x"0000" else '0';
                OV_calc <= '1' when (RdData1(15) = op_lit10(15)) and (lit_res(15) /= RdData1(15)) else '0';

            when "110" => -- INC2 Ws, Wd
                sY      <= inc2_res(15 downto 0);
                C_calc  <= inc2_res(16);
                N_calc  <= inc2_res(15);
                Z_calc  <= '1' when inc2_res(15 downto 0) = x"0000" else '0';
                OV_calc <= '1' when (RdData1(15) = '0') and (inc2_res(15) = '1') else '0';

            when "111" => -- SETM Wd
                sY      <= x"FFFF";
                C_calc  <= '0';
                N_calc  <= '1';
                Z_calc  <= '0';
                OV_calc <= '0';

            when others =>
                sY      <= (others => '0');
                C_calc  <= '0';
                N_calc  <= '0';
                Z_calc  <= '0';
                OV_calc <= '0';
        end case;
    end process;

    -- Synchronous Flag Registers with Enable Signals
    process(Clk)
    begin
        if rising_edge(Clk) then
            if N_EN = '1' then
                N_reg <= N_calc;
            end if;
            if OV_EN = '1' then
                OV_reg <= OV_calc;
            end if;
            if Z_EN = '1' then
                Z_reg <= Z_calc;
            end if;
            if C_EN = '1' then
                C_reg <= C_calc;
            end if;
        end if;
    end process;

    Y <= sY;
    N <= N_reg;
    OV <= OV_reg;
    Z <= Z_reg;
    C <= C_reg;

end Behavioral;
