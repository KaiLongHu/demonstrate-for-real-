//轮询控制
module switch_ctrl(
input 	clk,//时钟50M
input 	reset_n,//复位，低电平有效
input 	flag,//启动flag，高电平有效
input [7:0] data_out,//AD量化值输出，取高8位
output [4:0] addr,//地址			

input	  rdreq,//读使能
output  empty,//空
output  full,//满
output	[7:0]  q//读数据				
);

//轮询间隔时间和次数可以设置
//parameter delay_time=32'd5_000_000;//time=delay_time*20ns

parameter 	delay_time	=	32'd5_00_000;//time=delay_time*20ns
parameter 	cycle_times	=	8'd2;//轮询cycle_times次
parameter 	addressnum	=	5'd20;//address total number
	
	
reg [31:0]	delay_cnt	=	32'd0;	//间隔时间计数	
reg [7:0] 	cyc_cnt		=	8'd0;		//轮询次数
reg [5:0] 	addr_cnt	=	6'd0;		//地址
reg [1:0]	flag_j1		=	1'd0;		//jugde1的标识
reg [3:0]	NS,CS;	


assign addr=addr_cnt;

localparam [3:0]
	IDLE		=	4'd0,	//IDLE
	s_start		=	4'd1,	//收到FLAG后启动
	s_delay		=	4'd2,	//延迟
	s_getAD		=	4'd3,	//获得AD值
	s_addrpp	=	4'd4,	//地址累加
	s_cyclepp	=	4'd5,	//判断cycle是否累加
	
	s_judge1w	=	4'd6,	//给一个judgefalg运算缓冲
	s_judge1	=	4'd7,	//判断当前循环是否进行完毕,是去下一cycle 还是end
	s_nextcyc	=	4'd8,	//进入下一cycle,addr清0
	s_endflag	=	4'd9,	//确定cycle都执行完毕
	s_nextaddr	=	4'd10,	//还在cycle内采样下一addr
	
	s_wr0d		=	4'd11,	//写0d
	s_wr0a		=	4'd12,	//写0a,无论还有没有剩余cycle都发送已完成cycle的内容
	s_judge2	=	4'd13;	//根据endflag判断是否还有下一cycle
	
	// s_end 		=	4'd13;	//end 所有内容清0
	



//1ST
always	@(posedge clk or negedge reset_n)
	if(!reset_n)
		CS=IDLE;
	else
		CS=NS;
	
//2ST
always	@(posedge clk or negedge reset_n)
	begin 
	NS=4'dx;
	case(CS)
	IDLE://IDLE
		if(flag==0)//启动采样
			NS=s_start;
		else
			NS=IDLE;
			
			
	s_start://收到FLAG后启动
		NS=s_delay;	
		
	s_delay://延迟
		NS=s_getAD;
	
	s_getAD://获得AD值
		NS=s_addrpp;
	
	s_addrpp://地址累加
		NS=s_cyclepp;

	s_cyclepp://判断cycle是否累加
		NS=s_judge1;			
				
	s_judge1w://给一个judgefalg运算缓冲
		NS=s_judge1;
			
	s_judge1:	//判断当前循环是否进行完毕,是去下一cycle 还是end
				begin
		if(flag_j1==2'd1)//循环内
			NS=s_nextaddr;
		else if(flag_j1==2'd2)//本循环完成下一循环
			NS=s_nextcyc;
		else if(flag_j1==2'd3)//所有循环结束
			NS=s_endflag;
				end 
	
	s_nextaddr://还在cycle内采样下一addr
		NS=s_delay;
	
	s_nextcyc://进入下一cycle,addr清0
		NS=s_wr0d;
	
	s_endflag://确定cycle都执行完毕
		NS=s_wr0d;
			
	s_wr0d://写0d
		NS=s_wr0a;
		
	s_wr0a://写0a,无论还有没有剩余cycle都发送已完成cycle的内容
		NS=s_judge2;
	
	s_judge2://根据endflag判断是否还有下一cycle
			begin
		if(flag_j1==2'd3)//所有循环结束
			NS=IDLE;
		else 
			NS=s_delay;
			end 

	endcase
	end 


//各种功能模块
//delay_time*******************************************************
always@(posedge clk or negedge reset_n)
	case(CS)
		IDLE:
			delay_cnt	<=	32'd0;					
		s_delay:	
			delay_cnt	<=	delay_cnt+32'd1;
		default:
			delay_cnt	<=	32'd0;				
	endcase

//cyc_cnt*********************************************************
always@(posedge clk or negedge reset_n)begin
	case(CS)
		IDLE:
			cyc_cnt	<=	8'd0;
		//在s_cyclepp状态下的addr要比已经ADget完成的地址大1	
		//所以如果addr_cnt-addressnum=1就说明cyc采完了
		s_cyclepp:	begin								
			if(addr_cnt>addressnum)
				cyc_cnt	<=	cyc_cnt+8'd1;
			else 
				cyc_cnt	<=	cyc_cnt;
						end
	endcase
	end

//addr_cnt*************************************************************
always@(posedge clk or negedge reset_n)
	case(CS)
		IDLE:
			addr_cnt	<=	5'd0;
		s_addrpp:
			addr_cnt	<=	addr_cnt	+	5'd1;
		s_nextcyc:
			addr_cnt	<=	5'd0;
		default:
			addr_cnt	<=	5'd0;
	endcase
	
//flag_j1*************************************************************
always@(posedge clk or negedge reset_n)
	case(CS)
		IDLE:
			flag_j1	<=	2'd0;
		s_judge1:begin
			if(addr_cnt<=addressnum )
				flag_j1	<=	2'd1;
			else if (addr_cnt>addressnum	&& cyc_cnt<cycle_times)
				flag_j1	<=	2'd2;
			else if (addr_cnt>addressnum	&& cyc_cnt>=cycle_times)
				flag_j1	<=	2'd3;
				end 
		default:
			flag_j1	<=	flag_j1;
	endcase


//FIFO模块*************************************************************
reg AD_wr_en=0;
reg [7:0] FIFO_data;
always@(posedge clk or negedge reset_n)
	if(reset_n==0)begin//复位，低电平有效
		AD_wr_en<=0;
		FIFO_data<=8'd0;
		end
	else				
		if(CS==s_getAD)begin
			AD_wr_en<=1;//AD fifo写使能
			FIFO_data<=data_out;//data_out
			end
		else if(CS==s_wr0d)begin//写0d
			AD_wr_en<=1;//AD fifo写使能
			FIFO_data<=8'h0d;//
			end
		else if(CS==s_wr0a)begin//写0a
			AD_wr_en<=1;//AD fifo写使能
			FIFO_data<=8'h0a;//
			end
		else
			AD_wr_en<=0;

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




endmodule