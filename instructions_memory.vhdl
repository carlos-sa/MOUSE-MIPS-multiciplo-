library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity instructions_memory is
	generic (
		length: integer := 256;
		address_width: integer := 32;
		data_width: integer := 32);

	port (
    clock, enable: in std_logic;
		address_to_read: in std_logic_vector (address_width - 1 downto 0);
		instruction_out: out std_logic_vector (data_width - 1 downto 0));
end instructions_memory;

architecture behavioral of instructions_memory is

	type instructions_sequence is array (0 to length) of std_logic_vector (data_width - 1 downto 0);
	signal instructions: instructions_sequence :=
		-- mtr  $a0, a1
   (0 => X"54042800",
	-- srl  $t0, $a1, 1
	1 => X"00054042",
	-- sll  $t1, $t0, 3
	3 => X"000848c0",
	-- sll  $t2, $t0, 1
	4 => X"00085040",
	-- add  $t0, $t1, $t2
	5 => X"012a4020",
	-- srl  $t1, $a0, 1
	6 => X"00044842",
	-- srl  $t2, $t1, 5
	7 => X"00095142",
	-- add  $t0, $t0, $t2
	8 => X"010a4020",
	-- addi $a3, $0, -1
	9 => X"2007ffff",
	-- addi $s1, $0, 0
	10 => X"20110000",
	-- sw $s1, 0(s0)
	11 => x"ae110000",
	-- sw a3, 0(t0)
	12 => X"ad070000",
	-- addi $s0, $t0, 0
	13 => X"21100000",
	-- j 0
	14 => x"08000000",
		
		
		others => (others => 'U'));

begin

	process(clock)
		variable index: integer;
	begin
    if rising_edge(clock) then
      if enable='1' then
      		index := to_integer(unsigned(address_to_read));
			  instruction_out <= instructions(index);
			end if;
    end if;
	end process;

end behavioral;