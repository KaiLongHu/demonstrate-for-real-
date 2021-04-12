`timescale 1ns/1ns
`define clock_period 20

module demonstrate_tb;

reg clk;
reg reset_n;
reg SDO;
reg flag;

wire F1_8ADD_A;
wire F1_8ADD_B;
wire F1_8ADD_C;

wire F2_8ADD_A;
wire F2_8ADD_B;
wire F2_8ADD_C;

wire F2_4ADD_A;
wire F2_4ADD_B;
//wire ADD_CO;


  demonstrate T1 (
							 			.clk(clk),					//时钟50M
							 			.reset_n(reset_n),					//复位，低电平有效
							 			//.SDO(SDO),						//AD_SDO
										.flag(flag),
		
							  	 		.F1_8ADD_A(F1_8ADD_A),				//底层八选一
							 			.F1_8ADD_B(F1_8ADD_B),
							 			.F1_8ADD_C(F1_8ADD_C),
								
							 			.F2_8ADD_A(F2_8ADD_A),				//中层八选一
							 			.F2_8ADD_B(F2_8ADD_B),
							 			.F2_8ADD_C(F2_8ADD_C),
							
							    	   .F2_4ADD_A(F2_4ADD_A),				//顶层四选一
							  			.F2_4ADD_B(F2_4ADD_B),
							
							 			.unlock()					//MAX1452锁信号,正常工作模式配置为低电平	
							);
							
		initial clk = 1'b1;
		initial SDO = 1'b1;
		initial flag = 1'b1;
//		initial F1_8ADD_A = 1'b0;
//		initial F1_8ADD_B = 1'b0;
//		initial F1_8ADD_C = 1'b0;
//		
//		initial F2_8ADD_A = 1'b0;
//		initial F2_8ADD_B = 1'b0;
//		initial F2_8ADD_C = 1'b0;
//		
//		initial F2_4ADD_A = 1'b0;
//		initial F2_4ADD_B = 1'b0;
		
		
		
		
		always#(`clock_period/2) clk = ~clk; //延时半个时钟周期翻转
		initial begin
		reset_n = 1'b0;
		#(`clock_period*200);
		reset_n = 1'b1;

		#(`clock_period*50);
      flag=1;
		#(`clock_period*10);
		flag=0;
		$stop;//仿真停止
		end
	
							
							
endmodule 						