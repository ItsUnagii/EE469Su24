`timescale 10ps/10ps

module CPU (clk, reset);

	input logic clk, reset;
	
	// ----- INSTRUCTION FETCH (IF) -----
	logic [63:0] FetchPC, IDBranchPC;
	logic [31:0] FetchInstr;
	logic IDBrTaken;
	
	instructionFetch IF (.clk, .reset, .instruction(FetchInstr), .currentPC(FetchPC), .branchAddress(IDBranchPC), .brTaken(IDBrTaken));
	
	
	// ----- IF -> ID REGISTER -----
	logic [63:0] IDPC;
	logic [31:0] IDInstr;
	
	instructionRegister IFtoID (.clk, .reset, .FetchPC, .FetchInstr, .IDPC, .IDInstr);
		
	
	// Control Signals
	// logic [31:0] Instruction;
	logic [2:0]  IDALUOp;
	logic [1:0]  IDALUSrc, IDMem2Reg;
	logic 		 IDBrSrc, IDReg2Loc, IDReg2Write, IDMemWrite, IDMemRead, IDUncondBr, IDFlagWrite, IDZero, BLTBrTaken, EXOverflow, EXNegative;
	
	controlSignal ctrlSig (.instruction(IDInstr), .ALUOp(IDALUOp), .ALUSrc(IDALUSrc), .Mem2Reg(IDMem2Reg), .BrTaken(IDBrTaken), .BrSrc(IDBrSrc), .Reg2Loc(IDReg2Loc), .Reg2Write(IDReg2Write), .RegWrite(IDRegWrite), .MemWrite(IDMemWrite), .MemRead(IDMemRead), .UncondBr(IDUncondBr), .ZeroFlag(IDZero), .FlagWrite(IDFlagWrite), .BLTBrTaken(BLTBrTaken));
	
	
	// ----- FORWARDING UNIT -----
	
	logic [4:0] IDAddressA, IDAddressB, EXAddressW, MEMAddressW;
	logic [1:0] ForwardA, ForwardB;
	logic       EXRegWrite, MEMRegWrite, WBRegWrite;

	forwardingUnit fwdUnit (.IDAddressA, .IDAddressB, .EXAddressW, .MEMAddressW, .EXRegWrite, .MEMRegWrite, .ForwardA, .ForwardB);
	
	
	// ----- INSTRUCTION DECODE (ID) -----
	logic [63:0] IDDataA, IDDataB, IDImm9Ext, IDImm12Ext; 
	logic [63:0] WBDataToReg, WBMuxOut, EXALUOut;
	logic [4:0]  IDAddressW, WBAddressW;
	
	instructionDecode ID (.clk, .reset, .IDPC, .IDInstr, .IDReg2Loc, .IDReg2Write, .IDUncondBr, .IDBrSrc, .WBDataToReg, .WBRegWrite, .WBAddressW, .IDAddressA, .IDAddressB, .IDAddressW, .IDDataA, .IDDataB, .IDImm12Ext, .IDImm9Ext, .IDBranchPC, .ForwardA, .ForwardB, .EXALUOut, .WBMuxOut, .IDZero); 
	
	
	// ----- ID -> EX REGISTER -----
	logic [63:0] EXDataA, EXDataB, EXImm9Ext, EXImm12Ext, EXIncrementedPC;
	logic [31:0] EXInstr;
	logic [2:0]  EXALUOp;
	logic [1:0] EXALUSrc, EXMem2Reg;
	logic EXMemWrite, EXMemRead, EXFlagWrite;

	decodeRegister IDtoEX (.clk, .reset, .IDIncrementedPC(FetchPC), .IDALUOp, .IDALUSrc, .IDMem2Reg, .IDRegWrite, .IDMemWrite, .IDMemRead, .IDFlagWrite, .IDAddressW, .IDDataA, .IDDataB, .IDImm12Ext, .IDImm9Ext, .EXIncrementedPC, .EXALUOp, .EXALUSrc, .EXMem2Reg, .EXRegWrite, .EXMemWrite, .EXMemRead, .EXFlagWrite, .EXAddressW, .EXDataA, .EXDataB, .EXImm12Ext, .EXImm9Ext);
	
	
	// ----- EXECUTE (EX) ----- 
	logic EXZero, EXCarryout;
	
	execute EX (.clk, .reset, .EXDataA, .EXDataB, .EXALUSrc, .EXALUOp, .EXFlagWrite, .EXImm12Ext, .EXImm9Ext, .EXALUOut, .EXOverflow, .EXNegative, .EXZero, .EXCarryout, .BLTBrTaken);
	
	
	// ----- EX -> MEM REGISTER -----
	logic [63:0] MEMIncrementedPC, MEMDataB, MEMALUOut;
	logic [1:0]  MEMMem2Reg;
	logic 		 MEMMemWrite, MEMMemRead;
	
	execRegister EXtoMEM (.clk, .reset, .EXIncrementedPC, .EXMem2Reg, .EXRegWrite, .EXMemWrite, .EXMemRead, .EXAddressW, .EXDataB, .EXALUOut, .MEMIncrementedPC, .MEMMem2Reg, .MEMRegWrite, .MEMMemWrite, .MEMMemRead, .MEMAddressW, .MEMDataB, .MEMALUOut);
	
	
	// ----- MEMORY (MEM) -----
	logic [63:0] MEMOut;
	
	memory MEM (.clk, .reset, .address(MEMALUOut), .MemWrite(MEMMemWrite), .MemRead(MEMMemRead), .MemWriteData(MEMDataB), .MEMOut);
	
	
	// ----- MEM -> WB REGISTER -----
	
	memoryRegister MEMtoWB (.clk, .reset, .MEMIncrementedPC, .MEMAddressW, .MEMALUOut, .MEMMem2Reg, .MEMRegWrite, .MEMOut, .WBAddressW, .WBDataToReg, .WBRegWrite, .WBMuxOut);
	
//	// Flag Signals
//	logic        FlagWrite, NegativeFlag, CoutFlag, OverflowFlag, ZeroFlag;
//
//	// Logic passed between modules
//	logic [63:0] Db, NoBranchPC;
//	logic 		 ALUZero;
//	
//	InstructionFetch instFetch (.clk, .reset, .Instruction, 
//											.BrTaken, .BrToReg, .UncondBr, .Db, .NoBranchPC);
//	
//	ControlSignal signal (.Instruction, .ALUOp, .ALUSrc, .Mem2Reg, .BrTaken, .BrToReg, 
//									.Reg2Loc, .Reg2Write, .RegWrite, .MemWrite, .MemRead, .UncondBr, 
//										.FlagWrite, .NegativeFlag, .CoutFlag, .OverflowFlag, .ZeroFlag, .ALUZero);
//										
//	Datapath data (.clk, .reset, .Instruction, .ALUOp, .ALUSrc, .Mem2Reg, .Reg2Loc,
//							.Reg2Write, .RegWrite, .MemWrite, .MemRead, .FlagWrite, .NegativeFlag, 
//								.CoutFlag, .OverflowFlag, .ZeroFlag, .ALUZero, .Db, .NoBranchPC, .XferSize(4'b1000));

endmodule 

module cpu_tb();
	logic clk, reset;
	
	CPU dut (.clk(clk), .reset(reset));
	
	parameter CLOCK_PERIOD = 10000;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	int i;
	initial begin
		reset = 1; @(posedge clk); @(posedge clk);
		reset = 0; @(posedge clk);
		for (i = 0; i < 100; i++) begin
			@(posedge clk);
		end
		$stop;
	end	
endmodule
