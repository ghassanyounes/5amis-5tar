-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
library displays;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use displays.lcd_types.all;
use displays.lcd_funcs.all;
entity LCD_Message_Fmt is
  port (clk, rst : in std_logic;
        opcode_st : in string(1 to 5);
        opcode    : in std_logic_vector( 6 downto 0);
        rd_i,rs1_i,rs2_i: in std_logic_vector( 4 downto 0);
        pc        : in std_logic_vector(11 downto 0):= x"000";
        imm       : in std_logic_vector(31 downto 0);
        msg       : out message := (others => "00100000")
    );
end entity;

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --

architecture rtl of LCD_Message_fmt is
  signal data_msg: message := (others => "00100000");
  signal rd, rs1, rs2: std_logic_vector(7 downto 0) := x"00";
begin
  msg <= data_msg;
  process (opcode) is 
  begin
    case '0' & opcode is
      when x"03" => -- LOAD: lw, lhw, lb
        rd  <= "000" &  rd_i;
        rs1 <= (others => '1');
        rs2 <= (others => '1');
      when x"13" => -- OP-IMM: i-type,
        rd  <= "000" &  rd_i;
        rs1 <= "000" & rs1_i;
        rs2 <= (others => '1');
      when x"17" => -- AUIPC  
        rd  <= "000" &  rd_i;
        rs1 <= (others => '1');
        rs2 <= (others => '1');
      when x"23" => -- STORE
        rd  <= (others => '1');
        rs1 <= "000" & rs1_i;
        rs2 <= "000" & rs2_i;
      when x"33" => -- OP
        rd  <= "000" &  rd_i;
        rs1 <= "000" & rs1_i;
        rs2 <= "000" & rs2_i;
      when x"37" => -- LUI
        rd  <= "000" &  rd_i;
        rs1 <= (others => '1');
        rs2 <= (others => '1');
      when x"63" => -- BRANCH
        rd  <= (others => '1');
        rs1 <= "000" & rs1_i;
        rs2 <= "000" & rs2_i;
      when x"67" => -- JALR
        rd  <= "000" &  rd_i;
        rs1 <= "000" & rs1_i;
        rs2 <=  (others => '1');
      when x"6F" => -- JAL
        rd  <= "000" &  rd_i;
        rs1 <= (others => '1');
        rs2 <= (others => '1');
      when others =>
        rd  <= (others => '1');
        rs1 <= (others => '1');
        rs2 <= (others => '1');
    end case;
  end process;
  
  process (clk, opcode) is
    constant immText  : string(1 to  4) := "Imm:";
    variable upper_lim, lower_lim: integer := 0;
  begin
  -- PC
  for i in 0 to 2 loop
    upper_lim := 11 - (i*4);
    lower_lim :=  8 - (i*4);
    if pc(upper_lim downto lower_lim) < "1010" then
      data_msg(i) <= num_to_ascii(pc(upper_lim downto lower_lim));
    elsif pc(upper_lim downto lower_lim) > "1001" then
      data_msg(i) <= hex_to_ascii(pc(upper_lim downto lower_lim));
    else
      data_msg(i) <= x"FF";
    end if; 
  end loop;
  -- imm
  for i in immText'range loop -- 1 to 4
    data_msg(3+i) <= char_to_ascii(immText(i));
  end loop;
  
  for i in 0 to 7 loop
    upper_lim := 31 - (i*4);
    lower_lim := 28 - (i*4);
    if imm(upper_lim downto lower_lim) < "1010" then
      data_msg( 8+i) <= num_to_ascii(imm(upper_lim downto lower_lim));
    elsif imm(upper_lim downto lower_lim) > "1001" then
      data_msg( 8+i) <= hex_to_ascii(imm(upper_lim downto lower_lim));
    else
      data_msg( 8+i) <= x"FF";
    end if; 
  end loop;
  
  -- instr
  data_msg(16) <= char_to_ascii('>'); 
  
  for i in opcode_st'range  loop -- 1 to 5
    data_msg(17+i) <= char_to_ascii(opcode_st(i));
  end loop;

  if rd(7 downto 5) = "111" then
    data_msg(24) <= x"2A";
    data_msg(25) <= x"2A";
  else
    if rd(7 downto 4) < "1010" then
      data_msg(24) <= num_to_ascii(rd(7 downto 4));
    elsif rd(7 downto 4) > "1001" then
      data_msg(24) <= hex_to_ascii(rd(7 downto 4));
    else
      data_msg(24) <= x"FF";
    end if; 
    if rd(3 downto 0) < "1010" then
      data_msg(25) <= num_to_ascii(rd(3 downto 0));
    elsif rd(3 downto 0) > "1001" then
      data_msg(25) <= hex_to_ascii(rd(3 downto 0));
    else
      data_msg(25) <= x"FF";
    end if; 
  end if;

  if rs1(7 downto 5) = "111" then
    data_msg(27) <= x"2A";
    data_msg(28) <= x"2A";
  else
    if rs1(7 downto 4) < "1010" then
      data_msg(27) <= num_to_ascii(rs1(7 downto 4));
    elsif rs1(7 downto 4) > "1001" then
      data_msg(27) <= hex_to_ascii(rs1(7 downto 4));
    else
      data_msg(27) <= x"FF";
    end if; 
    if rs1(3 downto 0) < "1010" then
      data_msg(28) <= num_to_ascii(rs1(3 downto 0));
    elsif rs1(3 downto 0) > "1001" then
      data_msg(28) <= hex_to_ascii(rs1(3 downto 0));
    else
      data_msg(28) <= x"FF";
    end if; 
  end if;

  if rs2(7 downto 5) = "111" then
    data_msg(30) <= x"2A";
    data_msg(31) <= x"2A";
  else
    if rs2(7 downto 4) < "1010" then
      data_msg(30) <= num_to_ascii(rs2(7 downto 4));
    elsif rs2(7 downto 4) > "1001" then
      data_msg(30) <= hex_to_ascii(rs2(7 downto 4));
    else
      data_msg(30) <= x"FF";
    end if; 
    if rs2(3 downto 0) < "1010" then
      data_msg(31) <= num_to_ascii(rs2(3 downto 0));
    elsif rs2(3 downto 0) > "1001" then
      data_msg(31) <= hex_to_ascii(rs2(3 downto 0));
    else
      data_msg(31) <= x"FF";
    end if; 
  end if;
  end process;
end rtl;
