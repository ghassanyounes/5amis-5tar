-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
entity clk_div is 
	generic(size: integer := 32; pre: integer:= 25_000_000);
	port(clk_in : in  std_logic;
		   clk_out: out std_logic);
end clk_div;  

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --

architecture rtl of clk_div is
  constant countStop: std_logic_vector(size-1 downto 0) := std_logic_vector(to_unsigned(pre, size));
	signal   counter  : std_logic_vector(size-1 downto 0) := (others => '0');
	signal   clk      : std_logic;
begin 
	clk_out <= clk;
	gen_clk: process (clk_in)
	begin 
		if (clk_in'event and clk_in = '1') then
			if (counter = countStop) then 
				counter <= (others => '0');
				clk <= not clk;
			else 
				counter <= counter + '1';
			end if;
		end if;
	end process gen_clk;
end rtl;