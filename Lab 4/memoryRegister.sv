`timescale 10ps/10ps

module memoryRegister (clk, reset, MEMIncrementedPC, MEMAddressW, MEMALUOut, MEMMem2Reg, MEMRegWrite, MEMOut, WBAddressW, WBDataToReg, WBRegWrite, WBMuxOut);
    
   input  logic        clk, reset;
	input  logic 		  MEMRegWrite;
   input  logic [1:0]  MEMMem2Reg;
   input  logic [4:0]  MEMAddressW;
   input  logic [63:0] MEMIncrementedPC, MEMOut, MEMALUOut;

	output logic 		  WBRegWrite;
	output logic [4:0]  WBAddressW;
   output logic [63:0] WBDataToReg, WBMuxOut;
	
	mux4to1_64bit MuxRegWriteBack (.select(MEMMem2Reg), .in({64'bX, MEMIncrementedPC, MEMOut, MEMALUOut}), .out(WBMuxOut));
	 
	registerN #(.N(64)) WBDataReg (.reset, .clk, .in(WBMuxOut), .out(WBDataToReg));
   registerN #(.N(5)) RdReg (.reset, .clk, .in(MEMAddressW), .out(WBAddressW));

   D_FF RegWriteReg (.q(WBRegWrite), .d(MEMRegWrite), .reset, .clk);

endmodule