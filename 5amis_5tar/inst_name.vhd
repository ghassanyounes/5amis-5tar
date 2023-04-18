-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
library displays;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity inst_name is 
    port (opcode_str: out string(1 to 5);
          opcode    : in std_logic_vector(6 downto 0);
          funct3    : in std_logic_vector(2 downto 0);
          funct7    : in std_logic_vector(6 downto 0));
  end entity;

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --
architecture rtl of inst_name is
begin	
name: process (opcode, funct3, funct7) is
begin
	case ('0' & opcode) is
	when x"03" => -- LOAD: lw, lhw, lb
		case (funct3) is
			when "010" => -- lw
				opcode_str <= "lw   ";
			when "001" => -- lh
				opcode_str <= "lh   ";
			when "000" => -- lb 
				opcode_str <= "lb   ";
			when "101" => -- lhu
				opcode_str <= "lh   ";
			when "100" => -- lbu 
				opcode_str <= "lb   ";
			when others =>
				opcode_str <= "_err_";
		end case;
	when x"13" => -- OP-IMM: i-type, 
		case (funct7(5) & funct3) is
			when "0000" => -- addi
				opcode_str <= "addi ";
			when "0001" => -- slli
				opcode_str <= "slli ";
			when "0010" => -- slti
				opcode_str <= "slti ";
			when "0011" => -- sltiu
				opcode_str <= "sltiu";
			when "0100" => -- xori
				opcode_str <= "xori ";
			when "0101" => -- srli
				opcode_str <= "srli ";
			when "0110" => -- ori
				opcode_str <= "ori  ";
			when "0111" => -- andi 
				opcode_str <= "andi ";
	when others =>
				opcode_str <= "_err_";
		end case;
	when x"17" => -- AUIPC  
				opcode_str <= "auipc";
	when x"23" => -- STORE
		case (funct3) is
			when "010" => -- sw
				opcode_str <= "sw   ";
			when "001" => -- sh
				opcode_str <= "sh   ";
			when "000" => -- sb 
				opcode_str <= "sb   ";
			when others =>
				opcode_str <= "_err_";
		end case;
	when x"33" => -- OP 
		case (funct7(5) & funct3) is
			when "0000" => -- add
				opcode_str <= "add  ";
			when "1000" => -- sub
				opcode_str <= "sub  ";
			when "0001" => -- sll
				opcode_str <= "sll  ";
			when "0010" => -- slt
				opcode_str <= "slt  ";
			when "0011" => -- sltu
				opcode_str <= "sltu ";
			when "0100" => -- xor
				opcode_str <= "xor  ";
			when "0101" => -- srl
				opcode_str <= "srl  ";
			when "0110" => -- or
				opcode_str <= "or   ";
			when "0111" => -- and 
				opcode_str <= "and  ";
			when others =>
				opcode_str <= "_err_";
		end case;
	when x"37" => -- LUI
			opcode_str <= "lui  ";
	when x"63" => -- BRANCH
		case (funct3) is
			when "000" => -- beq
				opcode_str <= "beq  ";
			when "001" => -- bne
				opcode_str <= "bne  ";
			when "100" => -- blt 
				opcode_str <= "blt  ";
			when "101" => -- bge 
				opcode_str <= "bge  ";
			when others =>
				opcode_str <= "_err_";
		end case;
	when x"67" => -- JALR
				opcode_str <= "jalr ";
	when x"6F" => -- JAL
				opcode_str <= "jal  ";
	when others =>
				opcode_str <= "_err_";
	end case;
end process;
end rtl;