--medazizlhb
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fft is
    generic (
        N : positive := 8   -- Number of FFT points
    );
    port (
        clk : in  std_logic;
        reset : in  std_logic;
        data_in : in  std_logic_vector(N-1 downto 0);
        data_out : out  std_logic_vector(N-1 downto 0)
    );
end fft;

architecture Behavioral of fft is
    type complex_vector is array (0 to N-1) of std_logic_vector(N-1 downto 0);
    signal stage1, stage2 : complex_vector;
    signal twiddle_factor : std_logic_vector(N-1 downto 0);
    signal index : integer range 0 to N-1 := 0;
    
begin
    process (clk, reset)
    begin
        if reset = '1' then
            stage1 <= (others => (others => '0'));
        elsif rising_edge(clk) then
            stage1(index) <= data_in;
        end if;
    end process;
    
    process (stage1)
    begin
        for i in 0 to (N/2)-1 loop
            stage2(i) <= stage1(i) + stage1(i + (N/2));
            stage2(i + (N/2)) <= stage1(i) - stage1(i + (N/2));
        end loop;
    end process;
    
    data_out <= stage2;
end Behavioral;
