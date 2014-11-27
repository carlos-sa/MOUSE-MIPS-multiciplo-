--------------------------------------------------------------------------------
--   http://eewiki.net/pages/viewpage.action?pageId=15925278
--   FileName:         vga_controller.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------

--Table A1:  Timing Specifications for Various VGA Modes
--Resolution(pixels) RefreshRate(Hz)  PixelClock(MHz)  
--                     Horizontal(pixel_clocks)  
--                     Display  FrontPorch  SyncPulse  BackPorch  
--                                      Vertical(rows)  
--                                      Display  FrontPorch  SyncPulse  BackPorch
--                                                      h_syncPolarity  v_syncPolarity
--640x350  70  25.175  640  16  96  48  350  37  2  60  p  n
--640x350  85  31.5  640  32  64  96  350  32  3  60  p  n
--640x400  70  25.175  640  16  96  48  400  12  2  35  n  p
--640x400  85  31.5  640  32  64  96  400  1  3  41  n  p
--640x480  60  25.175  640  16  96  48  480  10  2  33  n  n
--640x480  73  31.5  640  24  40  128  480  9  2  29  n  n
--640x480  75  31.5  640  16  64  120  480  1  3  16  n  n
--640x480  85  36  640  56  56  80  480  1  3  25  n  n
--640x480  100  43.16  640  40  64  104  480  1  3  25  n  p
--720x400  85  35.5  720  36  72  108  400  1  3  42  n  p
--768x576  60  34.96  768  24  80  104  576  1  3  17  n  p
--768x576  72  42.93  768  32  80  112  576  1  3  21  n  p
--768x576  75  45.51  768  40  80  120  576  1  3  22  n  p
--768x576  85  51.84  768  40  80  120  576  1  3  25  n  p
--768x576  100  62.57  768  48  80  128  576  1  3  31  n  p
--800x600  56  36  800  24  72  128  600  1  2  22  p  p
--800x600  60  40  800  40  128  88  600  1  4  23  p  p
--800x600  75  49.5  800  16  80  160  600  1  3  21  p  p
--800x600  72  50  800  56  120  64  600  37  6  23  p  p
--800x600  85  56.25  800  32  64  152  600  1  3  27  p  p
--800x600  100  68.18  800  48  88  136  600  1  3  32  n  p
--1024x768  43  44.9  1024  8  176  56  768  0  8  41  p  p
--1024x768  60  65  1024  24  136  160  768  3  6  29  n  n
--1024x768  70  75  1024  24  136  144  768  3  6  29  n  n
--1024x768  75  78.8  1024  16  96  176  768  1  3  28  p  p
--1024x768  85  94.5  1024  48  96  208  768  1  3  36  p  p
--1024x768  100  113.31  1024  72  112  184  768  1  3  42  n  p
--1152x864  75  108  1152  64  128  256  864  1  3  32  p  p
--1152x864  85  119.65  1152  72  128  200  864  1  3  39  n  p
--1152x864  100  143.47  1152  80  128  208  864  1  3  47  n  p
--1152x864  60  81.62  1152  64  120  184  864  1  3  27  n  p
--1280x1024  60  108  1280  48  112  248  1024  1  3  38  p  p
--1280x1024  75  135  1280  16  144  248  1024  1  3  38  p  p
--1280x1024  85  157.5  1280  64  160  224  1024  1  3  44  p  p
--1280x1024  100  190.96  1280  96  144  240  1024  1  3  57  n  p
--1280x800  60  83.46  1280  64  136  200  800  1  3  24  n  p
--1280x960  60  102.1  1280  80  136  216  960  1  3  30  n  p
--1280x960  72  124.54  1280  88  136  224  960  1  3  37  n  p
--1280x960  75  129.86  1280  88  136  224  960  1  3  38  n  p
--1280x960  85  148.5  1280  64  160  224  960  1  3  47  p  p
--1280x960  100  178.99  1280  96  144  240  960  1  3  53  n  p
--1368x768  60  85.86  1368  72  144  216  768  1  3  23  n  p
--1400x1050  60  122.61  1400  88  152  240  1050  1  3  33  n  p
--1400x1050  72  149.34  1400  96  152  248  1050  1  3  40  n  p
--1400x1050  75  155.85  1400  96  152  248  1050  1  3  42  n  p
--1400x1050  85  179.26  1400  104  152  256  1050  1  3  49  n  p
--1400x1050  100  214.39  1400  112  152  264  1050  1  3  58  n  p
--1440x900  60  106.47  1440  80  152  232  900  1  3  28  n  p
--1600x1200  60  162  1600  64  192  304  1200  1  3  46  p  p
--1600x1200  65  175.5  1600  64  192  304  1200  1  3  46  p  p
--1600x1200  70  189  1600  64  192  304  1200  1  3  46  p  p
--1600x1200  75  202.5  1600  64  192  304  1200  1  3  46  p  p
--1600x1200  85  229.5  1600  64  192  304  1200  1  3  46  p  p
--1600x1200  100  280.64  1600  128  176  304  1200  1  3  67  n  p
--1680x1050  60  147.14  1680  104  184  288  1050  1  3  33  n  p
--1792x1344  60  204.8  1792  128  200  328  1344  1  3  46  n  p
--1792x1344  75  261  1792  96  216  352  1344  1  3  69  n  p
--1856x1392  60  218.3  1856  96  224  352  1392  1  3  43  n  p
--1856x1392  75  288  1856  128  224  352  1392  1  3  104  n  p
--1920x1200  60  193.16  1920  128  208  336  1200  1  3  38  n  p
--1920x1440  60  234  1920  128  208  344  1440  1  3  56  n  p
--1920x1440  75  297  1920  144  224  352  1440  1  3  56  n  p

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY vga_controller IS
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
END vga_controller;

ARCHITECTURE behavior OF vga_controller IS
  CONSTANT  h_period  :  INTEGER := h_pulse + h_bp + h_pixels + h_fp;  --total number of pixel clocks in a row
  CONSTANT  v_period  :  INTEGER := v_pulse + v_bp + v_pixels + v_fp;  --total number of rows in column
BEGIN

  n_blank <= '1';  --no direct blanking
  n_sync <= '0';   --no sync on green
  
  PROCESS(pixel_clk, reset_n)
    VARIABLE h_count  :  INTEGER RANGE 0 TO h_period - 1 := 0;  --horizontal counter (counts the columns)
    VARIABLE v_count  :  INTEGER RANGE 0 TO v_period - 1 := 0;  --vertical counter (counts the rows)
  BEGIN
  
    IF(reset_n = '0') THEN    --reset asserted
      h_count := 0;           --reset horizontal counter
      v_count := 0;           --reset vertical counter
      h_sync <= NOT h_pol;    --deassert horizontal sync
      v_sync <= NOT v_pol;    --deassert vertical sync
      disp_ena <= '0';        --disable display
      column <= 0;            --reset column pixel coordinate
      row <= 0;               --reset row pixel coordinate
      
    ELSIF(pixel_clk'EVENT AND pixel_clk = '1') THEN

      --counters
      IF(h_count < h_period - 1) THEN    --horizontal counter (pixels)
        h_count := h_count + 1;
      ELSE
        h_count := 0;
        IF(v_count < v_period - 1) THEN  --veritcal counter (rows)
          v_count := v_count + 1;
        ELSE
          v_count := 0;
        END IF;
      END IF;

      --horizontal sync signal
      IF(h_count < h_pixels + h_fp OR h_count > h_pixels + h_fp + h_pulse) THEN
        h_sync <= NOT h_pol;    --deassert horiztonal sync pulse
      ELSE
        h_sync <= h_pol;        --assert horiztonal sync pulse
      END IF;
      
      --vertical sync signal
      IF(v_count < v_pixels + v_fp OR v_count > v_pixels + v_fp + v_pulse) THEN
        v_sync <= NOT v_pol;    --deassert vertical sync pulse
      ELSE 
        v_sync <= v_pol;        --assert vertical sync pulse
      END IF;
      
      --set pixel coordinates
      IF(h_count < h_pixels) THEN    --horiztonal display time
        column <= h_count;           --set horiztonal pixel coordinate
      END IF;
      IF(v_count < v_pixels) THEN    --vertical display time
        row <= v_count;              --set vertical pixel coordinate
      END IF;

      --set display enable output
      IF(h_count < h_pixels AND v_count < v_pixels) THEN    --display time
        disp_ena <= '1';                                    --enable display
      ELSE                                                  --blanking time
        disp_ena <= '0';                                    --disable display
      END IF;

    END IF;
  END PROCESS;

END behavior;