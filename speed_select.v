module speed_select(clk,rst_n,clk_bps);

input clk;					// 50MHz主时钟
input rst_n;				//低电平复位信号
output clk_bps;			// clk_bps的高电平为接收或者发送数据位，每个波特周期的中间 

////波特率控制50M晶振时
//parameter 	bps9600 		= 5208;	//波特率为9600bps,开发板板晶振为50M，计算为50000000/9600=5208
//parameter 	bps9600_2 	= 2604;  //5208/2=2604

//波特率控制100M晶振时
parameter 	bps9600 		= 10416;	//波特率为9600bps,晶振为100M，计算为100000000/9600=10416
parameter 	bps9600_2 	= 5208;  //10416/2=5208

reg[13:0] bps_para;	//分频计数最大值
reg[13:0] bps_para_2;	//分频计数的一半
reg[13:0] cnt;			//分频计数
reg clk_bps_r;			//波特率时钟寄存器

////----------------------------------------------------------
//reg[2:0] uart_ctrl;	// uart波特率选择寄存器
////----------------------------------------------------------
//
always @ (posedge clk or negedge rst_n) begin
	bps_para <= bps9600;
	bps_para_2 <= bps9600_2;
end

always @ (posedge clk or negedge rst_n)
	if(!rst_n) cnt <= 13'd0;
	else if(cnt<bps_para) cnt <= cnt+1'b1;	//波特率时计数
	else cnt <= 13'd0;

always @ (posedge clk or negedge rst_n)
	if(!rst_n) clk_bps_r <= 1'b0;
	else if(cnt==bps_para_2) clk_bps_r <= 1'b1;	// clk_bps_r高电平为接收或者发送数据位
	else clk_bps_r <= 1'b0;

assign clk_bps = clk_bps_r;

endmodule
