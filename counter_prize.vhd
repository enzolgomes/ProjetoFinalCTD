library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.numeric_std.all;

entity counter_prize is
    port (
        CLK        : in  std_logic;
        Set        : in  std_logic;
        E          : in  std_logic;
        INIT_MONEY : in  std_logic_vector(11 downto 0);
        PRIZE      : in  std_logic_vector(25 downto 0);
        BIN_MONEY  : out std_logic_vector(25 downto 0)
    );
end counter_prize;

architecture behv of counter_prize is
    signal money : signed(25 downto 0) := (others => '0');
begin
    process(CLK)
        variable soma : signed(26 downto 0);
    begin
        if (CLK'event and CLK = '1') then
            if Set = '1' then
                money <= signed(resize(unsigned(INIT_MONEY), 26));
            elsif E = '1' then
                soma := resize(money, 27) + resize(signed(PRIZE), 27);
                if soma > to_signed(33554431, 27) then
                    money <= to_signed(33554431, 26);
                elsif soma < to_signed(-33554432, 27) then
                    money <= to_signed(-33554432, 26);
                else
                    money <= resize(soma, 26);
                end if;
            end if;
        end if;
    end process;

    BIN_MONEY <= std_logic_vector(money);
end behv;
