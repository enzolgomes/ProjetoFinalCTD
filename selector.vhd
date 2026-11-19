library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.numeric_std.all;

entity selector is
    port (
        X         : in  std_logic_vector(4 downto 0);
        SPEED_MUX : out std_logic_vector(1 downto 0)
    );
end selector;

architecture circuito of selector is
begin
    -- Rodadas 1 a 4  (X = 17..14): 2Hz ("00")
    -- Rodadas 5 a 9  (X = 13..9):  3Hz ("01")
    -- Rodadas 10 a 14 (X = 8..4):  4Hz ("10")
    -- Rodadas 15 a 18 (X = 3..0):  5Hz ("11")
    SPEED_MUX <= "00" when (unsigned(X) >= 14 and unsigned(X) <= 17) else
                 "01" when (unsigned(X) >= 9  and unsigned(X) <= 13) else
                 "10" when (unsigned(X) >= 4  and unsigned(X) <= 8)  else
                 "11";
end circuito;
