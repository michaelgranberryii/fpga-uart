library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.env.stop;

entity baud_gen_tb is
end baud_gen_tb;

architecture Behavioral of baud_gen_tb is
    signal clk_tb : std_logic := '0';
    signal rst_tb : std_logic;
    signal dvsr_tb : std_logic_vector(10 downto 0);
    signal ticks_tb : std_logic;
    constant CP : time := 8 ns;
begin

    uut: entity work.baud_gen port map (clk => clk_tb, rst => rst_tb, dvsr => dvsr_tb, ticks => ticks_tb);

    dvsr_tb <= std_logic_vector(to_unsigned(67, dvsr_tb'length));

    clk_p: process
    begin
        clk_tb <= not clk_tb;
        wait for CP/2;
    end process;

    uut_p: process
    begin
        -- reset
        rst_tb <= '1';
        wait for CP;
        rst_tb <= '0';
        wait for CP;
        
        

        wait for 1000 ns;
        stop;
    end process; 

end Behavioral;
