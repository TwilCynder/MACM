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