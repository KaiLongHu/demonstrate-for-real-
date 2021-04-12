//轮询控制
module switch_ctrl(
input 	clk,//时钟100M
input 	reset_n,//复位，低电平有效
input 	flag,//启动flag，高电平有效
input [7:0] data_out,//AD量化值输出，取高8位
output [5:0] addr,//地址			

input	  rdreq,//读使能
output  empty,//空
output  full,//满
output	[7:0]  q//读数据				
);

//轮询间隔时间和次数可以设置

parameter delay_time=32'd5_00_000;//time=delay_time*10ns,5_00_000= 5ms
parameter cycle_times=8'd8;


reg [7:0] times=8'd0;//轮询次数
reg [31:0] delay_cnt=32'd0;//间隔时间计数
reg [5:0] address=5'd0;

assign addr=address;

reg [4:0] state=5'd0;
parameter s_idle=5'd0;
parameter s_start=5'd1;
parameter s_delay=5'd2;
parameter s_getAD=5'd3;
parameter s_next=5'd4;
parameter s_end=5'd5;
parameter s_wr_0d=5'd6;
parameter s_wr_0a=5'd7;
parameter s_addressadd=5'd8;



always@(posedge clk or negedge reset_n)
	if(reset_n==0)//复位，低电平有效
		state<=s_idle;
	else
		case(state)
			s_idle:
				if(flag==0)//启动flag //
					state<=s_start;
				else  
					state<=s_idle;
					
			s_start://开始轮询
				state<=s_delay;//延迟
				
			s_delay:
				if(delay_cnt>=delay_time)//延迟
					state<=s_getAD;
				else
					state<=s_delay;//延迟
					
			s_getAD://取AD值
				if(address==5'd31 && times>=cycle_times)
					state<=s_end;
					else
					state<=s_next;
					
			s_next://轮询下一地址
				if(address==5'd31&& times<cycle_times)//如果cycle大于1要不地址重置0
				state<=s_addressadd;//地址重置0
				else
				state<=s_start;
				
			s_addressadd:
				state<=s_start;
				
				
	
			s_end:
				state<=s_wr_0d;//写0d
			s_wr_0d:
				state<=s_wr_0a;//写0a
			s_wr_0a:
				state<=s_idle;
			default:;
		endcase
				
//间隔时间计数					
always@(posedge clk or negedge reset_n)
	if(reset_n==0)//复位，低电平有效
		delay_cnt<=32'd0;
	else				
		if(state==s_delay)		
			delay_cnt<=delay_cnt+1;
		else
			delay_cnt<=32'd0;

reg AD_wr_en=0;
reg [7:0] FIFO_data;
always@(posedge clk or negedge reset_n)
	if(reset_n==0)begin//复位，低电平有效
		AD_wr_en<=0;
		FIFO_data<=8'd0;
		end
	else				
		if(state==s_getAD)begin
			AD_wr_en<=1;//AD fifo写使能
			FIFO_data<=data_out;//data_out
			end
		else if(state==s_wr_0d)begin//写0d
			AD_wr_en<=1;//AD fifo写使能
			FIFO_data<=8'h0d;//
			end
		else if(state==s_wr_0a)begin//写0a
			AD_wr_en<=1;//AD fifo写使能
			FIFO_data<=8'h0a;//
			end
		else
			AD_wr_en<=0;
			
always@(posedge clk or negedge reset_n)
	if(reset_n==0)//复位，低电平有效
		address<=5'd0;
	else				
		if(state==s_next)		
			address<=address+5'd1;//地址累加
		else 
			if(state==s_addressadd)
			address<=32'd0;
			else 
			address<=address;
			
always@(posedge clk or negedge reset_n)
	if(reset_n==0)//复位，低电平有效
		times<=8'd0;
	else				
//		if(state==s_start && address==5'd31)		
if(state==s_start&& address==5'd25 )
			times<=times+8'd1;//轮询次数累加
		else
			if(state==s_idle)
				times<=8'd0;
			else 
				times<=times;				
			
//FIFO 8bit 4096深度		

wire [15:0] usedw;	
AD_FIFO	AD_FIFO_i (
	.clock ( clk ),
	.data ( FIFO_data ),
	.rdreq ( rdreq ),
	.wrreq ( AD_wr_en ),
	.empty ( empty ),
	.full ( full ),
	.q ( q ),
	.usedw ( usedw )
	);			
			
//0d 0a

		
endmodule
