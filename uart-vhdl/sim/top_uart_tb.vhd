library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.env.stop;

entity top_uart_tb is
end top_uart_tb;

architecture Behavioral of top_uart_tb is


        constant N_tb : integer := 11;
        constant DATA_WIDTH_tb : integer := 8;
        constant FIFO_W_tb : integer := 0;
        constant CP : time := 8 ns;

        signal clk_tb :  std_logic := '0';
        signal rst_tb :  std_logic;
        signal led_tb :  std_logic_vector(3 downto 0);
        signal rx_tb :  std_logic;
        signal tx_tb :  std_logic;
        signal counter : natural := 0;
        constant rx_in : std_logic_vector(7 downto 0) := x"34";


begin

    uut_1: entity work.top_uart 
    generic map (
        N => N_tb,
        DATA_WIDTH => DATA_WIDTH_tb,
        FIFO_W => FIFO_W_tb
    )
    port map (
        clk => clk_tb,
        rst => rst_tb,
        led => led_tb,
        tx => tx_tb,
        rx => rx_tb
    );

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

    rx_p: process
    begin
        counter <= counter + 1;
        rx_tb <= rx_in(counter mod 7);
        wait for CP;
    end process;

    stop_p: process
    begin
        wait for 1000 us;
        stop;
    end process;

end Behavioral;