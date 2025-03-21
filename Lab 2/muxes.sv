`timescale 10ps/10ps

module mux2to1 (sel, in, out);
	input  logic 		 sel;
	input  logic [1:0] in;
	output logic 	    out;
	
	logic selBar;
	logic [1:0] andStore;
	
	not #5 not0 (selBar, sel);
	and #5 not1 (andStore[0], selBar, in[0]);
	and #5 and0 (andStore[1], sel,    in[1]);
	or  #5 or1  (out, andStore[0], andStore[1]);
endmodule 


module mux4to1 (sel, in, out);
	input  logic [1:0] sel;
	input  logic [3:0] in;
	output logic 	    out;
	
	logic [1:0] muxOut;
	
	mux2to1 mux0 (.sel(sel[0]), .in(in[1:0]), .out(muxOut[0]));
	mux2to1 mux1 (.sel(sel[0]), .in(in[3:2]), .out(muxOut[1]));
	mux2to1 mux2 (.sel(sel[1]), .in(muxOut),  .out(out));
endmodule 

module mux8to1 (sel, in, out);
	input  logic [2:0] sel;
	input  logic [7:0] in;
	output logic 	    out;
	
	logic [1:0] muxOut;
	
	mux4to1 mux0 (.sel(sel[1:0]), .in(in[3:0]), .out(muxOut[0]));
	mux4to1 mux1 (.sel(sel[1:0]), .in(in[7:4]), .out(muxOut[1]));
	mux2to1 mux2 (.sel(sel[2]), .in(muxOut),  .out(out));
endmodule 