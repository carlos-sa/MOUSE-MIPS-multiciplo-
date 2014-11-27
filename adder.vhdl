library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity adder is
	port (a, b, cin: in std_logic; sum, cout: out std_logic);
end adder;

architecture structural of adder is
	begin
	sum <= a xor b xor cin;
	cout <= (a and b) or (a and cin) or (b and cin);
end structural;

