-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
library displays;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
  entity biten_sel is 
  port (immediate: in  std_logic_vector(31 downto 0);
        lst: in  std_logic_vector(2 downto 0);
        biten: out std_logic_vector(3 downto 0));
  end entity;

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --

architecture rtl of biten_sel is 
  signal remainder: integer:= 0;
begin 
  remainder <= to_integer(signed(immediate)) mod 4; 
  process (lst) is 
  begin 
    case (lst) is 
      when "000"  => biten(remainder) <= '1'; 
      when "001"  => biten(remainder) <= '1'; biten(remainder + 1) <= '1';
      when others => biten <= (others => '1');
    end case;
  end process;
end rtl;
