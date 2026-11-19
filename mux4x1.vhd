library IEEE;
use IEEE.Std_Logic_1164.all;

entity mux4x1 is
    port (
        sel : in  std_logic_vector(1 downto 0);
        F1  : in  std_logic;
        F2  : in  std_logic;
        F3  : in  std_logic;
        F4  : in  std_logic;
        F   : out std_logic
    );
end mux4x1;

architecture circuito of mux4x1 is
begin
    F <= F1 when sel = "00" else
         F2 when sel = "01" else
         F3 when sel = "10" else
         F4;
end circuito;
