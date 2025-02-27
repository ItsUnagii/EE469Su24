module instructionRegister (clk, reset, FetchPC, FetchInstr, IDPC, IDInstr);
    
    input  logic        clk, reset;
    input  logic [31:0] FetchInstr;
	 input  logic [63:0] FetchPC;

    output logic [31:0] IDInstr;
	 output logic [63:0] IDPC;

    // regs
    registerN #(.N(32)) InstructionRegister (.reset, .clk, .in(FetchInstr), .out(IDInstr));
	 registerN #(.N(64)) PCRegister (.reset, .clk, .in(FetchPC), .out(IDPC));

endmodule 