library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.numeric_std.all;

entity counter_round is
    port (
        CLK : in  std_logic;
        Set : in  std_logic;
        E   : in  std_logic;
        X   : out std_logic_vector(4 downto 0);
        tc  : out std_logic
    );
end counter_round;

architecture behv of counter_round is
    signal cnt    : unsigned(4 downto 0) := to_unsigned(17, 5);
    signal tc_reg : std_logic := '0';
begin
    -- Inicia em 17 (Rodada 1 = 18 LEDs acesos) e decrementa ate 0 (Rodada 18 = 1 LED aceso).
    -- Ao decrementar com cnt = 0 (fim da rodada 18), ativa tc = '1' (end_round) e apaga todos os LEDs (31).
    process(CLK)
    begin
        if (CLK'event and CLK = '1') then
            if Set = '1' then
                cnt    <= to_unsigned(17, 5);
                tc_reg <= '0';
            elsif E = '1' then
                if cnt = 0 or cnt = 31 then
                    cnt    <= to_unsigned(31, 5);
                    tc_reg <= '1';
                else
                    cnt    <= cnt - 1;
                    tc_reg <= '0';
                end if;
            end if;
        end if;
    end process;

    X  <= std_logic_vector(cnt);
    tc <= tc_reg;
end behv;
