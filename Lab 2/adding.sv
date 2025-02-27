`timescale 10ps/10ps

module adder (A, B, Cin, Cout, S);

	input  logic A, B, Cin;
	output logic Cout, S;

	logic AorB;
	logic AandB;
	logic Cand1;
	
	xor #5 xor0 (AorB, A, B);
	xor #5 xor1 (S, Cin, AorB); // S is 1 only when one of the three inputs is 1
										// or when all of them are 1: (A ^ B) ^ Cin
	and #5 and0 (AandB, A, B);
	and #5 and1 (Cand1, AorB, Cin);
	
	or #5  or0  (Cout, Cand1, AandB);

endmodule

