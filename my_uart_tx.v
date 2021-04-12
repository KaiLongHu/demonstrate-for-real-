module my_uart_tx(clk,rst_n,clk_bps,rd_data,rd_en,empty,rs_tx);

input clk;						// 50MHz主时钟
input rst_n;					//低电平复位信号
input clk_bps;					// clk_bps的高电平为接收或者发送数据位的中间采样点
input[7:0] rd_data;			//接收数据寄存器
output rd_en;					//接收数据使能
input empty;					//配置完成信号
output rs_tx;				// 发送数据信号

//---------------------------------------------------------
reg[7:0] tx_data=8'd0;		//待发送数据的寄存器
//---------------------------------------------------------
reg tx_en=0;					//发送数据使能信号，高有效
reg[3:0] num;

reg rd_en=0;
reg [2:0] state=3'd0;
reg [31:0] wait_cnt=32'd0;
always@(posedge clk or negedge rst_n) 
	if(!rst_n) 
		wait_cnt<=32'd0;
	else
		if(state==3'd5)
			wait_cnt<=wait_cnt+32'd1;
		else
			wait_cnt<=32'd0;


always@(posedge clk or negedge rst_n) 
	if(!rst_n) 
		state<=3'd0;
	else
		case(state)
			3'd0://wait
				if(empty==0)
					state<=3'd1;//read
				else
					state<=3'd0;
			3'd1://read_en
				state<=3'd2;
			3'd2://read_data
				state<=3'd3;
			3'd3://send
				state<=3'd4;
			3'd4:
				if(tx_en==0)//发送完成
					state<=3'd5;//3'd0--wait
				else
					state<=3'd4;
			3'd5://wait 2.5ms
				if(wait_cnt>=32'd1)//8ms,计数(250000)125_000
					state<=3'd0;
				else
					state<=3'd5;
			default:;
		endcase
		
always@(posedge clk )
	if(state==3'd1)
		rd_en<=1;//读使能
	else
		rd_en<=0;
		
		
always@(posedge clk or negedge rst_n)
if(!rst_n)
	tx_data<=8'd0;
else
	if(state==3'd3)
		tx_data<=rd_data;//读数据,把数据存入发送数据寄存器
	else
		tx_data<=tx_data;		
		
		

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
			tx_en <= 1'b0;
		end
	else if(state==3'd3) begin	//接收数据完毕，准备把接收到的数据发回去
			tx_en <= 1'b1;		//进入发送数据状态中
		end
	else if(num==4'd11) begin	//数据发送完成，复位
			tx_en <= 1'b0;
		end
end

//---------------------------------------------------------
reg rs232_tx_r;

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
			num <= 4'd0;
			rs232_tx_r <= 1'b1;
		end
	else if(tx_en) begin
			if(clk_bps)	begin
					num <= num+1'b1;
					case (num)
						4'd0:	rs232_tx_r <= 1'b0; 	//发送起始位
						4'd1:	rs232_tx_r <= tx_data[0];	//发送bit0
						4'd2:	rs232_tx_r <= tx_data[1];	//发送bit1
						4'd3: rs232_tx_r <= tx_data[2];	//发送bit2
						4'd4: rs232_tx_r <= tx_data[3];	//发送bit3
						4'd5: rs232_tx_r <= tx_data[4];	//发送bit4
						4'd6: rs232_tx_r <= tx_data[5];	//发送bit5
						4'd7:	rs232_tx_r <= tx_data[6];	//发送bit6
						4'd8: rs232_tx_r <= tx_data[7];	//发送bit7
						4'd9: rs232_tx_r <= 1'b1;	//发送结束位
					 	default: rs232_tx_r <= 1'b1;
						endcase
				end
			else if(num==4'd11) num <= 4'd0;	//复位
		end
end

assign rs_tx = rs232_tx_r;

endmodule
