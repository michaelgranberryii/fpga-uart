library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.env.stop;

entity uart_rx_tb is
end uart_rx_tb;

architecture Behavioral of uart_rx_tb is

    constant DBIT_tb : integer := 8;    -- # data bits
    constant SB_TICK_tb : integer := 16;    -- # ticks for stop bits
    constant CP : time := 8 ns;
    
    signal clk_tb : std_logic := '0';
    signal rst_tb : std_logic;
    signal rx_tb : std_logic;
    signal s_tick_tb : std_logic := '1';
    signal rx_done_tick_tb : std_logic;
    signal dout_tb :std_logic_vector(7 downto 0);
    

begin

    uut: entity work.uart_rx port map (
                                        clk => clk_tb, 
                                        rst => rst_tb, 
                                        rx => rx_tb, 
                                        s_tick => s_tick_tb, 
                                        rx_done_tick => rx_done_tick_tb, 
                                        dout => dout_tb
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
        rx_tb <= '1';
        wait for CP;
        rst_tb <= '0';
        wait for 15*CP;

        rx_tb <= '0';
        wait for 7*CP;
        rx_tb <= '1';
        wait for 68*CP;
        rx_tb <= '0';
        wait for 68*CP;
        rx_tb <= '1';
        wait for 68*CP;
        rx_tb <= '0';
        wait for 68*CP;
        rx_tb <= '1';
        wait for 100*CP;
        stop;
    end process;

    s_tick_p: process
    begin
        s_tick_tb <= not s_tick_tb;
        wait for 68*CP;
    end process;

end Behavioral;
