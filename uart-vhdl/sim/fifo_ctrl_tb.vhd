library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.env.stop;

entity fifo_ctrl_tb is
--  Port ( );
end fifo_ctrl_tb;

architecture Behavioral of fifo_ctrl_tb is
    -- Constants
    constant ADDR_WIDTH_TB : natural := 4;
    constant CP : time := 10 ns;

    -- Signals
    signal clk_tb : std_logic := '0'; 
    signal rst_tb : std_logic;
    signal rd_tb, wr_tb : std_logic;
    signal empty_tb, full_tb : std_logic;
    signal w_addr_tb : std_logic_vector(ADDR_WIDTH_TB - 1 downto 0);
    signal r_addr_tb : std_logic_vector(ADDR_WIDTH_TB - 1 downto 0);
begin

    -- Unit Under Test
    uut: entity work.fifo_ctrl 
        generic map (
            ADDR_WIDTH => ADDR_WIDTH_TB
        )
        port map (
            clk => clk_tb,
            rst => rst_tb,
            rd => rd_tb,
            wr => wr_tb,
            empty => empty_tb,
            full => full_tb,
            w_addr => w_addr_tb,
            r_addr => r_addr_tb
        );

    -- Clock
    clock: process
    begin
        clk_tb <= not clk_tb;
        wait for CP/2;
    end process;

    -- Test
    test: process
    begin
        -- reset
        rst_tb <= '1';
        wr_tb <= '0';
        rd_tb <= '0';
        wait for CP;
        rst_tb <= '0';
        wait for CP;

        -- Assert write
        wr_tb <= '1';
        wait for 17*CP;
        wr_tb <= '0';
        wait for 2*CP;

        -- Assert write and read
        wr_tb <= '1';
        rd_tb <= '1';
        wait for 5*CP;
        wr_tb <= '0';
        rd_tb <= '0';
        wait for 5*CP;

        -- Assert read
        rd_tb <= '1';
        wait for 17*CP;
        rd_tb <= '0';
        wait for 5*CP;

        -- Assert write and read
        wr_tb <= '1';
        rd_tb <= '1';
        wait for 5*CP;
        wr_tb <= '0';
        rd_tb <= '0';
        wait for 5*CP;


        rst_tb <= '1';
        wait for CP;
        rst_tb <= '0';
        wait for CP;

        -- Stop
        stop;
    end process;
end Behavioral;
