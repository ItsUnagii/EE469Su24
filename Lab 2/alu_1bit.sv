`timescale 10ps/10ps

module alu_1bit (ctrl, A, B, out, Cin, Cout);
	input logic [2:0] ctrl;
	input logic A, B, Cin;
	
	output logic Cout, out;
	
	logic [7:0] result; // store 1 bit for each operation
	logic B_add, andAB, orAB, xorAB;
	
	// ctrl			Operation						Notes:
	// 000:			result = B						value of overflow and carry_out unimportant
	// 010:			result = A + B
	// 011:			result = A - B
	// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
	// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
	// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant
	
	mux2to1 invertB (.sel(ctrl[0]), .in({~B, B}), .out(B_add)); // are you adding or subtracting
	adder fullAdder (.A(A), .B(B_add), .Cin(Cin), .Cout(Cout), .S(result[2]));
	
	and #5 andLogic (andAB, A, B);
	or  #5 orLogic  (orAB,  A, B);
	xor #5 xorLogic (xorAB, A, B);
	
	assign result[0] = B;
	assign result[3] = result[2]; // negative
	assign result[4] = andAB;
	assign result[5] = orAB;
	assign result[6] = xorAB;

	mux8to1 control (.sel(ctrl[2:0]), .in(result[7:0]), .out(out));
endmodule



module alu_1bit_tb();
	logic [2:0] ctrl; 
	logic			A, B, Cout, Cin, out;
	
	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	
	alu_1bit test (.ctrl, .A, .B, .out, .Cout, .Cin);
	
	integer i;
	initial begin
		ctrl = ALU_PASS_B; A = 1'b0; B = 1'b0; Cin = 0; #10;
		ctrl = ALU_ADD;							   Cin = 1; #10;
		ctrl = ALU_ADD;							   Cin = 0; #10;
		ctrl = ALU_SUBTRACT;							Cin = 1; #10;
		ctrl = ALU_SUBTRACT;							Cin = 0; #10;
		ctrl = ALU_AND;							   Cin = 0; #10;
		ctrl = ALU_OR;							      Cin = 0; #10;
		ctrl = ALU_XOR;							   Cin = 0; #10;
		
		ctrl = ALU_PASS_B; A = 1'b0; B = 1'b1; Cin = 0; #10;
		ctrl = ALU_ADD;							   Cin = 1; #10;
		ctrl = ALU_ADD;							   Cin = 0; #10;
		ctrl = ALU_SUBTRACT;							Cin = 1; #10;
		ctrl = ALU_SUBTRACT;							Cin = 0; #10;
		ctrl = ALU_AND;							   Cin = 0; #10;
		ctrl = ALU_OR;							      Cin = 0; #10;
		ctrl = ALU_XOR;							   Cin = 0; #10;
		
		ctrl = ALU_PASS_B; A = 1'b1; B = 1'b0; Cin = 0; #10;
		ctrl = ALU_ADD;							   Cin = 1; #10;
		ctrl = ALU_ADD;							   Cin = 0; #10;
		ctrl = ALU_SUBTRACT;							Cin = 1; #10;
		ctrl = ALU_SUBTRACT;							Cin = 0; #10;
		ctrl = ALU_AND;							   Cin = 0; #10;
		ctrl = ALU_OR;							      Cin = 0; #10;
		ctrl = ALU_XOR;							   Cin = 0; #10;
		
		ctrl = ALU_PASS_B; A = 1'b1; B = 1'b1; Cin = 0; #10;
		ctrl = ALU_ADD;							   Cin = 1; #10;
		ctrl = ALU_ADD;							   Cin = 0; #10;
		ctrl = ALU_SUBTRACT;							Cin = 1; #10;
		ctrl = ALU_SUBTRACT;							Cin = 0; #10;
		ctrl = ALU_AND;							   Cin = 0; #10;
		ctrl = ALU_OR;							      Cin = 0; #10;
		ctrl = ALU_XOR;							   Cin = 0; #10;
		$stop;
	end
endmodule 