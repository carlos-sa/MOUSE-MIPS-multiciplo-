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
		-- lw $t0, 0($0)
   (0 => X"8C080000",
    1 => X"200f0006",
    2 => X"20100005",
    3 => X"01f08822",
		-- lw $t1, 0($0)
    --1 => X"8C090000",
    -- addi 2 no v0
    --2 => X"20020002",
    -- sll $t5, $t1 shift left 2
    --3 => X"00096880",
    -- srl $t6, $t5 shift right 2
    --4 => X"000d7042",
		-- lw $t2, 1($0)
		--2 => X"8C0A0001",
		-- add $t0, $t0, $t1
		--3 => X"01094020",
		-- addi $t4, $zero, 7
		--4 =>X"200C0007", 
		-- beq $t0, $t1, -2
		--5 => X"1109FFFE",
		-- bne $t0, $0, -2
		--6 => X"1400FFFE",
		-- bne, $t0, $t1, 1
		--7 => X"15090001",
		-- bne, $0, $0, -2
		--8 => X"1400FFFE",
		-- beq, $0, $0, -3
		--9 => X"1000FFFD",
		-- sw, $t2, 0($t0)
		--10 => X"AD0A0000",
		-- sw, $t2, 0($t0)
		--j 3
		--11 => X"08000003",
		
		
		
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