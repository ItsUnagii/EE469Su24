`timescale 10ps/10ps

module bitAND (A, B, out);
	input  logic [63:0] A, B;
	output logic [63:0] out;

	genvar i;
	generate
		for (i=0; i<64; i++) begin : bitwiseANDs
			and #5 (out[i], A[i], B[i]);
		end
	endgenerate
endmodule


module bitOR (A, B, out);
	input  logic [63:0] A, B;
	output logic [63:0] out;

	genvar i;
	generate
		for (i=0; i<64; i++) begin : bitwiseORs
			or #5 (out[i], A[i], B[i]);
		end
	endgenerate
endmodule


module bitXOR (A, B, out);
	input  logic [63:0] A, B;
	output logic [63:0] out;

	genvar i;
	generate
		for (i=0; i<64; i++) begin : bitwiseXORs
			xor #5 (out[i], A[i], B[i]);
		end
	endgenerate
endmodule