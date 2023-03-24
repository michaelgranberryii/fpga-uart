library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_uart is
    generic (
        N : integer := 11;
        DATA_WIDTH : integer := 8;
        FIFO_W : integer := 0
    );
    port (
        clk : in std_logic;
        rst : in std_logic;
        led : out std_logic_vector(3 downto 0);
        led_r : out std_logic;
        led_g : out std_logic;
        led_b : out std_logic;
        tx : out std_logic;
        rx : in std_logic
    );

end top_uart;

architecture Behavioral of top_uart is

    constant dvsr : std_logic_vector((N-1) downto 0) := std_logic_vector(to_unsigned(68, 11));

    signal wr_en : std_logic;
    signal wr_uart : std_logic;
    signal rd_uart : std_logic;
    signal wr_dvsr : std_logic;
    signal tx_full : std_logic;
    signal rx_empty : std_logic;
    signal r_data : std_logic_vector((DATA_WIDTH-1) downto 0);
    signal w_data : std_logic_vector((DATA_WIDTH-1) downto 0);
    signal dvsr_reg : std_logic_vector((N-1) downto 0);

begin

uart_i : entity work.uart
    generic map (
        DBIT => 8,
        SB_TICK => 16,
        FIFO_W => 0
    )
    port map (
        clk => clk,
        rst => rst,
        rd_uart => rd_uart,
        wr_uart => wr_uart,
        dvsr => dvsr,
        rx => rx,
        w_data => w_data,
        tx_full =>tx_full,
        rx_empty => rx_empty,
        r_data => r_data,
        tx => tx
    );

    led <= r_data(3 downto 0);
    wr_uart <= '1';
    rd_uart <= '1';
    -- w_data -- Always on

end Behavioral;