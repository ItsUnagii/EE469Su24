`timescale 10ps/10ps

module forwardingUnit (IDAddressA, IDAddressB, EXAddressW, MEMAddressW, EXRegWrite, MEMRegWrite, ForwardA, ForwardB);
	input  logic [4:0] IDAddressA, IDAddressB, EXAddressW, MEMAddressW;
	input  logic       EXRegWrite, MEMRegWrite;
	
	output logic [1:0] ForwardA, ForwardB; 
	// 00 - no fwd
	// 01 - forward from EX
	// 10 - forward from MEM
	
	always_comb begin
		if (EXRegWrite && (EXAddressW == IDAddressA) && (EXAddressW != 5'd31)) begin
			// if:
			// - EX is writing to reg
			// - write reg in EX is needed in ID
			// - EX isn't writing to X31
			// forward from EX
			ForwardA = 2'b01;
		end
		else if (MEMRegWrite && (MEMAddressW != 5'd31) && (MEMAddressW == IDAddressA) && (~EXRegWrite || (EXAddressW != IDAddressA) || (EXAddressW == 5'd31))) begin
			// if:
			// - MEM is writing to reg
			// - MEM is not writing to X31
		   // - write reg in MEM is needed in ID
		   // - not writing in EX, EX isn't writing to ID read reg, or EX is writing to X31 (stop hazards)
			// forward from MEM
			ForwardA = 2'b10;
		end
		else begin
			ForwardA = 2'b00;
		end
		
		// do it again for register b
		if (EXRegWrite && (EXAddressW == IDAddressB) && (EXAddressW != 5'd31)) begin
			ForwardB = 2'b01;
		end
		else if (MEMRegWrite && (MEMAddressW != 5'd31) && (MEMAddressW == IDAddressB) && (~EXRegWrite || (EXAddressW != IDAddressB) || (EXAddressW== 5'd31))) begin
			ForwardB = 2'b10;
		end
		else begin
			ForwardB = 2'b00;
		end
	end

endmodule 
