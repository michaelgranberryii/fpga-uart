library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity reg_file_tb is
 end reg_file_tb;
 
 architecture Behavioral of reg_file_tb is
     -- Constants
     constant ADDR_WIDTH_TB : integer := 2;
     constant DATA_WIDTH_TB : integer := 8;
     constant CP : time := 10 ns;
 
     -- Signal
     signal clk_tb : std_logic := '0';
     signal wr_en_tb :  std_logic;
     signal w_addr_tb : std_logic_vector(ADDR_WIDTH_TB-1 downto 0);
     signal r_addr_tb : std_logic_vector(ADDR_WIDTH_TB-1 downto 0);
     signal w_data_tb : std_logic_vector(DATA_WIDTH_TB-1 downto 0);
     signal r_data_tb : std_logic_vector(DATA_WIDTH_TB-1 downto 0);
 begin
     -- Unit Under Test
     uut: entity work.reg_file
     generic map(
         ADDR_WIDTH => ADDR_WIDTH_TB,
         DATA_WIDTH => DATA_WIDTH_TB
     )
     port map (
         clk => clk_tb,
         wr_en => wr_en_tb,
         -- addr
         w_addr => w_addr_tb,
         r_addr => r_addr_tb,
         -- data
         w_data => w_data_tb,
         r_data => r_data_tb -- out
     );

 -- Clock
 clock:  process
         begin
             clk_tb <= not clk_tb;
             wait for CP/2;
         end process;
 
 -- Test
 test:   process
        begin
            wr_en_tb <= '0';
            -- r_addr_tb <= "00";
            wait for CP;

            -- write data 1
            wr_en_tb <= '1';
            w_addr_tb <= "00";
            w_data_tb <= x"2e";
            wait for CP;
            wr_en_tb <= '0';
            wait for CP;

            -- write data 2
            wr_en_tb <= '1';
            w_addr_tb <= "01";
            w_data_tb <= x"34";
            wait for CP;
            wr_en_tb <= '0';
            wait for CP;

            -- write data 3
            wr_en_tb <= '1';
            w_addr_tb <= "10";
            w_data_tb <= x"77";
            wait for CP;
            wr_en_tb <= '0';
            wait for CP;

            -- write data 4
            wr_en_tb <= '1';
            w_addr_tb <= "11";
            w_data_tb <= x"ff";
            wait for CP;
            wr_en_tb <= '0';
            wait for CP;

            -- en = 0
            wr_en_tb <= '0';
            wait for CP;

            -- read data 0
            r_addr_tb <= "00";
            wait for CP;

            -- read data 1
            r_addr_tb <= "01";
            wait for CP;
            
            -- read data 2
            r_addr_tb <= "10";
            wait for CP;

            -- read data 3
            r_addr_tb <= "11";
            wait for 2*CP;
            stop;
        end process;
 end Behavioral;