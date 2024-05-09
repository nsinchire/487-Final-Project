LIBRARY IEEE;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity snake is
    PORT (
        clk_in : IN STD_LOGIC; -- system clock
        
        VGA_red : OUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- VGA outputs
        VGA_green : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_blue : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_hsync : OUT STD_LOGIC;
        VGA_vsync : OUT STD_LOGIC;
        
        btnc : IN STD_LOGIC; -- Button inputs
        btnu : IN STD_LOGIC;
        btnl : IN STD_LOGIC;
        btnr : IN STD_LOGIC;
        btnd : IN STD_LOGIC;
        
        SEG7_anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0); -- anodes of four 7-seg displays
        SEG7_seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
    );
end snake;

architecture Behavioral of snake is
    SIGNAL pxl_clk : STD_LOGIC := '0'; -- 25 MHz clock to VGA sync module
    -- internal signals to connect modules
    SIGNAL S_red, S_green, S_blue : STD_LOGIC; --_VECTOR (3 DOWNTO 0);
    SIGNAL S_vsync : STD_LOGIC;
    SIGNAL S_pixel_row, S_pixel_col : STD_LOGIC_VECTOR (10 DOWNTO 0);
    --SIGNAL batpos : STD_LOGIC_VECTOR (10 DOWNTO 0); -- 9 downto 0
    SIGNAL count : STD_LOGIC_VECTOR (20 DOWNTO 0);
    signal timer : std_logic_vector (15 downto 0);
    SIGNAL display : std_logic_vector (15 DOWNTO 0); -- value to be displayed
    SIGNAL led_mpx : STD_LOGIC_VECTOR (2 DOWNTO 0); -- 7-seg multiplexing clock
    signal screen : std_logic_vector (31 downto 0);
    
    signal snake_x: std_logic_vector (10 downto 0); -- position of snake
    signal snake_y: std_logic_vector (10 downto 0);
    
    constant size : integer := 8;
    signal onesec : integer;
    
    type state is (left, right, up, down, pause);
    signal direction : state;
    
    
    COMPONENT vga_sync IS
        PORT (
            pixel_clk : IN STD_LOGIC;
            red_in    : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_in  : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_in   : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            red_out   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_out : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_out  : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            hsync : OUT STD_LOGIC;
            vsync : OUT STD_LOGIC;
            pixel_row : OUT STD_LOGIC_VECTOR (10 DOWNTO 0);
            pixel_col : OUT STD_LOGIC_VECTOR (10 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT clk_wiz_0 is
        PORT (
            clk_in1  : in std_logic;
            clk_out1 : out std_logic
        );
    END COMPONENT;
    COMPONENT leddec16 IS
        PORT (
            dig : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            anode : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            seg : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
        );
    END COMPONENT;
    component apple_n_snake is 
        port (
            reset : std_logic;
            snake_x : in std_logic_vector (10 downto 0);
            snake_y : in std_logic_vector (10 downto 0);
            count : in std_logic_vector (20 downto 0);
            
            v_sync : IN STD_LOGIC;
            pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
            red : OUT STD_LOGIC;
            green : OUT STD_LOGIC;
            blue : OUT STD_LOGIC;
            
            score : out std_logic_vector (15 downto 0)
        );
    end component;
    
begin
    pos : PROCESS (clk_in) is
    BEGIN
        if rising_edge(clk_in) then
            screen <= timer & display;
            onesec <= onesec + 1;
            count <= count + 1;
            if onesec = 100000000 and timer /= 0 then
                onesec <= 0;
                timer <= timer - '1';
            end if;
            if timer > 0 or btnc = '1' then
                case direction is 
                    when left =>
                        if count = 0 and snake_x > (0 + size) then 
                            snake_x <= snake_x - 3;
                        end if;
                    when right =>
                        if count = 0 and snake_x < (800 - size) then
                            snake_x <= snake_x + 3;
                        end if;
                    when down =>
                        if count = 0 and snake_y > (0 + size) then
                            snake_y <= snake_y + 3;
                        end if;
                    when up =>
                        if count = 0 and snake_y < (600 - size) then
                            snake_y <= snake_y - 3;
                        end if;
                    when others =>
                        null;
                end case;        
                    
                IF btnl = '1' THEN
                    direction <= left;
                ELSIF btnr = '1' THEN
                    direction <= right;
                elsif btnd = '1' then
                    direction <= down;
                elsif btnu = '1' then
                    direction <= up;
                END IF;
                
                if btnc = '1' then
                    snake_x <= conv_std_logic_vector(300, 11);
                    snake_y <= conv_std_logic_vector(400, 11);
                    direction <= pause;
                    timer <= conv_std_logic_vector(30, 16);
                end if;
            end if;
        end if;
    END PROCESS;
    
    game : apple_n_snake
    port map(
        reset => btnc,
        snake_x => snake_x,
        snake_y => snake_y,
        count => count,
        
        v_sync => S_vsync, 
        pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col,
        red => S_red, 
        green => S_green, 
        blue => S_blue,
        
        score => display
    );
    
    vga_driver : vga_sync
    PORT MAP(--instantiate vga_sync component
        pixel_clk => pxl_clk, 
        red_in => S_red & "000", 
        green_in => S_green & "000", 
        blue_in => S_blue & "000", 
        red_out => VGA_red, 
        green_out => VGA_green, 
        blue_out => VGA_blue, 
        pixel_row => S_pixel_row, 
        pixel_col => S_pixel_col, 
        hsync => VGA_hsync, 
        vsync => S_vsync
    );
    VGA_vsync <= S_vsync; --connect output vsync
        
    clk_wiz_0_inst : clk_wiz_0
    port map (
      clk_in1 => clk_in,
      clk_out1 => pxl_clk
    );
    
    led_mpx <= count(19 DOWNTO 17); -- 7-seg multiplexing clock
    led1 : leddec16
    PORT MAP(
      dig => led_mpx, data => screen, 
      anode => SEG7_anode, seg => SEG7_seg
    );
end Behavioral;
