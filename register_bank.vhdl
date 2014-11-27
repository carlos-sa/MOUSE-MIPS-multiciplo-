library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity register_bank is
	generic (width: integer := 32);
	port (
		clock: in std_logic;
		register_to_read1, register_to_read2, register_to_write: 
		in std_logic_vector (4 downto 0);
	write: in std_logic;
	data_to_write: in std_logic_vector (width - 1 downto 0);
	data_out1, data_out2: out std_logic_vector (width - 1 downto 0));
end register_bank;

architecture behavioral of register_bank is
  subtype register_t is std_logic_vector (width - 1 downto 0);
	type register_set is array (0 to 31) of register_t; 
-- Modelsim
--	signal registers: register_set := 
--		(0 => (others => '0'),
--			others => (others => 'U'));
-- Quartus II
  signal registers: register_set;

begin

		read_data: process (clock)
			variable index1, index2: integer;
		begin
      if rising_edge(clock) then
        index1 := to_integer(unsigned(register_to_read1));
        index2 := to_integer(unsigned(register_to_read2));
        if index1 = 0 then
            data_out1 <= (others => '0');
        else
            data_out1 <= registers(index1);
        end if;
        if index2 = 0 then
            data_out2 <= (others => '0');
        else
            data_out2 <= registers(index2);
        end if;
      end if;
	end process;

		write_data: process (clock)
			variable index: integer;
		begin
      if rising_edge(clock) then
        if write = '1' then
          index := to_integer(unsigned(register_to_write));
          if index /= 0 then
            registers(index) <= data_to_write;
          end if;
        end if;
			end if;
		end process;

end behavioral;

