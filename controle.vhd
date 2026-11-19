library IEEE;
use IEEE.Std_Logic_1164.all;

entity controle is
    port (
        end_money, end_round           : in  std_logic;
        enter_end, enter, reset, clk   : in  std_logic; -- sinais do ButtonSync ativos em '1'
        R1, R2, E1, E2, E3, E4, E5, E6 : out std_logic
    );
end controle;

architecture arqc of controle is
    type STATES is (
        START,
        SETUP,
        PLAY0,
        PLAY1,
        PLAY2,
        COUNT_ROUND,
        CHECK_UEIT,
        RESET_SEQ,
        RESULT
    );
    signal EA : STATES := START;
    signal PE : STATES := START;
begin
    -- Registrador de estado (reset sincrono ativo em '1' gerado pelo ButtonSync)
    process(clk)
    begin
        if (clk'event and clk = '1') then
            if reset = '1' then
                EA <= START;
            else
                EA <= PE;
            end if;
        end if;
    end process;

    -- Logica de proximo estado e saidas de controle (Moore)
    process(EA, enter, enter_end, end_money, end_round)
    begin
        -- Valores padrao para evitar latches
        R1 <= '0';
        R2 <= '0';
        E1 <= '0';
        E2 <= '0';
        E3 <= '0';
        E4 <= '0';
        E5 <= '0';
        E6 <= '0';
        PE <= EA;

        case EA is
            when START =>
                R1 <= '1';
                R2 <= '1';
                PE <= SETUP;

            when SETUP =>
                E1 <= '1';
                if enter = '1' then
                    PE <= PLAY0;
                else
                    PE <= SETUP;
                end if;

            when PLAY0 =>
                E2 <= '1';
                E3 <= '1';
                E4 <= '1';
                if enter = '1' then
                    PE <= PLAY1;
                else
                    PE <= PLAY0;
                end if;

            when PLAY1 =>
                E3 <= '1';
                E4 <= '1';
                if enter = '1' then
                    PE <= PLAY2;
                else
                    PE <= PLAY1;
                end if;

            when PLAY2 =>
                E4 <= '1';
                if enter = '1' then
                    PE <= COUNT_ROUND;
                else
                    PE <= PLAY2;
                end if;

            when COUNT_ROUND =>
                E5 <= '1';
                PE <= CHECK_UEIT;

            when CHECK_UEIT =>
                if (end_round = '1' or end_money = '1' or enter_end = '1') then
                    PE <= RESULT;
                elsif enter = '1' then
                    PE <= RESET_SEQ;
                else
                    PE <= CHECK_UEIT;
                end if;

            when RESET_SEQ =>
                R2 <= '1';
                PE <= PLAY0;

            when RESULT =>
                E6 <= '1';
                if enter = '1' then
                    PE <= START;
                else
                    PE <= RESULT;
                end if;
        end case;
    end process;
end arqc;
