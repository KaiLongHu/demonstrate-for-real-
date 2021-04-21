library verilog;
use verilog.vl_types.all;
entity switch_ctrl is
    generic(
        delay_time      : integer := 500000;
        cycle_times     : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0);
        s_idle          : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0);
        s_start         : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi1);
        s_delay         : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi0);
        s_getAD         : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi1);
        s_next          : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi0);
        s_end           : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi1);
        s_wr_0d         : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi0);
        s_wr_0a         : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        flag            : in     vl_logic;
        data_out        : in     vl_logic_vector(7 downto 0);
        addr            : out    vl_logic_vector(4 downto 0);
        rdreq           : in     vl_logic;
        empty           : out    vl_logic;
        full            : out    vl_logic;
        q               : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of delay_time : constant is 1;
    attribute mti_svvh_generic_type of cycle_times : constant is 1;
    attribute mti_svvh_generic_type of s_idle : constant is 1;
    attribute mti_svvh_generic_type of s_start : constant is 1;
    attribute mti_svvh_generic_type of s_delay : constant is 1;
    attribute mti_svvh_generic_type of s_getAD : constant is 1;
    attribute mti_svvh_generic_type of s_next : constant is 1;
    attribute mti_svvh_generic_type of s_end : constant is 1;
    attribute mti_svvh_generic_type of s_wr_0d : constant is 1;
    attribute mti_svvh_generic_type of s_wr_0a : constant is 1;
end switch_ctrl;
