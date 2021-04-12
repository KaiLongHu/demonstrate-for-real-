module LTC231512(
input clk_50M,//时钟50M
input reset_n,//复位，低电平有效
input SDO,//AD_SDO
output reg CS_n,//AD_CS
output SCK,//AD_SCK
output [11:0] data_out//AD量化值输出
);

	
	
//sck==25MHz
reg [5:0] cnt=6'd0;
always@(posedge clk_50M or negedge reset_n)		//每20ns计数一次，50MHZ系统时钟
	if(!reset_n)
		cnt<=6'd0;
	else
		if(cnt>=6'd33)//计数0~33							//一共34个计数器用来执行读取时序
			cnt<=6'd0;
		else
			cnt<=cnt+6'd1;//计数

//控制CS
always@(posedge clk_50M or negedge reset_n)		//0~4是上一个读取周期过后的等待，此时CS是高
	if(!reset_n)
		CS_n<=1;
	else
		if(cnt>=6'd4)										//5开始拉低CS 开始读数
			CS_n<=0;											//
		else
			CS_n<=1;

//控制SCK
reg SCK_buf=0;
always@(posedge clk_50M or negedge reset_n)		//这是SCK 的分频
	if(!reset_n)
		SCK_buf<=0;
	else
		if(cnt>6'd4 && cnt<6'd33)//5~34
			SCK_buf<=~SCK_buf;
		else
			SCK_buf<=0;

assign SCK=SCK_buf;	//输出SCK		25Mhz
			
reg [11:0] data;
always@(posedge clk_50M or negedge reset_n)
	if(!reset_n)
		data<=12'd0;
	else
		case(cnt)//根据cnt计数值读取SDO
			6'd7:data[11]<=SDO;
			6'd9:data[10]<=SDO;
			6'd11:data[9]<=SDO;
			6'd13:data[8]<=SDO;
			6'd15:data[7]<=SDO;
			6'd17:data[6]<=SDO;
			6'd19:data[5]<=SDO;
			6'd21:data[4]<=SDO;
			6'd23:data[3]<=SDO;
			6'd25:data[2]<=SDO;
			6'd27:data[1]<=SDO;
			6'd29:data[0]<=SDO;
			6'd31:data<=12'd0;
			default:;
		endcase
		
//锁存data到data_out_buf中		
reg [11:0] data_out_buf=12'd0;
always@(posedge clk_50M or negedge reset_n)
	if(!reset_n)
		data_out_buf<=12'd0;
	else			
		if(cnt==6'd30)
			data_out_buf<=data;
		else
			data_out_buf<=data_out_buf;

assign 	data_out=data_out_buf;//输出AD值
			
endmodule
