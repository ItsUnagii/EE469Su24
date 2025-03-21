`timescale 10ps/10ps

module execRegister (clk, reset, EXIncrementedPC, EXMem2Reg, EXRegWrite, EXMemWrite, EXMemRead, EXAddressW, EXDataB, EXALUOut, MEMIncrementedPC, MEMMem2Reg, MEMRegWrite, MEMMemWrite, MEMMemRead, MEMAddressW, MEMDataB, MEMALUOut);
	
    input  logic        clk, reset;
    input  logic [63:0] EXIncrementedPC, EXDataB, EXALUOut;
    input  logic [4:0]  EXAddressW;
    input  logic [1:0]  EXMem2Reg;
    input  logic        EXMemWrite, EXMemRead, EXRegWrite;

    output logic [63:0] MEMIncrementedPC, MEMDataB, MEMALUOut;
    output logic [4:0]  MEMAddressW;
    output logic [1:0]  MEMMem2Reg;
    output logic        MEMMemWrite, MEMMemRead, MEMRegWrite;

    // make 64 bit regs
    register64 ALUOutReg (.reset, .clk, .write(1'b1), .in(EXALUOut), .out(MEMALUOut));
    register64 DbReg (.reset, .clk, .write(1'b1), .in(EXDataB), .out(MEMDataB));
	 register64 PCReg (.reset, .clk, .write(1'b1), .in(EXIncrementedPC), .out(MEMIncrementedPC));
	 
    // register address regs
    registerN #(.N(5)) RnReg (.reset, .clk, .in(EXAddressW), .out(MEMAddressW));
    registerN #(.N(2)) Mem2RegReg (.reset, .clk, .in(EXMem2Reg), .out(MEMMem2Reg));

    D_FF MEMWriteReg (.q(MEMMemWrite), .d(EXMemWrite), .reset, .clk);
    D_FF MEMReadReg (.q(MEMMemRead), .d(EXMemRead), .reset, .clk);
    D_FF RegWriteReg (.q(MEMRegWrite), .d(EXRegWrite), .reset, .clk);

endmodule
