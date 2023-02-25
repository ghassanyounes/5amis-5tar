-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
library displays;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
  entity control_unit is 
    port (br_lt, br_ge : in  std_logic                                         := '0';
          inst         : in  std_logic_vector(31 downto 0)                     := (others => '0');
          opcode_str   : out string(1 to 5)                                    := "NOP  ";
          wb_sel       : out std_logic_vector( 1 downto 0)                     := (others => '0');
          imm_sel      : out std_logic_vector( 2 downto 0)                     := (others => '0');
          alu_op       : out std_logic_vector( 3 downto 0)                     := (others => '0');
          pc_sel, reg_w_en, br_un, alu_a_sel, alu_b_sel, mem_rw: out std_logic := '0');
  end entity;

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --
architecture rtl of control_unit is 
  signal opcode: std_logic_vector(6 downto 0) := (others => 'X');
  signal alu_sd: std_logic_vector(3 downto 0) := (others => 'X');
  signal funct3: std_logic_vector(2 downto 0) := (others => 'X');
begin 
  alu_sel <= inst(30) & inst(14 downto 12);
  funct3  <= inst(14 downto 12);
  opcode  <= inst(6 downto 0);
  inst_decode: process (inst, br_lt, br_ge) is 
  begin 
    -- branch funct3
    -- 000 beq
    -- 001 bne
    -- 100 blt
    -- 101 bge
    if '0' & opcode = x"63" then 
      br_un <= '0';
      if funct3 = "000" then
        pc_sel <= '1' when br_ge = '1' else '0' when others;

      elsif funct3 = "001" then 
        pc_sel <= '1' when br_ge = '0' else '0' when others;

      elsif funct3 = "100" then 
        pc_sel <= '1' when br_lt = '1' else '0' when others;

      elsif funct3 = "101" and br_ge = '0' then 
        pc_sel <= '1' when br_lt = '0' else '0' when others;
      elsif funct3 = "101" and br_ge = '1' then 
        pc_sel <= '1';
      end if;
    elsif '0' & opcode = x"67" or '0' & opcode = x"6F" then 
      pc_sel <= '1';
    else 
      pc_sel <= '0';
    end if;

    -- imm sel options -- 
    -- 000 i
    -- 001 s
    -- 010 b
    -- 011 u
    -- 100 j
    case ('0' & opcode) is
      when x"03" => -- LOAD: lw, lhw, lb
        imm_sel   <= "000"; 
        alu_a_sel <= '1';
        reg_w_en  <= '1'; 
        wb_sel    <= "00";
      when x"13" => -- OP-IMM: i-type,
        imm_sel   <= "000";
        alu_a_sel <= '1';
        reg_w_en  <= '1'; 
        wb_sel    <= "01";
      when x"17" => -- AUIPC  
        imm_sel   <= "011";
        alu_a_sel <= '0';
        reg_w_en  <= '1'; 
        wb_sel    <= "01";
      when x"23" => -- STORE
        imm_sel   <= "001";
        alu_a_sel <= '1';
        reg_w_en  <= '0'; 
      when x"33" => -- OP
        imm_sel   <= "XXX";
        alu_a_sel <= '1';
        reg_w_en  <= '1'; 
        wb_sel    <= "01";
      when x"37" => -- LUI
        imm_sel   <= "011";
        alu_a_sel <= '1';
        reg_w_en  <= '1'; 
        wb_sel    <= "01";
      when x"63" => -- BRANCH
        imm_sel   <= "010";
        alu_a_sel <= '0';
        reg_w_en  <= '0'; 
      when x"67" => -- JALR
        imm_sel   <= "000";
        alu_a_sel <= '1';
        wb_sel    <= "10";
      when x"6F" => -- JAL
        imm_sel   <= "100";
        alu_a_sel <= '0';
        wb_sel    <= "10";
      when others =>
        imm_sel <= "XXX";
    end case;

    -- Set alu b selector to op when in r-type
    if '0' & opcode = x"33" then 
      alu_b_sel <= '0';
    else
      alu_b_sel <= '1';
    end if;

    -- Set ALUOP based on funct3 and func7 (for sub) 
    if '0' & opcode = x"17" then 
      alu_op <= inst(30) & inst(14 downto 12);
    else
      alu_op <= (others => '0');
    end if;

    -- Set mem write if in set mode, otherwise read
    if '0' & opcode = x"23" then 
      mem_rw <= '1';
    else
      mem_rw <= '0';
    end if;
  end process;
end rtl;
