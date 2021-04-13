library verilog;
use verilog.vl_types.all;
entity my_uart_tx is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        clk_bps         : in     vl_logic;
        rd_data         : in     vl_logic_vector(7 downto 0);
        rd_en           : out    vl_logic;
        empty           : in     vl_logic;
        rs_tx           : out    vl_logic
    );
end my_uart_tx;
