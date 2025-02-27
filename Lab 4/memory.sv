`timescale 10ps/10ps

module memory (clk, reset, address, MemWrite, MemRead, MemWriteData, MEMOut);
	 
	 input  logic [63:0] address, MemWriteData;
    input  logic        clk, reset, MemWrite, MemRead;
    
    output logic [63:0] MEMOut;

    datamem DataMemory (.address, .write_enable(MemWrite), .read_enable(MemRead), .write_data(MemWriteData), .clk, .xfer_size(4'b1000), .read_data(MEMOut));

endmodule