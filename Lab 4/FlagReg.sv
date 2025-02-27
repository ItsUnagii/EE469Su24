`timescale 10ps/10ps

module FlagReg (clk, reset, enable, in, out);

	input  logic [3:0] in; // {Negative, Cout, Overflow, Zero}
	input  logic 		 clk, reset, enable;
	
	output logic [3:0] out;
	
	logic [3:0] storeFlag;
	
	genvar i;
	generate
		for(i = 0; i < 4; i++) begin: eachFlag
			mux2to1 pick (.select(enable), .in({in[i], out[i]}), .out(storeFlag[i]));
			D_FF ff (.q(out[i]), .d(storeFlag[i]), .clk(clk), .reset(reset));
		end
		
	endgenerate
endmodule 