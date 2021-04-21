library verilog;
use verilog.vl_types.all;
entity demonstrate is
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        SDO             : in     vl_logic;
        CS_n            : out    vl_logic;
        SCK             : out    vl_logic;
        rs_tx           : out    vl_logic;
        tx_1452         : out    vl_logic;
        flag            : in     vl_logic;
        F1_8ADD_A       : out    vl_logic;
        F1_8ADD_B       : out    vl_logic;
        F1_8ADD_C       : out    vl_logic;
        F2_8ADD_A       : out    vl_logic;
        F2_8ADD_B       : out    vl_logic;
        F2_8ADD_C       : out    vl_logic;
        F3_8ADD_A       : out    vl_logic;
        F3_8ADD_B       : out    vl_logic;
        F3_8ADD_C       : out    vl_logic;
        unlock          : out    vl_logic
    );
end demonstrate;
