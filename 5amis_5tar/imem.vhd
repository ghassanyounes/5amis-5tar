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

instructions: process(pc) is
begin

  -- pc values are in hexadecimal
  case pc is
  
--        when x"00000000" => instr <= B"000000000000_00000_000_00000_0010011"; -- nop 
--      when x"00000004" => instr <= B"000000000100_00001_000_00010_0010011"; -- addi x2, x1, 4     | x2 = 0 + 15 = 15
--      when x"00000008" => instr <= B"0100000_00001_00010_000_00011_0110011"; -- sub  x3, x2, x1    | x3 = 15 - 0 = 15
--      when x"0000000C" => instr <= B"0000000_00011_00010_010_00000_0100011"; -- sw x3, 0(x2)  (store data in x3 at address from address at x2, with offset 4)
--      when x"00000010" => instr <= B"0000000_00000_00010_010_00100_0100011"; -- sw x0, 4(x2)  (store data in x3 at address from address at x2, with offset 4)
--      when x"00000014" => instr <= B"000000000000_00010_010_00100_0000011"; --  lw   x4, 0(x2)   | a2 = 0x4206900f
--      when x"00000018" => instr <= B"000000000100_00010_010_00100_0000011"; --  lw   x4, 4(x2)   | a2 = 0x4206900f
      
      
     
--      when x"00000004" => instr <= B"000000000100_00001_000_00010_0010011"; -- addi x2, x1, 4
--      when x"00000008" => instr <= B"01000010000001101001_00011_0110111"; -- lui  x3, 0x42069   
--      when x"0000000C" => instr <= B"001001101001_00011_000_00011_0010011"; -- addi x3, x3, 0x269     
      --when x"00000010" => instr <= B"0000000_00011_00010_010_00000_0100011"; -- sw x3, 0(x2)  
--      when x"00000010" => instr <= B"0000000_00011_00010_000_00000_0100011"; -- sb x3, 0(x2)
--      when x"00000014" => instr <= B"0000000_00011_00010_001_00100_0100011"; -- sh x3, 4(x2)
--      when x"00000018" => instr <= B"0000000_00011_00010_010_01000_0100011"; -- sh x3, 8(x2)
--      when x"0000001C" => instr <= B"000000000000_00010_010_00100_0000011"; --  lw   x4, 0(x2)   
--      when x"00000020" => instr <= B"000000000100_00010_010_00101_0000011"; --  lw   x4, 4(x2)   
--      when x"00000024" => instr <= B"000000001000_00010_010_00110_0000011"; --  lw   x4, 8(x2)
      --when x"00000014" => instr <= B"000000000001_00010_000_00101_0000011"; -- lb x5, 1(x2)
      --when x"00000018" => instr <= B"000000000010_00010_000_00101_0000011"; -- lb x5, 2(x2)
      
    --  when x"00000010" => instr <= B"0000000_00011_00000_100_00001_1100011"; -- blt  a0, a1, 0x2   | jump to pc = 0x54 by adding 8 to pc
    --                            31                      11     6     0
    when x"00000000" => instr <= B"0_0000011000_0_00000000_00001_1101111"; -- jal  x0, 0x18      | jump to pc = 0x30, the "main" function
    when x"00000004" => instr <= B"0000000_00001_01010_001_01010_0010011"; -- slli a0, a0, 0x1   | a0 << 1
    when x"00000008" => instr <=  B"000000000101_01010_000_01010_0010011"; -- addi a0, a0, 0x5   | a0 += 5
    when x"0000000C" => instr <=  B"000000000000_00001_000_00000_1100111"; -- jalr x0, x1, 0x0   | return and discard return address
    when x"00000010" => instr <=  B"000000000000_00000_000_00000_0010011"; -- nop
    when x"00000014" => instr <=  B"000000000000_00000_000_00000_0010011"; -- nop
    when x"00000018" => instr <=  B"000000000000_00000_000_00000_0010011"; -- nop
    when x"0000001C" => instr <=  B"000000000000_00000_000_00000_0010011"; -- nop
    when x"00000020" => instr <=  B"000000000000_00000_000_00000_0010011"; -- nop
    when x"00000024" => instr <=  B"000000000000_00000_000_00000_0010011"; -- nop
    when x"00000028" => instr <=  B"000000000000_00000_000_00000_0010011"; -- nop
    when x"0000002C" => instr <=  B"000000000000_00000_000_00000_0010011"; -- nop
    when x"00000030" => instr <=    B"01000010000001101001_01010_0110111"; -- lui  a0, 0x42069   | a0 = 0x42069000
    when x"00000034" => instr <=  B"000000001111_01010_000_01010_0010011"; -- addi a0, a0, 0x00f | a0 = 0x4206900f
    when x"00000038" => instr <=  B"000000000100_00000_000_01011_0010011"; -- addi a1, x0, 0x004 | a1 = 0x00000004
    when x"0000003C" => instr <= B"0000000_01010_01011_010_00000_0100011"; -- sw   a0, a1
    when x"00000040" => instr <= B"0100000_01011_01010_000_01010_0110011"; -- sub  a0, a0, a1    | a0 = 0x4206900b
    when x"00000044" => instr <=  B"000000000000_01011_010_01011_0000011"; -- lw   a1, a1, 0x0   | a1 = 0x4206900f
    when x"00000048" => instr <= B"0000000_01011_01010_100_01100_1100011"; -- blt  a0, a1, 0x2   | jump to pc = 0x54 by adding 8 to pc
    when x"0000004C" => instr <=  B"000000000000_00000_000_00000_0010011"; -- nop
    when x"00000050" => instr <=  B"000000000000_00000_000_00000_0010011"; -- nop
    when x"00000054" => instr <=  B"101111101110_00000_000_01010_0010011"; -- addi a0, x0, 0xbee | set a0 to be 0xbee
    when x"00000058" => instr <=  B"000000001000_00000_000_01000_0010011"; -- addi s0, x0, 0x8   | set s0 to be 0x8
    when x"0000005C" => instr <= B"0000000_01000_01010_001_00010_0100011"; -- sh   s0, a0, 0x2   | store half word in second half of mem address ref'd by s0
    when x"00000060" => instr <= B"1_1111010010_1_11111111_00001_1101111"; -- jal  x1, -0x56     | jump to 'shift 1 and add 5'
    when x"00000064" => instr <=  B"000000000000_01000_010_01011_0000011"; -- lw   a1, (0x0)s0   | load word from mem address ref'd by s0 into a1 | a1 = 0x000dea00
    when x"00000068" => instr <=  B"000011110000_01011_000_01011_0010011"; -- addi a1, a1, 0xf0  | add 0x69 to a1   | a1 = 0x000beef0
    when x"0000006C" => instr <= B"0000000_01100_01011_001_01011_0010011"; -- slli a1, a1, 0xC   | a1 << 12 | a1 = 0xbeef0000
    when x"00000070" => instr <=  B"000000000100_00000_000_01100_0010011"; -- addi a2, x0, 0x004 | a2 = 0x00000004 
    when x"00000074" => instr <=  B"000000000000_01100_010_01100_0000011"; -- lw   a2, (0x0)a2   | a2 = 0x4206900f
    when x"00000078" => instr <=  B"000000001111_00000_000_01101_0010011"; -- addi a3, x0, 0xf   | a2 = 0x0000000f 
    when x"0000007C" => instr <= B"0100000_01100_01011_000_01100_0110011"; -- sub  a2, a1, a2    | a2 = 0x42069000
    when x"00000080" => instr <= B"0000000_01100_01011_111_01100_0110011"; -- and  a2, a2, a1    | a3 = 0x20600000
    when x"00000084" => instr <=    B"11011110101011010000_01110_0110111"; -- lui  a4, 0xdead0   | a4 = 0xdead0000
    when x"00000088" => instr <=    B"10111110111011110000_01010_0110111"; -- lui  a3, 0xbeef0   | a3 = 0xbeef0000
    when x"0000008C" => instr <= B"0000000_10000_01101_101_01101_0010011"; -- srli a3, a3, 0x10  | a3 = 0x0000beef
    when x"00000090" => instr <= B"0000000_01101_01110_110_01101_0110011"; -- or   a3, a3, a4    | a3 = 0xdeadbeef
    when x"00000094" => instr <=    B"10111110111011111101_01110_0110111"; -- lui  a4, 0xbeefd   | a4 = 0xbeefd000
    when x"00000098" => instr <=  B"111010101101_01101_000_01110_0010011"; -- addi a4, a4, 0xead | a4 = 0xbeefdead
    when x"0000009C" => instr <= B"0000000_01101_01110_100_01110_0110011"; -- xor  a4, a3, a4    | a4 = 0x60426042
    when x"000000A0" => instr <=    B"00001111000000001111_01110_0010111"; -- auipc a4, 0x0f00f  | a4 = 0x0f00f0a0
    when x"000000A4" => instr <= B"0000000_00000_01110_000_01100_0100011"; -- addi a2, x0, 0xc   | a2 = 0x0000000c
    when x"000000A8" => instr <= B"0000000_01100_01110_000_00001_0100011"; -- sb   a2, (0x1)a4 
    when x"000000AC" => instr <=  B"000000000000_00000_000_00000_0010011"; -- nop
    when x"000000B0" => instr <=  B"000000000000_01100_010_01100_0000011"; -- lw   a4, a2, 0x0   | a4 = 0x0000a000
    when x"000000B4" => instr <=  B"000000000001_01100_010_01111_0000011"; -- srli   a5, a4, 0x8   | a5 = 0x000000a0
    when x"000000B8" => instr <= B"0000000_00100_01111_101_01111_0010011"; -- srli a5, a5, 0x4   | a5 = 0x0000000a
    when x"000000BC" => instr <= B"0000000_01111_01111_001_01111_0110011"; -- sll  a5, a5, a5    | a5 = 0x00028000
    when x"000000C0" => instr <= B"0000000_01111_01110_101_01110_0110011"; -- srl  a4, a4, a5    | a4 = 0x00000028
    when x"000000C4" => instr <= B"1111111_01111_01110_001_11101_1100011"; -- bne a5, a4, -0x1   | keep shifting a5 until they are equal
    when x"000000C8" => instr <= B"0000000_00001_01111_101_01111_0010011"; -- srli a5, 0x1
    when x"000000CC" => instr <= B"0000000_01110_01100_010_01111_0110011"; -- slt  a5, a2, a4    | a5 = 0x00000001
    when x"000000D0" => instr <=  B"000000100111_01111_100_01100_0010011"; -- xori a2, a5, 0x27  | a2 = 0x0000000f
    when x"000000D4" => instr <= B"0000000_01100_01110_000_01111_0110011"; -- add  a5, a4, a2    | a5 = 0x00000037
    when x"000000D8" => instr <=  B"000000000000_01100_010_01111_0010011"; -- slti a5, a2, 0x0   | a5 = 0x00000000
    when x"00000100" => instr <= B"0000000_01110_01111_111_01100_0110011"; -- and  a2, a5, a4    | a2 = 0x00000020
    when x"00000104" => instr <=  B"000000110000_00000_000_00000_1100111"; -- jalr x0, x0, 0x30 | jump to beginning of main again 
      when others =>    instr <=  B"000000000000_00000_000_00000_0010011"; -- nop
  end case;
  
end process;
end rtl;
