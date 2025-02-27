`timescale 10ps/10ps

module fullAdder (result, A, B, cin, cout);
	input  logic A, B, cin;
	output logic result, cout;
	logic xorAB, andAB, andCX;
	
	xor #5 xor0 (xorAB, A, B);
	xor #5 xor1 (result, xorAB, cin);
	and #5 and0 (andAB, A, B);
	and #5 and1 (andCX, cin, xorAB);
	or  #5 or0  (cout, andAB, andCX);
endmodule 

module fullAdder_64(result, A, B, cin, cout);
	input  logic [63:0] A, B;
	input  logic cin;
	output logic cout;
	
	output logic [63:0] result;
	logic [63:0] carries;
	
	fullAdder addFirst (.result(result[0]), .A(A[0]), .B(B[0]), .cin(cin), .cout(carries[0]));
	genvar i;
	generate 
		for (i = 1; i < 64; i++) begin: otherAdds
			fullAdder theOtherAdders (.result(result[i]), .A(A[i]), .B(B[i]), .cin(carries[i-1]), .cout(carries[i]));
		end
	endgenerate
	
	assign cout = carries[63];
	
endmodule
