library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--para uso com o clock de 50MHz da placa DE2 (CLOCK_50)

entity Div_Freq_DE2 is
    port (        
        clk: in std_logic;
        reset: in std_logic;
        CLK_2Hz, CLK_3Hz, CLK_4Hz, CLK_5Hz: out std_logic
    );
end Div_Freq_DE2;

architecture divisor of Div_Freq_DE2 is
    signal cont2, cont3, cont4, cont5: std_logic_vector(27 downto 0);
    
    begin
        P1: process(clk, reset)
        begin
            
            if reset = '1' then
                
                cont2 <= x"0000000";
                cont3 <= x"0000000";
                cont4 <= x"0000000";
                cont5 <= x"0000000";
                CLK_2Hz <= '0';
                CLK_3Hz <= '0';
                CLK_4Hz <= '0';
                CLK_5Hz <= '0';
                 
            elsif clk'event and clk = '1' then

                --2Hz = 0.5s = 25.000.000 ciclos (0 a 24.999.999)
                if cont2 < x"17D783F" then  -- 24.999.999 em hex
                    CLK_2Hz <= '0';
                    cont2 <= cont2 + 1;
                else   
                    cont2 <= x"0000000";
                    CLK_2Hz <= '1';
                end if;
                
                --3Hz = 0.33s = 16.666.667 ciclos (0 a 16.666.666)
                if cont3 < x"0FE502A" then  -- 16.666.666 em hex
                    CLK_3Hz <= '0';
                    cont3 <= cont3 + 1;
                else   
                    cont3 <= x"0000000";
                    CLK_3Hz <= '1';
                end if;
                
                --4Hz = 0.25s = 12.500.000 ciclos (0 a 12.499.999)
                if cont4 < x"0BEBC1F" then  -- 12.499.999 em hex
                    CLK_4Hz <= '0';
                    cont4 <= cont4 + 1;
                else   
                    cont4 <= x"0000000";
                    CLK_4Hz <= '1';
                end if;
                
                --5Hz = 0.2s = 10.000.000 ciclos (0 a 9.999.999)
                if cont5 < x"098967F" then  -- 9.999.999 em hex
                    CLK_5Hz <= '0';
                    cont5 <= cont5 + 1;
                else   
                    cont5 <= x"0000000";
                    CLK_5Hz <= '1';
                end if;
                
            end if;

        end process;
            
end architecture;