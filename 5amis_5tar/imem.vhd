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
begin
  -- pc values are in hexadecimal
  case pc is
    --                     31                      11     6     0
    when x"00" => instr <= "0_0000011000_0_00000000_00001_1101111"; -- jal  x0, 0x18      | jump to pc = 0x30, the "main" function
    when x"04" => instr <= "0000000_00001_01010_001_01010_0010011"; -- slli a0, a0, 0x1   | a0 << 1
    when x"08" => instr <= "000000000101__01010_111_01010_0010011"; -- addi a0, a0, 0x5   | a0 += 5
    when x"0C" => instr <= "000000000000__00001_000_00000_1100111"; -- jalr x0, x1, 0x0   | return and discard return address
    when x"10" => instr <= "000000000000__00000_000_00000_0010011"; -- nop
    when x"14" => instr <= "000000000000__00000_000_00000_0010011"; -- nop
    when x"18" => instr <= "000000000000__00000_000_00000_0010011"; -- nop
    when x"1C" => instr <= "000000000000__00000_000_00000_0010011"; -- nop
    when x"20" => instr <= "000000000000__00000_000_00000_0010011"; -- nop
    when x"24" => instr <= "000000000000__00000_000_00000_0010011"; -- nop
    when x"28" => instr <= "000000000000__00000_000_00000_0010011"; -- nop
    when x"2C" => instr <= "000000000000__00000_000_00000_0010011"; -- nop
    when x"30" => instr <= "01000010000001101001____01010_0110111"; -- lui  a0, 0x42069   | a0 = 0x42069000
    when x"34" => instr <= "000000001111__00000_111_01010_0010011"; -- addi a0, x0, 0x00f | a0 = 0x4206900f
    when x"38" => instr <= "000000000010__00000_111_01010_0010011"; -- addi a1, x0, 0x004 | a1 = 0x00000004
    when x"3C" => instr <= "0000000_01010_01011_010_00000_0100011"; -- sw   a0, a1
    when x"40" => instr <= "0100000_01011_01010_000_01010_0110011"; -- sub  a0, a0, a1    | a0 = 0x4206900b
    when x"44" => instr <= "000000000000__01011_010_01011_0000011"; -- lw   a1, a1, 0x0   | a1 = 0x4206900f
    when x"48" => instr <= "0000000_01011_01010_100_01000_1100011"; -- blt  a0, a1, 0x1   | jump to pc = 0x54 by adding 8 to pc
    when x"4C" => instr <= "000000000000__00000_000_00000_0010011"; -- nop
    when x"50" => instr <= "000000000000__00000_000_00000_0010011"; -- nop
    when x"54" => instr <= "101111101110__00000_000_01010_0010011"; -- addi a0, x0, 0xbee | set a0 to be 0xbee
    when x"58" => instr <= "000000001000__00000_000_01000_0010011"; -- addi s0, x0, 0x8   | set s0 to be 0x8
    when x"5C" => instr <= "0000000_01000_01010_001_00010_0100011"; -- sh   s0, a0, 0x2   | store half word in second half of mem address ref'd by s0
    when x"60" => instr <= "1_1111010101_1_11111111_00001_1101111"; -- jal  x1, -0x56     | jump to 'shift 1 and add 5'
    when x"64" => instr <= "000000000000__01100_010_01100_0000011"; -- lw   a1, s0, 0x0   | load word from mem address ref'd by s0 into a1 | a1 = 0x000dea00
    when x"68" => instr <= "000011110000__01011_000_01011_0010011"; -- addi a1, a1, 0xf0  | add 0x69 to a1   | a1 = 0x000beef0
    when x"6C" => instr <= "0000000_01100_01011_001_01011_0010011"; -- slli a1, a1, 0xC   | a1 << 12 | a1 = 0xbeef0000
    when x"70" => instr <= "000000000100__00000_000_01100_0010011"; -- addi a2, x0, 0x004 | a2 = 0x00000004 
    when x"74" => instr <= "000000000000__01100_010_01100_0000011"; -- lw   a2, a2, 0x0   | a2 = 0x4206900f
    when x"78" => instr <= "000000001111__00000_000_01101_0010011"; -- addi a3, x0, 0xf   | a2 = 0x0000000f 
    when x"7C" => instr <= "0100000_01100_01011_000_01100_0110011"; -- sub  a2, a1, a2    | a2 = 0x42069000
    when x"80" => instr <= "0000000_01100_01011_111_01100_0110011"; -- and  a2, a2, a1    | a3 = 0x20600000
    when x"84" => instr <= "11011110101011010000____01110_0110111"; -- lui  a4, 0xdead0   | a4 = 0xdead0000
    when x"88" => instr <= "10111110111011110000____01010_0110111"; -- lui  a3, 0xbeef0   | a3 = 0xbeef0000
    when x"8C" => instr <= "0000000_10000_01101_101_01101_0010011"; -- srli a3, a3, 0x10  | a3 = 0x0000beef
    when x"90" => instr <= "0000000_01101_01110_110_01101_0110011"; -- or   a3, a3, a4    | a3 = 0xdeadbeef
    when x"94" => instr <= "10111110111011111101____01110_0110111"; -- lui  a4, 0xbeefd   | a4 = 0xbeefd000
    when x"98" => instr <= "111010101101__01101_000_01110_0010011"; -- addi a4, a4, 0xead | a4 = 0xbeefdead
    when x"9C" => instr <= "0000000_01101_01110_100_01110_0110011"; -- xor  a4, a3, a4    | a4 = 0x60426042
    when x"A0" => instr <= "00001111000000001111____01110_0010111"; -- auipc a4, 0x0f00f  | a4 = 0x0f00f0a0
    when x"A4" => instr <= "0000000_00000_01110_000_01100_0100011"; -- addi a2, x0, 0xc   | a2 = 0x0000000c
    when x"A8" => instr <= "0000000_01100_01110_000_00001_0100011"; -- sb   a2, a4, 0x1
    when x"AC" => instr <= "000000000000__01100_001_01100_0000011"; -- lh   a4, a2, 0x0   | a4 = 0x0000a000
    when x"B0" => instr <= "000000000001__01100_000_01111_0000011"; -- lb   a5, a2, 0x1   | a5 = 0x000000a0
    when x"B4" => instr <= "0000000_00100_01111_101_01111_0010011"; -- srli a5, a5, 0x4   | a5 = 0x0000000a
    when x"B8" => instr <= "0000000_01111_01110_101_01110_0110011"; -- srl  a4, a4, a5    | a4 = 0x00000028
    when x"BC" => instr <= "0000000_01111_01111_001_01111_0110011"; -- sll  a5, a5, a5    | a5 = 0x00028000
    when x"C0" => instr <= "0000000_00001_01111_101_01111_0010011"; -- srli a5, 0x1
    when x"C4" => instr <= "1111111_01111_01110_001_11101_1100011"; -- bne a5, a4, -0x1   | keep shifting a5 until they are equal
    when x"C8" => instr <= "000000100111__01111_100_01100_0010011"; -- xori a2, a5, 0x27  | a2 = 0x0000000f
    when x"CC" => instr <= "0000000_01110_01100_010_01111_0110011"; -- slt  a5, a2, a4    | a5 = 0x00000001
    when x"D0" => instr <= "000000000000__01100_010_01111_0010011"; -- slti a5, a2, 0x0   | a5 = 0x00000000
    when x"D4" => instr <= "0000000_01100_01110_000_01111_0110011"; -- add  a5, a4, a2    | a5 = 0x00000037
    when x"D8" => instr <= "0000000_01110_01111_111_01100_0110011"; -- and  a2, a5, a4    | a2 = 0x00000020
    when x"DC" => instr <= ""; -- 
    when x"E0" => instr <= ""; -- 
    when x"E4" => instr <= ""; -- 
    when x"E8" => instr <= ""; -- 
    when x"EC" => instr <= ""; -- 
    when x"F0" => instr <= ""; -- 
    when x"F4" => instr <= ""; -- 
    when x"F8" => instr <= ""; -- 
    when x"FC" => instr <= ""; -- 
    when x"100" => instr <= "000000110000  00000 000 00000 1100111"; -- jalr x0, x0, 0x30 | jump to beginning of main again 
    when others => 
                  instr <= "000000000000  00000 000 00000 0010011"; -- nop
  end case;
  -- Dereference is divided by 4 because each member of instr_arr is a 4-byte vector which therefore
  -- represents the 4-byte increase of the program counter
end rtl;
