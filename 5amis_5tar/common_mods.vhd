-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --
library ieee;
use ieee.std_logic_1164.all;

entity mux_2x32 is
	port(a : in std_logic_vector(31 downto 0);
       b : in std_logic_vector(31 downto 0);
       sel      : in std_logic;
		   data_out : out std_logic_vector(31 downto 0));
end mux_2x32;

library ieee;
use ieee.std_logic_1164.all;

entity mux_3x32 is
	port(a        : in std_logic_vector(31 downto 0);
       b        : in std_logic_vector(31 downto 0);
       c        : in std_logic_vector(31 downto 0);
       sel      : in std_logic_vector(1 downto 0);
		   data_out : out std_logic_vector(31 downto 0));
end mux_3x32;

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --


architecture rtl of mux_2x32 is
begin

with sel select
data_out <= a when '0',
            b when '1',
            (others => '0') when others;

end rtl;

architecture rtl of mux_3x32 is
begin

with sel select
data_out <= a when "00",
            b when "01",
            c when "10",
            (others => '0') when others;

end rtl;