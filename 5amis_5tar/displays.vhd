-- --------------------------------------------------------------------------------------------- --
--                                      PACKAGE DECLARATIONS                                     --
-- --------------------------------------------------------------------------------------------- --
-- Type Package
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package lcd_types is
type state_type is (
  hold, func_set, disp_on , mode_set, return_home, toggle_en, reset1, reset2, reset3, display_clear, disp_off,
  write_ch00, write_ch01, write_ch02, write_ch03, write_ch04, write_ch05, write_ch06, write_ch07, 
  write_ch08, write_ch09, write_ch10, write_ch11, write_ch12, write_ch13, write_ch14, write_ch15, 
  write_ch16, write_ch17, write_ch18, write_ch19, write_ch20, write_ch21, write_ch22, write_ch23, new_line,
  write_ch24, write_ch25, write_ch26, write_ch27, write_ch28, write_ch29, write_ch30, write_ch31
);
  
type message is array (0 to 31) of std_logic_vector (7 downto 0);

end package lcd_types;

-- Function package

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
package lcd_funcs is 

function num_to_ascii (in_val: in std_logic_vector(3 downto 0)) return std_logic_vector;
function hex_to_ascii (in_val: in std_logic_vector(3 downto 0)) return std_logic_vector;
function char_to_ascii(in_val: in character) return std_logic_vector;

end package lcd_funcs;

package body lcd_funcs is 
function num_to_ascii (in_val: in std_logic_vector(3 downto 0)) return std_logic_vector is
begin
  return "0011" & in_val;
end function num_to_ascii;

function hex_to_ascii (in_val: in std_logic_vector(3 downto 0)) return std_logic_vector is
begin
  return "0100" & std_logic_vector("0001" + unsigned(in_val) - "1010");
end function hex_to_ascii;

function char_to_ascii(in_val: in character) return std_logic_vector is
begin
  return std_logic_vector(to_unsigned(character'pos(in_val), 8));
end function char_to_ascii;

end package body lcd_funcs;


-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
use ieee.std_logic_1164.all;
entity hexDisplay is 
  port(nybble: in  std_logic_vector(3 downto 0);
       disp:   out std_logic_vector(6 downto 0));
end hexDisplay;

library ieee;
use ieee.std_logic_1164.all;
use work.lcd_types.all;
entity lcd_driver is
  port (reset : in std_logic := '0';
        clk   : in std_logic := '0';
        chars : in message;
        d_bus : inout  std_logic_vector(7 downto 0);
        rw_lcd: buffer std_logic;
        rs_lcd, on_lcd, en_lcd, blon_lcd: out std_logic);
end entity lcd_driver;

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --

architecture rtl of hexDisplay is
begin
	display: process(nybble) is 
		begin
		case nybble is 
			when "0000" => disp <= "1000000"; --0
			when "0001" => disp <= "1111001"; --1
			when "0010" => disp <= "0100100"; --2
			when "0011" => disp <= "0110000"; --3
			when "0100" => disp <= "0011001"; --4
			when "0101" => disp <= "0010010"; --5
			when "0110" => disp <= "0000010"; --6
			when "0111" => disp <= "1111000"; --7
			when "1000" => disp <= "0000000"; --8
			when "1001" => disp <= "0011000"; --9
			when "1010" => disp <= "0001000"; --A
			when "1011" => disp <= "0000011"; --b
			when "1100" => disp <= "1000110"; --c
			when "1101" => disp <= "0100001"; --d
			when "1110" => disp <= "0000110"; --E
			when "1111" => disp <= "0001110"; --F
			when others => disp <= "0101011"; --n
		end case;
	end process;
end rtl;


architecture rtl of lcd_driver is
  signal state, next_command : work.lcd_types.state_type;
  signal data_bus: std_logic_vector(7 downto 0) := "ZZZZZZZZ";
  signal chars_added: std_logic_vector(4 downto 0) := "00000";
 begin
  d_bus <= data_bus when rw_lcd = '0' else "ZZZZZZZZ";
  on_lcd <= '1';
  
  main_loop: process (clk, reset) is
  begin
  if (reset = '1') then 
    state <= reset1; 
    data_bus <= x"38"; 
    next_command <= reset2;
    en_lcd <= '1';
    rs_lcd <= '0';
    rw_lcd <= '0';
  elsif clk'event and clk = '1' then 
  case state is 
    -- Pushbutton reset needs 3 states to allow for variability of clk edge
    when reset1 =>
      en_lcd <= '1';
      rs_lcd <= '0';
      rw_lcd <= '0'; 
      data_bus <= x"38";
      state <= toggle_en;
      next_command <= reset2;
    when reset2 => 
      en_lcd <= '1';
      rs_lcd <= '0';
      rw_lcd <= '0'; 
      data_bus <= x"38";
      state <= toggle_en;
      next_command <= reset3;
    when reset3 => 
      en_lcd <= '1';
      rs_lcd <= '0';
      rw_lcd <= '0'; 
      data_bus <= x"38";
      state <= toggle_en;
      next_command <= func_set;
 
    when func_set =>
      en_lcd <= '1';
      rs_lcd <= '0';
      rw_lcd <= '0'; 
      data_bus <= x"38";
      state <= toggle_en;
      next_command <= disp_off;
    -- turn display off and turn off cursor
    when disp_off =>
      en_lcd <= '1';
      rs_lcd <= '0';
      rw_lcd <= '0'; 
      data_bus <= x"08";
      state <= toggle_en;
      next_command <= display_clear;
    -- turn display on and turn off cursor
    when display_clear =>
      en_lcd <= '1';
      rs_lcd <= '0';
      rw_lcd <= '0'; 
      data_bus <= x"01";
      state <= toggle_en;
      next_command <= disp_on;
    -- turn display on and turn off cursor
    when disp_on =>
      en_lcd <= '1';
      rs_lcd <= '0';
      rw_lcd <= '0'; 
      data_bus <= x"0C";
      state <= toggle_en;
      next_command <= mode_set;
    -- set write mode to auto increment address and move cursor to the right
    when mode_set =>
      en_lcd <= '1';
      rs_lcd <= '0';
      rw_lcd <= '0'; 
      data_bus <= x"06";
      state <= toggle_en;
      next_command <= write_ch00;

    -- write ascii character in lcd character location
    when write_ch00 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(0);
      state <= toggle_en;
      next_command <= write_ch01;
    -- write ascii character in lcd character location
    when write_ch01 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(1);
      state <= toggle_en;
      next_command <= write_ch02;
    -- write ascii character in lcd character location
    when write_ch02 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(2);
      state <= toggle_en;
      next_command <= write_ch03;
    -- write ascii character in lcd character location
    when write_ch03 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(3);
      state <= toggle_en;
      next_command <= write_ch04;
    -- write ascii character in lcd character location
    when write_ch04 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(4);
      state <= toggle_en;
      next_command <= write_ch05;
    -- write ascii character in lcd character location
    when write_ch05 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(5);
      state <= toggle_en;
      next_command <= write_ch06;
    -- write ascii character in lcd character location
    when write_ch06 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(6);
      state <= toggle_en;
      next_command <= write_ch07;
    -- write ascii character in lcd character location
    when write_ch07 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(7);
      state <= toggle_en;
      next_command <= write_ch08;
    -- write ascii character in lcd character location
    when write_ch08 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(8);
      state <= toggle_en;
      next_command <= write_ch09;
    -- write ascii character in lcd character location
    when write_ch09 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(9);
      state <= toggle_en;
      next_command <= write_ch10;
    -- write ascii character in lcd character location
    when write_ch10 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(10);
      state <= toggle_en;
      next_command <= write_ch11;
    -- write ascii character in lcd character location
    when write_ch11 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(11);
      state <= toggle_en;
      next_command <= write_ch12;
    -- write ascii character in lcd character location
    when write_ch12 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(12);
      state <= toggle_en;
      next_command <= write_ch13;
    -- write ascii character in lcd character location
    when write_ch13 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(13);
      state <= toggle_en;
      next_command <= write_ch14;
    -- write ascii character in lcd character location
    when write_ch14 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(14);
      state <= toggle_en;
      next_command <= write_ch15;
    -- write ascii character in lcd character location
    when write_ch15 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(15);
      state <= toggle_en;
      next_command <= new_line;
    -- move to next line
    when new_line =>
      en_lcd <= '1';
      rs_lcd <= '0';
      rw_lcd <= '0'; 
      data_bus <= x"A8"; -- Go to (b1000_0000) + character index 40 (b0010_1000)
      state <= toggle_en;
      next_command <= write_ch16;
    -- write ascii character in lcd character location
    when write_ch16 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(16);
      state <= toggle_en;
      next_command <= write_ch17;
    -- write ascii character in lcd character location
    when write_ch17 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(17);
      state <= toggle_en;
      next_command <= write_ch18;
    -- write ascii character in lcd character location
    when write_ch18 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(18);
      state <= toggle_en;
      next_command <= write_ch19;
    -- write ascii character in lcd character location
    when write_ch19 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(19);
      state <= toggle_en;
      next_command <= write_ch20;
    -- write ascii character in lcd character location
    when write_ch20 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(20);
      state <= toggle_en;
      next_command <= write_ch21;
    -- write ascii character in lcd character location
    when write_ch21 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(21);
      state <= toggle_en;
      next_command <= write_ch22;
    -- write ascii character in lcd character location
    when write_ch22 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(22);
      state <= toggle_en;
      next_command <= write_ch23;
    -- write ascii character in lcd character location
    when write_ch23 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(23);
      state <= toggle_en;
      next_command <= write_ch24;
    -- write ascii character in lcd character location
    when write_ch24 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(24);
      state <= toggle_en;
      next_command <= write_ch25;
    -- write ascii character in lcd character location
    when write_ch25 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(25);
      state <= toggle_en;
      next_command <= write_ch26;
    -- write ascii character in lcd character location
    when write_ch26 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(26);
      state <= toggle_en;
      next_command <= write_ch27;
    -- write ascii character in lcd character location
    when write_ch27 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(27);
      state <= toggle_en;
      next_command <= write_ch28;
    -- write ascii character in lcd character location
    when write_ch28 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(28);
      state <= toggle_en;
      next_command <= write_ch29;
    -- write ascii character in lcd character location
    when write_ch29 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(29);
      state <= toggle_en;
      next_command <= write_ch30;
    -- write ascii character in lcd character location
    when write_ch30 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(30);
      state <= toggle_en;
      next_command <= write_ch31;
    -- write ascii character in lcd character location
    when write_ch31 =>
      en_lcd <= '1';
      rs_lcd <= '1';
      rw_lcd <= '0'; 
      data_bus <= chars(31);
      state <= toggle_en;
      next_command <= return_home;
      
    -- Return to original position
    when return_home =>
      en_lcd <= '1';
      rs_lcd <= '0';
      rw_lcd <= '0'; 
      data_bus <= x"02";
      state <= toggle_en;
      next_command <= write_ch00;
      
     -- These coordinate toggling the states
     -- Toggle E line on the falling edge loads instruction/data to LCD controller
    when toggle_en => 
      en_lcd <= '0';
      state <= hold;
    when hold =>
      state <= next_command;
    end case;
  end if;
  end process;
 end rtl;
