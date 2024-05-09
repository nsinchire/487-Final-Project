library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity apple_n_snake is
    Port ( 
        reset : in std_logic;
        snake_x : in std_logic_vector (10 downto 0);
        snake_y : in std_logic_vector (10 downto 0);
        count : in std_logic_vector (20 downto 0);
        -- Display Settings
        v_sync : IN STD_LOGIC;
        pixel_row : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        pixel_col : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
        red : OUT STD_LOGIC;
        green : OUT STD_LOGIC;
        blue : OUT STD_LOGIC;
        
        score : out std_logic_vector (15 downto 0) -- score of player
    );
end apple_n_snake;

architecture Behavioral of apple_n_snake is
    CONSTANT ssize : INTEGER := 8; -- snake size in pixels
    CONSTANT asize : INTEGER := 8; -- apple size in pixels
    signal snake_on : std_logic; -- indicates whether snake is at current pixel position
    signal apple_on : std_logic; -- indicates whether snake is at current pixel position
    signal random_apple_x : std_logic_vector (9 downto 0); -- temp random apple position
    signal random_apple_y : std_logic_vector (9 downto 0);
    signal apple_x : std_logic_vector (9 downto 0); -- apple position 10 bits for x, 9 for y
    signal apple_y : std_logic_vector (8 downto 0);
    signal temp_score :  std_logic_vector (15 downto 0); 
    
begin
    red <= NOT snake_on; -- color setup for red apple and cyan snake on white background
    green <= NOT apple_on;
    blue <= NOT apple_on;
    
    -- process to draw snake
    -- set snake_on if current pixel address is covered by snake position
    snakedraw : PROCESS (snake_x, snake_y, pixel_row, pixel_col) IS
    BEGIN
        IF ((pixel_col >= snake_x - ssize) OR (snake_x <= ssize)) AND
         pixel_col <= snake_x + ssize AND
             pixel_row >= snake_y - ssize AND
             pixel_row <= snake_y + ssize THEN
                snake_on <= '1';
        ELSE
            snake_on <= '0';
        END IF;
    END PROCESS;
    
    -- process to spawn an apple
    -- set apple_on if current pixel address is covered by apple position
    appledraw : process (apple_x, apple_y, pixel_row, pixel_col) is 
    begin
        IF ((pixel_col >= apple_x - asize) OR (apple_x <= asize)) AND
         pixel_col <= apple_x + asize AND
             pixel_row >= apple_y - asize AND
             pixel_row <= apple_y + asize THEN
                apple_on <= '1';
        ELSE
            apple_on <= '0';
        END IF;
    end process;
    
    --start apple production
    start : process
    begin
        WAIT UNTIL rising_edge(v_sync);
        if reset = '1' then
            -- Generate new apple location
            if count (20 downto 11) > 8 and count (20 downto 11) < 790 then
                apple_x <= count (20 downto 11);
            end if;
            if count (8 downto 0) > 8 then
                apple_y <= count (8 downto 0);
            end if;
            -- Set score to zero
            temp_score <= "0000000000000000";
            score <= temp_score;
        elsif (apple_x + ssize/2) >= (snake_x - asize) AND
              (apple_x - ssize/2) <= (snake_x + asize) AND
              (apple_y + ssize/2) >= (snake_y - asize) AND
              (apple_y - ssize/2) <= (snake_y + asize) THEN
            temp_score <= temp_score + '1';
            -- Generate new apple location
            if count (20 downto 11) > 8 and count (20 downto 11) < 790 then
                apple_x <= count (20 downto 11);
            end if;
            if count (8 downto 0) > 8 then
                apple_y <= count (8 downto 0);
            end if;
        end if;
        score <= temp_score;
    end process;
    
end Behavioral;
