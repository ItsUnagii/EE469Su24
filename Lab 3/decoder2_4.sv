`timescale 10ps/10ps

module decoder2_4 (in, out, en);
	input logic [1:0] in;
	input logic en;
	output logic [3:0] out;
	logic [1:0] not_in;
	
	not #5 n0 (not_in[0], in[0]);
	not #5 n1 (not_in[1], in[1]);
	
	and #5 a0 (out[0], not_in[0], not_in[1], en);
	and #5 a1 (out[1], in[0], not_in[1], en);
	and #5 a2 (out[2], not_in[0], in[1], en);
	and #5 a3 (out[3], in[0], in[1], en);
endmodule

module decoder3_8 (in, out, en);
	input logic [2:0] in;
	input logic en;
	output logic [7:0] out;
	logic [2:0] not_in;
	
	not #5 n0 (not_in[0], in[0]);
	not #5 n1 (not_in[1], in[1]);
	not #5 n2 (not_in[2], in[2]);
	
	and #5 a0 (out[0], not_in[0], not_in[1], not_in[2], en);
	and #5 a1 (out[1], in[0], not_in[1], not_in[2], en);
	and #5 a2 (out[2], not_in[0], in[1], not_in[2], en);
	and #5 a3 (out[3], in[0], in[1], not_in[2], en);
	and #5 a4 (out[4], not_in[0], not_in[1], in[2], en);
	and #5 a5 (out[5], in[0], not_in[1], in[2], en);
	and #5 a6 (out[6], not_in[0], in[1], in[2], en);
	and #5 a7 (out[7], in[0], in[1], in[2], en);	
endmodule

module decoder5_32 (in, out, en);
	input logic [4:0] in;
	input logic en;
	output logic [31:0] out;
	
	logic [3:0] temp;
	
	decoder2_4 d1 (.in(in[4:3]), .out(temp), .en);
	decoder3_8 d2 (.in(in[2:0]), .out(out[7:0]), .en(temp[0]));
	decoder3_8 d3 (.in(in[2:0]), .out(out[15:8]), .en(temp[1]));
	decoder3_8 d4 (.in(in[2:0]), .out(out[23:16]), .en(temp[2]));
	decoder3_8 d5 (.in(in[2:0]), .out(out[31:24]), .en(temp[3]));
endmodule
