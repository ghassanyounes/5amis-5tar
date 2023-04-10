-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file is
  port (clk                 : in  std_logic;
        write_en            : in  std_logic;                     -- 1 = write, 0 = read
        dataD               : in  std_logic_vector(31 downto 0); -- writeback
        addrD, addrA, addrB : in  std_logic_vector(4 downto 0);  -- rd, rs1, rs2
        dataA, dataB        : out std_logic_vector(31 downto 0));
end entity;

architecture rtl of reg_file is
type r_file is array (0 to 31) of std_logic_vector(31 downto 0);
signal reg : r_file := (others => (others => '0'));
begin

process(clk) is
begin 
  if (clk'event and clk = '1') then	-- write data to register in register file
    if (write_en = '1') then
      reg(to_integer(unsigned(addrD))) <= dataD;
    end if;
  end if;
end process;

-- read data always
dataA <= reg(to_integer(unsigned(addrA))); 
dataB <= reg(to_integer(unsigned(addrB)));
  
end rtl;