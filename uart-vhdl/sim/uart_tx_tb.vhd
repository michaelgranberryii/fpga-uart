library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.stop;

entity uart_tx_tb is

end uart_tx_tb;

architecture Behavioral of uart_tx_tb is


        constant DBIT    : integer := 8;   -- # data bits
        constant SB_TICK : integer := 16;   -- # ticks for stop bits
        constant CP : time := 8 ns;

        signal clk_tb : std_logic := '0';
        signal rst_tb   : std_logic;
        signal tx_start_tb     : std_logic;
        signal s_tick_tb       :  std_logic := '1';
        signal din_tb          : std_logic_vector(7 downto 0);
        signal tx_done_tick_tb : std_logic;
        signal tx_tb           : std_logic;

begin

    uut: entity work.uart_tx port map (
        clk_tb,
        rst_tb,
        tx_start_tb,
        s_tick_tb,
        din_tb,
        tx_done_tick_tb,
        tx_tb
    );

    clk_p: process
    begin
        clk_tb <= not clk_tb;
        wait for CP/2;
    end process;

    uut_p: process
    begin
        -- rst
        rst_tb <= '1';
        tx_start_tb <= '0';
        din_tb <= x"A6";
        wait for CP;
        rst_tb <= '0';
        wait for 15*CP;

        tx_start_tb <= '1';
        wait for CP;
        tx_start_tb <= '0';
       
        wait for 400*CP;
        stop;

    end process;

    s_tick_p: process
    begin
        s_tick_tb <= not s_tick_tb;
        wait for 68*CP;
    end process;

end Behavioral;
