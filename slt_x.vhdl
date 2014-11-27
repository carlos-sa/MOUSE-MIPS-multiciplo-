library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity slt_x is
	generic (width: integer := 32);
	port (a, b: in std_logic_vector (width - 1 downto 0);
		result: out std_logic_vector (width - 1 downto 0));
end slt_x;

architecture structural of slt_x is

	component subtractor_x 
		generic (width: integer := 32);
		port (a, b: in std_logic_vector (width - 1 downto 0);
			result: out std_logic_vector (width - 1 downto 0));
	end component;

	signal output: std_logic_vector (width - 1 downto 0) := (others => '0');
	signal subtraction: std_logic_vector (width - 1 downto 0);

	begin

		subtractor: subtractor_x generic map (width) port map (a, b, subtraction);
		output(0) <= subtraction (width - 1);
		result <= output;

end structural;

