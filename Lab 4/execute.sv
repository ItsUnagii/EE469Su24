`timescale 10ps/10ps

module execute (clk, reset, EXDataA, EXDataB, EXALUSrc, EXALUOp, EXFlagWrite, EXImm12Ext, EXImm9Ext, EXALUOut, EXOverflow, EXNegative, EXZero, EXCarryout, BLTBrTaken);
	
	input  logic [63:0] EXDataA, EXDataB, EXImm12Ext, EXImm9Ext;
	input  logic [2:0]  EXALUOp;
   input  logic [1:0]  EXALUSrc;
   input  logic        EXFlagWrite, clk, reset;

	output logic [63:0] EXALUOut;
	output logic 		EXOverflow, EXNegative, EXZero, EXCarryout, BLTBrTaken;

	logic 	 Overflow, Negative, Zero, Carryout;
	logic		 NotEXFlagWrite, XorExNegOver, XorNegOver, AndFlagWriteXor, AndNotFlagWriteXor;
	
	// ALUSrc
	logic [63:0] ALUSrcOut;
	mux4to1_64bit ALUSrcMux (.select(EXALUSrc), .in({64'bx, EXImm9Ext, EXImm12Ext, EXDataB}), .out(ALUSrcOut));
	
	// ALU
	alu maths (.A(EXDataA), .B(ALUSrcOut), .cntrl(EXALUOp), .result(EXALUOut), .negative(Negative), .zero(Zero), .overflow(Overflow), .carry_out(Carryout));
	
	// flag register
	FlagReg TheFlagRegister (.clk, .reset, .enable(EXFlagWrite), .in({Negative, Carryout, Overflow, Zero}), .out({EXNegative, EXCarryout, EXOverflow, EXZero}));

	
	// BLTBRTaken Logic: (~EXFlagWrite & (EXNegative ^ EXOverflow)) | (EXFlagWrite & (Negative ^ Overflow))
	not #5 n0 (NotEXFlagWrite, EXFlagWrite);
	xor #5 x0 (XorExNegOver, EXNegative, EXOverflow);
	xor #5 x1 (XorNegOver, Negative, Overflow);
	and #5 a0 (AndFlagWriteXor, EXFlagWrite, XorNegOver);
	and #5 a1 (AndNotFlagWriteXor, NotEXFlagWrite, XorExNegOver);
	or  #5 o0 (BLTBrTaken, AndFlagWriteXor, AndNotFlagWriteXor);


endmodule 