module max1452_top(
							input clk,
							input rst_n,
							output rs_tx,
							output 	reg   unlock						
							);
							
																										
//----------------------------------------------------
parameter casenum		= 	5'd25;//send data case数量		
//----------------------------------------------------	

//----------------------------------------------------
wire clk_bps;		// clk_bps的高电平为接收或者发送数据位，每个波特周期的中间 
reg[7:0] rd_data=8'h00;	//接收数据寄存器，保存直至下一个数据来到
wire rd_en;	//接收数据有效
reg empty=0; // 全部配置完成以后变为empty

reg [4:0] data_cnt=5'd0;//13个字节		
reg [4:0] unlock_cnt=5'd0;	

//----------------------------------------------------
//波特率选择模块
speed_select		speed_select(	.clk(clk),	
											.rst_n(rst_n),
											.clk_bps(clk_bps)
											);			

											
//发送数据模块
my_uart_tx			my_uart_tx(		.clk(clk),	//发送数据模块
											.rst_n(rst_n),
											.clk_bps(clk_bps),
											.rd_data(rd_data),
											.rd_en(rd_en),
											.empty(empty),
											.rs_tx(rs_tx)
											);
											
//----------------------------------------------------
//发送数据											

						
always@(posedge clk or negedge rst_n)
if(!rst_n)
	data_cnt<=5'd0;
else
	if(rd_en==1)//读使能
		if(data_cnt>= casenum+1)				//读到13就一直停留在13,empty以data_cnt位条件接收完成置1,13=data_cnt最后一个的case+1(12+1=13)
			data_cnt<=	casenum+1;				
		else
			data_cnt<=data_cnt+1;
	else
		data_cnt<=data_cnt;
		
always@(posedge clk or negedge rst_n)
if(!rst_n)
	empty<=0;
else
	if(data_cnt==casenum+1)
			empty<=1;
			
			
//unlock control two different versions	
//----------------------------------------------------

//v1
//----------------------------------------------------
//always@(posedge clk or negedge rst_n)		
//if(!rst_n)
//	unlock=1'b1;
//else if(data_cnt==5'd13)//当发送完成后，data_cnt一直保持在这个位置，把unlock配置为低。
//	unlock=1'b1;//!!!!!!!!!gai le 	
//	else 
//	unlock<=1'b1;

//v2
//----------------------------------------------------
always@(posedge clk or negedge rst_n)	
	unlock	<=	1'b1;

//v3
//----------------------------------------------------
//unlock 比 data多计数一个周期 
//unlock_cnt计数是case数+2(比data_cnt多1个)


//always@(posedge clk or negedge rst_n)
//if(!rst_n)
//	unlock_cnt<=5'd0;
//else
//	if(rd_en==1)
//		if(unlock_cnt>=casenum+2)
//			unlock_cnt<=casenum+2;
//		else 
//			unlock_cnt<=unlock_cnt+1;
//		else	
//			unlock_cnt<=unlock_cnt;
//			
//always@(posedge clk or negedge rst_n)
//if(!rst_n)
//	unlock<=1'b1;
//else 
//	if(unlock_cnt<=casenum+2)
//		unlock<=1'b0;


always@(posedge clk or negedge rst_n)
if(!rst_n)
	rd_data<=8'h00;
else 
//首先擦写CL所在位置第五页EEPROM，因为只有擦除可以配1，写只能写0
//擦除后配置configuration寄存器
//配置FSODAC 
//OTCDAC FSOTCDAC为0X0200(应用笔记上推荐)
//ODAC也配置为ALL ZERO，参考stm32程序判断
	case(data_cnt)

		5'd0: rd_data<=8'h01;
	//configuration	//本来是f341
	//现在调整PGA 为3341
	//f141 G5
	//7241 G6
	//7641 G6 IRO -9
		5'd1: rd_data<=8'hf0;//PGA 低倍数
		5'd2: rd_data<=8'h11;
		5'd3: rd_data<=8'h42;
		5'd4: rd_data<=8'h13;
		
//		5'd1: rd_data<=8'hf0;
//		5'd2: rd_data<=8'h31;
//		5'd3: rd_data<=8'h42;
//		5'd4: rd_data<=8'h13;

		5'd5: rd_data<=8'h06;
		5'd6: rd_data<=8'h09;
	//FOSDAC	3333
		5'd7: rd_data<=8'h30;
		5'd8: rd_data<=8'h31;
		5'd9: rd_data<=8'h32;
		5'd10: rd_data<=8'h33;
		
		5'd11: rd_data<=8'h36;
		5'd12: rd_data<=8'h09;
	//	//OFFSET DAC 0000
		5'd13: rd_data<=8'h00;
		5'd14: rd_data<=8'h01;
		5'd15: rd_data<=8'h02;
		5'd16: rd_data<=8'h03;
		
		5'd17: rd_data<=8'h16;
		5'd18: rd_data<=8'h09;
	//OFFSET TCDAC 0000
		5'd19: rd_data<=8'h00;
		5'd20: rd_data<=8'h01;
		5'd21: rd_data<=8'h02;
		5'd22: rd_data<=8'h03;
		5'd23: rd_data<=8'h26;
		5'd24: rd_data<=8'h09;
	//
		5'd25: rd_data<=8'hfa;

			default:rd_data<=8'h00;

		
	endcase
	
									
endmodule
