-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity branch_comp is
  port (a, b         : in  std_logic_vector(31 downto 0);
        br_un        : in  std_logic;
        br_eq, br_lt : out std_logic := '0');
end entity;

-- --------------------------------------------------------------------------------------------- --
--                                   ARCHITECTURE DECLARATIONS                                   --
-- --------------------------------------------------------------------------------------------- --

architecture rtl of branch_comp is
begin

process (a, b, br_un) is
begin

if (a = b) then
  br_eq <= '1';
else 
  br_eq <= '0';
end if;

if (br_un = '0') then
  if (signed(a) < signed(b)) then
      br_lt <= '1';
    end if;
  else 
    if (unsigned(a) < unsigned(b)) then
      br_lt <= '1';
        end if;
end if;
end process;

end rtl;