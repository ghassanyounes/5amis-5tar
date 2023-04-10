-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity imem is 
  port (pc   : in  std_logic_vector(31 downto 0); 
        instr: out std_logic_vector(31 downto 0));
end entity;

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --

architecture rtl of imem is 
  type imem_arr is array (natural range <>) of std_logic_vector(31 downto 0);
  signal instr_arr : imem_arr(0 to 29): (others => x"00000013" ) -- default NOP
begin

  instr_arr( 0) <= ""; -- jal  x0, 0x6        | jump to pc = 14, the "main" function
  instr_arr( 1) <= ""; -- sll  a0, a0, 0x1    | a0 << 1
  instr_arr( 2) <= ""; -- addi a0, a0, 0x5    | a0 += 5
  instr_arr( 3) <= ""; -- jalr x0, x1, 0x0    | return and discard return address
  instr_arr( 4) <= ""; -- 
  instr_arr( 5) <= ""; -- 
  instr_arr( 6) <= ""; -- 
  instr_arr( 7) <= ""; -- 
  instr_arr( 8) <= ""; -- 
  instr_arr( 9) <= ""; -- 
  instr_arr(10) <= ""; -- 
  instr_arr(11) <= ""; --                     
  instr_arr(12) <= ""; -- lui  a0, 0x04206    | a0 = 0x04206000
  instr_arr(13) <= ""; -- addi a0, x0, 0x90f  | a0 = 0x0420690F
  instr_arr(14) <= ""; -- addi a1, x0, 0x004  | a1 = 0x00000004
  instr_arr(15) <= ""; -- sw   a0, a1
  instr_arr(16) <= ""; -- sub  a0, a0, a1     | a0 = 0x0420690B
  instr_arr(17) <= ""; -- lw   a1, a1         | a1 = 0x0420690F
  instr_arr(18) <= ""; -- blt  a0, a1, 0x2    | jump to pc = 22
  instr_arr(19) <= ""; -- 
  instr_arr(20) <= ""; -- 
  instr_arr(21) <= ""; -- 
  instr_arr(22) <= ""; -- 
  instr_arr(23) <= ""; -- 
  instr_arr(24) <= ""; -- jal  x1, 0x4        | jump to shift 1 and add 5
  instr_arr(25) <= ""; -- 
  instr_arr(26) <= ""; -- 
  instr_arr(27) <= ""; -- 
  instr_arr(28) <= ""; -- 
  instr_arr(29) <= ""; -- 

  instr <= instr_arr(pc/4)
  -- Dereference is divided by 4 because each member of instr_arr is a 4-byte vector which therefore
  -- represents the 4-byte increase of the program counter
end rtl;
