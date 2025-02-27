`timescale 10ps/10ps

module alu_1bit (ctrl, A, B, cout, cin, out);
	input  logic [2:0]  ctrl;
	input  logic A, B, cin;
	
   output logic out, cout;
	
	logic [7:0] results;
	logic       adderB, andAB, orAB, xorAB;
	
	mux2to1 invertB (.select(ctrl[0]), .in({~B, B}), .out(adderB));
	fullAdder adder (.result(results[2]), .A(A), .B(adderB), .cin(cin), .cout(cout));
	
	xor #5 theXor (xorAB, A, B);
	and #5 theAnd (andAB, A, B);
	or  #5 theOr  (orAB, A, B);
	
	assign results[0] = B;
	assign results[3] = results[2];
	assign results[4] = andAB;
	assign results[5] = orAB;
	assign results[6] = xorAB;

	mux8to1 selectOp (.select(ctrl[2:0]), .in(results[7:0]), .out(out));
endmodule 
