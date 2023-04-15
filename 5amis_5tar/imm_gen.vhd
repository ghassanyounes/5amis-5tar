-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity imm_gen is
  port (instr   : in std_logic_vector(24 downto 0);
        imm_sel : in std_logic_vector(2 downto 0);
        imm     : out std_logic_vector(31 downto 0));
end entity;

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --

architecture rtl of imm_gen is
begin
process(imm_sel)
begin 
  case imm_sel is
    when "000" => -- i-type
      imm(31 downto 11) <= (others => instr(24));
      imm(10 downto 5)  <= instr(23 downto 18);
      imm(4 downto 0)   <= instr(17 downto 13);
    when "001" => -- s-type
      imm(31 downto 11) <= (others => instr(24));
      imm(10 downto 5)  <= instr(23 downto 18);
      imm(4 downto 0)   <= instr(4 downto 0);
    when "010" => -- b-type
      imm(31 downto 12) <= (others => instr(24));
      imm(11)           <= instr(0);
      imm(10 downto 5)  <= instr(23 downto 18);
      imm(4 downto 1)   <= instr(4 downto 1);
      imm(0)            <= '0'; 
    when "011" => -- u-type
      imm(31)           <= instr(24);
      imm(30 downto 20) <= instr(23 downto 13);
      imm(19 downto 12) <= instr(12 downto 5);
      imm(11 downto 0)  <= (others => '0');
    when "100" => -- j-type
      imm(31 downto 20) <= (others => instr(24));
      imm(19 downto 12) <= instr(12 downto 5);
      imm(11)           <= instr(13);
      imm(10 downto 5)  <= instr(23 downto 18);
      imm(4 downto 1)   <= instr(17 downto 14);
      imm(0)            <= '0';
    when others =>
      imm <= (others => '0');
  end case;
  
end process;
end rtl;