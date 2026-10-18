----------------------------------------------------------------------------------
-- Module Name: PIC24 - Structural Top Level
-- Project Name: MiniPIC24 - Project 6
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PIC24 is
    Port ( Clk : in  STD_LOGIC;
           INW0 : in  STD_LOGIC_VECTOR (15 downto 0);
           INW1 : in  STD_LOGIC_VECTOR (15 downto 0);
           OUTW0 : out  STD_LOGIC_VECTOR (15 downto 0));
end PIC24;

architecture Structural of PIC24 is

    -- Component Declarations
    component ProgCnt
        Port ( Clk : in  STD_LOGIC;
               New_PC : in  STD_LOGIC_VECTOR (5 downto 0);
               PC : out  STD_LOGIC_VECTOR (5 downto 0));
    end component;

    component PC_Update
        Port ( N : in  STD_LOGIC;
               OV : in  STD_LOGIC;
               Z : in  STD_LOGIC;
               C : in  STD_LOGIC;
               Slit16 : in  STD_LOGIC_VECTOR (4 downto 0);
               BranchType : in  STD_LOGIC_VECTOR (2 downto 0);
               Branch : in  STD_LOGIC;
               PC : in  STD_LOGIC_VECTOR (5 downto 0);
               New_PC : out  STD_LOGIC_VECTOR (5 downto 0));
    end component;

    component ROM32x24
        Port ( Addr : in  STD_LOGIC_VECTOR (4 downto 0);
               Data : out  STD_LOGIC_VECTOR (23 downto 0));
    end component;

    component ctrl
        Port ( OP : in  STD_LOGIC_VECTOR (7 downto 0);
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
    end component;

    component MUX_Reg_Dest
        Port ( I0 : in  STD_LOGIC_VECTOR (3 downto 0);
               I1 : in  STD_LOGIC_VECTOR (3 downto 0);
               I2 : in  STD_LOGIC_VECTOR (3 downto 0);
               Sel : in  STD_LOGIC_VECTOR (1 downto 0);
               Y : out  STD_LOGIC_VECTOR (3 downto 0));
    end component;

    component File_Regs
        Port ( Clk : in  STD_LOGIC;
               WrEn : in  STD_LOGIC;
               RdReg1 : in  STD_LOGIC_VECTOR (3 downto 0);
               RdReg2 : in  STD_LOGIC_VECTOR (3 downto 0);
               WrReg : in  STD_LOGIC_VECTOR (3 downto 0);
               WrData : in  STD_LOGIC_VECTOR (15 downto 0);
               RdData1 : out  STD_LOGIC_VECTOR (15 downto 0);
               RdData2 : out  STD_LOGIC_VECTOR (15 downto 0));
    end component;

    component ALU
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
               N : out  STD_LOGIC;
               OV : out  STD_LOGIC;
               Z : out  STD_LOGIC;
               C : out  STD_LOGIC);
    end component;

    component DataMem
        Port ( Clk : in  STD_LOGIC;
               Wr : in  STD_LOGIC;
               Addr : in  STD_LOGIC_VECTOR (4 downto 0);
               DataIn : in  STD_LOGIC_VECTOR (15 downto 0);
               INW0 : in  STD_LOGIC_VECTOR (15 downto 0);
               INW1 : in  STD_LOGIC_VECTOR (15 downto 0);
               DataOut : out  STD_LOGIC_VECTOR (15 downto 0);
               OUTW0 : out  STD_LOGIC_VECTOR (15 downto 0));
    end component;

    component MUX2V16
        Port ( I0 : in  STD_LOGIC_VECTOR (15 downto 0);
               I1 : in  STD_LOGIC_VECTOR (15 downto 0);
               Sel : in  STD_LOGIC;
               Y : out  STD_LOGIC_VECTOR (15 downto 0));
    end component;

    -- Internal Signals
    signal PC          : STD_LOGIC_VECTOR (5 downto 0);
    signal New_PC      : STD_LOGIC_VECTOR (5 downto 0);
    signal Instr       : STD_LOGIC_VECTOR (23 downto 0);
    signal N, OV, Z, C : STD_LOGIC;

    signal CE_NF, CE_OVF, CE_ZF, CE_CF : STD_LOGIC;
    signal ALUOP      : STD_LOGIC_VECTOR (2 downto 0);
    signal MemWr, Mem2Reg, RegWr, Branch : STD_LOGIC;
    signal RegDest    : STD_LOGIC_VECTOR (1 downto 0);
    signal BranchType : STD_LOGIC_VECTOR (2 downto 0);

    signal RdReg1_sel : STD_LOGIC_VECTOR (3 downto 0);
    signal WrReg      : STD_LOGIC_VECTOR (3 downto 0);
    signal RdData1    : STD_LOGIC_VECTOR (15 downto 0);
    signal RdData2    : STD_LOGIC_VECTOR (15 downto 0);
    signal ALU_Y      : STD_LOGIC_VECTOR (15 downto 0);
    signal Mem_DataOut: STD_LOGIC_VECTOR (15 downto 0);
    signal WrData     : STD_LOGIC_VECTOR (15 downto 0);

begin

    -- Register read port 1 multiplexing:
    -- For 3-operand arithmetic (ADD, SUB, AND, IOR): Wb is at Instr(18 downto 15).
    -- For single operand/2-operand (FF1L, ADD #lit10, INC2, MOV Wns): Ws/Wn is at Instr(3 downto 0).
    RdReg1_sel <= Instr(18 downto 15) when (Instr(23 downto 20) = "0100" or
                                            Instr(23 downto 20) = "0101" or
                                            Instr(23 downto 20) = "0110" or
                                            Instr(23 downto 20) = "0111") and
                                           Instr(23 downto 16) /= x"46"
                  else Instr(3 downto 0);

    -- Instantiations
    U_ProgCnt: ProgCnt port map (
        Clk => Clk,
        New_PC => New_PC,
        PC => PC
    );

    U_ROM: ROM32x24 port map (
        Addr => PC(5 downto 1),
        Data => Instr
    );

    U_ctrl: ctrl port map (
        OP => Instr(23 downto 16),
        CE_NF => CE_NF,
        CE_OVF => CE_OVF,
        CE_ZF => CE_ZF,
        CE_CF => CE_CF,
        ALUOP => ALUOP,
        MemWr => MemWr,
        Mem2Reg => Mem2Reg,
        RegWr => RegWr,
        Branch => Branch,
        RegDest => RegDest,
        BranchType => BranchType
    );

    U_PC_Update: PC_Update port map (
        N => N,
        OV => OV,
        Z => Z,
        C => C,
        Slit16 => Instr(4 downto 0),
        BranchType => BranchType,
        Branch => Branch,
        PC => PC,
        New_PC => New_PC
    );

    U_MUX_Reg_Dest: MUX_Reg_Dest port map (
        I0 => Instr(3 downto 0),
        I1 => Instr(10 downto 7),
        I2 => Instr(7 downto 4),
        Sel => RegDest,
        Y => WrReg
    );

    U_File_Regs: File_Regs port map (
        Clk => Clk,
        WrEn => RegWr,
        RdReg1 => RdReg1_sel,
        RdReg2 => Instr(3 downto 0),
        WrReg => WrReg,
        WrData => WrData,
        RdData1 => RdData1,
        RdData2 => RdData2
    );

    U_ALU: ALU port map (
        Clk => Clk,
        RdData1 => RdData1,
        RdData2 => RdData2,
        ALUOP => ALUOP,
        N_EN => CE_NF,
        OV_EN => CE_OVF,
        Z_EN => CE_ZF,
        C_EN => CE_CF,
        lit10 => Instr(13 downto 4),
        Y => ALU_Y,
        N => N,
        OV => OV,
        Z => Z,
        C => C
    );

    U_DataMem: DataMem port map (
        Clk => Clk,
        Wr => MemWr,
        Addr => Instr(8 downto 4),
        DataIn => RdData1,
        INW0 => INW0,
        INW1 => INW1,
        DataOut => Mem_DataOut,
        OUTW0 => OUTW0
    );

    U_MUX2V16: MUX2V16 port map (
        I0 => ALU_Y,
        I1 => Mem_DataOut,
        Sel => Mem2Reg,
        Y => WrData
    );

end Structural;
