`timescale 1ns/10ps

module InstructionFetch ( clk, 
								  reset,
								  Instruction, 
								  BrTaken, 
								  BrToReg,
								  UncondBr,
								  Db, 
								  NoBranchPC );
								  
	input  logic [63:0] Db;
	input  logic BrTaken, BrToReg, clk, reset, UncondBr;
	
	output logic [63:0] NoBranchPC;
	output logic [31:0] Instruction;
	
	logic [63:0] condAddr, uncondAddr, brAddr, shiftedAddr, brPcAddr, currentPC, updatedPC;
	
	instructmem InstructionMemory (.address(currentPC), .instruction(Instruction), .clk);
	
	// PC + 4
	fullAdder_64 advancePc (.result(NoBranchPC), .A(currentPC), .B(64'd4), .cin(1'b0), .cout());
	
	// Sign Extend the address inputs
	// Instruction[23:5] conditional address (19 bits)
	// Instruction[25:0] unconditional address (26 bits)
	SignExtend #(.width(19)) ExtendCondAddr (.in(Instruction[23:5]), .out(condAddr));
	SignExtend #(.width(26)) ExtendBrAddr (.in(Instruction[25:0]), .out(uncondAddr));
	
	// pick which one to use based on if its an unconditional branch
	mux2to1_Nbit #(.N(64)) muxCond (.en(UncondBr), .a(condAddr), .b(uncondAddr), .out(brAddr));
	
	// multiply brAdder by 4
	shifter shiftBranchAddress (.value(brAddr), .direction(1'b0), .distance(6'b000010), .result(shiftedAddr));

	// Add the shiftedAddr with currentPC
	fullAdder_64 addAddress (.result(brPcAddr), .A(currentPC), .B(shiftedAddr), .cin(1'b0), .cout());

	// Determine if branch instruction was given or not
	// if it was given, store branched PC address in updatedPC to be sent into PC module
	mux4to1_64bit MuxBranch (.select({BrToReg, BrTaken}), .in({64'b0, Db, brPcAddr, NoBranchPC}), .out(updatedPC));

	// Register that hold the ProgramCounter
	// Current PC gets fed into instruction memory
	ProgramCounter PC (.clk, .reset, .in(updatedPC), .out(currentPC));
endmodule 