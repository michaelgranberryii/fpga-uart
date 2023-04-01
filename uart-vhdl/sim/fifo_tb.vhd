library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity fifo_tb is
 end fifo_tb;
 
 architecture Behavioral of fifo_tb is
     -- Constants
     constant ADDR_WIDTH_TB : integer := 2;
     constant DATA_WIDTH_TB : integer := 8;
     constant CP : time := 10 ns;
 
     -- Signals
     signal clk_tb : std_logic := '0'; 
     signal rst_tb : std_logic;
     signal rd_tb, wr_tb : std_logic;
     signal w_data_tb : std_logic_vector(DATA_WIDTH_TB - 1 downto 0);
     signal empty_tb, full_tb : std_logic;
     signal r_data_tb : std_logic_vector(DATA_WIDTH_TB - 1 downto 0);
 begin
 
    -- Unit Under Test
    uut: entity work.fifo
    generic map(
        ADDR_WIDTH => ADDR_WIDTH_TB,
        DATA_WIDTH => DATA_WIDTH_TB
    )
    port map (
        clk => clk_tb,
        rst => rst_tb,
        rd => rd_tb,
        wr => wr_tb,
        w_data => w_data_tb,
        empty => empty_tb,
        full => full_tb,
        r_data => r_data_tb
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
            -- reset
            rd_tb <= '0';
            wr_tb <= '0';
            rst_tb <= '1';
            wait for CP;
            rst_tb <= '0';
            wait for CP;

            -- write 1
            wr_tb <= '1';
            w_data_tb <= x"a5";
            wait for CP;
            wr_tb <= '0';
            wait for CP;

            -- write 2
            wr_tb <= '1';
            w_data_tb <= x"34";
            wait for CP;
            wr_tb <= '0';
            wait for CP;

            -- write 3
            wr_tb <= '1';
            w_data_tb <= x"c1";
            wait for CP;
            wr_tb <= '0';
            wait for CP;

            -- write 4
            wr_tb <= '1';
            w_data_tb <= x"66";
            wait for CP;
            wr_tb <= '0';
            wait for CP;

            -- read 1
            rd_tb <= '1';
            wait for CP;
            rd_tb<= '0';
            wait for CP;

            -- read 2
            rd_tb <= '1';
            wait for CP;
            rd_tb<= '0';
            wait for CP;

            -- read 3
            rd_tb <= '1';
            wait for CP;
            rd_tb<= '0';
            wait for CP;

            -- read 4
            rd_tb <= '1';
            wait for CP;
            rd_tb<= '0';
            wait for CP;

            -- write 6
            wr_tb <= '1';
            w_data_tb <= x"65";
            wait for CP;
            wr_tb <= '0';
            wait for CP;

            -- read 6
            rd_tb <= '1';
            wait for CP;
            rd_tb<= '0';
            wait for CP;

            -- reset
            rst_tb <= '1';
            wait for CP;
            rst_tb <= '0';
            wait for CP;
            -- stop
            stop;
        end process;
end Behavioral;