module SignExtend #(parameter width = 5) (in, out);
	
	// make parameter for modular sign extensions
	// extends any width to 64
	
	input  logic [width-1:0] in;
	
	output logic [63:0]  out;

	assign out[63:width] = {(64-width){in[width-1]}};	
	assign out[width-1:0] = in[width-1:0];
	
endmodule
	