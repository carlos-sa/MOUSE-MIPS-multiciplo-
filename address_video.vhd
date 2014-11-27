LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY address_video IS
	PORT(
    column       : IN  INTEGER;
    row          : IN  INTEGER;
    disp_ena     : IN  STD_LOGIC;
    video_out    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
    video_address: OUT STD_LOGIC_VECTOR(11 downto 0);
		VGA_R 		   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		VGA_G 	     : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		VGA_B 		   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END address_video;

ARCHITECTURE behavior OF address_video IS

SIGNAL column_std: std_LOGIC_VECTOR(9 downto 0);
signal pixel: std_logic;
signal row_div2 : unsigned(11 downto 0);

BEGIN

  column_std <= std_logic_vector(to_unsigned(column, 10));
  row_div2 <= shift_right(to_unsigned(row, 12), 1);
  video_address <= std_logic_vector(
              (shift_left(row_div2, 3)) 
            + (shift_left(row_div2, 1)) 
            + (shift_right(to_unsigned(column, 12), 6)));  
  
  pixel <= video_out(31-to_integer(unsigned(column_std(5 downto 1))));
  
  VGA_R <= (others => pixel) when disp_ena='1' else (others => '0');
  VGA_G <= (others => pixel) when disp_ena='1' else (others => '0');
  VGA_B <= (others => not pixel) when disp_ena='1' else (others => '0');
  
END behavior;
