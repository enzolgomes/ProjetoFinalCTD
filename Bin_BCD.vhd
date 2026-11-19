library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Bin_BCD is
    port (
        BIN : in  std_logic_vector(25 downto 0);
        BCD : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of Bin_BCD is
begin

    process(BIN)
        variable temp : unsigned(31 downto 0);
    begin

        temp := (others => '0');

        for i in 25 downto 0 loop

            for j in 0 to 7 loop
                if temp(4*j+3 downto 4*j) >= 5 then
                    temp(4*j+3 downto 4*j) :=
                        temp(4*j+3 downto 4*j) + 3;
                end if;
            end loop;

            temp := shift_left(temp, 1);
            temp(0) := BIN(i);

        end loop;

        BCD <= std_logic_vector(temp);

    end process;

end architecture;