library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity t_processor is
end t_processor;

architecture behavioral of t_processor is

	constant period: time := 10 ns;
	signal clock: std_logic := '1';
	signal turn_off: std_logic := '0';
	signal current_instruction, video_out: std_logic_vector (31 downto 0);
	signal data_in_last_modified_register, instruction_address: std_logic_vector (31 downto 0);
			signal expected: std_logic_vector (31 downto 0) := 			"00000000000000000000000000101010";
	signal video_address: std_logic_vector(11 downto 0);



SIGNAL pixel_clk: std_logic;
SIGNAL disp_ena: std_logic;
SIGNAL row, column: integer;
SIGNAL column_std: std_LOGIC_VECTOR(9 downto 0);

signal pixel: std_logic;

SIGNAL 		VGA_HS_d 		:	STD_LOGIC_VECTOR(2 downto 0);
SIGNAL 		VGA_VS_d 		:	STD_LOGIC_VECTOR(2 downto 0);
SIGNAL 		disp_ena_d 		:	STD_LOGIC_VECTOR(2 downto 0);

SIGNAL VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS: std_logic;

signal row_div2 : unsigned(11 downto 0);


	component processor 
	port (clock, turn_off: in std_logic;
		instruction_address, current_instruction, data_in_last_modified_register, video_out: 
		out std_logic_vector (31 downto 0);
    video_address: in std_logic_vector(11 downto 0));
	end component;
	
	COMPONENT vga_controller
  GENERIC(
    h_pulse   :  INTEGER   := 96;    --horiztonal sync pulse width in pixels
    h_bp      :  INTEGER   := 48;    --horiztonal back porch width in pixels
    h_pixels  :  INTEGER   := 640;   --horiztonal display width in pixels
    h_fp      :  INTEGER   := 16;    --horiztonal front porch width in pixels
    h_pol     :  STD_LOGIC := '0';   --horizontal sync pulse polarity (1 = positive, 0 = negative)
    v_pulse   :  INTEGER   := 2;     --vertical sync pulse width in rows
    v_bp      :  INTEGER   := 33;    --vertical back porch width in rows
    v_pixels  :  INTEGER   := 480;   --vertical display width in rows
    v_fp      :  INTEGER   := 10;    --vertical front porch width in rows
    v_pol     :  STD_LOGIC := '0');  --vertical sync pulse polarity (1 = positive, 0 = negative)
  PORT(
    pixel_clk :  IN   STD_LOGIC;     --pixel clock at frequency of VGA mode being used
    reset_n   :  IN   STD_LOGIC;     --active low asycnchronous reset
    h_sync    :  OUT  STD_LOGIC;     --horiztonal sync pulse
    v_sync    :  OUT  STD_LOGIC;     --vertical sync pulse
    disp_ena  :  OUT  STD_LOGIC;     --display enable ('1' = display time, '0' = blanking time)
    column    :  OUT  INTEGER;       --horizontal pixel coordinate
    row       :  OUT  INTEGER;       --vertical pixel coordinate
    n_blank   :  OUT  STD_LOGIC;     --direct blacking output to DAC
    n_sync    :  OUT  STD_LOGIC);    --sync-on-green output to DAC
END COMPONENT;

begin

		the_processor: processor port map (clock, turn_off, instruction_address, current_instruction, 			data_in_last_modified_register, video_out, video_address);

    video_card: vga_controller port map (clock, '1', VGA_HS_d(0), VGA_VS_d(0), disp_ena_d(0), column, row);

  VGA_R <= pixel when disp_ena='1' else '0';
  VGA_G <= pixel when disp_ena='1' else '0';
  VGA_B <= not pixel when disp_ena='1' else '0';

  VGA_HS <= VGA_HS_d(2);
  VGA_VS <= VGA_VS_d(2);

  disp_ena <= disp_ena_d(2);

  column_std <= std_logic_vector(to_unsigned(column, 10));

  row_div2 <= shift_right(to_unsigned(row, 12), 1);

  video_address <= std_logic_vector(
              (shift_left(row_div2, 3)) 
            + (shift_left(row_div2, 1)) 
            + (shift_right(to_unsigned(column, 12), 6)));  

  pixel <= video_out(31-to_integer(unsigned(column_std(5 downto 1))));

		clock_process: process
		begin
			clock <= not clock;
			wait for period / 2;
		end process;

  delay: process(clock)
  begin
      if rising_edge(clock) then
         VGA_HS_d(2 downto 1) <= VGA_HS_d(1 downto 0);
         VGA_VS_d(2 downto 1) <= VGA_VS_d(1 downto 0);
         disp_ena_d(2 downto 1) <= disp_ena_d(1 downto 0);
      end if;
  end process;

		stimulus: process
		begin

			wait for period * 50;

--			turn_off <= '1';
     	wait;

		end process;

end behavioral;
