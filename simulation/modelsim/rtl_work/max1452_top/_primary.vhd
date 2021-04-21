library verilog;
use verilog.vl_types.all;
entity max1452_top is
    generic(
        casenum         : vl_logic_vector(0 to 4) := (Hi1, Hi1, Hi0, Hi0, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        rs_tx           : out    vl_logic;
        unlock          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of casenum : constant is 1;
end max1452_top;
