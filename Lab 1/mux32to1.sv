`timescale 10ps/10ps

module mux2to1(data, sel, out);

	input  logic [1:0] data;
	input  logic sel;
	output logic out;
	
	logic selBar;
	logic andStore [1:0]; 
	
	// logic: out = (data[1] & sel) | (data[0] & ~sel);
	
	not #5 not0 (selBar, sel);
	and #5 and0 (andStore[0], data[1], sel);
	and #5 and1 (andStore[1], data[0], selBar);
	or  #5 or0  (out, andStore[0], andStore[1]);
	
endmodule


module mux4to1 (data, sel, out);
	output logic  out;

	input logic [3:0] data;
	input logic [1:0] sel;

	logic [3:0] temp;
	logic [1:0] selBar;

	not #50 not0 (selBar[0], sel[0]);
	not #50 not1 (selBar[1], sel[1]);

	and #50 and0 (temp[0], data[0], selBar[0], selBar[1]);
	and #50 and1 (temp[1], data[1], sel[0], selBar[1]);
	and #50 and2 (temp[2], data[2], selBar[0], sel[1]);
	and #50 and3 (temp[3], data[3], sel[0], sel[1]);

	or #50 or0 (out, temp[0], temp[1], temp[2], temp[3]);

	// out = (data[0] & ~sel[0] & ~sel[1]) | (data[1] & sel[0] & ~sel[1]) | (data[2] & ~sel[0] & sel[1]) | (data[3] & sel[0] & sel[1])
	// temp helps store each of these 4 arrays
	// could have done this with 2to1s tbh
	
endmodule


module mux8to1(data, sel, out);
	
	input  logic [7:0] data;
	input  logic [2:0] sel;
	output logic out;
	
	logic muxOut[1:0];
	
	mux4to1 mux0 (.data(data[3:0]),   .sel(sel[1:0]), .out(muxOut[0]));
	mux4to1 mux1 (.data(data[7:4]),   .sel(sel[1:0]), .out(muxOut[1]));
	mux2to1 mux2 (.data(muxOut[1:0]), .sel(sel[2]), .out);

endmodule


module mux16to1(data, sel, out);

	input  logic [15:0] data;
	input  logic [3:0] sel;
	output logic out;
	
	logic muxOut[1:0];
	
	mux8to1 mux0 (.data(data[7:0]),   .sel(sel[2:0]), .out(muxOut[0]));
	mux8to1 mux1 (.data(data[15:8]),  .sel(sel[2:0]), .out(muxOut[1]));
	mux2to1 mux2 (.data(muxOut[1:0]), .sel(sel[3]),   .out);

endmodule

module mux32to1 (data, out, sel);
	output logic out;

	input logic [31:0] data;
	input logic [4:0] sel;

	logic [7:0] temp1;
	logic [1:0] temp2;

	generate
		genvar i;
		for (i=0; i<8; i++) begin : forloop
			mux4to1 setupMuxes (.data(data[(i*4)+3:i*4]), .out(temp1[i]), .sel(sel[1:0]));
		end
	endgenerate

	mux4to1 mux0 (.data(temp1[3:0]), .sel(sel[3:2]), .out(temp2[0]));
	mux4to1 mux1 (.data(temp1[7:4]), .sel(sel[3:2]), .out(temp2[1]));

	mux2to1 mux2 (.data(temp2), .out(out), .sel(sel[4]));
endmodule


module mux64 (in, out, read);
	output logic [63:0] out;

	input logic [4:0] read;
	input logic [63:0] in [31:0];

	logic [31:0] temp [63:0]; 

	generate
		genvar i, j;
		for (i=0; i < 64; i++) begin : bits
			for (j=0; j < 32; j++) begin : registers
				assign temp[i][j] = in[j][i];
			end
			mux32to1 choose (.data(temp[i]), .sel(read), .out(out[i]));
		end
	endgenerate


endmodule
