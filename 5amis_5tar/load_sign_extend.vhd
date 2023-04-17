-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
library displays;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity load_sign_extend is 
port (value: in  std_logic_vector(31 downto 0);
      lst  : in  std_logic_vector( 2 downto 0);
      offst: in  std_logic_vector( 2 downto 0);
      res  : out std_logic_vector(31 downto 0));
end entity;

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --

architecture rtl of load_sign_extend is 
  signal shifted: std_logic_vector(31 downto 0);
begin 
  shifted <= std_logic_vector(shift_left(unsigned(value), to_integer(unsigned(offst * 8))));
  process (lst) is 
  begin 
    case (lst) is 
      when "000"  => 
        res( 7 downto  0) <= shifted( 7 downto 0); 
        res(31 downto  8) <= res( 7);
      when "001"  => 
        res(15 downto  0) <= shifted(15 downto 0); 
        res(31 downto 16) <= res(15);
      when "100"  => 
        res( 7 downto  0) <= shifted( 7 downto 0); 
        res(31 downto  8) <= '0';
      when "101"  => 
        res(15 downto  0) <= shifted(15 downto 0); 
        res(31 downto 16) <= '0';
      when others => res <= (others => '1');
    end case;
  end process;
end rtl;
