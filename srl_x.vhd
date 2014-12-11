library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity srl_x is
	generic (width: integer := 32);
	port (a, b: in std_logic_vector (width - 1 downto 0);
	result: out std_logic_vector (width - 1 downto 0));
end srl_x;

architecture structural of srl_x is
begin
	result <= std_logic_vector(unsigned(b) srl to_integer(unsigned(a)));

end structural; 