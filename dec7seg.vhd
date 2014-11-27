library IEEE;
use  IEEE.STD_LOGIC_1164.all;

ENTITY dec7seg IS
  PORT(
    hex_digit  : IN  STD_LOGIC_VECTOR(3 downto 0);
    segment   : out STD_LOGIC_VECTOR(6 downto 0));
END dec7seg;

ARCHITECTURE ONLY OF dec7seg IS
  SIGNAL segment_data : STD_LOGIC_VECTOR(6 downto 0);
BEGIN
  PROCESS (Hex_digit)
  BEGIN
    CASE Hex_digit IS
        WHEN "0000" =>
            segment_data <= "0111111";
        WHEN "0001" =>
            segment_data <= "0000110";
        WHEN "0010" =>
            segment_data <= "1011011";
        WHEN "0011" =>
            segment_data <= "1001111";
        WHEN "0100" =>
            segment_data <= "1100110";
        WHEN "0101" =>
            segment_data <= "1101101";
        WHEN "0110" =>
            segment_data <= "1111101";
        WHEN "0111" =>
            segment_data <= "0000111";
        WHEN "1000" =>
            segment_data <= "1111111";
        WHEN "1001" =>
            segment_data <= "1101111"; 
        WHEN "1010" =>
            segment_data <= "1110111";
        WHEN "1011" =>
            segment_data <= "1111100"; 
        WHEN "1100" =>
            segment_data <= "0111001"; 
        WHEN "1101" =>
            segment_data <= "1011110"; 
        WHEN "1110" =>
            segment_data <= "1111001"; 
        WHEN "1111" =>
            segment_data <= "1110001"; 
     WHEN OTHERS =>
            segment_data <= "0111110";
    END CASE;
  END PROCESS;

  -- extract segment data and LED driver is inverted
  segment <= NOT segment_data;
  
END ONLY;
