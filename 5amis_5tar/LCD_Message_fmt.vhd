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
  port (clk       : in std_logic;
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
begin
  process (clk) is
    constant instrText: string(1 to 8) := "Inst: 0x";
    constant swText : string(1 to 5) := "Sw:0x"; 
    variable upper_lim, lower_lim: integer := 0;
  begin
  for i in instrText'range loop -- 1 to 6
    msg(i-1) <= char_to_ascii(instrText(i));
  end loop;
  
  for i in 0 to 7 loop
    upper_lim := 31 - (i*4);
    lower_lim := 28 - (i*4);
    if instr(upper_lim downto lower_lim) < "1010" then
      msg( 8+i) <= num_to_ascii(instr(upper_lim downto lower_lim));
    elsif instr(upper_lim downto lower_lim) > "1001" then
      msg( 8+i) <= hex_to_ascii(instr(upper_lim downto lower_lim));
    else
      msg( 8+i) <= x"FF";
    end if; 
  end loop;

  for i in swText'range loop -- 1 to 5
    msg(15+i) <= char_to_ascii(swText(i));
  end loop;

  for i in 0 to 3 loop
    upper_lim := 15 - (i*4);
    lower_lim := 12 - (i*4);
    if sw(upper_lim downto lower_lim) < "1010" then
      msg(21+i) <= num_to_ascii(sw(upper_lim downto lower_lim));
    elsif sw(upper_lim downto lower_lim) > "1001" then
      msg(21+i) <= hex_to_ascii(sw(upper_lim downto lower_lim));
    else
      msg(21+i) <= x"FF";
    end if; 
  end loop;
  
  msg(26) <= char_to_ascii('>'); 
  
  for i in opcode_st'range  loop -- 0 to 4
    msg(26+i) <= char_to_ascii(opcode_st(i));
  end loop;

  end process;
end rtl;