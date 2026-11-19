library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Divisor de Frequência para entrada com Clock de 500Hz

entity Div_Freq is
    port (        
        clk: in std_logic; -- Clock de 500 Hz
        reset: in std_logic;
        CLK_2Hz, CLK_3Hz, CLK_4Hz, CLK_5Hz: out std_logic
    );
end Div_Freq;

architecture divisor of Div_Freq is
    signal cont2, cont3, cont4, cont5: std_logic_vector(7 downto 0);
    
    begin
        P1: process(clk, reset)
        begin
            
            if reset = '1' then
                
                cont2 <= x"00";
                cont3 <= x"00";
                cont4 <= x"00";
                cont5 <= x"00";
                CLK_2Hz <= '0';
                CLK_3Hz <= '0';
                CLK_4Hz <= '0';
                CLK_5Hz <= '0';
                 
            elsif clk'event and clk = '1' then

                -- 2 Hz: Contar ate 249 (x"0F9")
                if cont2 < x"0F9" then
                    CLK_2Hz <= '0';
                    cont2 <= cont2 + 1;
                else   
                    cont2 <= x"00";
                    CLK_2Hz <= '1';
                end if;
                
                -- 3 Hz: Contar ate 165 (x"0A5")
                if cont3 < x"0A5" then
                    CLK_3Hz <= '0';
                    cont3 <= cont3 + 1;
                else   
                    cont3 <= x"00";
                    CLK_3Hz <= '1';
                end if;
                
                -- 4 Hz: Contar ate 124 (x"07C")
                if cont4 < x"07C" then
                    CLK_4Hz <= '0';
                    cont4 <= cont4 + 1;
                else   
                    cont4 <= x"00";
                    CLK_4Hz <= '1';
                end if;
                
                -- 5 Hz: Contar ate 99 (x"063")
                if cont5 < x"063" then
                    CLK_5Hz <= '0';
                    cont5 <= cont5 + 1;
                else   
                    cont5 <= x"00";
                    CLK_5Hz <= '1';
                end if;
                
            end if;

        end process;
            
end architecture;