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
        biten: out std_logic_vector(3 downto 0) := "1111");
  end entity;

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --

architecture rtl of biten_sel is 
  signal remainder: integer := 0;
begin 
  remainder <= to_integer(signed(immediate)) mod 4; 
  
  process (immediate, lst, remainder) is 
  variable bytes : std_logic_vector(3 downto 0) := "0000";
  begin 
    
    bytes := "0000";
    
    case (lst) is 
      when "000"  => bytes(remainder) := '1'; 
      --when "001"  => biten(remainder) <= '1'; biten(remainder + 1) <= '1';
      when others => bytes := (others => '1');
    end case;
    biten <= bytes;
  end process;
  
  
end rtl;
