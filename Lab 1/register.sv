module register (in, out, enable, clk);
	
	input logic [63:0] in;
	input logic enable, clk;
	
	output logic [63:0] out;
	
	logic [63:0] d; 
	
	generate
		genvar i; 
		for (i = 0; i < 64; i++) begin : set
			mux2to1 pick (.data({in[i], out[i]}), .out(d[i]), .sel(enable));
			D_FF    ff   (.q(out[i]), .d(d[i]), .reset(1'b0), .clk(clk));
		end
	endgenerate
endmodule

