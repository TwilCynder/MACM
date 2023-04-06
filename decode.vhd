-------------------------------------------------------

-- Décodeur

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


entity decode is
  port(
    instr : in std_logic_vector(31 downto 0);
    PCSrc, RegWR, MemToReg, MemWr, , Branch, CCWr, AluSrc : out std_logic;
    AluCtrl, ImmSrc, RegSrc : out std_logic_vector(1 downto 0);
    Cond : out std_logic_vector (3 downto 0)
  );      
end entity;

architecture decode_arch of decode

begin
  AluCtrl <=
    "00" when instr(27 downto 26) = "10" else -- +
    (
      "00" when instr(24 downto 21) = "0100" else -- +
      "01" when instr(24 downto 21) = "0010" else -- -
      "10" when instr(24 downto 21) = "0000" else -- &
      "11" when instr(24 downto 21) = "1100" else -- |
      "01" when instr(24 downto 21) = "1010" else -- -
      "00" --error
    ) when instr(27 downto 26) = "00" else
    (
      "00" when instr(23) = '0' else -- +
      "01" when instr(23) = '1' else -- -
      "00" --error
    ) when instr(27 downto 26) = "01" else
    "00"  --error

  
end architecture;