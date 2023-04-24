--BIG WIP A COMPLETEER POR LES ETAGES

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity entite_test is
  --
end entity;

architecture arch_test_FE of entite_test is
  signal npc_t, npc_fw_br_t, pc_plus_4_t, i_FE_t : std_logic_vector (31 downto 0);
  signal PCSrc_ER_t, Bpris_EX_t, GEL_LI_t, clk_t : std_logic;
begin
  
  fe: entity work.etageFE 
    port map (npc_t, npc_fw_br_t, PCSrc_ER_t, Bpris_EX_t, GEL_LI_t, clk_t, pc_plus_4_t, i_FE_t);

  process 
  begin
    clk_t <= '0';
    npc_t <= (others => '0');
    npc_fw_br_t <= (others => '0');
    PCSrc_ER_t <= '0';
    Bpris_EX_t <= '0';
    GEL_LI_t <= '1';

    wait for 5 ns;
    clk_t <= '1';
    wait for 5 ns;

    clk_t <= '0';
    npc_t <= (others => '0');
    npc_fw_br_t <= (others => '0');
    PCSrc_ER_t <= '0';
    Bpris_EX_t <= '0';

    wait for 5 ns;
    clk_t <= '1';
    wait for 5 ns;

    wait for 5 ns;

    wait;
  end process;

end architecture;

architecture arch_test_DE of entite_test is
  signal Op1_t, Op2_t, extImm_t, i_DE_t, WD_ER_t, pc_plus_4_t : std_logic_vector (31 downto 0);
  signal Op3_ER_t, Reg1_t, Reg2_t, Op3_DE_t : std_logic_vector (3 downto 0);
  signal RegSrc_t, immSrc_t : std_logic_vector(1 downto 0);
  signal Reg_Wr_t, clk_t : std_logic;
begin
  
  de: entity work.etageDE
    port map (clk_t, Reg_Wr_t, i_DE_t, WD_ER_t, pc_plus_4_t, Op3_ER_t, RegSrc_t, immSrc_t, Reg1_t, Reg2_t, Op3_DE_t, Op1_t, Op2_t, extImm_t);
  process
  begin
    clk_t <= '0';
    i_DE_t <= "11100010100000000010000000001111"; --instruction reg/imm ADD R2, R0, #15
    WD_ER_t <= "10101010101010101010101010101010"; --valeur arbitraire
    Op3_ER_t <= "1000"; --on écrit dans R8
    pc_plus_4_t <= (2 => '1', others => '0');
    RegSrc_t <= "01"; 
    immSrc_t <= "00";
    Reg_Wr_t <= '1'; --on veut écrire la valeur arbitraire dans un registre

    wait for 5 ns;
    clk_t <= '1';
    wait for 5 ns;

    clk_t <= '0';
    Reg_Wr_t <= '0'; --cette fois on n'écrit pas dans le registre Op3

    wait for 5 ns;
    clk_t <= '1';
    wait for 5 ns;

    clk_t <= '0';
    i_DE_t <= "11100010100010000010000000001111"; --instruction qui regarde dans le registre R8

    wait for 5 ns;
    clk_t <= '1';
    wait for 5 ns;

    wait for 5 ns;

    wait;
  end process;

end architecture;

architecture arch_test_EX of entite_test is
  signal Op1_t, Op2_t, extImm_t, Res_fw_ME_t, Res_fwd_ER_t, Res_EX_t, WD_EX_t, npc_fw_br_t : std_logic_vector (31 downto 0);
  signal Op3_EX_t, CC_t, Op3_EX_out_t : std_logic_vector (3 downto 0);
  signal EA_EX_t, EB_EX_t, AluCtrl_EX_t : std_logic_vector(1 downto 0);
  signal AluSrc_EX_t : std_logic;
begin
  
  ex: entity work.etageEX
    port map (Op1_t, Op2_t, extImm_t, Res_fw_ME_t, Res_fwd_ER_t, Op3_EX_t, EA_EX_t, EB_EX_t, AluCtrl_EX_t, AluSrc_EX_t, Res_EX_t, WD_EX_t, npc_fw_br_t, CC_t, Op3_EX_out_t);

  process 
  begin
    Op1_t <= "00000000000000000000000000000111"; --7
    Op2_t <= "00000000000000000000000000000010"; --2
    EA_EX_t <= "00";
    EB_EX_t <= "00";
    Res_fw_ME_t <= (others => '0');
    Res_fwd_ER_t <= (others => '0');
    Op3_EX_t <= "1000";
    extImm_t <= (others => '0');
    AluSrc_EX_t <= '0';
    AluCtrl_EX_t <= "01"; -- moins

    wait for 5 ns;
    --vérifier que ça sort bien 5 (7 - 2)
    wait for 5 ns;

    Op1_t <= "00000000000000000000000000001000"; --8
    extImm_t <= "00000000000000000000000000000111"; --7
    AluSrc_EX_t <= '1';

    wait for 5 ns;
    --vérifier que ça sort bien 1 (8 - 1)
    wait for 5 ns;

    wait for 5 ns;

    wait;
  end process;

end architecture;