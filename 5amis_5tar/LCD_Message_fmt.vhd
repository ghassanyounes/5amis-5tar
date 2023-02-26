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
  port (clk, tggl, rst : in std_logic;
        opcode_st : in string(1 to 5);
        opcode    : in std_logic_vector(6 downto 0);
        sw        : in std_logic_vector(15 downto 0);
        instr     : in std_logic_vector(31 downto 0);
        msg       : out message := (others => "00100000")
    );
end entity;

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --

architecture rtl of LCD_Message_fmt is
  type disp_state is (change, welcome1, welcome2, names, info_1, info_2, info_3, data);

  signal mode_shift: disp_state := welcome1;
  signal next_state: disp_state := welcome2;
  signal welcome1_msg, welcome2_msg, names_msg, 
         info_1_msg, info_2_msg, info_3_msg, data_msg: message := (others => "00100000");
begin
  process (clk) is
    constant welc1_str: string(1 to 32) := "Press KEY (1) to change screens ";
    constant welc2_str: string(1 to 32) := "   5amis 5tar,    a RISC-V mcu  ";
    constant names_str: string(1 to 32) := "Project by Jane,Camille, Ghassan";
    constant info1_str: string(1 to 32) := "Opcode: hex0,1     rd: hex2,3   ";
    constant info2_str: string(1 to 32) := "ALUop,WB: hex4,5   PC: hex6,7   ";
    constant info3_str: string(1 to 32) := "Immediate: LEDs   R 15-0,G 7-4  ";
    constant instrText: string(1 to  8) := "Inst: 0x";
    constant swText   : string(1 to  5) := "Sw:0x"; 
    variable upper_lim, lower_lim: integer := 0;
  begin

  for i in welc1_str'range loop -- 1 to 32
    welcome1_msg(i-1) <= char_to_ascii(welc1_str(i));
  end loop;

  for i in welc2_str'range loop -- 1 to 32
    welcome2_msg(i-1) <= char_to_ascii(welc2_str(i));
  end loop;

  for i in names_str'range loop -- 1 to 32
    names_msg(i-1) <= char_to_ascii(names_str(i));
  end loop;

  for i in info1_str'range loop -- 1 to 32
    info_1_msg(i-1) <= char_to_ascii(info1_str(i));
  end loop;

  for i in info2_str'range loop -- 1 to 32
    info_2_msg(i-1) <= char_to_ascii(info2_str(i));
  end loop;

  for i in info3_str'range loop -- 1 to 32
    info_3_msg(i-1) <= char_to_ascii(info3_str(i));
  end loop;

  for i in instrText'range loop -- 1 to 6
    data_msg(i-1) <= char_to_ascii(instrText(i));
  end loop;
  
  for i in 0 to 7 loop
    upper_lim := 31 - (i*4);
    lower_lim := 28 - (i*4);
    if instr(upper_lim downto lower_lim) < "1010" then
      data_msg( 8+i) <= num_to_ascii(instr(upper_lim downto lower_lim));
    elsif instr(upper_lim downto lower_lim) > "1001" then
      data_msg( 8+i) <= hex_to_ascii(instr(upper_lim downto lower_lim));
    else
      data_msg( 8+i) <= x"FF";
    end if; 
  end loop;

  for i in swText'range loop -- 1 to 5
    data_msg(15+i) <= char_to_ascii(swText(i));
  end loop;

  for i in 0 to 3 loop
    upper_lim := 15 - (i*4);
    lower_lim := 12 - (i*4);
    if sw(upper_lim downto lower_lim) < "1010" then
      data_msg(21+i) <= num_to_ascii(sw(upper_lim downto lower_lim));
    elsif sw(upper_lim downto lower_lim) > "1001" then
      data_msg(21+i) <= hex_to_ascii(sw(upper_lim downto lower_lim));
    else
      data_msg(21+i) <= x"FF";
    end if; 
  end loop;
  
  data_msg(26) <= char_to_ascii('>'); 
  
  for i in opcode_st'range  loop -- 0 to 4
    data_msg(26+i) <= char_to_ascii(opcode_st(i));
  end loop;
  end process;

  process (tggl, rst) is 
  begin
  if rst = '0' then 
    msg <= welcome1_msg;
    mode_shift <= change;
    next_state <= welcome2;
  elsif tggl'event and tggl = '1' then
    case (mode_shift) is
    when change   => mode_shift <= next_state;
    when welcome1 =>
      msg         <= welcome1_msg;
      mode_shift  <= change;
      next_state  <= welcome2;
    when welcome2 =>
      msg         <= welcome2_msg;
      mode_shift  <= change;
      next_state  <= names;
    when names    =>
      msg         <= names_msg;
      mode_shift  <= change;
      next_state  <= info_1;
    when info_1   =>
      msg         <= info_1_msg;
      mode_shift  <= change;
      next_state  <= info_2;
    when info_2   =>
      msg         <= info_2_msg;
      mode_shift  <= change;
      next_state  <= info_3;
    when info_3   =>
      msg         <= info_3_msg;
      mode_shift  <= change;
      next_state  <= data;
    when data     =>
      msg         <= data_msg;
      mode_shift  <= change;
      next_state  <= welcome2;
    when others   => 
      msg         <= welcome1_msg;
      mode_shift  <= change;
      next_state  <= welcome2;
    end case;
  end if;
  end process;
end rtl;