module switch(
input clk,//时钟
input [5:0] addr,//地址 把位宽增加1原来是4
output  F1_8ADD_A,				//底层八选一
output 	F1_8ADD_B,
output 	F1_8ADD_C,

output 	F2_8ADD_A,				//中层八选一
output 	F2_8ADD_B,
output 	F2_8ADD_C,

output 	F3_8ADD_A,				
output 	F3_8ADD_B,
output 	F3_8ADD_C


);

reg [2:0] F1_8ADD;
reg [2:0] F2_8ADD;
reg [2:0] F3_8ADD;




//A20 B20 C20 for U23 U21 U20
assign F1_8ADD_A=F1_8ADD[0];
assign F1_8ADD_B=F1_8ADD[1];
assign F1_8ADD_C=F1_8ADD[2];

//A200 B200 C200 for U207 u202
assign F2_8ADD_A=F2_8ADD[0];
assign F2_8ADD_B=F2_8ADD[1];
assign F2_8ADD_C=F2_8ADD[2];

//A201 B210 C210 for U214
assign F3_8ADD_A=F3_8ADD[0];
assign F3_8ADD_B=F3_8ADD[1];
assign F3_8ADD_C=F3_8ADD[2];



always@(posedge clk)begin
	F1_8ADD	<=	3'd3;
	F2_8ADD	<=	3'd0;
	F3_8ADD	<=	3'd0;
	end 
	



//always@(posedge clk)
//	case(addr)
//	
//	//1012
//		5'd0:begin F1_8ADD<=3'd2; F2_8ADD<=2'd1; F3_8ADD<=2'd0; end
//		5'd1:begin F1_8ADD<=3'd2; F2_8ADD<=2'd1; F3_8ADD<=2'd0; end
//		5'd2:begin F1_8ADD<=3'd2; F2_8ADD<=2'd1; F3_8ADD<=2'd0; end
//		5'd3:begin F1_8ADD<=3'd2; F2_8ADD<=2'd1; F3_8ADD<=2'd0; end
//		5'd4:begin F1_8ADD<=3'd2; F2_8ADD<=2'd1; F3_8ADD<=2'd0; end
//	//1003
//		5'd5:begin F1_8ADD<=3'd3; F2_8ADD<=2'd0; F3_8ADD<=2'd0; end
//		5'd6:begin F1_8ADD<=3'd3; F2_8ADD<=2'd0; F3_8ADD<=2'd0; end
//		5'd7:begin F1_8ADD<=3'd3; F2_8ADD<=2'd0; F3_8ADD<=2'd0; end
//		5'd8:begin F1_8ADD<=3'd3; F2_8ADD<=2'd0; F3_8ADD<=2'd0; end
//		5'd9:begin F1_8ADD<=3'd3; F2_8ADD<=2'd0; F3_8ADD<=2'd0; end
//	//1016	
//		5'd10:begin F1_8ADD<=3'd6; F2_8ADD<=2'd1; F3_8ADD<=2'd0; end
//		5'd11:begin F1_8ADD<=3'd6; F2_8ADD<=2'd1; F3_8ADD<=2'd0; end
//		5'd12:begin F1_8ADD<=3'd6; F2_8ADD<=2'd1; F3_8ADD<=2'd0; end
//		5'd13:begin F1_8ADD<=3'd6; F2_8ADD<=2'd1; F3_8ADD<=2'd0; end
//		5'd14:begin F1_8ADD<=3'd6; F2_8ADD<=2'd1; F3_8ADD<=2'd0; end
//	//1032
//		5'd15:begin F1_8ADD<=3'd2; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
//		5'd16:begin F1_8ADD<=3'd2; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
//		5'd17:begin F1_8ADD<=3'd2; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
//		5'd18:begin F1_8ADD<=3'd2; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
//		5'd19:begin F1_8ADD<=3'd2; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
//	//1043
//		5'd20:begin F1_8ADD<=3'd3; F2_8ADD<=2'd4; F3_8ADD<=2'd0; end
//		5'd21:begin F1_8ADD<=3'd3; F2_8ADD<=2'd4; F3_8ADD<=2'd0; end
//		5'd22:begin F1_8ADD<=3'd3; F2_8ADD<=2'd4; F3_8ADD<=2'd0; end
//		5'd23:begin F1_8ADD<=3'd3; F2_8ADD<=2'd4; F3_8ADD<=2'd0; end
//		5'd24:begin F1_8ADD<=3'd3; F2_8ADD<=2'd4; F3_8ADD<=2'd0; end
//	//1046
//		5'd25:begin F1_8ADD<=3'd6; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
//		5'd26:begin F1_8ADD<=3'd6; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
//		5'd27:begin F1_8ADD<=3'd6; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
//		5'd28:begin F1_8ADD<=3'd6; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
//		5'd29:begin F1_8ADD<=3'd6; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
//	//FF
//		5'd30:begin F1_8ADD<=3'd0; F2_8ADD<=2'd0; F3_8ADD<=2'd0; end
//		5'd31:begin F1_8ADD<=3'd0; F2_8ADD<=2'd0; F3_8ADD<=2'd0; end
//
//		default:;
//	endcase
//
//
//
//
////always@(posedge clk)
////	case(addr)
////		
////	
////		5'd0:begin F1_8ADD<=3'd0; F2_8ADD<=2'd2; F3_8ADD<=2'd0; end
////		5'd1:begin F1_8ADD<=3'd1; F2_8ADD<=2'd2; F3_8ADD<=2'd0; end
////		5'd2:begin F1_8ADD<=3'd2; F2_8ADD<=2'd2; F3_8ADD<=2'd0; end//
////		5'd3:begin F1_8ADD<=3'd3; F2_8ADD<=2'd2; F3_8ADD<=2'd0; end
////		5'd4:begin F1_8ADD<=3'd4; F2_8ADD<=2'd2; F3_8ADD<=2'd0; end//
////		5'd5:begin F1_8ADD<=3'd5; F2_8ADD<=2'd2; F3_8ADD<=2'd0; end
////		5'd6:begin F1_8ADD<=3'd6; F2_8ADD<=2'd2; F3_8ADD<=2'd0; end
////		5'd7:begin F1_8ADD<=3'd7; F2_8ADD<=2'd2; F3_8ADD<=2'd0; end
////
////		5'd8:begin F1_8ADD<=3'd0; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
////		5'd9:begin F1_8ADD<=3'd1; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
////		5'd10:begin F1_8ADD<=3'd2; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
////		5'd11:begin F1_8ADD<=3'd3; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
////		5'd12:begin F1_8ADD<=3'd4; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
////		5'd13:begin F1_8ADD<=3'd5; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
////		5'd14:begin F1_8ADD<=3'd6; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
////		5'd15:begin F1_8ADD<=3'd7; F2_8ADD<=2'd3; F3_8ADD<=2'd0; end
////
////		5'd16:begin F1_8ADD<=3'd0; F2_8ADD<=2'd4; F3_8ADD<=2'd0; end
////		5'd17:begin F1_8ADD<=3'd1; F2_8ADD<=2'd4; F3_8ADD<=2'd0; end
////		5'd18:begin F1_8ADD<=3'd2; F2_8ADD<=2'd4; F3_8ADD<=2'd0; end
////		5'd19:begin F1_8ADD<=3'd3; F2_8ADD<=2'd4; F3_8ADD<=2'd0; end
////		5'd20:begin F1_8ADD<=3'd4; F2_8ADD<=2'd4; F3_8ADD<=2'd0; end
////		5'd21:begin F1_8ADD<=3'd5; F2_8ADD<=2'd4; F3_8ADD<=2'd0; end
////		5'd22:begin F1_8ADD<=3'd6; F2_8ADD<=2'd4; F3_8ADD<=2'd0; end
////		5'd23:begin F1_8ADD<=3'd7; F2_8ADD<=2'd4; F3_8ADD<=2'd0; end
////
////		5'd24:begin F1_8ADD<=3'd0; F2_8ADD<=2'd5; F3_8ADD<=2'd0; end
////		5'd25:begin F1_8ADD<=3'd1; F2_8ADD<=2'd5; F3_8ADD<=2'd0; end
////		5'd26:begin F1_8ADD<=3'd2; F2_8ADD<=2'd5; F3_8ADD<=2'd0; end
////		5'd27:begin F1_8ADD<=3'd3; F2_8ADD<=2'd5; F3_8ADD<=2'd0; end
////		5'd28:begin F1_8ADD<=3'd4; F2_8ADD<=2'd5; F3_8ADD<=2'd0; end
////		5'd29:begin F1_8ADD<=3'd5; F2_8ADD<=2'd5; F3_8ADD<=2'd0; end
////		5'd30:begin F1_8ADD<=3'd6; F2_8ADD<=2'd5; F3_8ADD<=2'd0; end
////		5'd31:begin F1_8ADD<=3'd7; F2_8ADD<=2'd5; F3_8ADD<=2'd0; end
////
////	
////		default:;
////	endcase


endmodule
