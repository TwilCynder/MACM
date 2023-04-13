-------------------------------------------------------

-- Chemin de données

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

--GEL LI VIENT DE LA GESTION DES ALEAS
entity dataPath is
  port(
    clk,  ALUSrc_EX, MemWr_Mem, MemWr_RE, PCSrc_ER, Bpris_EX, Gel_LI, Gel_DI, RAZ_DI, RegWR, Clr_EX, MemToReg_RE : in std_logic;
    RegSrc, EA_EX, EB_EX, immSrc, ALUCtrl_EX : in std_logic_vector(1 downto 0);
    instr_DE: out std_logic_vector(31 downto 0);
    a1, a2, CC: out std_logic_vector(3 downto 0)
);      
end entity;

architecture dataPath_arch of dataPath is
  signal Res_RE, npc_fwd_br, pc_plus_4, i_FE, i_DE, Op1_DE, Op2_DE, Op1_EX, Op2_EX, extImm_DE, extImm_EX, Res_EX, Res_ME, WD_EX, WD_ME, Res_Mem_ME, Res_Mem_RE, Res_ALU_ME, Res_ALU_RE, Res_fwd_ME : std_logic_vector(31 downto 0);
  signal Op3_DE, Op3_EX, a1_DE, a1_EX, a2_DE, a2_EX, Op3_EX_out, Op3_ME, Op3_ME_out, Op3_RE, Op3_RE_out : std_logic_vector(3 downto 0);
begin

  -- FE
  fe: entity work.etageFE
    port map (Res_RE, npc_fwd_br, PCSrc_ER, Bpris_EX, GEL_LI, clk, pc_plus_4, i_FE);

  reg_fe_de: entity work.Reg32sync
    port map(i_FE, i_DE, Gel_DI, RAZ_DI, clk);
  instr_DE <= i_DE;

  -- DE
  de: entity work.etageDE
    port map (clk, RegWr, i_DE, Res_RE, pc_plus_4, Op3_RE_out, RegSrc, immSrc, a1_DE, a2_DE, Op3_DE, Op1_DE, Op2_DE, extImm_DE);
  
  reg_de_ex_a1: entity work.Reg4
    port map (a1_DE, a1, '1', Clr_EX, clk);
  reg_de_ex_a2: entity work.Reg4
    port map (a2_DE, a2, '1', Clr_EX, clk);
  reg_de_ex_Op1: entity work.Reg32sync
    port map (Op1_DE, Op1_EX, '1', Clr_EX, clk);
  reg_de_ex_Op2: entity work.Reg32sync
    port map (Op2_DE, Op2_EX, '1', Clr_EX, clk);
  reg_de_ex_extImm: entity work.Reg32sync
    port map (extImm_DE, extImm_EX, '1', Clr_EX, clk);
  reg_de_ex_Op3: entity work.Reg4
    port map (Op3_DE, Op3_EX, '1', Clr_EX, clk);
  
  -- EX
  ex: entity work.etageEX
    port map(Op1_EX, Op2_Ex, ExtImm_EX, Res_fwd_ME, Res_RE, Op3_EX, EA_EX, EB_EX, ALUCtrl_EX, ALUSrc_EX, Res_EX, WD_EX, npc_fwd_br, CC, Op3_EX_out);

  reg_ex_me_Res: entity work.Reg32sync
    port map(Res_EX, Res_ME, '1', '1', clk);
  reg_ex_me_WD: entity work.Reg32sync
    port map(WD_EX, WD_ME, '1', '1', clk);
  reg_ex_me_Op3: entity work.Reg4
    port map (Op3_EX_out, Op3_ME, '1', '1', clk);
  
  -- ME
  me: entity work.etageME
    port map(Res_ME, WD_ME, Op3_ME, clk, MemWR_Mem, Res_Mem_ME, Res_ALU_ME, Res_fwd_ME, Op3_ME_out);
  
  reg_me_re_Res_Mem: entity work.Reg32sync
    port map(Res_Mem_ME, Res_Mem_RE, '1', '1', clk);
  reg_me_re_ALU: entity work.Reg32sync
    port map(Res_ALU_ME, Res_ALU_RE, '1', '1', clk);
  reg_me_re_Op3: entity work.Reg4
    port map(Op3_ME_out, Op3_RE, '1', '1', clk);
  
  -- RE
  re: entity work.etageER
    port map(Res_Mem_RE, Res_ALU_RE, Op3_RE, MemToReg_RE, Res_RE, Op3_RE_out);
  
end architecture;
