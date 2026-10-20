
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    generic (
        CLOCK_HZ : positive := 125_000_000
    );
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        i_btn   : in  std_logic;
        o_pulse : out std_logic
    );
end entity debounce;

architecture Behavioral of debounce is

    constant DEBOUNCE_CYCLECOUNT : positive :=
        CLOCK_HZ / 100; -- 10 ms

    signal r_btn_meta : std_logic := '0';
    signal r_btn_sync : std_logic := '0';

    signal r_pulse : std_logic := '0';

    signal r_debounce_counter : natural range
        0 to DEBOUNCE_CYCLECOUNT := 0;

    type debouncer_state is (
        IDLE,
        COUNTING_PRESS,
        PRESSED,
        COUNTING_RELEASE
    );

    signal state : debouncer_state := IDLE;

    -- Vivado synchronizer placement hint
    attribute ASYNC_REG : string;
    attribute ASYNC_REG of r_btn_meta : signal is "TRUE";
    attribute ASYNC_REG of r_btn_sync : signal is "TRUE";

begin

    o_pulse <= r_pulse;

    process(clk)
    begin
        if rising_edge(clk) then

            if reset = '1' then
                r_btn_meta <= '0';
                r_btn_sync <= '0';
                r_pulse <= '0';
                r_debounce_counter <= 0;
                state <= IDLE;

            else
                -- Synchronize asynchronous button
                r_btn_meta <= i_btn;
                r_btn_sync <= r_btn_meta;

                -- Default: pulse is low
                r_pulse <= '0';

                case state is

                    when IDLE =>
                        r_debounce_counter <= 0;

                        if r_btn_sync = '1' then
                            state <= COUNTING_PRESS;
                            r_debounce_counter <= 1;
                        end if;

                    when COUNTING_PRESS =>
                        if r_btn_sync = '0' then
                            state <= IDLE;
                            r_debounce_counter <= 0;

                        elsif r_debounce_counter = DEBOUNCE_CYCLECOUNT then
                            state <= PRESSED;
                            r_pulse <= '1';
                            r_debounce_counter <= 0;

                        else
                            r_debounce_counter <=
                                r_debounce_counter + 1;
                        end if;

                    when PRESSED =>
                        if r_btn_sync = '0' then
                            state <= COUNTING_RELEASE;
                            r_debounce_counter <= 1;
                        end if;
                    when COUNTING_RELEASE =>
                        if r_btn_sync = '1' then
                            -- Release was not stable
                            state <= PRESSED;
                            r_debounce_counter <= 0;

                        elsif r_debounce_counter =
                              DEBOUNCE_CYCLECOUNT then
                            -- Valid release: rearm button
                            state <= IDLE;
                            r_debounce_counter <= 0;

                        else
                            r_debounce_counter <=
                                r_debounce_counter + 1;
                        end if;

                end case;
            end if;
        end if;
    end process;
end architecture Behavioral;
