module regfile (ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
	input  logic        RegWrite, clk;
	input  logic [4:0]  ReadRegister1, ReadRegister2, WriteRegister;
	input  logic [63:0] WriteData;
	output logic [63:0] ReadData1, ReadData2;
	
	logic [31:0] registerWrite;
	logic [63:0] registerData [31:0];
	
	// decodign
	// 5:32 enable decoder?
	decoder5to32 decoder (.in(WriteRegister), .out(registerWrite), .enable(RegWrite));
	
	// registers
	generate
		genvar i;
		for (i=0; i<31; i++) begin : allRegisters
			// write stuff to each register
			register regs (.in(WriteData), .out(registerData[i]), .enable(registerWrite[i]), .clk(clk));
		end
	endgenerate
	
	assign registerData[31] = 64'b0; // set to all 0s
	
	// 2 larg 32x64 to 64 output muxes
	mux64 one (.in(registerData), .out(ReadData1), .read(ReadRegister1));
	mux64 two (.in(registerData), .out(ReadData2), .read(ReadRegister2));

endmodule