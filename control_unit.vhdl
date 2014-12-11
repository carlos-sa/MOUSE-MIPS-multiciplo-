library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity control_unit is 
	port (
		clock: in std_logic;
		instruction: in std_logic_vector (31 downto 0);
		enable_program_counter,
		enable_alu_output_register: out std_logic := '0';
		register1, register2, register3: out std_logic_vector (4 downto 0);
		write_register: out std_logic; 
		mem_to_register: out std_logic_vector (1 downto 0);
	  reg_dst: out std_logic;
	  source_alu: out std_logic_vector (1 downto 0);
		alu_operation: out std_logic_vector (2 downto 0);
		read_memory, write_memory: out std_logic;
		offset: out std_logic_vector (31 downto 0);
		jump_control: out std_logic;
		jump_offset: out std_logic_vector(25 downto 0);
		branch:  out  std_logic;
		branch2: out std_logic;
		source_a : out std_logic);
		
end control_unit;

architecture behavioral of control_unit is
	type state is (fetch, decode, alu, mem, writeback);
	signal next_state: state := fetch;
	signal opcode: std_logic_vector(5 downto 0);
	signal opcode_r: std_logic_vector(5 downto 0);

	constant    lw:  std_logic_vector (5 downto 0) := "100011";
	constant    sw:  std_logic_vector (5 downto 0) := "101011";
	constant     r:  std_logic_vector (5 downto 0) := "000000";
	constant     j:  std_logic_vector (5 downto 0) := "000010";
  constant   beq:  std_logic_vector (5 downto 0) := "000100";
  constant   bne:  std_logic_vector (5 downto 0) := "000101";
  constant  addi: std_logic_vector (5 downto 0) := "001000";
  constant mtr: std_logic_vector (5 downto 0) := "010101";


	function extend_to_32(input: std_logic_vector (15 downto 0)) return std_logic_vector is 
	variable s: signed (31 downto 0);
	begin
		s := resize(signed(input), s'length);
		return std_logic_vector(s);  
	end;

begin

  offset <= extend_to_32(instruction(15 downto 0));
  opcode    <= instruction(31 downto 26);
	register1 <= instruction(25 downto 21);
	register2 <= instruction(20 downto 16);
	register3 <= instruction(15 downto 11);
  jump_offset <= instruction(25 downto 0);
  opcode_r <= instruction(5 downto 0);

	next_state_function: process(clock)
	begin

  	if rising_edge(clock) then

		alu_operation <= "XXX";
		enable_alu_output_register <= '0';
		enable_program_counter <= '0';
		jump_control <= '0';
		read_memory <= '0';
		reg_dst <= '0';
		source_alu <= "00";
   	mem_to_register <= "00";
		write_memory <= '0';
		write_register <= '0';
    branch <= '0';
    branch2 <= '0';
    source_a <= '0';

		case next_state is

			when fetch =>
				-- instruction fetch
				enable_program_counter <= '1';
			  next_state <= decode;

			when decode =>
				-- instruction decode 
				next_state <= alu;

			when alu =>
				enable_alu_output_register <= '1';
				alu_operation <= "010";

				if opcode = lw then
      		source_alu <= "01";
					next_state <= mem;
				elsif opcode = sw then
      		source_alu <= "01";
					next_state <= mem;
				elsif opcode = j then
     			jump_control <= '1';
				  next_state <= fetch;
				elsif opcode = beq then
				  branch <= '1';
				  alu_operation <= "011";
				  next_state <= fetch; 
				elsif opcode = bne then
				  branch2 <= '1';
				  alu_operation <= "011";
				  next_state <= fetch; 
				elsif opcode = addi then  
 					alu_operation <= "010";
 					source_alu <= "01";
 					next_state <= writeback;
				elsif opcode = mtr then
					mem_to_register <= "10";
					write_register <= '1';
					next_state <= writeback;
					
					
				elsif opcode = r then
					if opcode_r = "000010" then
						alu_operation <= "110";
						source_alu <= "10";
						source_a <= '1';
						next_state <= writeback;
					
					elsif opcode_r = "000000" then
						alu_operation <= "101";
						source_alu <= "10";
						source_a <= '1';
						next_state <= writeback;
					
					elsif opcode_r = "100010" then
					 alu_operation <= "011";
					 next_state <= writeback;	
						
					else -- tipo r sem ser sll ou srl
						next_state <= writeback;
					end if;
				
				end if;
				
				

			when mem =>
        -- memory address calculation
				if opcode = lw then
          read_memory <= '1';
					next_state <= writeback;
				else --if opcode = sw then
      				write_memory <= '1';
					next_state <= fetch; 
				end if;

			when writeback =>
				-- write regiter result
        if opcode = lw then
   				mem_to_register <= "01";
   	  elsif opcode = addi then
 				  reg_dst <= '0';
		  elsif opcode = mtr then
					mem_to_register <= "11";
					reg_dst <= '1';
        else 
				  reg_dst <= '1';
        end if;
				write_register <= '1';
				next_state <= fetch;
			
		end case;
    
    end if;
	end process;

end behavioral;

