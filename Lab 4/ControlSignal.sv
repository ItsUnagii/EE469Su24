`timescale 10ps/10ps

module controlSignal (instruction, ALUOp, ALUSrc, Mem2Reg, BrTaken, BrSrc, Reg2Loc, Reg2Write, RegWrite, MemWrite, MemRead, UncondBr, ZeroFlag, FlagWrite, BLTBrTaken);
    
   input logic  [31:0] instruction;
   input logic 		  ZeroFlag, BLTBrTaken;

	output logic [2:0] ALUOp;
	output logic [1:0] ALUSrc, Mem2Reg;
   output logic 		 BrTaken, BrSrc, Reg2Loc, Reg2Write, RegWrite, MemWrite, MemRead, UncondBr, FlagWrite;
    
	 enum logic [10:0] {
		B    = 11'b000101xxxxx,
		BLT  = 11'b01010100XXX,
		BL   = 11'b100101XXXXX,
		BR   = 11'b11010110000,
		CBZ  = 11'b10110100XXX,
		ADDI = 11'b10010001000,
		ADDS = 11'b10101011000,
		SUBS = 11'b11101011000,
		LDUR = 11'b11111000010,
		STUR = 11'b11111000000
	 } OpCodes;
	 
    always_comb begin
		casex (instruction[31:21])
		
			B: begin
				ALUOp 	 = 3'bX;
				FlagWrite = 1'b0;
				UncondBr  = 1'b1;
				BrTaken   = 1'b1;
				BrSrc     = 1'b0;
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b0;
				Mem2Reg   = 2'bX;
				ALUSrc    = 2'bX;
				Reg2Loc   = 1'bX;
				Reg2Write = 1'bX;
			end
			
			BLT: begin
				ALUOp 	 = 3'bX;
				FlagWrite = 1'b0;
				UncondBr  = 1'b0;
				BrTaken   = BLTBrTaken;
				BrSrc     = 1'b0;
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b0;
				Mem2Reg   = 2'bX;
				ALUSrc    = 2'bX;
				Reg2Loc   = 1'bX;
				Reg2Write = 1'bX;
			end
			
			BL: begin
				ALUOp 	 = 3'bX;
				FlagWrite = 1'b0;
				UncondBr  = 1'b1;
				BrTaken   = 1'b1;
				BrSrc     = 1'b0;
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b1;
				Mem2Reg   = 2'b10;
				ALUSrc    = 2'bX;
				Reg2Loc   = 1'bX;
				Reg2Write = 1'b1;
			end

			BR: begin
				ALUOp 	 = 3'bX;
				FlagWrite = 1'b0;
				UncondBr  = 1'bX;
				BrTaken   = 1'b1;
				BrSrc     = 1'b1;
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b0;
				Mem2Reg   = 2'bX;
				ALUSrc    = 2'bX;
				Reg2Loc   = 1'b0;
				Reg2Write = 1'bX;
			end
			
			CBZ: begin
				ALUOp 	 = 3'b000;
				FlagWrite = 1'b0;
				UncondBr  = 1'b0;
				BrTaken   = ZeroFlag;
				BrSrc     = 1'b0;
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b0;
				Mem2Reg   = 2'bX;
				ALUSrc    = 2'b00;
				Reg2Loc   = 1'b0;
				Reg2Write = 1'bX;
			end
			
			ADDI: begin
				ALUOp 	 = 3'b010;
				FlagWrite = 1'b0;
				UncondBr  = 1'bX;
				BrTaken   = 1'b0;
				BrSrc     = 1'b0;
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b1;
				Mem2Reg   = 2'b00;
				ALUSrc    = 2'b01;
				Reg2Loc   = 1'bX;
				Reg2Write = 1'b0;
			end
			
			ADDS: begin
				ALUOp 	 = 3'b010;
				FlagWrite = 1'b1;
				UncondBr  = 1'bX;
				BrTaken   = 1'b0;
				BrSrc     = 1'b0;
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b1;
				Mem2Reg   = 2'b00;
				ALUSrc    = 2'b00;
				Reg2Loc   = 1'b1;
				Reg2Write = 1'b0;
			end
			
			SUBS: begin
				ALUOp 	 = 3'b011;
				FlagWrite = 1'b1;
				UncondBr  = 1'bX;
				BrTaken   = 1'b0;
				BrSrc     = 1'b0;
				MemWrite  = 1'b0;
				MemRead	 = 1'bX;
				RegWrite  = 1'b1;
				Mem2Reg   = 2'b00;
				ALUSrc    = 2'b00;
				Reg2Loc   = 1'b1;
				Reg2Write = 1'b0;
			end
			
			LDUR: begin
				ALUOp 	 = 3'b010;
				FlagWrite = 1'b0;
				UncondBr  = 1'bX;
				BrTaken   = 1'b0;
				BrSrc     = 1'b0;
				MemWrite  = 1'b0;
				MemRead	 = 1'b1;
				RegWrite  = 1'b1;
				Mem2Reg   = 2'b01;
				ALUSrc    = 2'b10;
				Reg2Loc   = 1'bX;
				Reg2Write = 1'b0;
			end
			
			STUR: begin
				ALUOp 	 = 3'b010;
				FlagWrite = 1'b0;
				UncondBr  = 1'bX;
				BrTaken   = 1'b0;
				BrSrc     = 1'b0;
				MemWrite  = 1'b1;
				MemRead	 = 1'bX;
				RegWrite  = 1'b0;
				Mem2Reg   = 2'bX;
				ALUSrc    = 2'b10;
				Reg2Loc   = 1'b0;
				Reg2Write = 1'b0;
			end
			
		endcase
	end
endmodule
