library IEEE;
use IEEE.Std_Logic_1164.all;

entity datapath is
    port (
        SW                                             : in  std_logic_vector(17 downto 0);
        clk, R1, R2, E1, E2, E3, E4, E5, E6            : in  std_logic;
        LEDR                                           : out std_logic_vector(17 downto 0);
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 : out std_logic_vector(6 downto 0);
        end_money, end_round                           : out std_logic
    );
end datapath;

architecture arqdtp of datapath is
    -- Sinais internos do datapath
    signal CLK_2Hz, CLK_3Hz, CLK_4Hz, CLK_5Hz : std_logic;
    signal SPEED_MUX : std_logic_vector(1 downto 0);
    signal SPEED     : std_logic;

    signal X         : std_logic_vector(4 downto 0);
    signal E_round   : std_logic;

    signal INIT_MONEY : std_logic_vector(11 downto 0);
    signal Rst_seq    : std_logic;
    signal SEQ0, SEQ1, SEQ2 : std_logic_vector(3 downto 0);
    signal SEQ_ALL    : std_logic_vector(11 downto 0);

    signal DECOD_OUT  : std_logic_vector(26 downto 0);
    signal Doubling   : std_logic;
    signal PRIZE_OUT  : std_logic_vector(25 downto 0);
    signal SEL_PRIZE  : std_logic;
    signal PRIZE      : std_logic_vector(25 downto 0);
    signal BIN_MONEY  : std_logic_vector(25 downto 0);
    signal BIN_BCD_IN : std_logic_vector(25 downto 0);
    signal MONEY      : std_logic_vector(31 downto 0);

    signal SEL_MUX    : std_logic;
    signal DEC_M0, DEC_M1, DEC_M2, DEC_M3 : std_logic_vector(6 downto 0);
    signal DEC_M4, DEC_M5, DEC_M6, DEC_M7 : std_logic_vector(6 downto 0);
    signal DEC_S0, DEC_S1, DEC_S2         : std_logic_vector(6 downto 0);

    constant ZERO_26   : std_logic_vector(25 downto 0) := (others => '0');
    constant BLANK_HEX : std_logic_vector(6 downto 0)  := "1111111";

    -- Declaracao dos componentes (blocos do professor + modulos reutilizaveis)
    component Div_Freq is -- Para emulador (CLK_500Hz)
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            CLK_2Hz : out std_logic;
            CLK_3Hz : out std_logic;
            CLK_4Hz : out std_logic;
            CLK_5Hz : out std_logic
        );
    end component;

    component Div_Freq_DE2 is -- Para placa DE2 (CLOCK_50)
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            CLK_2Hz : out std_logic;
            CLK_3Hz : out std_logic;
            CLK_4Hz : out std_logic;
            CLK_5Hz : out std_logic
        );
    end component;

    component mux4x1 is
        port (
            sel : in  std_logic_vector(1 downto 0);
            F1  : in  std_logic;
            F2  : in  std_logic;
            F3  : in  std_logic;
            F4  : in  std_logic;
            F   : out std_logic
        );
    end component;

    component mux2x1 is
        generic (
            N : integer := 7
        );
        port (
            sel : in  std_logic;
            F1  : in  std_logic_vector(N - 1 downto 0);
            F2  : in  std_logic_vector(N - 1 downto 0);
            F   : out std_logic_vector(N - 1 downto 0)
        );
    end component;

    component selector is
        port (
            X         : in  std_logic_vector(4 downto 0);
            SPEED_MUX : out std_logic_vector(1 downto 0)
        );
    end component;

    component decoder_termometrico is
        port (
            X    : in  std_logic_vector(4 downto 0);
            LEDR : out std_logic_vector(17 downto 0)
        );
    end component;

    component registrador is
        port (
            CLK : in  std_logic;
            R   : in  std_logic;
            E   : in  std_logic;
            D   : in  std_logic_vector(11 downto 0);
            Q   : out std_logic_vector(11 downto 0)
        );
    end component;

    component counter_round is
        port (
            CLK : in  std_logic;
            Set : in  std_logic;
            E   : in  std_logic;
            X   : out std_logic_vector(4 downto 0);
            tc  : out std_logic
        );
    end component;

    component counter_prize is
        port (
            CLK        : in  std_logic;
            Set        : in  std_logic;
            E          : in  std_logic;
            INIT_MONEY : in  std_logic_vector(11 downto 0);
            PRIZE      : in  std_logic_vector(25 downto 0);
            BIN_MONEY  : out std_logic_vector(25 downto 0)
        );
    end component;

    component decod_prize is
        port (
            seq_12bits : in  std_logic_vector(11 downto 0);
            prize      : out std_logic_vector(26 downto 0)
        );
    end component;

    component Bin_BCD is
        port (
            BIN : in  std_logic_vector(25 downto 0);
            BCD : out std_logic_vector(31 downto 0)
        );
    end component;

    component sequenciador is
        port (
            Rst   : in  std_logic;
            E     : in  std_logic;
            SPEED : in  std_logic;
            Q     : out std_logic_vector(3 downto 0)
        );
    end component;

    component dec7seg is
        port (
            C : in  std_logic_vector(3 downto 0);
            F : out std_logic_vector(6 downto 0)
        );
    end component;

begin
    -- =========================================================================
    -- Divisor de frequencia:
    -- Para emulador online (CLK_500Hz em usertop.vhd): usar Div_Freq
    -- Para placa DE2 (CLOCK_50 em usertop.vhd): comentar Div_Freq e descomentar Div_Freq_DE2
    -- =========================================================================
    -- DIV_FREQ_EMU : Div_Freq
    --     port map (
    --         clk     => clk,
    --         reset   => R1,
    --         CLK_2Hz => CLK_2Hz,
    --         CLK_3Hz => CLK_3Hz,
    --         CLK_4Hz => CLK_4Hz,
    --         CLK_5Hz => CLK_5Hz
    --     );

    DIVFREQ : Div_Freq_DE2
        port map (
            clk     => clk,
            reset   => R1,
            CLK_2Hz => CLK_2Hz,
            CLK_3Hz => CLK_3Hz,
            CLK_4Hz => CLK_4Hz,
            CLK_5Hz => CLK_5Hz
        );

    -- Selecao de velocidade conforme rodada atual
    U_SELECTOR : selector
        port map (
            X         => X,
            SPEED_MUX => SPEED_MUX
        );

    U_MUX_SPEED : mux4x1
        port map (
            sel => SPEED_MUX,
            F1  => CLK_2Hz,
            F2  => CLK_3Hz,
            F3  => CLK_4Hz,
            F4  => CLK_5Hz,
            F   => SPEED
        );

    -- Registrador da aposta inicial
    U_REG : registrador
        port map (
            CLK => clk,
            R   => R2,
            E   => E1,
            D   => SW(11 downto 0),
            Q   => INIT_MONEY
        );

    -- Contador regressivo de rodadas e decodificador termometrico para LEDR(17..0)
    E_round <= E5 or (CLK_2Hz and E6);

    U_COUNTER_ROUND : counter_round
        port map (
            CLK => clk,
            Set => R1,
            E   => E_round,
            X   => X,
            tc  => end_round
        );

    U_DECODER_TERMO : decoder_termometrico
        port map (
            X    => X,
            LEDR => LEDR
        );

    -- Sequenciadores SEQ0, SEQ1 e SEQ2
    Rst_seq <= R1 or R2;

    U_SEQ0 : sequenciador
        port map (
            Rst   => Rst_seq,
            E     => E2,
            SPEED => SPEED,
            Q     => SEQ0
        );

    U_SEQ1 : sequenciador
        port map (
            Rst   => Rst_seq,
            E     => E3,
            SPEED => SPEED,
            Q     => SEQ1
        );

    U_SEQ2 : sequenciador
        port map (
            Rst   => Rst_seq,
            E     => E4,
            SPEED => SPEED,
            Q     => SEQ2
        );

    -- Decodificacao de premio, selecao de Doubling e acumulador de dinheiro
    SEQ_ALL <= SEQ2 & SEQ1 & SEQ0;

    U_DECOD_PRIZE : decod_prize
        port map (
            seq_12bits => SEQ_ALL,
            prize      => DECOD_OUT
        );

    Doubling  <= DECOD_OUT(26);
    PRIZE_OUT <= DECOD_OUT(25 downto 0);
    SEL_PRIZE <= Doubling and E5;

    U_MUX_PRIZE : mux2x1
        generic map (N => 26)
        port map (
            sel => SEL_PRIZE,
            F1  => PRIZE_OUT,
            F2  => BIN_MONEY,
            F   => PRIZE
        );

    U_COUNTER_PRIZE : counter_prize
        port map (
            CLK        => clk,
            Set        => E1,
            E          => E5,
            INIT_MONEY => INIT_MONEY,
            PRIZE      => PRIZE,
            BIN_MONEY  => BIN_MONEY
        );

    end_money <= BIN_MONEY(25);

    -- Se dinheiro < 0 (BIN_MONEY(25) = '1'), exibe 0 nos displays
    U_MUX_BIN : mux2x1
        generic map (N => 26)
        port map (
            sel => BIN_MONEY(25),
            F1  => BIN_MONEY,
            F2  => ZERO_26,
            F   => BIN_BCD_IN
        );

    U_BIN_BCD : Bin_BCD
        port map (
            BIN => BIN_BCD_IN,
            BCD => MONEY
        );

    -- Decodificadores de 7 segmentos para MONEY(31..0)
    U_DEC_M0 : dec7seg port map (C => MONEY(3 downto 0),   F => DEC_M0);
    U_DEC_M1 : dec7seg port map (C => MONEY(7 downto 4),   F => DEC_M1);
    U_DEC_M2 : dec7seg port map (C => MONEY(11 downto 8),  F => DEC_M2);
    U_DEC_M3 : dec7seg port map (C => MONEY(15 downto 12), F => DEC_M3);
    U_DEC_M4 : dec7seg port map (C => MONEY(19 downto 16), F => DEC_M4);
    U_DEC_M5 : dec7seg port map (C => MONEY(23 downto 20), F => DEC_M5);
    U_DEC_M6 : dec7seg port map (C => MONEY(27 downto 24), F => DEC_M6);
    U_DEC_M7 : dec7seg port map (C => MONEY(31 downto 28), F => DEC_M7);

    -- Decodificadores de 7 segmentos para SEQ0, SEQ1 e SEQ2
    U_DEC_S0 : dec7seg port map (C => SEQ0, F => DEC_S0);
    U_DEC_S1 : dec7seg port map (C => SEQ1, F => DEC_S1);
    U_DEC_S2 : dec7seg port map (C => SEQ2, F => DEC_S2);

    -- Multiplexacao dos displays HEX0..HEX7
    SEL_MUX <= E2 or E3 or E4 or SW(17);

    U_MUX_HEX0 : mux2x1 generic map (N => 7) port map (sel => SEL_MUX, F1 => DEC_M0, F2 => DEC_S0,    F => HEX0);
    U_MUX_HEX1 : mux2x1 generic map (N => 7) port map (sel => SEL_MUX, F1 => DEC_M1, F2 => DEC_S1,    F => HEX1);
    U_MUX_HEX2 : mux2x1 generic map (N => 7) port map (sel => SEL_MUX, F1 => DEC_M2, F2 => DEC_S2,    F => HEX2);
    U_MUX_HEX3 : mux2x1 generic map (N => 7) port map (sel => SEL_MUX, F1 => DEC_M3, F2 => BLANK_HEX, F => HEX3);
    U_MUX_HEX4 : mux2x1 generic map (N => 7) port map (sel => SEL_MUX, F1 => DEC_M4, F2 => BLANK_HEX, F => HEX4);
    U_MUX_HEX5 : mux2x1 generic map (N => 7) port map (sel => SEL_MUX, F1 => DEC_M5, F2 => BLANK_HEX, F => HEX5);
    U_MUX_HEX6 : mux2x1 generic map (N => 7) port map (sel => SEL_MUX, F1 => DEC_M6, F2 => BLANK_HEX, F => HEX6);
    U_MUX_HEX7 : mux2x1 generic map (N => 7) port map (sel => SEL_MUX, F1 => DEC_M7, F2 => BLANK_HEX, F => HEX7);
end arqdtp;
