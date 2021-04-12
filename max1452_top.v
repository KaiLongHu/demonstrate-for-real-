module max1452_top(
							input clk,
							input rst_n,
							output rs_tx,
							output 	reg   unlock,
							
							output  	   	F1_8ADD_A,				//底层八选一
							output 	 		F1_8ADD_B,
							output 	 		F1_8ADD_C,	
							output 			F2_8ADD_A,				//中层八选一
							output 			F2_8ADD_B,
							output 			F2_8ADD_C,
							output 			F3_8ADD_A,
							output 			F3_8ADD_B,
							output 			F3_8ADD_C,

						
							input				SDO,						//AD_SDO
							output  			CS_n,						//AD_CS
							output 			SCK,						//AD_SCK
							output 			[11:0] data_out						
							);
							
												
reg [2:0] F1_8ADD;
reg [2:0] F2_8ADD;
reg [2:0] F3_8ADD;					

assign F1_8ADD_A=F1_8ADD[0];
assign F1_8ADD_B=F1_8ADD[1];
assign F1_8ADD_C=F1_8ADD[2];

assign F2_8ADD_A=F2_8ADD[0];
assign F2_8ADD_B=F2_8ADD[1];
assign F2_8ADD_C=F2_8ADD[2];

assign F3_8ADD_A=F3_8ADD[0];
assign F3_8ADD_B=F3_8ADD[1];
assign F3_8ADD_C=F3_8ADD[2];	
							
//----------------------------------------------------
////ABC
			
always@(posedge clk)begin
	F1_8ADD	<=	3'd6;
	F2_8ADD	<=	3'd3;
	F3_8ADD	<=	3'd0;			
					end
							
							
							
							
							


//----------------------------------------------------
wire clk_bps;		// clk_bps的高电平为接收或者发送数据位，每个波特周期的中间 
reg[7:0] rd_data=8'h00;	//接收数据寄存器，保存直至下一个数据来到
wire rd_en;	//接收数据有效
reg empty=0; // 全部配置完成以后变为empty

reg [4:0] data_cnt=5'd0;//13个字节		
reg [4:0] unlock_cnt=5'd0;	

//ADC模块
LTC231512 T1(
 .clk_50M(clk),
 .reset_n(rst_n),
 .SDO(SDO),
 .CS_n(CS_n),
 .SCK(SCK), 
 .data_out(data_out)
);
	
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

//----------------------------------------------------
parameter casenum		= 	5'd25;//send data case数量		
//----------------------------------------------------	
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
//#########################################################################################
//	//OFFSET DAC 0000
//		5'd13: rd_data<=8'h00;
//		5'd14: rd_data<=8'h01;
//		5'd15: rd_data<=8'h02;
//		5'd16: rd_data<=8'h03;
//		
//		5'd17: rd_data<=8'h16;
//		5'd18: rd_data<=8'h09;
//	//OFFSET TCDAC 0200
//		5'd19: rd_data<=8'h00;
//		5'd20: rd_data<=8'h01;
//		5'd21: rd_data<=8'h22;
//		5'd22: rd_data<=8'h03;
//		
//		5'd23: rd_data<=8'h26;
//		5'd24: rd_data<=8'h09;
//#########################################################################################
//case(data_cnt)
//		5'd0: rd_data<=8'h01;//
//		
//		
//		//10ff=0001 0000 1111 1111 
//		//改变pga参数 0001 0000 1100 0011
//		//10C3
//		//
//		5'd1: rd_data<=8'hf0;
//		5'd2: rd_data<=8'hf1;
////		5'd1: rd_data<=8'h30;
////		5'd2: rd_data<=8'hc1;
//		5'd3: rd_data<=8'h02;
//		5'd4: rd_data<=8'h13;
//		
//		5'd5: rd_data<=8'h06;
//		5'd6: rd_data<=8'h09;
//		5'd7: rd_data<=8'h30;
//		5'd8: rd_data<=8'h31;
//		5'd9: rd_data<=8'h32;
//		5'd10: rd_data<=8'h33;
//		5'd11: rd_data<=8'h36;
//		5'd12: rd_data<=8'h09;
//		default:rd_data<=8'h00;
//#########################################################################################
//	   5'd0: rd_data<=8'h01;
//		5'd1: rd_data<=8'hf8;
//		5'd2: rd_data<=8'h59;	
//		default:rd_data<=8'h00;

//#########################################################################################
//	case(data_cnt)
//		5'd0: rd_data<=8'h01;//
//		5'd1: rd_data<=8'hf0;
//		5'd2: rd_data<=8'hf1;
//		5'd3: rd_data<=8'h02;
//		5'd4: rd_data<=8'h13;
//		5'd5: rd_data<=8'h06;
//		5'd6: rd_data<=8'h09;
//		5'd7: rd_data<=8'h30;
//		5'd8: rd_data<=8'h31;
//		5'd9: rd_data<=8'h32;
//		5'd10: rd_data<=8'h33;
//		5'd11: rd_data<=8'h36;
//		5'd12: rd_data<=8'h09;
//		default:rd_data<=8'h00;
//
//	5'd0: rd_data<=8'hff;
//		5'd1: rd_data<=8'h01;//
//		5'd2: rd_data<=8'hf0;
//		5'd3: rd_data<=8'hf1;
//		5'd4: rd_data<=8'h02;
//		5'd5: rd_data<=8'h13;
//		5'd6: rd_data<=8'h06;
//		5'd7: rd_data<=8'h09;
//		5'd8: rd_data<=8'h30;
//		5'd9: rd_data<=8'h31;
//		5'd10: rd_data<=8'h32;
//		5'd11: rd_data<=8'h33;
//		5'd12: rd_data<=8'h36;
//		5'd13: rd_data<=8'h09;
//		default:rd_data<=8'h00;
//

//################################################
//	//part1
//		5'd0: rd_data<=8'h01;//
//		5'd1: rd_data<=8'hf0;
//		5'd2: rd_data<=8'hf1;
//		5'd3: rd_data<=8'h02;
//		5'd4: rd_data<=8'h13;
//		5'd5: rd_data<=8'h06;
//		5'd6: rd_data<=8'h09;
//		
//	//part2	
//		5'd7: rd_data<=8'h30;
//		5'd8: rd_data<=8'h31;
//		5'd9: rd_data<=8'h32;
//		5'd10: rd_data<=8'h33;
//		5'd11: rd_data<=8'h36;
//		5'd12: rd_data<=8'h09;
//		
//	//part3
//		5'd13: rd_data<=8'hf0;
//		5'd14: rd_data<=8'hf1;
//		5'd15: rd_data<=8'h06;
//		5'd16: rd_data<=8'h07;
//		5'd17: rd_data<=8'h18; 
//		5'd18: rd_data<=8'h19;
//		5'd19: unlock<=1'b0;


//	5'd0: rd_data<=8'hff;//
//		5'd1: rd_data<=8'h01;//
//		5'd2: rd_data<=8'hf0;
//		5'd3: rd_data<=8'hf1;
//		5'd4: rd_data<=8'h02;
//		5'd5: rd_data<=8'h13;
//		5'd6: rd_data<=8'h06;
//		5'd7: rd_data<=8'h09;
//		
//	//part2	
//		5'd8: rd_data<=8'h30;
//		5'd9: rd_data<=8'h31;
//		5'd10: rd_data<=8'h32;
//		5'd11: rd_data<=8'h33;
//		5'd12: rd_data<=8'h36;
//		5'd13: rd_data<=8'h09;
//		
//	//part3
//		5'd14: rd_data<=8'hf0;
//		5'd15: rd_data<=8'hf1;
//		5'd16: rd_data<=8'h06;
//		5'd17: rd_data<=8'h07;
//		5'd18: rd_data<=8'h18; 
//		5'd19: rd_data<=8'h19;
//		5'd20: unlock<=1'b0;


////CHECK BAUD RATE
//		5'd0: rd_data<=8'h01;
//	
////ERASE EEPROM PAGE 5 WHERE CL7:0 BELONG,AFTER ERASE ALL BINARY TURN TO 1(FF)
//		5'd1: rd_data<=8'h77; 
//		5'd2: rd_data<=8'hD8;
//		5'd3: rd_data<=8'h79;
//// Set configuration register			
//		5'd4: rd_data<=8'hf0;
//		5'd5: rd_data<=8'h31;
//		5'd6: rd_data<=8'h02;
//		5'd7: rd_data<=8'h13;
//		
//		5'd8: rd_data<=8'h06;
//		5'd9: rd_data<=8'h09;		
////SET FSODAC (BRIDGE ENCOURAGE VALUE)
//	//数据资料中规定该限制为0x4000至0xC000，VDD=5V时，大概对应FSODAC的1.25(1.28)V至3.75(3.83)V,
//	//配置为3333的时候大概1V
//		5'd10: rd_data<=8'h30;
//		5'd11: rd_data<=8'h31;
//		5'd12: rd_data<=8'h32;
//		5'd13: rd_data<=8'h33;
//		
//		5'd14: rd_data<=8'h36;
//		5'd15: rd_data<=8'h09;	
//		default:rd_data<=8'h00;
//****************************************************************************************************
//CHECK BAUD RATE
//		5'd0: rd_data<=8'h01;
//	
////ERASE EEPROM PAGE 5 WHERE CL7:0 BELONG,AFTER ERASE ALL BINARY TURN TO 1(FF)
////CL[7:0]==FFHEX
//		5'd1: rd_data<=8'h77; 
//		5'd2: rd_data<=8'hD8;
//		5'd3: rd_data<=8'h79;
////// Set configuration EEPROM 
////high byte161 first			
//		5'd4: rd_data<=8'h30;//[11:8]
//		5'd5: rd_data<=8'hf1;//[15:12]
//		
//		5'd6: rd_data<=8'h16;
//		5'd7: rd_data<=8'h67;
//		5'd8: rd_data<=8'hd8;
//		5'd9: rd_data<=8'h19;	
////low byte 160
//		5'd10: rd_data<=8'h10;//[3:0]
//		5'd11: rd_data<=8'h01;//[7:4]
//		
//		5'd12: rd_data<=8'h06;
//		5'd13: rd_data<=8'h67;
//		5'd14: rd_data<=8'hd8;
//		5'd15: rd_data<=8'h19;
//		
////ODAC SET TO ALL ZERO
////HIGH BYTE 15F FIRST 
//		5'd16: rd_data<=8'h00;//[11:8]
//		5'd17: rd_data<=8'h01;//[15:12]
//		
//		5'd18: rd_data<=8'hf6;
//		5'd19: rd_data<=8'h57;
//		5'd20: rd_data<=8'hd8;
//		5'd21: rd_data<=8'h19;	
////LOW BYTE 	15E
//		5'd22: rd_data<=8'h00;//[3:0]
//		5'd23: rd_data<=8'h01;//[7:4]
//		
//		5'd24: rd_data<=8'he6;
//		5'd25: rd_data<=8'h57;
//		5'd26: rd_data<=8'hd8;
//		5'd27: rd_data<=8'h19;