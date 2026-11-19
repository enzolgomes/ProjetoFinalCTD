library ieee;
use ieee.std_logic_1164.all; 

entity ButtonSync is 
port(
    KEY0, KEY1, KEY3, CLK: in  std_logic;
    enter_end, enter, reset : out std_logic
);
end ButtonSync;

architecture ButtonSyncImpl of ButtonSync is

    type STATES is (EsperaApertar, SaidaAtiva, EsperaSoltar);
    
    -- Sinais de estado independentes para cada botão
    signal Reset_state, Reset_next       : STATES := EsperaApertar;
    signal Enter_state, Enter_next       : STATES := EsperaApertar;
    signal EnterEnd_state, EnterEnd_next : STATES := EsperaApertar;

begin

    -- Registrador síncrono (Clock) para atualizar todos os estados
    process (CLK) 
    begin
        if rising_edge(CLK) then
            Reset_state    <= Reset_next;
            Enter_state    <= Enter_next;
            EnterEnd_state <= EnterEnd_next;
        end if;
    end process;
    
    -- FSM para KEY0 (Reset)
    process (Reset_state, KEY0)
    begin
        case Reset_state is
            when EsperaApertar =>
                if KEY0 = '0' then Reset_next <= SaidaAtiva;
                else Reset_next <= EsperaApertar;
                end if;
                reset <= '0';
            when SaidaAtiva =>
                if KEY0 = '0' then Reset_next <= EsperaSoltar;
                else Reset_next <= EsperaApertar;
                end if;   
                reset <= '1';
            when EsperaSoltar =>
                if KEY0 = '0' then Reset_next <= EsperaSoltar;
                else Reset_next <= EsperaApertar;
                end if;   
                reset <= '0';
        end case;         
    end process;
    
    -- FSM para KEY1 (Enter)
    process (Enter_state, KEY1)
    begin
        case Enter_state is
            when EsperaApertar =>
                if KEY1 = '0' then Enter_next <= SaidaAtiva; else Enter_next <= EsperaApertar; end if;
                enter <= '0';
            when SaidaAtiva =>
                if KEY1 = '0' then Enter_next <= EsperaSoltar; else Enter_next <= EsperaApertar; end if;   
                enter <= '1';
            when EsperaSoltar =>
                if KEY1 = '0' then Enter_next <= EsperaSoltar; else Enter_next <= EsperaApertar; end if;   
                enter <= '0';
        end case;         
    end process;
    
    -- FSM para KEY3 (Enter_End)
    process (EnterEnd_state, KEY3)
    begin
        case EnterEnd_state is
            when EsperaApertar =>
                if KEY3 = '0' then EnterEnd_next <= SaidaAtiva; else EnterEnd_next <= EsperaApertar; end if;
                enter_end <= '0';
            when SaidaAtiva =>
                if KEY3 = '0' then EnterEnd_next <= EsperaSoltar; else EnterEnd_next <= EsperaApertar; end if;   
                enter_end <= '1';
            when EsperaSoltar =>
                if KEY3 = '0' then EnterEnd_next <= EsperaSoltar; else EnterEnd_next <= EsperaApertar; end if;   
                enter_end <= '0';
        end case;         
    end process;

end ButtonSyncImpl;