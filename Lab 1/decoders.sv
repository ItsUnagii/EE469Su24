`timescale 10ps/10ps

module decode1to2 (in, out, enable);
	input logic in, enable;
	output logic [1:0] out;
	
	logic temp;
	
	not #5 not0 (temp, in);
	and #5 and0 (out[0], enable, temp);
	and #5 and1 (out[1], enable, in);

endmodule


module decode2to4(in, out, enable) ;
	input  logic [1:0] in;
	input  logic       enable;
	output logic [3:0] out;
	
	logic [1:0] temp;
	
	not #5 not0 (temp[0], in[0]);
	not #5 not1 (temp[1], in[1]);
	and #5 and0 (out[0], enable, temp[0], temp[1]);
	and #5 and1 (out[1], enable, in[0],   temp[1]);
	and #5 and2 (out[2], enable, temp[0], in[1]);
	and #5 and3 (out[3], enable, in[0],   in[1]);

endmodule


module decode3to8 (in, out, enable);
	input  logic [2:0] in;
	input  logic       enable;
	output logic [7:0] out;
	
	logic [1:0] temp;
	
	decode1to2 decode0 (.in(in[2]),   .out(temp[1:0]), .enable(enable));
	decode2to4 decode1 (.in(in[1:0]), .out(out[3:0]),  .enable(temp[0]));
	decode2to4 decode2 (.in(in[1:0]), .out(out[7:4]),  .enable(temp[1]));	
endmodule


module decoder5to32(in, out, enable);
	input  logic [4:0]  in;
	input  logic        enable;
	output logic [31:0] out;
	
	logic [3:0] temp;
	
	decode2to4 decode0 (.in(in[4:3]), .out(temp[3:0]),  .enable(enable));
	decode3to8 decode1 (.in(in[2:0]), .out(out[7:0]),   .enable(temp[0]));
	decode3to8 decode2 (.in(in[2:0]), .out(out[15:8]),  .enable(temp[1]));
	decode3to8 decode3 (.in(in[2:0]), .out(out[23:16]), .enable(temp[2]));
	decode3to8 decode4 (.in(in[2:0]), .out(out[31:24]), .enable(temp[3]));
	
endmodule