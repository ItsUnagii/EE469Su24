`timescale 10ps/10ps

module nor_64 (in, out);
	input logic [63:0] in;
	output logic out;
	
	logic [15:0] signal_nor;
	logic [3:0]  signal_and;
	
	genvar i;
	generate
		for (i = 0; i < 16; i++) begin : nor_results
			nor #5 norResults (signal_nor[i], in[4*i], in[4*i+1], in[4*i+2], in[4*i+3]);
		end
	endgenerate
	
	generate
		for (i = 0; i < 4; i++) begin : and_results
			and #5 andResults (signal_and[i], signal_nor[4*i], signal_nor[4*i+1], signal_nor[4*i+2], signal_nor[4*i+3]);
		end
	endgenerate
	
	and #5 zeroAnd (out, signal_and[0], signal_and[1], signal_and[2], signal_and[3]);
endmodule 