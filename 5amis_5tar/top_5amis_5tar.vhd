-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
library clock;
library displays;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use clock.all;
use displays.all;
use displays.lcd_types.all;
entity top_5amis_5tar is 
  port (clock_50 : in std_logic;
        key  : in std_logic_vector (3  downto 0);
        sw   : in  std_logic_vector(17 downto 0);
				ledr : out std_logic_vector(17 downto 0);
				ledg : out std_logic_vector(8  downto 0);
				hex0 , hex1, hex2, hex3, hex4, hex5, hex6, hex7: out std_logic_vector(6 downto 0) := "1111111";
        lcd_rw  : buffer std_logic;
        lcd_data: inout std_logic_vector(7 downto 0);
        lcd_rs  , lcd_on, lcd_en: out std_logic);
end entity top_5amis_5tar;

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --

architecture rtl of top_5amis_5tar is

  component LCD_Message_Fmt is
    port (clk       : in std_logic;
          opcode_st : in string(1 to 5);
          opcode    : in std_logic_vector(6 downto 0);
          sw        : in std_logic_vector(15 downto 0);
          instr     : in std_logic_vector(31 downto 0);
          msg       : out message
      );
  end component;

  component control_unit is 
    port (br_lt, br_ge : in  std_logic := '0';
          inst       : in  std_logic_vector(31 downto 0) := (others => '0');
          opcode_str : out string(1 to 5) := "NOP  ";
          wb_sel     : out std_logic_vector( 1 downto 0) := (others => '0');
          imm_sel    : out std_logic_vector( 2 downto 0) := (others => '0');
          alu_op     : out std_logic_vector( 3 downto 0) := (others => '0');
          pc_sel, reg_w_en, br_un, alu_a_sel, alu_b_sel, mem_rw: out std_logic := '0');
  end component;

  signal clock_1hz , clock_10hz, clock_400hz, clock_1khz, clock_10Mhz, sys_clk: std_logic := '0';
  signal br_lt, br_un, br_ge, pc_sel, reg_w_en, alu_a_sel, alu_b_sel, mem_rw : std_logic := '0';
  signal program_counter, instruction: std_logic_vector(31 downto 0):= x"00F50513";
  signal immediate : std_logic_vector(19 downto 0) := (others => '0');
  signal opcode    : std_logic_vector( 6 downto 0) := (others => '0');
  signal opcode_st : string(1 to 5) := "NOP  ";
  signal dest_reg  : std_logic_vector( 4 downto 0) := (others => '0');
  signal alu_op    : std_logic_vector( 3 downto 0) := (others => '0');
  signal imm_sel   : std_logic_vector( 2 downto 0) := (others => '0');
  signal wb_sel    : std_logic_vector( 1 downto 0) := (others => '0');
  signal reset_sig : std_logic := '1';
  signal msg       : message := (others => "00100000");
begin
  -- Reset signal set by 0th button and shows on ledg(0) when active.
  reset_sig <= key(0);
  ledg(0) <= not reset_sig;
  
  -- Base clock is shown on ledg(8)
  sys_clk <= clock_1hz;
    -- sys_clk <= not key(3);  --an option for manual PC increments
  ledg(8) <= clock_1hz;
  
  -------------------------
  ctl_unt: control_unit 
  port map (br_lt, br_ge, instruction, opcode_st, wb_sel, imm_sel, alu_op,
            pc_sel, reg_w_en, br_un, alu_a_sel, alu_b_sel, mem_rw);

  -------------------------


  -- Upper 2 switches are mapped to red leds (16, 17)
  ledr(17 downto 16) <= sw(17 downto 16);

  -- Show immediate using LEDs (first nybble using green LEDs, rest on red)
  ledg( 7 downto  4) <= immediate( 3 downto 0);
  ledr(15 downto  0) <= immediate(19 downto 4);

  -- Display instruction on LCD display 
  message_fmt : LCD_Message_Fmt port map(clock_50, opcode_st, opcode, sw(15 downto 0), instruction, msg); 
  
  screen : entity displays.lcd_driver(rtl) 
    port map (reset => reset_sig, clk_400 => clock_400hz, chars => msg, d_bus => lcd_data, 
              rw_lcd => lcd_rw, rs_lcd => lcd_rs, on_lcd => lcd_on, en_lcd => lcd_en);
  
  -- Display opcode on hex 0,1
  dis0: entity displays.hexDisplay(rtl) 
    port map (nybble => opcode(3 downto 0), 
              disp   => hex0);
  dis1: entity displays.hexDisplay(rtl) 
    port map (nybble => "0" & opcode(6 downto 4), 
              disp   => hex1);

  -- Display destination register on hex 2,3
  dis2: entity displays.hexDisplay(rtl) 
    port map (nybble => dest_reg(3 downto 0), 
              disp   => hex2);
  dis3: entity displays.hexDisplay(rtl) 
    port map (nybble => "000" & dest_reg(4), 
              disp   => hex3);

  -- Display ALU setting on hex 4
  dis4: entity displays.hexDisplay(rtl) 
    port map (nybble => '0' & alu_op(2 downto 0), 
              disp   => hex4);
   
  -- Display Writeback select on hex 5
  dis5: entity displays.hexDisplay(rtl) 
    port map (nybble => "00" & wb_sel(1 downto 0), 
              disp   => hex5);

  -- Display program counter on hex 6,7
  dis6: entity displays.hexDisplay(rtl) 
    port map (nybble => program_counter(3 downto 0), 
              disp   => hex6);
  dis7: entity displays.hexDisplay(rtl) 
    port map (nybble => program_counter(7 downto 4), 
              disp   => hex7);
  
  clk_1: entity clock.clk_div(rtl) 
    generic map (size => 25, pre => 25_000_000)
    port map(clk_in => clock_50, clk_out => clock_1hz);
    
  clk_10: entity clock.clk_div(rtl) 
    generic map (size => 24, pre => 2_500_000)
    port map(clk_in => clock_50, clk_out => clock_10hz);
  
  clk_400: entity clock.clk_div(rtl) 
    generic map (size => 20, pre => 625_000)
    port map(clk_in => clock_50, clk_out => clock_400hz);
    
end rtl;