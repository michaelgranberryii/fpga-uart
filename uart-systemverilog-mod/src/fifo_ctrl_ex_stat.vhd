library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fifo_ctrl_ex_stat is
 Generic (ADDR_WIDTH : natural := 4);
 Port (
    clk, reset : in std_logic;
    rd, wr : in std_logic;
    empty, full : out std_logic;
    almost_empty, almost_full : out std_logic;
    word_count : out std_logic_vector(ADDR_WIDTH downto 0); 
    w_addr : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    r_addr : out std_logic_vector(ADDR_WIDTH-1 downto 0)
 );
end fifo_ctrl_ex_stat;

architecture Behavioral of fifo_ctrl_ex_stat is
    signal w_ptr_reg  : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal w_ptr_next : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal w_ptr_succ : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal r_ptr_reg  : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal r_ptr_next : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal r_ptr_succ : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal full_reg   : std_logic;
    signal full_next  : std_logic;
    signal empty_reg  : std_logic;
    signal empty_next : std_logic;
    signal wr_op      : std_logic_vector(1 downto 0);
    signal count : integer;
    signal n : integer := ((2**ADDR_WIDTH)*1/4);
    signal m : integer := ((2**ADDR_WIDTH)*3/4);
begin
   
-- register for read and write pointers
process(clk, reset)
begin
   if (reset = '1') then
      w_ptr_reg <= (others => '0');
      r_ptr_reg <= (others => '0');
      full_reg  <= '0';
      empty_reg <= '1';
   elsif (clk'event and clk = '1') then
      w_ptr_reg <= w_ptr_next;
      r_ptr_reg <= r_ptr_next;
      full_reg  <= full_next;
      empty_reg <= empty_next;
   end if;
end process;

-- successive pointer values
w_ptr_succ <= std_logic_vector(unsigned(w_ptr_reg) + 1);
r_ptr_succ <= std_logic_vector(unsigned(r_ptr_reg) + 1);

-- next-state logic for read and write pointers
wr_op <= wr & rd;

process(w_ptr_reg, w_ptr_succ, r_ptr_reg, r_ptr_succ, wr_op, empty_reg, full_reg)
  begin
     w_ptr_next <= w_ptr_reg;
     r_ptr_next <= r_ptr_reg;
     full_next  <= full_reg;
     empty_next <= empty_reg;
     case wr_op is
        when "00" =>                   -- no op
        when "01" =>                   -- read
           if (empty_reg /= '1') then  -- not empty
              r_ptr_next <= r_ptr_succ;
              full_next  <= '0';
              if (r_ptr_succ = w_ptr_reg) then
                 empty_next <= '1';
              end if;
           end if;
           when "10" =>                   -- write
           if (full_reg /= '1') then   -- not full
              w_ptr_next <= w_ptr_succ;
              empty_next <= '0';
              if (w_ptr_succ = r_ptr_reg) then
                 full_next <= '1';
              end if;
           end if;
        when others =>                 -- write/read;
           w_ptr_next <= w_ptr_succ;
           r_ptr_next <= r_ptr_succ;
     end case;
end process;

-- Counter
process(clk, reset)
begin
   if reset = '1' then
      count <= 0;
   elsif rising_edge(clk) then
      if (full_reg = '1' and wr = '1') and (empty_reg = '0' and rd = '1') then
         count <= count;
      elsif (full_reg = '0' and wr = '1') and (empty_reg = '1' and rd = '1') then
         count <= count;
      elsif (full_reg = '0' and wr = '1') and (empty_reg = '0' and rd = '1') then
         count <= count;
      elsif (full_reg = '0' and wr = '1') then
         count <= count + 1;
      elsif (empty_reg = '0' and rd = '1') then
         count <= count - 1;
      else
         count <= count;
      end if;
   end if;
end process;

-- output
w_addr <= w_ptr_reg;
r_addr <= r_ptr_reg;
full   <= full_reg;
empty  <= empty_reg;
word_count <= std_logic_vector(to_unsigned(count,word_count'length));

almost_empty <= '1'  when count = n else
                     '0';

almost_full <= '1'  when count = m else
                     '0';

end Behavioral;
