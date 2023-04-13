-------------------------------------------------------

-- Décodeur

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


entity decode is
  port(
    instr : in std_logic_vector(31 downto 0);
    PCSrc, RegWR, MemToReg, MemWr, Branch, CCWr, AluSrc : out std_logic;
    AluCtrl, ImmSrc, RegSrc : out std_logic_vector(1 downto 0);
    Cond : out std_logic_vector (3 downto 0) --LEFT TO CONTROLLER ENTITY
  );      
end entity;

architecture decode_arch of decode is 

begin
  AluCtrl(1) <= '1' when instr(27 downto 26) = "00" and (instr(24 downto 21) = "0000" or instr(24 downto 21) = "1100") else '0';
  AluCtrl(0) <= 
    instr(23) when instr(27 downto 26) = "01" else
    '1' when instr(27 downto 26) = "00" and (instr(24) = '1' or instr(24 downto 21) = "0010") else
    '0';

  Branch <= '1' when instr(27 downto 26) = "10" else '0';

  MemToReg <= '1' when instr(27 downto 26) = "01" and instr (20) = '1' else '0';

  MemWr <= '1' when instr(27 downto 26) = "01" and instr (20) = '0' else '0';

  AluSrc <= '0' when instr(27 downto 26) = "00" and instr (25) = '0' else '1';

  ImmSrc <= instr(27 downto 26);

  RegWr <= 
    '1' when (instr(27 downto 26) = "00" and  not (instr (25) = '0' and instr(20) = '1')) or (instr(27 downto 26) = "00" and instr (20) = '1')
    else '0';

  RegSrc(0) <= '1' when instr(27 downto 26) = "10" else '0';
  RegSrc(1) <= '1' when instr(27 downto 26) = "01" else '0';

  PCSrc <= '1' when instr(15 downto 12) = "1111" and not (instr(27 downto 26) = "01" and instr (20) = '0') else '0';

  CCWr <= '1' when instr(27 downto 26) = "00" and instr (20) = '1' else '0';

  Cond <= instr(31 downto 28);

end architecture;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity cond is
  port(
    CCWr_EX : in std_logic;
    CC, CC_EX, CondCode : in std_logic_vector(3 downto 0);
    CondEx : out std_logic;
    CC_new : out std_logic_vector (3 downto 0)
  );      
end entity;

architecture cond_arch of cond is 
  signal CondEx_i : std_logic;
  signal N, Z, C, V : std_logic;
begin

  --N Z C V
  N <= CC(3);
  Z <= CC(2);
  C <= CC(1);
  V <= CC(0);

  CondEx_i <= 
    Z             when CondCode = "0000" else
    not Z         when CondCode = "0001" else
    C             when CondCode = "0010" else 
    not C         when CondCode = "0011" else
    N             when CondCode = "0100" else 
    not N         when CondCode = "0101" else
    V             when CondCode = "0110" else 
    not V         when CondCode = "0111" else
    C and not Z   when CondCode = "1000" else
    (not C) or Z  when CondCode = "1001" else
    N xnor V      when CondCode = "1010" else
    N xor  V      when CondCode = "1011" else
    (not Z) and (N xor V) when CondCode = "1100" else
    Z or (N xor V)        when CondCode = "1101" else
    '1'           when CondCode = "1110" else
    '0';

  CondEx <= CondEx_i;
  CC_new <= CC when CCWr_EX = '1' and CondEx_i = '1' else CC_EX;

end architecture;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity controller is
  port(
    Clr_EX, clk : in std_logic;
    CC : in std_logic_vector (3 downto 0);
    instr : in std_logic_vector(31 downto 0);
  
    PCSrc, BPris, RegWR, ALUSrc, MemWR, MemToReg: out std_logic;
    AluCtrl, immSrc, RegSrc : out std_logic_vector(1 downto 0)

  );  
end entity;

architecture controller_arch of controller is 
  signal RegWr_DE, RegWr_EX, RegWr_EX_cond, RegWr_Mem : std_logic;
  signal PCSrc_DE, PCSrc_EX, PCSrc_EX_cond, PCSrc_Mem : std_logic;
  signal MemWR_DE, MemWR_EX, MemWR_EX_cond : std_logic;
  signal Bpris_DE, Bpris_EX : std_logic;
  signal CCWr_DE, CCWr_EX : std_logic;
  signal MemToReg_DE, MemToReg_EX, MemToReg_Mem : std_logic;
  signal AluSrc_DE : std_logic;
  signal CondEx : std_logic;

  signal AluCtrl_DE : std_logic_vector (1 downto 0);

  signal Cond_DE, Cond_EX : std_logic_vector(3 downto 0);
  signal CC_loop, CC_EX : std_logic_vector(3 downto 0);

begin

  decode: entity work.decode
    port map (
      instr, 
      PCSrc_DE, RegWr_DE, MemToReg_DE, MemWR_DE, Bpris_DE, CCWr_DE, AluSrc_DE,
      AluCtrl_DE, immSrc, RegSrc,
      Cond_DE
    );

  reg_de_ex_regwr: entity work.Reg1
    port map (RegWr_DE, RegWr_EX, '1', Clr_EX, clk);
  reg_de_ex_pcsrc: entity work.Reg1
    port map (PCSrc_DE, PCSrc_EX, '1', Clr_EX, clk);
  reg_de_ex_ccwr: entity work.Reg1
    port map (CCWr_DE, CCWr_EX, '1', Clr_EX, clk);
  reg_de_ex_memwr: entity work.Reg1
    port map (MemWR_DE, MemWR_EX, '1', Clr_EX, clk);
  reg_de_ex_aluctrl: entity work.Reg2
    port map (AluCtrl_DE, AluCtrl, '1', Clr_EX, clk);
  reg_de_ex_bpris: entity work.Reg1
    port map (Bpris_DE, Bpris_EX, '1', Clr_EX, clk);
  reg_de_ex_memtoreg: entity work.Reg1
    port map (MemToReg_DE, MemToReg_EX, '1', Clr_EX, clk);
  reg_de_ex_alusrc: entity work.Reg1
    port map (AluSrc_DE, ALUSrc, '1', Clr_EX, clk);
  reg_de_ex_cond: entity work.Reg4
    port map (Cond_DE, Cond_EX, '1', Clr_EX, clk);
  reg_de_ex_cc_loop: entity work.Reg4
    port map (CC_loop, CC_EX, '1', Clr_EX, clk);

  cond: entity work.cond
    port map (CCWr_EX, CC, CC_EX, Cond_EX, CondEx, CC_loop);
  
  RegWr_EX_cond <= RegWr_EX and CondEx;
  PCSrc_EX_cond <= PCSrc_EX and CondEx;
  MemWR_EX_cond <= MemWR_EX and CondEx;
  BPris <= Bpris_EX and CondEx;

end architecture;