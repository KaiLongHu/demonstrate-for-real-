library verilog;
use verilog.vl_types.all;
entity switch is
    port(
        clk             : in     vl_logic;
        addr            : in     vl_logic_vector(5 downto 0);
        F1_8ADD_A       : out    vl_logic;
        F1_8ADD_B       : out    vl_logic;
        F1_8ADD_C       : out    vl_logic;
        F2_8ADD_A       : out    vl_logic;
        F2_8ADD_B       : out    vl_logic;
        F2_8ADD_C       : out    vl_logic;
        F3_8ADD_A       : out    vl_logic;
        F3_8ADD_B       : out    vl_logic;
        F3_8ADD_C       : out    vl_logic
    );
end switch;
