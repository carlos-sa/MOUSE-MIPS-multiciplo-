library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity subtractor_x is
	generic (width: integer := 32);
	port (a, b: in std_logic_vector (width - 1 downto 0);
		result: out std_logic_vector (width - 1 downto 0));
end subtractor_x;

architecture structural of subtractor_x is

	component adder
	port (a, b, cin: in std_logic; sum, cout: out std_logic);
	end component;

	signal carry: std_logic_vector (width downto 0) := (0 => '1', others => '0');
	signal notb: std_logic_vector (width - 1 downto 0); 

	begin

	notb <= not b;

		stages: for i in width - 1 downto 0 generate
					adder1: adder port map (a(i), notb(i), carry(i), result(i), 
			carry(i + 1));
		end generate;
end structural;

