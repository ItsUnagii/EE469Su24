`timescale 10ps/10ps

module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);
	input  logic [63:0] A, B;
	input  logic [2:0]  cntrl;
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out;
	
	
	logic [63:0] alu_Cout;
	logic [15:0] zero_check_1;
	logic [3:0]  zero_check_2;
	
	// cntrl			Operation						Notes:
	// 000:			result = B						value of overflow and carry_out unimportant
	// 010:			result = A + B
	// 011:			result = A - B
	// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
	// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
	// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant
	
	// adding and subtracting :anguish:
	// Adding:      A + B  + 0
	// Subtracting: A + B' + 1
	
	// 64 1-bit alus
	// set the first alu because it takes no carry in
	alu_1bit first (.ctrl(cntrl), .A(A[0]), .B(B[0]), .out(result[0]), .Cin(cntrl[0]), .Cout(alu_Cout[0]));
	
	genvar i;
	generate
		for (i = 1; i < 64; i++) begin : alus
			alu_1bit slice (.ctrl(cntrl), .A(A[i]), .B(B[i]), .out(result[i]), .Cin(alu_Cout[i-1]), .Cout(alu_Cout[i]));
		end
	endgenerate
	
	// check for 0s
	generate 
		for (i = 0; i < 16; i++) begin : check_zeros_1
			nor #5 check_1 (zero_check_1[i], result[4*i], result[4*i+1], result[4*i+2], result[4*i+3]);
		end
	endgenerate
	
	generate 
		for (i = 0; i < 4; i++) begin : check_zeros_2
			and #5 check_2 (zero_check_2[i], zero_check_1[4*i], zero_check_1[4*i+1], zero_check_1[4*i+2], zero_check_1[4*i+3]);
		end
	endgenerate
	
	and #5 final_zero_check (zero, zero_check_2[0], zero_check_2[1], zero_check_2[2], zero_check_2[3]);
	
	// identify MSB carry signals and xor
	xor #5 set_overflow (overflow, alu_Cout[63], alu_Cout[62]);
	
	// final adjustments
	assign negative = result[63];
	assign carry_out = alu_Cout[63];
	
endmodule
