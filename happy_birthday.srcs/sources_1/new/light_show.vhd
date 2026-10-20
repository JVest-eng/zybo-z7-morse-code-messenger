----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2026 05:47:06 PM
-- Design Name: 
-- Module Name: light_show - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.02 - FILE
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity light_show is
    generic (
        CLOCK_HZ : integer := 125_000_000 --hz
    );
    port ( 
        clk : in std_logic;
        tick : in std_logic;
        reset : in std_logic;
        start : in std_logic;
        busy : out std_logic;
        led : out std_logic
    );
end light_show;

architecture rtl of light_show is
    constant MESSAGE : std_logic_vector(0 to 225) :=
        "0000000" &
        "1010101"           & "000" & -- H
        "1"                 & "000" & -- E
        "101110101"         & "000" & -- L
        "101110101"         & "000" & -- L
        "11101110111"       & "000" & -- O
        "1110101110101110111" & "0000000" & -- !
        "1010101"           & "000" & -- H
        "10111"             & "000" & -- A
        "10111011101"       & "000" & -- P
        "10111011101"       & "000" & -- P
        "1110101110111"     & "0000000" & -- Y
        "111010101"         & "000" & -- B
        "101"               & "000" & -- I
        "1011101"           & "000" & -- R
        "111"               & "000" & -- T
        "1010101"           & "000" & -- H
        "1110101"           & "000" & -- D
        "10111"             & "000" & -- A
        "1110101110111";                -- Y

    type player_state_t is (IDLE, PLAYING);
    signal state : player_state_t := IDLE;
    signal message_indexer : natural range 0 to MESSAGE'length - 1 := 0; --indexer
    signal r_led : std_logic := '0';
begin
    led <= r_led;
    busy <= '1' when state = PLAYING else '0';
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                message_indexer <= 0;
                state <= IDLE;
                r_led <= '0';
            else
                --evaluate state
                case state is
                    when PLAYING =>
                        if tick = '1' then
                            if message_indexer = MESSAGE'high then
                                state <= IDLE;
                                r_led <= '0';
                            else
                                r_led <= MESSAGE(message_indexer + 1);
                                message_indexer <= message_indexer + 1;
                            end if;
                        end if;
                    when others => --since binary state, all other states are equal to IDLE behavior.
                        r_led <= '0'; --send off signal to not latch.
                        message_indexer <= 0;
                        if start = '1' then
                            state <= PLAYING; -- next cycle.
                            r_led <= MESSAGE(0);
                        end if;
                end case;
            end if;
        end if;
    end process;

end architecture rtl;
