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
    Cond : out std_logic_vector (3 downto 0)
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

end architecture;

entity cond is
  port(
    CCWr_EX : in std_logic;
    CC, CC_EX, Cond : in std_logic_vector(3 downto 0);
    CondEx : out std_logic;
    CC_ : out std_logic_vector (3 downto 0)
  );      
end entity;

architecture cond_arch of cond is 
  signal CondEx_i : std_logic_vector(31 downto 0);
begin

  CondEx_i <= 

  CondEx <= CondEx_i;
  CC_ <= CC when CCWr_EX = '1' and CondEx_i = '1' else CC_EX;