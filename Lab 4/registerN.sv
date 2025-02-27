module registerN #(parameter N = 64) (reset, clk, in, out);

   input  logic reset, clk;
	input  logic [N-1:0] in;
   
	output logic [N-1:0] out;
	
   
	genvar i;
	generate
		for (i=0; i < N; i++) begin : regDFFs
			D_FF ff (.q(out[i]), .d(in[i]), .reset, .clk);
		end
	endgenerate

endmodule 