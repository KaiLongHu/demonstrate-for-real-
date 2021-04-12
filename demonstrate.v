module  demonstrate (
							input 			clk,					//时钟50M
							input 			reset_n,					//复位，低电平有效
							input SDO,//AD_SDO
							output CS_n,//AD_CS
							output SCK,//AD_SCK
							output rs_tx,
							output tx_1452,
							input 			flag,						//启动flag
												
							output  	 		F1_8ADD_A,				//底层八选一
							output 			F1_8ADD_B,
							output 			F1_8ADD_C,
								
							output 			F2_8ADD_A,				//中层八选一
							output 			F2_8ADD_B,
							output 			F2_8ADD_C,
							
							output 			F3_8ADD_A,				
							output 			F3_8ADD_B,
							output 			F3_8ADD_C,

							
							output 			unlock					//MAX1452锁信号,正常工作模式配置为低电平
			
							);

wire [11:0] data_out;//AD量化值输出

//assign unlock = 1'b0;			//unlock 在MAX1452正常工作配置低电平	



	

//******************************************************************************************************************************************************
//AD转换模块
LTC231512 lt1(
				 
				 .clk_50M		(clk),// 分频器输出
				 .reset_n		(reset_n),
				 .SDO				(SDO),
				 
				 .CS_n			(CS_n),
				 .SCK				(SCK),
				 .data_out		(data_out)
				);
				
wire [5:0] addr;//地址 4变5
//轮询模块
switch i_switch(
.  clk(clk),//时钟
.  addr(addr),//地址
.  F1_8ADD_A(F1_8ADD_A),				//底层八选一
. 	F1_8ADD_B(F1_8ADD_B),
. 	F1_8ADD_C(F1_8ADD_C),
. 	F2_8ADD_A(F2_8ADD_A),				//中层八选一
. 	F2_8ADD_B(F2_8ADD_B),
. 	F2_8ADD_C(F2_8ADD_C),
.  F3_8ADD_A(F3_8ADD_A),				
. 	F3_8ADD_B(F3_8ADD_B),
. 	F3_8ADD_C(F3_8ADD_C)
);

wire	rdreq;//读使能
wire  empty;//空
wire  full;//满
wire	[7:0]  q;//读数据
wire 	dbflag;//消抖信号

//轮询控制
switch_ctrl i_switch_ctrl(
. clk(clk),//时钟50M
. reset_n(reset_n),//复位，低电平有效
. flag(flag),//启动flag，低电平
. data_out(data_out[7:0]),//AD量化值输出，取高8位
. addr(addr),//地址	

. rdreq(rdreq),//读使能
. empty(empty),//空
. full(full),//满
. q(q)//读数据							
);

wire clk_bps;
//串口发送
speed_select i_speed_select(
.clk(clk),
.rst_n(reset_n),
.clk_bps(clk_bps)
);

//串口
my_uart_tx i_my_uart_tx(
.clk(clk),
.rst_n(reset_n),
.clk_bps(clk_bps),
.rd_data(q),
.rd_en(rdreq),
.empty(empty),
.rs_tx(rs_tx)
);

 max1452_top max1452(
							. clk(clk),
							. rst_n(reset_n),
							. rs_tx(tx_1452),
							. unlock(unlock),// unlock send complete turn to low!!!!!!!!!!																		
							);





endmodule 