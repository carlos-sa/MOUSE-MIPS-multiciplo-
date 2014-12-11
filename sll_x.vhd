library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sll_x is
	generic (width: integer := 32);
	port (a, b: in std_logic_vector (width - 1 downto 0);
	result: out std_logic_vector (width - 1 downto 0));
end sll_x;

architecture structural of sll_x is
begin
	result <= std_logic_vector(unsigned(a) sll to_integer(unsigned(b)));

end structural; 