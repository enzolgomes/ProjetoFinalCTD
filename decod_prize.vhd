library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decod_prize is
    port (
        seq_12bits : in  std_logic_vector(11 downto 0); -- HEX2 & HEX1 & HEX0
        prize      : out std_logic_vector(26 downto 0)  -- Bit 26: Double | Bits 25..0: Valor em binário
    );
end entity decod_prize;

architecture Behavioral of decod_prize is
begin

    prize <= 
        -- Doubling (MSB = '1')
        "100000000000000000000000000" when seq_12bits = x"777" or seq_12bits(11 downto 8) = x"5" else

        -- Valores Positivos
        "000000011110100001001000000" when seq_12bits = x"999" else                   -- +1.000.000 
        "000000000011000011010100000" when seq_12bits = x"AAA" else                   -- +100.000   
        "000000000000010011100010000" when seq_12bits = x"123" else                   -- +10.000    
        "000000000000000001111101000" when seq_12bits(11 downto 8) = x"3" else        -- +1.000     
        "000000000000000000001100100" when seq_12bits(11 downto 4) = x"75" else       -- +100       
        "000000000000000000000001010" when seq_12bits(11 downto 4) = x"95" else       -- +10
       

        -- Valores Negativos (Complemento de dois de 26 bits)
        "011111111111111111111110110" when seq_12bits(11 downto 8) = x"B" else        -- -10 
        "011111111111111111110011100" when seq_12bits(11 downto 8) = x"C" else        -- -100
        "011111111111111110000011000" when seq_12bits(11 downto 8) = x"D" else        -- -1.000
        "011111111111101100011110000" when seq_12bits(11 downto 8) = x"E" else        -- -10.000
        "011111111100111100101100000" when seq_12bits(11 downto 8) = x"F" else        -- -100.000
        "011111100001011110111000000" when seq_12bits(11 downto 8) = x"2" else        -- -1.000.000

        -- Lose All (Perde tudo)
        "010000000000000000000000000" when seq_12bits(11 downto 8) = x"0" else        -- Lose All (-33554432)

        -- Caso padrão (Retorna 0 / Sem alteração)
        "000000000000000000000000000";

end architecture Behavioral;