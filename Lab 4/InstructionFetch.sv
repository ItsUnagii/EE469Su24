`timescale 10ps/10ps

module instructionFetch (clk, reset, instruction, currentPC, branchAddress, brTaken);

	input logic [63:0] branchAddress;
	input logic clk, reset, brTaken;
	
	output logic [63:0] currentPC;
	output logic [31:0] instruction;
	
	logic [63:0] addedPC, nextPC;
	
	instructmem InstructionMemory (.address(currentPC), .instruction, .clk);
	
	// PC + 4
	fullAdder_64 PCIncrement (.result(addedPC), .A(currentPC), .B(64'd4), .cin(1'b0), .cout());
	
	// proceed as normal or branch
	mux2to1_64bit BranchMUX (.select(brTaken), .in({branchAddress, addedPC}), .out(nextPC));

	// PC
	ProgramCounter PC (.clk, .reset, .in(nextPC), .out(currentPC));

endmodule
