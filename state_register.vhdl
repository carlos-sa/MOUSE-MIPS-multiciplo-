library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity state_register is
	generic (width: integer := 32);
	port (
		clock: in std_logic;
		input: in std_logic_vector (width - 1 downto 0);
		write_enable: in std_logic;
		output: out std_logic_vector (width - 1 downto 0));
end state_register;

architecture behavioral of state_register is

	signal stored_data: std_logic_vector (width - 1 downto 0);

begin

	output <= stored_data;

	write: process (clock)
	begin
		if rising_edge(clock) then
			if write_enable = '1' then
				stored_data <= input;
			end if;
		end if;
	end process;

end behavioral;

