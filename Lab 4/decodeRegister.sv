module decodeRegister (clk, reset, IDIncrementedPC, IDALUOp, IDALUSrc, IDMem2Reg, IDRegWrite, IDMemWrite, IDMemRead, IDFlagWrite, IDAddressW, IDDataA, IDDataB, IDImm12Ext, IDImm9Ext, EXIncrementedPC, EXALUOp, EXALUSrc, EXMem2Reg, EXRegWrite, EXMemWrite, EXMemRead, EXFlagWrite, EXAddressW, EXDataA, EXDataB, EXImm12Ext, EXImm9Ext);
    
    input  logic        clk, reset;
    input  logic [63:0] IDIncrementedPC, IDDataA, IDDataB, IDImm9Ext, IDImm12Ext;
    input  logic [4:0]  IDAddressW;
    input  logic [2:0]  IDALUOp;
    input  logic [1:0]  IDMem2Reg, IDALUSrc;
    input  logic        IDMemWrite, IDMemRead, IDRegWrite, IDFlagWrite;
    
    output logic [63:0] EXIncrementedPC, EXDataA, EXDataB, EXImm9Ext, EXImm12Ext;
    output logic [4:0]  EXAddressW;
    output logic [2:0]  EXALUOp;
    output logic [1:0]  EXMem2Reg, EXALUSrc;
    output logic        EXMemWrite, EXMemRead, EXRegWrite, EXFlagWrite;

	 // DFF ID values into EX values
	 
    // make registers
    register64 PCReg (.reset, .clk, .write(1'b1), .in(IDIncrementedPC), .out(EXIncrementedPC));
    register64 DaReg (.reset, .clk, .write(1'b1), .in(IDDataA), .out(EXDataA));
    register64 DbReg (.reset, .clk, .write(1'b1), .in(IDDataB), .out(EXDataB));
    register64 Imm9Reg (.reset, .clk, .write(1'b1), .in(IDImm9Ext), .out(EXImm9Ext));
    register64 Imm12Reg (.reset, .clk, .write(1'b1), .in(IDImm12Ext), .out(EXImm12Ext));

    // register address regs
    registerN #(.N(5)) RdReg (.reset, .clk, .in(IDAddressW), .out(EXAddressW));

    // control logic regs
    registerN #(.N(3)) ALUOpReg (.reset, .clk, .in(IDALUOp), .out(EXALUOp));
    registerN #(.N(2)) ALUSrcReg (.reset, .clk, .in(IDALUSrc), .out(EXALUSrc));
    registerN #(.N(2)) Mem2RegReg (.reset, .clk, .in(IDMem2Reg), .out(EXMem2Reg));
	 
    D_FF MemWriteReg (.q(EXMemWrite), .d(IDMemWrite), .reset, .clk);
    D_FF MemReadReg (.q(EXMemRead), .d(IDMemRead), .reset, .clk);
    D_FF RegWriteReg (.q(EXRegWrite), .d(IDRegWrite), .reset, .clk);
    D_FF FlagWriteReg (.q(EXFlagWrite), .d(IDFlagWrite), .reset, .clk);

endmodule