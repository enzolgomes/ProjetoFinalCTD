library IEEE;
use IEEE.Std_Logic_1164.all;

entity decoder_termometrico is
    port (
        X    : in  std_logic_vector(4 downto 0);
        LEDR : out std_logic_vector(17 downto 0)
    );
end decoder_termometrico;

architecture circuito of decoder_termometrico is
begin
    -- Na primeira rodada (X = 17), todos os 18 LEDs LEDR(17..0) estao ligados
    with X select
        LEDR <= "111111111111111111" when "10001", -- 17 (Rodada 1: 18 LEDs)
                "011111111111111111" when "10000", -- 16 (Rodada 2: 17 LEDs)
                "001111111111111111" when "01111", -- 15 (Rodada 3: 16 LEDs)
                "000111111111111111" when "01110", -- 14 (Rodada 4: 15 LEDs)
                "000011111111111111" when "01101", -- 13 (Rodada 5: 14 LEDs)
                "000001111111111111" when "01100", -- 12 (Rodada 6: 13 LEDs)
                "000000111111111111" when "01011", -- 11 (Rodada 7: 12 LEDs)
                "000000011111111111" when "01010", -- 10 (Rodada 8: 11 LEDs)
                "000000001111111111" when "01001", -- 9  (Rodada 9: 10 LEDs)
                "000000000111111111" when "01000", -- 8  (Rodada 10: 9 LEDs)
                "000000000011111111" when "00111", -- 7  (Rodada 11: 8 LEDs)
                "000000000001111111" when "00110", -- 6  (Rodada 12: 7 LEDs)
                "000000000000111111" when "00101", -- 5  (Rodada 13: 6 LEDs)
                "000000000000011111" when "00100", -- 4  (Rodada 14: 5 LEDs)
                "000000000000001111" when "00011", -- 3  (Rodada 15: 4 LEDs)
                "000000000000000111" when "00010", -- 2  (Rodada 16: 3 LEDs)
                "000000000000000011" when "00001", -- 1  (Rodada 17: 2 LEDs)
                "000000000000000001" when "00000", -- 0  (Rodada 18: 1 LED)
                "000000000000000000" when others;  -- Fim das rodadas (0 LEDs)
end circuito;
