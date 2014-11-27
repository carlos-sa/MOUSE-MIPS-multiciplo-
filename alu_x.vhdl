library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity alu_x is
	generic (width: integer := 32);
	port (a, b: in std_logic_vector (width - 1 downto 0);
	operation: in std_logic_vector (2 downto 0);
	result: out std_logic_vector (width - 1 downto 0));
end alu_x;

architecture structural of alu_x is

	component and_x 
		generic (width: integer := 32);
		port (a, b: in std_logic_vector (width - 1 downto 0);
		result: out std_logic_vector (width - 1 downto 0));
	end component;

	component or_x 
		generic (width: integer := 32);
		port (a, b: in std_logic_vector (width - 1 downto 0);
		result: out std_logic_vector (width - 1 downto 0));
	end component;

	component full_adder_x 
		generic (width: integer := 32);
		port (a, b: in std_logic_vector (width - 1 downto 0);
		result: out std_logic_vector (width - 1 downto 0));
	end component;

	component subtractor_x 
		generic (width: integer := 32);
		port (a, b: in std_logic_vector (width - 1 downto 0);
		result: out std_logic_vector (width - 1 downto 0));
	end component;

	component slt_x 
		generic (width: integer := 32);
		port (a, b: in std_logic_vector (width - 1 downto 0);
		result: out std_logic_vector (width - 1 downto 0));
	end component;

	component multiplexer
		generic (width: integer := 32);
		port (x0, x1, x2, x3, x4, x5, x6, x7: in std_logic_vector (width - 1 downto 0);
		selection: in std_logic_vector (2 downto 0);
		output: out std_logic_vector (width - 1 downto 0));
end component;

	signal x0, x1, x2, x3, x4, x5, x6, x7: std_logic_vector (width - 1 downto 0);

	begin

		and_x_1: and_x generic map (width) port map (a, b, x0);
		or_x_1: or_x generic map (width) port map (a, b, x1);
		adder: full_adder_x generic map (width) port map (a, b, x2);
		subtractor: subtractor_x generic map (width) port map (a, b, x3);
		slt: slt_x generic map (width) port map (a, b, x4);
		multx: multiplexer generic map (width) port map (x0, x1, x2, x3, x4, x5, x6, x7, 			operation, result);
 
end structural;
