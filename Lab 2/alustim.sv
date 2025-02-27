// Test bench for ALU
`timescale 1ns/10ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

module alustim();

	parameter delay = 100000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	logic [63:0] test_val;
	initial begin
	
		$display("%t testing PASS_A operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end
		
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		
		// 1 + 1
		A = 64'd1; B = 64'd1;
		#(delay);
		assert(result == 64'd2 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		// biggest number + 1
		//	max positive value is 0111...111 which is 7FFF...FFF in hex
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'd1;
		#(delay);
		assert(result == 64'h8000000000000000 && carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);
		
		// 1 + -1
		A = 64'd1; B = -(64'd1);
		#(delay);
		assert(result == 64'd0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
		
		// 0 + 0
		A = 64'd0; B = 64'd0;
		#(delay);
		assert(result == 64'd0 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 1);
		
		// -1 + -1
		A = -(64'd1); B = -(64'd1);
		#(delay);
		assert(result == -(64'd2) && carry_out == 1 && overflow == 0 && negative == 1 && zero == 0);
		
		// 16 + -1
		A = 64'd16; B = -(64'd1);
		#(delay);
		assert(result == 64'd15 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 0);
		
		
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		
		// normal subtraction
		// 2 - 1
		A = 64'd2; B = 64'd1;
		#(delay);
		assert(result == 64'd1 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 0);
		
		// subtracting 0
		// 0 - 0
		A = 64'd0; B = 64'd0;
		#(delay);
		assert(result == 64'd0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
		
		// negative result subtraction
		// 1 - 2
		A = 64'd1; B = 64'd2;
		#(delay);
		assert(result == -(64'd1) && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0);
		
		// negative overflow - 800...000 is the most negative number
		// biggest negative - 1
		A = 64'h8000000000000000; B = 64'd1;
		#(delay);
		assert(result == 64'h7FFFFFFFFFFFFFFF && carry_out == 1 && overflow == 1 && negative == 0 && zero == 0);
		
		// negative - positive
		// -1 - 1
		A = -(64'd1); B = 64'd1;
		#(delay);
		assert(result == -(64'd2) && carry_out == 1 && overflow == 0 && negative == 1 && zero == 0);
		
		// positive - negative
		// 1 - -1
		A = 64'd1; B = -(64'd1);
		#(delay);
		assert(result == 64'd2 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		// negative - negative
		// -1 - -1
		A = -(64'd1); B = -(64'd1);
		#(delay);
		assert(result == 64'd0 && carry_out == 1 && overflow == 0 && negative == 0 && zero == 1);
		
		$display("%t testing AND", $time);
		cntrl = ALU_AND;
		
		// 0101 & 0011 = 0001
		A = 64'h0000000000000005; B = 64'h0000000000000003;
		#(delay);
		assert(result == 64'h0000000000000001 && negative == 0 && zero == 0);
		
		$display("%t testing OR", $time);
		cntrl = ALU_OR;
		
		// 0101 v 0011 = 0111
		A = 64'h0000000000000005; B = 64'h0000000000000003;
		#(delay);
		assert(result == 64'h0000000000000007 && negative == 0 && zero == 0);
		
		$display("%t testing XOR", $time);
		cntrl = ALU_XOR;
		
		// 0101 ^ 0011 = 0110
		A = 64'h0000000000000005; B = 64'h0000000000000003;
		#(delay);
		assert(result == 64'h0000000000000006 && negative == 0 && zero == 0);
		
	end
endmodule
