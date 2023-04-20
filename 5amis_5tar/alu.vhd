-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is 
  port(data_in1 : in  std_logic_vector(31 downto 0);
       data_in2 : in  std_logic_vector(31 downto 0);
       op_code  : in  std_logic_vector(3 downto 0);
		   data_out : out std_logic_vector(31 downto 0));
end entity;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_bit.all;
entity do_sra is 
  port(data_in1 : in  std_logic_vector(31 downto 0);
       data_in2 : in  integer;
       data_out : out std_logic_vector(31 downto 0));
end entity;

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --

architecture rtl of alu is
signal slt_res, sra_res : std_logic_vector(31 downto 0);
begin

  sra_ass : entity work.do_sra(rtl)
  port map (data_in1, to_integer(unsigned(data_in2(4 downto 0))), sra_res);

process(op_code) begin

if (data_in1 < data_in2) then
  slt_res <= x"00000001";
else
  slt_res <= x"00000000";
end if;

case (op_code) is
  when "0000" => -- signed addition
    data_out <= std_logic_vector(signed(data_in1) + signed(data_in2));
  when "1000" => -- signed subtraction
    data_out <= std_logic_vector(signed(data_in1) - signed(data_in2));
  when "0001" =>  -- shift left logically
    data_out <= std_logic_vector(shift_left(unsigned(data_in1), to_integer(unsigned(data_in2(4 downto 0)))));
  when "0010" =>  -- set if less than (0 or 1) (SLT)
    data_out <= slt_res;
  when "0011" =>  -- set if less than (0 or 1) (SLTU)
    data_out <= slt_res;
  when "0100" =>  -- xor
    data_out <= data_in1 xor data_in2;
  when "0101" =>  -- shift right logically
    data_out <= std_logic_vector(shift_right(unsigned(data_in1), to_integer(unsigned(data_in2(4 downto 0)))));
  when "1101" =>  -- shift right logically
    data_out <= sra_res;
  when "0110" =>  -- or
    data_out <= data_in1 or data_in2;
  when "0111" =>
    data_out <= data_in1 and data_in2;
  when others =>
    data_out <= (others => 'X');
end case;
end process;

end rtl;

architecture rtl of do_sra is 
begin 
  data_out <= to_stdlogicvector(to_bitvector(data_in1) sra data_in2);
end rtl;
