`timescale 10ps/10ps

module register64 (reset, clk, write, in, out);
	
	input  logic 		  reset, clk, write;
	input  logic [63:0] in;
	output logic [63:0] out;
	
	logic [63:0] storeData;
	
	genvar i;
	generate
		for (i=0; i < 64; i++) begin : regFFs
			mux2to1 dSel (.select(write), .in({in[i], out[i]}), .out(storeData[i]));
			D_FF 	  ff   (.q(out[i]), .d(storeData[i]), .reset(reset), .clk(clk));
		end
	endgenerate
endmodule 
