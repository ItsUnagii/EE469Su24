`timescale 10ps/10ps

module instructionDecode (clk, reset, IDPC, IDInstr, IDReg2Loc, IDReg2Write, IDUncondBr, IDBrSrc, WBDataToReg, WBRegWrite, WBAddressW, IDAddressA, IDAddressB, IDAddressW, IDDataA, IDDataB, IDImm12Ext, IDImm9Ext, IDBranchPC, ForwardA, ForwardB, EXALUOut, WBMuxOut, IDZero);
    
    input  logic        clk, reset, IDReg2Loc, IDUncondBr, IDBrSrc, WBRegWrite, IDReg2Write;
    input  logic [63:0] IDPC, WBDataToReg, EXALUOut, WBMuxOut;
    input  logic [31:0] IDInstr;
	 input  logic [4:0]  WBAddressW;
	 input  logic [1:0]  ForwardA, ForwardB;

    output logic [63:0] IDDataA, IDDataB;
    output logic [4:0]  IDAddressA, IDAddressB, IDAddressW;
    output logic [63:0] IDImm9Ext, IDImm12Ext, IDBranchPC;
	 output logic 			IDZero;
	 
	 assign IDAddressA = IDInstr[9:5];
	
	// Reg2Write Mux
	// Determines which write register address in ID (Rd or X30)
	mux2to1_Nbit #(.N(5)) MuxReg2Write (.en(IDReg2Write), .a(IDInstr[4:0]), .b(5'd30), .out(IDAddressW));

   // Reg2Loc Mux
	// Determines which B register address (Rd or Rm)
	mux2to1_Nbit #(.N(5)) MuxReg2Loc (.en(IDReg2Loc), .a(IDInstr[4:0]), .b(IDInstr[20:16]), .out(IDAddressB));

    /* Register File for the CPU 
     * ReadData1 = IDDataA, ReadData2 = IDDataB, WriteData = WBDataToReg
     * Regfile will be updated at WB stage
     * RegWrite will signal whether or not it's ID or WB stage
     */
	 logic [63:0] RegDataA, RegDataB;
    regfile RegisterFile (.ReadData1(RegDataA), .ReadData2(RegDataB), .WriteData(WBDataToReg)
                        , .ReadRegister1(IDAddressA), .ReadRegister2(IDAddressB), .WriteRegister(WBAddressW)
                        , .RegWrite(WBRegWrite), .clk(~clk));
	 
	 mux4to1_64bit FwdAMux (.select(ForwardA), .in({64'bx, WBMuxOut, EXALUOut, RegDataA}), .out(IDDataA));
	 mux4to1_64bit FwdBMux (.select(ForwardB), .in({64'bx, WBMuxOut, EXALUOut, RegDataB}), .out(IDDataB));
	 
	 nor_64 CheckDbForZero (.in(IDDataB), .out(IDZero));
	 
   // Imm12Ext
	// (extended IDInstr[21:10])
	SignExtend #(.width(13)) ExtendImm12 (.in({1'b0, IDInstr[21:10]}), .out(IDImm12Ext));
	
	// MemAddr9Ext
	// (extended IDInstr[20:12])
	SignExtend #(.width(9)) ExtendImmMem (.in(IDInstr[20:12]), .out(IDImm9Ext));

	logic [63:0] brAddrExt, condAddrExt, IDImmBranch;
	SignExtend #(.width(26)) ExtendBrAddr (.in(IDInstr[25:0]), .out(brAddrExt));
	SignExtend #(.width(19)) ExtendCondAddr (.in(IDInstr[23:5]), .out(condAddrExt));
	
	mux2to1_64bit uncondMux (.select(IDUncondBr), .in({brAddrExt, condAddrExt}), .out(IDImmBranch));
	
	logic [63:0] shiftedAddr, adderResult;
	
	// if branched, update outputs accordingly
	shifter timesFour (.value(IDImmBranch), .direction(1'b0), .distance(6'b000010), .result(shiftedAddr));
	fullAdder_64 branchAdder (.result(adderResult), .A(IDPC), .B(shiftedAddr), .cin(1'b0), .cout());
	
	mux2to1_64bit theBrMux (.select(IDBrSrc), .in({IDDataB, adderResult}), .out(IDBranchPC));

endmodule
	