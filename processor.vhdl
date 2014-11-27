library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity processor is
	port (clock, turn_off: in std_logic;
		instruction_address, current_instruction, data_in_last_modified_register, video_out: 
		out std_logic_vector (31 downto 0);
    video_address: in std_logic_vector(11 downto 0));
end processor;

architecture behavioral of processor is

	component program_counter 
		generic (address_width: integer := 32);
	port (
		clock, enable, jump: in std_logic;
		next_address: out std_logic_vector (address_width - 1 downto 0);
		jump_address: in std_logic_vector (address_width - 1 downto 0));
	end component;

	component state_register 
		generic (width: integer := 32);
		port (
			clock: in std_logic;
			write_enable: in std_logic;
			input: in std_logic_vector (width - 1 downto 0);
			output: out std_logic_vector (width - 1 downto 0));
	end component;

	component instructions_memory 
		generic (
			length: integer := 256;
			address_width: integer := 32;
			data_width: integer := 32);

		port (
      clock, enable: in std_logic;
			address_to_read: in std_logic_vector (address_width - 1 downto 0);
			instruction_out: out std_logic_vector (data_width - 1 downto 0));
	end component;

	component control_unit
	port (
		clock: in std_logic;
		instruction: in std_logic_vector (31 downto 0);
		enable_program_counter, 
    enable_alu_output_register: out std_logic := '0';
		register1, register2, register3: out std_logic_vector (4 downto 0);
		write_register, mem_to_register: out std_logic;
		source_alu, reg_dst: out std_logic;
		alu_operation: out std_logic_vector (2 downto 0);
		read_memory, write_memory: out std_logic;
		offset: out std_logic_vector (31 downto 0);
		jump_control: out std_logic;
		jump_offset: out std_logic_vector(25 downto 0));
	end component;

	component register_bank
		generic (width: integer := 32);

		port (
			clock: in std_logic;
			register_to_read1, register_to_read2, register_to_write: 
			in std_logic_vector (4 downto 0);
		write: in std_logic;
		data_to_write: in std_logic_vector (width - 1 downto 0);
		data_out1, data_out2: out std_logic_vector (width - 1 downto 0));
	end component;

	component data_memory 
		generic (
			address_width: integer := 12;
			data_width: integer := 32);

		port (
    clock: std_logic;
		address_to_read, address_to_write, video_address: in std_logic_vector (address_width - 1 downto 0);
		data_to_write: in std_logic_vector (data_width - 1 downto 0);
		read, write: in std_logic;
		data_out, video_out: out std_logic_vector (data_width - 1 downto 0));
	end component;

	component alu_x
		generic (width: integer := 32);

		port (
			a, b: in std_logic_vector (width - 1 downto 0);
		operation: in std_logic_vector (2 downto 0);
		result: out std_logic_vector (width - 1 downto 0));
	end component;

	signal clk: std_logic;

	-- control signals for state elements.
	signal enable_program_counter, 	
		enable_alu_output_register, jump_control: std_logic;

	-- Signals related to the instruction fetch state.
	signal address_of_next_instruction, instruction, data_from_instruction_register, jump_address: 
			std_logic_vector (31 downto 0);
	signal	jump_offset: std_logic_vector(25 downto 0);

	-- Signals related to the banck of registers.
	signal destination_register, register1, register2, register3: std_logic_vector (4 downto 0);
	signal data_from_register1, data_from_register2, data_to_write_in_register: 
		std_logic_vector (31 downto 0); 
	signal write_register, mem_to_register: std_logic;

	-- Signals related to the ALU.
	signal alu_operand1, alu_operand2: std_logic_vector(31 downto 0);
	signal register_a, register_b, alu_result, 		
	  data_from_alu_output_register: std_logic_vector (31 downto 0);
	signal source_alu, reg_dst: std_logic;
	signal alu_operation: std_logic_vector (2 downto 0); 

	-- Signals related to the memory access.
	signal address_to_read, address_to_write: std_logic_vector (31 downto 0);
	signal data_from_memory, offset: std_logic_vector (31 downto 0);
	signal read_memory, write_memory: std_logic;

begin

    instruction_address <= address_of_next_instruction;
		alu_operand1 <= register_a;
		
		alu_operand2 <= register_b when source_alu = '0' else offset;
		data_to_write_in_register <= data_from_memory when mem_to_register = '1' else data_from_alu_output_register; 
		destination_register <= register2 when reg_dst = '0' else register3;
		
		address_to_read <= data_from_alu_output_register;
		address_to_write <= data_from_alu_output_register;

		current_instruction <= instruction;
		data_in_last_modified_register <= data_to_write_in_register;
		
		jump_address <= address_of_next_instruction(31 downto 26) & jump_offset;

		pc: program_counter port map (
		  clk, 
		  enable_program_counter, 
		  jump_control, 
		  address_of_next_instruction, 
		  jump_address);

		memory_of_instructions: instructions_memory port map (
		  clk, 
		  enable_program_counter, 
		  address_of_next_instruction, 
		  instruction);

		--instruction_register: state_register port map (clk, enable_instruction_register, 			instruction, data_from_instruction_register); 

		state_machine: control_unit port map (
		  clk, 
		  instruction, 			
		  enable_program_counter,  			
		  enable_alu_output_register, 
		  register1, 
		  register2, 
		  register3, 
      write_register,
		  mem_to_register, 
		  source_alu, 
		  reg_dst,
		  alu_operation, 			
		  read_memory, 
		  write_memory, 
		  offset, 
		  jump_control, 
		  jump_offset); 

		bank_of_registers: register_bank port map (
		  clk, 
		  register1, 
		  register2, 
		  destination_register, 		
		  write_register,
		  data_to_write_in_register, 
		  register_a, 
		  register_b);  

--		alu_input_register_a: state_register port map (clk, enable_alu_input_registers, 			data_from_register1, data_from_alu_input_a);

--		alu_input_register_b: state_register port map (clk, enable_alu_input_registers, 			data_from_register2, alu_operand2);

		alu: alu_x port map (alu_operand1, alu_operand2, alu_operation, alu_result);

		alu_output_register: state_register port map (clk, enable_alu_output_register,	alu_result, data_from_alu_output_register);

		memory_of_data : data_memory port map (
		  clock, 
		  address_to_read(11 downto 0), 
		  address_to_write(11 downto 0), 
		  video_address,	
		  register_b, 
		  read_memory, 
		  write_memory, 
		  data_from_memory, 
		  video_out);     

		--data_memory_register: state_register port map (clk, enable_data_memory_register, 			data_from_memory, data_from_memory_register);

		process (clock, turn_off)
		begin
			if turn_off /= '1' then
				clk <= clock;
      else
        clk <= '0';
			end if; 
		end process;
 
end behavioral;

