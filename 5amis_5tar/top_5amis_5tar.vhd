-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
library clock;
library displays;
library commonmods;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use clock.all;
use displays.all;
use displays.lcd_types.all;
use commonmods.all;

entity top_5amis_5tar is
  port (lcd_rw   : buffer std_logic;
        clock_50 : in     std_logic;
        key      : in     std_logic_vector( 3 downto 0);
        sw       : in     std_logic_vector(17 downto 0);
        lcd_data : inout  std_logic_vector(7 downto 0);
				ledr     : out    std_logic_vector(17 downto 0);
				ledg     : out    std_logic_vector( 8 downto 0);
        lcd_rs, lcd_on, lcd_en: out std_logic;
				hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7: out std_logic_vector(6 downto 0) := "1111111");
end entity top_5amis_5tar;

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --

architecture rtl of top_5amis_5tar is

  component LCD_Message_Fmt is
    port (clk, rst : in std_logic;
          opcode_st : in string(1 to 5);
          opcode    : in std_logic_vector( 6 downto 0);
          rd_i,rs1_i,rs2_i: in std_logic_vector( 4 downto 0);
          pc        : in std_logic_vector(11 downto 0);
          imm       : in std_logic_vector(31 downto 0);
          msg       : out message := (others => "00100000")
          );
  end component;

  component control_unit is
    port (br_lt, br_eq : in  std_logic := '0';
          inst         : in  std_logic_vector(31 downto 0) := (others => '0');
          opcode_str   : out string(1 to 5)                := "NOP  ";
          opcode       : out std_logic_vector( 6 downto 0) := (others => '0');
          wb_sel       : out std_logic_vector( 1 downto 0) := (others => '0');
          imm_sel, lst : out std_logic_vector( 2 downto 0) := (others => '0');
          alu_op       : out std_logic_vector( 3 downto 0) := (others => '0');
          pc_sel, reg_w_en, br_un, alu_a_sel, alu_b_sel, mem_rw: out std_logic := '0');
  end component;

  component imem is
  port (pc   : in  std_logic_vector(31 downto 0);
        instr: out std_logic_vector(31 downto 0));
  end component;

  component imm_gen is
  port (instr   : in std_logic_vector(24 downto 0);
        imm_sel : in std_logic_vector(2 downto 0);
        imm     : out std_logic_vector(31 downto 0));
  end component;

  component alu is
  port (data_in1 : in  std_logic_vector(31 downto 0);
        data_in2 : in  std_logic_vector(31 downto 0);
        op_code  : in  std_logic_vector( 3 downto 0);
		    data_out : out std_logic_vector(31 downto 0));
  end component;

  component pc is
  port (clk        : in  std_logic;
        reset      : in  std_logic;
        current_pc : in  std_logic_vector(31 downto 0);
        pc_out     : out std_logic_vector(31 downto 0));
  end component;

  component reg_file is
  port (clk, reset          : in  std_logic;
        write_en            : in  std_logic;                     -- 1 = write, 0 = read
        dataD               : in  std_logic_vector(31 downto 0); -- writeback
        addrD, addrA, addrB : in  std_logic_vector(4 downto 0);  -- rd, rs1, rs2
        dataA, dataB        : out std_logic_vector(31 downto 0);
        disp_sel : in std_logic_vector(4 downto 0);
        whatsinthereg : out std_logic_vector(31 downto 0));
  end component;

  component branch_comp is
  port (a, b         : in  std_logic_vector(31 downto 0);
          br_un        : in  std_logic;
          br_eq, br_lt : out std_logic := '0');
  end component;

  component load_sign_extend is
  port (value: in  std_logic_vector(31 downto 0);
        lst  : in  std_logic_vector( 2 downto 0);
        offst: in  std_logic_vector( 2 downto 0); -- std_logic_vector(unsigned(to_integer(signed(immediate)) mod 4))
        res  : out std_logic_vector(31 downto 0));
  end component;

  component biten_sel is
  port (immediate: in  std_logic_vector(31 downto 0);
        lst: in  std_logic_vector(2 downto 0);
        biten: out std_logic_vector(3 downto 0));
  end component;

  signal clock_1hz , clock_10hz, clock_600hz, clock_1khz, clock_10Mhz, sys_clk, br_lt, br_un,
         br_eq, pc_sel, reg_w_en, alu_a_sel, alu_b_sel, mem_rw : std_logic := '0';
  signal rs1, rs2, alu_a, alu_b, alu_res : std_logic_vector(31 downto 0) := (others => 'X');
  signal program_counter, next_pc, pcp4, store_value, loaded_value : std_logic_vector(31 downto 0) := x"00000000";
  signal instruction    : std_logic_vector(31 downto 0) := x"00F50513";
  signal immediate      : std_logic_vector(31 downto 0) := (others => '0');
  signal wb, dmem_out   : std_logic_vector(31 downto 0) := (others => 'X');
  signal opcode         : std_logic_vector( 6 downto 0) := (others => 'X');
  signal dest_reg       : std_logic_vector( 4 downto 0) := (others => '0');
  signal alu_op, biten  : std_logic_vector( 3 downto 0) := (others => '0');
  signal imm_sel, lst   : std_logic_vector( 2 downto 0) := (others => '0');
  signal wb_sel         : std_logic_vector( 1 downto 0) := (others => '0');
  signal reset_sig      : std_logic                     := '1';
  signal msg            : message                       := (others => "00100000");
  signal opcode_st      : string(1 to 5)                := "NOP  ";
  signal disp_reg, disp_value : std_logic_vector(31 downto 0);
begin
  -- Reset signal set by 0th button and shows on ledg(0) when active.
  reset_sig <= not key(0);
  --ledg(0) <= reset_sig;

  -- Base clock is shown on ledg(8)
  --sys_clk <= clock_1hz;
  sys_clk <= not key(3);
    -- sys_clk <= not key(3);  --an option for manual PC increments
  ledg(8) <= clock_1hz;


  -- Control Unit
  -------------------------
  ctl_unt: control_unit
    port map (br_lt, br_eq, instruction, opcode_st, opcode, wb_sel, imm_sel, lst, alu_op,
              pc_sel, reg_w_en, br_un, alu_a_sel, alu_b_sel, mem_rw);

  -- Instruction Fetch
  -------------------------
  pcp4 <= std_logic_vector(unsigned(program_counter) + 4);

  pc_mux   : entity commonmods.mux_2x32(rtl)
    port map (pcp4, alu_res, pc_sel, next_pc);

  pc_comp  : pc
    port map (sys_clk, reset_sig, next_pc, program_counter);

  insts    : imem
    port map (program_counter, instruction);

  -- Decode / Reg Read
  -------------------------

  imm_comp : imm_gen
    port map (instruction(31 downto 7), imm_sel, immediate);

  regfile : reg_file
    port map (sys_clk, reset_sig, reg_w_en, wb, dest_reg, instruction(19 downto 15),
              instruction(24 downto 20), rs1, rs2, sw(4 downto 0), disp_reg);

  b_cmp : branch_comp
    port map (rs1, rs2, br_un, br_eq, br_lt);

  -- Execute
  -------------------------
  alu_mux1 : entity commonmods.mux_2x32(rtl)
    port map (program_counter , rs1, alu_a_sel, alu_a);

  alu_mux2 : entity commonmods.mux_2x32(rtl)
    port map (rs2 , immediate, alu_b_sel, alu_b);

  alu_comp : alu
    port map (alu_a, alu_b, alu_op, alu_res);


  -- bit enable selector
  -------------------------
  biten_maker: biten_sel
    port map (immediate, lst, biten);

  -- Store multiplexer
  -------------------------
  store_mux : entity commonmods.mux_3x32(rtl)
    port map (x"000000" & rs2(7 downto 0), x"0000" & rs2(15 downto 0), rs2, lst(1 downto 0), store_value);

  --ledg(3 downto 0) <= biten;
  -- Memory
  -------------------------
  ram : entity work.ram_lpm(SYN)
		port map (address	=> alu_res(11 downto 0), byteena => biten, clock => sys_clk, data => store_value,
					 wren => mem_rw, q => dmem_out); -- mem_rw specific to altera on board mem

  -- Adjust loaded value
  --loaded: load_sign_extend
  --  port map (dmem_out, lst, std_logic_vector(to_unsigned(to_integer(signed(immediate)) mod 4, 3)), loaded_value);

  -- Reg Write
  -------------------------
  wb_mux : entity commonmods.mux_3x32(rtl)
    port map (dmem_out, alu_res, pcp4, wb_sel, wb);


  set_rd: process (opcode) is
  begin
    if '0' & opcode /= x"23" or '0' & opcode /= x"63" then
      dest_reg <= instruction(11 downto 7);
    else
      dest_reg <= "XXXXX";
    end if;
  end process;

  -- Show writeback using LEDs (first byte using green LEDs, rest on red)
  ledg( 7 downto 0) <= wb(7 downto 0);
  ledr(17 downto 0) <= wb(24 downto 7);

  -- Display instruction on LCD display
  message_fmt : LCD_Message_Fmt
    port map (clk => clock_50, rst => reset_sig,
              opcode_st => opcode_st,
              opcode => opcode,
              rd_i => dest_reg, rs1_i => instruction(19 downto 15), rs2_i => instruction(24 downto 20),
              pc => program_counter(11 downto 0),
              imm => immediate,
              msg => msg);

  screen : entity displays.lcd_driver(rtl)
    port map (reset => reset_sig, clk => clock_600hz, chars => msg, d_bus => lcd_data,
              rw_lcd => lcd_rw, rs_lcd => lcd_rs, on_lcd => lcd_on, en_lcd => lcd_en);

  -- Reg Write
  -------------------------
  set_hex : entity commonmods.mux_4x32(rtl)
    port map (disp_reg, alu_res, wb, instruction, sw(17 downto 16), disp_value);

  -- Display selected register on the hex displays
  dis0: entity displays.hexDisplay(rtl)
    port map (nybble => disp_value( 3 downto  0), disp => hex0);
  dis1: entity displays.hexDisplay(rtl)
    port map (nybble => disp_value( 7 downto  4), disp => hex1);
  dis2: entity displays.hexDisplay(rtl)
    port map (nybble => disp_value(11 downto  8), disp => hex2);
  dis3: entity displays.hexDisplay(rtl)
    port map (nybble => disp_value(15 downto 12), disp => hex3);
  dis4: entity displays.hexDisplay(rtl)
    port map (nybble => disp_value(19 downto 16), disp => hex4);
  dis5: entity displays.hexDisplay(rtl)
    port map (nybble => disp_value(23 downto 20), disp => hex5);
  dis6: entity displays.hexDisplay(rtl)
    port map (nybble => disp_value(27 downto 24), disp => hex6);
  dis7: entity displays.hexDisplay(rtl)
    port map (nybble => disp_value(31 downto 28), disp => hex7);

  clk_1: entity clock.clk_div(rtl)
    generic map (size => 25, pre => 25_000_000)
    port map(clk_in => clock_50, clk_out => clock_1hz);

  clk_10: entity clock.clk_div(rtl)
    generic map (size => 24, pre => 2_500_000)
    port map(clk_in => clock_50, clk_out => clock_10hz);

  clk_600: entity clock.clk_div(rtl)
    generic map (size => 20, pre => 41_667) -- 83_334
    port map(clk_in => clock_50, clk_out => clock_600hz);

end rtl;
