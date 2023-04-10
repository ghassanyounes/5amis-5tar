-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is 
  port(clk        : in  std_logic;
       reset      : in  std_logic;
       current_pc : in  std_logic_vector(31 downto 0);
       pc_out     : out std_logic_vector(31 downto 0));
end entity;


-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --

architecture rtl of pc is
begin

process(clk) begin

if (reset = '1') then
	pc_out <= (others => '0');
elsif (clk'event and clk = '1') then
	pc_out <= current_pc;
end if;

end process;

end rtl;