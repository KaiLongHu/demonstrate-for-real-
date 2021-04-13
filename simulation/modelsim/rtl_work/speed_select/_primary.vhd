library verilog;
use verilog.vl_types.all;
entity speed_select is
    generic(
        bps9600         : integer := 10416;
        bps9600_2       : integer := 5208
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        clk_bps         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of bps9600 : constant is 1;
    attribute mti_svvh_generic_type of bps9600_2 : constant is 1;
end speed_select;
