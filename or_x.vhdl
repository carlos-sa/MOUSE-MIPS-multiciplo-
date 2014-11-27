library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity or_x is
	generic (width: integer := 32);
	port (a, b: in std_logic_vector (width - 1 downto 0);
	result: out std_logic_vector (width - 1 downto 0));
end or_x;

architecture structural of or_x is
begin
	g: for i in width - 1 downto 0 generate
		result(i) <= a(i) or b(i);
	end generate;
end structural;

