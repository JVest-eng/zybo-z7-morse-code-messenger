
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_light_show is
end entity;

architecture sim of tb_light_show is

    constant CLK_PERIOD : time := 8 ns;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';
    signal start : std_logic := '0';
    signal tick  : std_logic := '0';
    signal busy  : std_logic;
    signal led   : std_logic;

begin

    -- 125 MHz clock
    clk <= not clk after CLK_PERIOD / 2;

    -- Device Under Test
    dut : entity work.light_show
        port map (
            clk   => clk,
            reset => reset,
            start => start,
            tick  => tick,
            busy  => busy,
            led   => led
        );

    stimulus : process

        constant FIRST_H : std_logic_vector(0 to 6)
            := "1010101";

        procedure advance_one_unit is
        begin
            wait until falling_edge(clk);
            tick <= '1';

            wait until rising_edge(clk);
            wait for 1 ns;

            wait until falling_edge(clk);
            tick <= '0';
        end procedure;

    begin

        -- Test 1: Reset
        reset <= '1';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert (busy = '0' and led = '0')
            report "FAIL: Reset"
            severity error;

        wait until falling_edge(clk);
        reset <= '0';

        -- Test 2: Start playback
        wait until falling_edge(clk);
        start <= '1';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert (busy = '1' and led = '1')
            report "FAIL: Start"
            severity error;

        wait until falling_edge(clk);
        start <= '0';

        -- Test 3: Verify first letter H
        for i in 1 to 6 loop
            advance_one_unit;

            assert (led = FIRST_H(i) and busy = '1')
                report "FAIL: H bit " & integer'image(i)
                severity error;
        end loop;

        -- Test 4: Complete first message
        for i in 7 to 218 loop
            advance_one_unit;
        end loop;

        assert busy = '1'
            report "FAIL: Playback ended early"
            severity error;

        advance_one_unit;

        assert (busy = '0' and led = '0')
            report "FAIL: First playback completion"
            severity error;

        -- Test 5: Start second playback
        wait until falling_edge(clk);
        start <= '1';

        wait until rising_edge(clk);
        wait for 1 ns;

        assert (busy = '1' and led = '1')
            report "FAIL: Restart"
            severity error;

        wait until falling_edge(clk);
        start <= '0';

        -- Complete second message
        for i in 1 to 219 loop
            advance_one_unit;
        end loop;

        assert (busy = '0' and led = '0')
            report "FAIL: Second playback completion"
            severity error;

        report "PASS: Both playbacks completed"
            severity note;

        std.env.stop;
        wait;

    end process;

end architecture sim;
