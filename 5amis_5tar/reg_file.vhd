-- --------------------------------------------------------------------------------------------- --
--                                     ENTITY DECLARATIONS                                       --
-- --------------------------------------------------------------------------------------------- --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file is
  port (clk, reset          : in  std_logic;
        write_en            : in  std_logic;                     -- 1 = write, 0 = read
        dataD               : in  std_logic_vector(31 downto 0); -- writeback
        addrD, addrA, addrB : in  std_logic_vector(4 downto 0);  -- rd, rs1, rs2
        dataA, dataB        : out std_logic_vector(31 downto 0);
        disp_sel : in std_logic_vector(4 downto 0);
        whatsinthereg : out std_logic_vector(31 downto 0));
end entity;

architecture rtl of reg_file is
type r_file is array (0 to 31) of std_logic_vector(31 downto 0);
signal reg : r_file := (others => (others => '0'));
begin

whatsinthereg <= reg(to_integer(unsigned(disp_sel)));

process(clk, reset) is
begin
  if (reset = '1') then
    reg <= (others => (others => '0'));
  elsif (clk'event and clk = '0') then	-- write data to register in register file
    if (write_en = '1' and addrD /= "00000") then
      reg(to_integer(unsigned(addrD))) <= dataD;
    end if;
  end if;
end process;

-- read data always
dataA <= reg(to_integer(unsigned(addrA))); 
dataB <= reg(to_integer(unsigned(addrB)));
  
end rtl;