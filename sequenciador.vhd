library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.numeric_std.all;

entity sequenciador is
    port (
        Rst   : in  std_logic;
        E     : in  std_logic;
        SPEED : in  std_logic;
        Q     : out std_logic_vector(3 downto 0)
    );
end sequenciador;

architecture behv of sequenciador is
    signal cnt : unsigned(3 downto 0) := (others => '0');
begin
    -- Reset assincrono para garantir reset imediato nos estados Init e Reset_Seq (1 ciclo de CLK)
    process(SPEED, Rst)
    begin
        if Rst = '1' then
            cnt <= (others => '0');
        elsif (SPEED'event and SPEED = '1') then
            if E = '1' then
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    Q <= std_logic_vector(cnt);
end behv;
