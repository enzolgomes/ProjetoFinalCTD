library IEEE;
use IEEE.Std_Logic_1164.all;

entity usertop is 
port(--CLOCK_50: in std_logic; -- usar placa DE2
	  CLK_500Hz: in std_logic; --usar no emulador
	  KEY: in std_logic_vector(3 downto 0);
	  SW:in std_logic_vector(17 downto 0);
	  HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7: out std_logic_vector(6 downto 0);
	  LEDR:out std_logic_vector(17 downto 0)
);
end usertop;

architecture arqu of usertop is 

 
component controle is 
	port(end_money, end_round: in std_logic;
		enter_end, enter, reset,clk: in std_logic;
		R1, R2, E1, E2, E3, E4, E5, E6: out std_logic);
	end component;
	
component datapath is 
port(SW: in std_logic_vector(17 downto 0);
	clk, R1, R2, E1, E2, E3, E4, E5, E6: in std_logic;
	LEDR: out std_logic_vector(17 downto 0);
	HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7: out std_logic_vector(6 downto 0);
	end_money, end_round: out std_logic
);
end component;

component ButtonSync is 
port(
    KEY0, KEY1, KEY3, CLK: in  std_logic;
    enter_end, enter, reset : out std_logic
);
end component;

-------------------------SINAIS--------------------------------------
signal R1, R2, E1, E2, E3, E4, E5, E6, end_money, end_round: std_logic;
signal enter_end, enter, reset: std_logic;

begin 
BSYNC: ButtonSync port map(KEY(0),KEY(1), KEY(3), CLK_500Hz,enter_end, enter, reset);
ctrl: controle port map(end_money, end_round, enter_end, enter, reset, CLK_500Hz,R1, R2, E1, E2, E3, E4, E5, E6);
datph: datapath port map(SW(17 downto 0),CLK_500Hz,R1, R2, E1, E2, E3, E4, E5, E6,LEDR(17 downto 0),HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, end_money, end_round);

end arqu;