--baud rate = clock rate/16/(dvsr+1)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity uart_tb is
end uart_tb;

architecture Behavioral of uart_tb is

        constant DBIT_tb : integer := 8;   -- # data bits
        constant SB_TICK_tb : integer := 16;  -- # ticks for stop bits, 16 per bit
        constant FIFO_W_tb : integer := 0;    -- # FIFO addr bits (depth: 2^FIFO_W)
        constant CP : time := 8 ns;

        signal clk_tb : std_logic := '0'; 
        signal rst_tb : std_logic;
        signal rd_uart_tb : std_logic;
        signal wr_uart_tb : std_logic;
        signal dvsr_tb : std_logic_vector(10 downto 0);
        signal rx_tb : std_logic;
        signal w_data_tb : std_logic_vector(7 downto 0);
        signal tx_full_tb : std_logic;
        signal rx_empty_tb : std_logic;
        signal r_data_tb : std_logic_vector(7 downto 0);
        signal tx_tb : std_logic;

begin

    uut: entity work.uart
    generic map (
        DBIT => DBIT_tb,
        SB_TICK => SB_TICK_tb,
        FIFO_W => FIFO_W_tb
    )
    port map (
        clk => clk_tb,
        rst => rst_tb,
        rd_uart => rd_uart_tb,
        wr_uart => wr_uart_tb,
        dvsr => dvsr_tb,
        rx => rx_tb,
        w_data => w_data_tb,
        tx_full => tx_full_tb,
        rx_empty => rx_empty_tb,
        r_data => r_data_tb,
        tx => tx_tb
    );

    dvsr_tb <= std_logic_vector(to_unsigned(68,11));

    clk_p: process
    begin
        clk_tb <= not clk_tb;
        wait for CP/2;
    end process;

    rst_p: process
    begin
        rst_tb <= '1';
        wait for CP;
        rst_tb <= '0';
        wait;
    end process;

    w_p: process
    begin
        wait for 1*CP;
        w_data_tb <= x"a6";
        wr_uart_tb <= '1';
        -- wait;
        wait for 100 us;
        stop;
    end process;

    r_p: process
    begin
        wait for 1*CP;
        rx_tb <= '1';
        rd_uart_tb <= '1';
        wait;
    end process;

end Behavioral;