library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity multiplexer is
	generic (width: integer := 32);
	port (x0, -- bitwise and
			 x1, -- bitwise or
			x2, -- adition
			x3, -- subtraction
			x4, -- set on less than 
			x5, x6, x7 -- not implemented yet.
				: in std_logic_vector (width - 1 downto 0);
		selection: in std_logic_vector (2 downto 0);
		output: out std_logic_vector (width - 1 downto 0));
end multiplexer;

architecture structural of multiplexer is

	signal unknown: std_logic_vector (width - 1 downto 0) := (others => 'X');

begin

	
	output <= x0 when selection = "000" else
		x1 when selection = "001" else
		x2 when selection = "010" else
		x3 when selection = "011" else
		x4 when selection = "100" else
		unknown;

end structural;

