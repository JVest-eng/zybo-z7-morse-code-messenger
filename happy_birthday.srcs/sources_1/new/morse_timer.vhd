----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/16/2026 06:29:41 PM
-- Design Name: 
-- Module Name: morse_timer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity morse_timer is -- Tick generator
    Generic (
        CLOCK_HZ : integer := 125_000_000;
        UNIT_MS : positive := 150 -- millisecond definition of duration of a pulse
    );
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           tick : out STD_LOGIC);
end morse_timer;

architecture rtl of morse_timer is
    constant CYCLES_PER_UNIT : positive := (CLOCK_HZ / 1000) * UNIT_MS;
    signal counter : natural range 0 to CYCLES_PER_UNIT - 1 := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            tick <= '0';
            if reset = '1' then
                counter <= 0;
            elsif counter = CYCLES_PER_UNIT - 1 then
                counter <= 0;
                tick <= '1';
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
end architecture rtl;
