`timescale 1 ps/ 1 ps
module switch_ctrl_vlg_tst();

reg clk;
reg [7:0] data_out;
reg flag;
reg rdreq;
reg reset_n;
// wires                                               
wire [4:0]  addr;
wire empty;
wire full;
wire [7:0]  q;

// assign statements (if any)                          
switch_ctrl i1 (
// port map - connection between master ports and signals/registers   
	.addr(addr),
	.clk(clk),
	.data_out(data_out),
	.empty(empty),
	.flag(flag),
	.full(full),
	.q(q),
	.rdreq(rdreq),
	.reset_n(reset_n)
);
initial                                                
begin                                                  
 data_out=8'd0;
 flag=1;
 rdreq=0;
 reset_n=0;//复位
#100;
 reset_n=1; 
 repeat(3)begin//重复3次
 #1000;
 flag=0;//启动
 #100;
 flag=1;
 #1000000;
 end
end  

always@(posedge clk)  
	if(i1.AD_wr_en==1)//AD使能
	data_out<=data_out+1;//产生AD值
	
always@(posedge clk)  
begin
	if(i1.empty==0)//AD使能
		begin
		rdreq<=1;//读使能	
		#20;
		rdreq<=0;//读使能	
		#3000;
		end
	else
		rdreq<=0;
end	
	

always                                                                  
begin                                                  
clk=0;
#10;
clk=1;
#10;                                            
end                                                    
endmodule