library IEEE;
use IEEE.Std_Logic_1164.all;

entity registrador is
    port (
        CLK : in  std_logic;
        R   : in  std_logic;
        E   : in  std_logic;
        D   : in  std_logic_vector(11 downto 0);
        Q   : out std_logic_vector(11 downto 0)
    );
end registrador;

architecture behv of registrador is
    signal reg : std_logic_vector(11 downto 0) := (others => '0');
begin
    process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            if R = '1' then
                reg <= (others => '0');
            elsif E = '1' then
                reg <= D;
            end if;
        end if;
    end process;

    Q <= reg;
end behv;
