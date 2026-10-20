----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/17/2026 09:39:07 PM
-- Design Name: 
-- Module Name: tb_debounce - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_debounce is
--  Port ( );
end tb_debounce;

architecture sim of tb_debounce is
    constant CLOCK_PERIOD_NS : time := 8 ns; 
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal btn_press : std_logic := '0';
    signal o_pulse : std_logic;
begin
clk <= not clk after CLOCK_PERIOD_NS / 2;
-- instantiate debounce
dut : entity work.debounce 
    port map (
        clk => clk,
        reset => reset,
        i_btn => btn_press,
        o_pulse => o_pulse
    );

end sim;
