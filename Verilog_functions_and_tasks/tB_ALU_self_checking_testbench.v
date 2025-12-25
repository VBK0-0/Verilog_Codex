`timescale 1us/1ns

module tB_ALU_self_checking_testbench();
	
	// Testbench variables
    parameter BUS_WIDTH = 8;
    reg  [3:0] opcode;
    reg [BUS_WIDTH-1:0] a, b;
    reg carry_in;
    wire [BUS_WIDTH-1:0] y;
    wire carry_out;
    wire borrow;
    wire zero;
    wire parity;
    wire invalid_op;
	
	// Define a list of opcodes
	localparam OP_ADD 		 = 1;  // A + B
	localparam OP_ADD_CARRY  = 2;  // A + B + Carry
	localparam OP_SUB 		 = 3;  // Subtract B from A
	localparam OP_INC 		 = 4;  // Increment A
	localparam OP_DEC		 = 5;  // Decrement A
	localparam OP_AND 		 = 6;  // Bitwise AND
	localparam OP_NOT  	     = 7;  // Bitwise NOT
	localparam OP_ROL        = 8;  // Rotate Left
	localparam OP_ROR 		 = 9;  // Rotate Right
	integer success_count = 0, error_count = 0, test_count = 0, i = 0;
	
    // Instantiate the DUT 
    ALU_self_checking_testbench
    // Parameters section
    #(.BUS_WIDTH(BUS_WIDTH))
    ALU0
   (.a(a),
   .b(b),
   .carry_in  (carry_in  ),
   .opcode    (opcode    ),
   .y		  (y         ),
   .carry_out (carry_out ),
   .borrow    (borrow    ),
   .zero      (zero      ),
   .parity,
   .invalid_op(invalid_op)
    );
  

	// This is used to model the ALU behavior at testbench level
	// for creating the expected data.
	// model_ALU = (invalid_op, parity, zero, borrow, carry_out, [BUS_WIDTH-1:0] y)
	function [BUS_WIDTH+4:0] model_ALU(input [3:0] opcode,
									   input [BUS_WIDTH-1:0] a,
									   input [BUS_WIDTH-1:0] b,
									   input carry_in);
			// Local variables used to model the ALU behavior
			reg [BUS_WIDTH-1:0] y;
			reg carry_out;
			reg borrow;
			reg zero;
			reg parity;
			reg invalid_op;
			
			begin
				y = 0; carry_out = 0; borrow = 0; invalid_op = 0;
				case (opcode)
					OP_ADD		   : begin {carry_out, y} = a + b; end //different than the RTL
					OP_ADD_CARRY   : begin {carry_out, y} = a + b + carry_in; end
					OP_SUB		   : begin {borrow, y} = a - b; end
					OP_INC   	   : begin {carry_out, y} = a + 1'b1; end
					OP_DEC		   : begin {borrow, y} = a - 1'b1; end
					OP_AND		   : begin y = a & b; end
					OP_NOT		   : begin y = ~a; end
					OP_ROL   	   : begin y = {a[BUS_WIDTH-2:0], a[BUS_WIDTH-1]}; end
					OP_ROR		   : begin y = {a[0], a[BUS_WIDTH-1:1]}; end
					default: begin invalid_op = 1; y = 0; carry_out = 0; borrow = 0; end
				endcase
				
				parity = ^y;
				zero = (y == 0);
				model_ALU = {invalid_op, parity, zero, borrow, carry_out, y};
			end
		endfunction
		
		// Compare the outputs of ALU with the outputs of the model_ALU
		task compare_data(input [BUS_WIDTH+4:0] expected_ALU, input [BUS_WIDTH+4:0] observed_ALU);
			begin
			
				if (expected_ALU === observed_ALU) begin // Use case equality operator
					$display($time, " SUCCESS \t EXPECTED invalid_op=%0d, parity=%b, zero=%b, borrow=%b, carry_out=%b, y=%b",
									  expected_ALU[BUS_WIDTH+4], expected_ALU[BUS_WIDTH+3],expected_ALU[BUS_WIDTH+2],
									  expected_ALU[BUS_WIDTH+1], expected_ALU[BUS_WIDTH],  expected_ALU[BUS_WIDTH-1]);
					$display($time, "         \t OBSERVED invalid_op=%0d, parity=%b, zero=%b, borrow=%b, carry_out=%b, y=%b",
									  observed_ALU[BUS_WIDTH+4], observed_ALU[BUS_WIDTH+3], observed_ALU[BUS_WIDTH+2], 
									  observed_ALU[BUS_WIDTH+1], observed_ALU[BUS_WIDTH],  observed_ALU[BUS_WIDTH-1:0]);
					success_count = success_count + 1;
				end else begin
					$display($time, " ERROR \t EXPECTED invalid_op=%0d, parity=%b, zero=%b, borrow=%b, carry_out=%b, y=%b",
									  expected_ALU[BUS_WIDTH+4], expected_ALU[BUS_WIDTH+3],expected_ALU[BUS_WIDTH+2],
									  expected_ALU[BUS_WIDTH+1], expected_ALU[BUS_WIDTH],  expected_ALU[BUS_WIDTH-1]);
					$display($time, "         \t OBSERVED invalid_op=%0d, parity=%b, zero=%b, borrow=%b, carry_out=%b, y=%b",
									  observed_ALU[BUS_WIDTH+4], observed_ALU[BUS_WIDTH+3], observed_ALU[BUS_WIDTH+2], 
									  observed_ALU[BUS_WIDTH+1], observed_ALU[BUS_WIDTH],  observed_ALU[BUS_WIDTH-1:0]);
					error_count = error_count + 1;
				end
				test_count = test_count +1;
			end
		endtask
		
		
		// Create stimulus
		initial begin
		
			for(i = 0; i<100; i=i+1) begin // change here the number of tests
				opcode   = $random % 10'd11; // also 1 invalid operation can occur
				a        = $random;
				b        = $random;
				carry_in = $random;
				
				#1; // give some time to the combinational circuit to compute (propagation delay)
				$display($time, " TEST%0d opcode = %0d, a = %0d, b = %0d, carry_in = %0b", i, opcode, a, b, carry_in);
				compare_data(model_ALU(opcode, a, b, carry_in), {invalid_op, parity, zero, borrow, carry_out, y});
				
				#2; // wait some time before the next test
			end
			
			// Print statistics
			$display($time, "TEST RESULTS success_count = %0d, error_count = %0d, test_count = %0d",
							success_count, error_count, test_count);
			#40 $stop;
		end
	endmodule
				
					
/*
#                    1 TEST0 opcode = 1, a = 129, b = 9, carry_in = 1
#                    1 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                    1         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=10001010
#                    4 TEST1 opcode = 9, a = 141, b = 101, carry_in = 0
#                    4 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=1
#                    4         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=11000110
#                    7 TEST2 opcode = 9, a = 13, b = 118, carry_in = 1
#                    7 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                    7         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=10000110
#                   10 TEST3 opcode = 4, a = 140, b = 249, carry_in = 0
#                   10 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=1
#                   10         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=10001101
#                   13 TEST4 opcode = 8, a = 170, b = 229, carry_in = 1
#                   13 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                   13         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=01010101
#                   16 TEST5 opcode = 2, a = 143, b = 242, carry_in = 0
#                   16 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=1, y=1
#                   16         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=1, y=10000001
#                   19 TEST6 opcode = 3, a = 197, b = 92, carry_in = 1
#                   19 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                   19         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=01101001
#                   22 TEST7 opcode = 2, a = 101, b = 99, carry_in = 0
#                   22 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                   22         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=11001000
#                   25 TEST8 opcode = 5, a = 32, b = 170, carry_in = 1
#                   25 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                   25         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=00011111
#                   28 TEST9 opcode = 0, a = 19, b = 13, carry_in = 1
#                   28 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                   28         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                   31 TEST10 opcode = 2, a = 213, b = 2, carry_in = 0
#                   31 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=1
#                   31         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=11010111
#                   34 TEST11 opcode = 2, a = 207, b = 35, carry_in = 0
#                   34 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                   34         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=11110010
#                   37 TEST12 opcode = 3, a = 60, b = 242, carry_in = 0
#                   37 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=1, carry_out=0, y=0
#                   37         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=1, carry_out=0, y=01001010
#                   40 TEST13 opcode = 7, a = 216, b = 120, carry_in = 1
#                   40 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                   40         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=00100111
#                   43 TEST14 opcode = 3, a = 182, b = 198, carry_in = 0
#                   43 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=1, carry_out=0, y=1
#                   43         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=1, carry_out=0, y=11110000
#                   46 TEST15 opcode = 3, a = 42, b = 11, carry_in = 1
#                   46 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                   46         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=00011111
#                   49 TEST16 opcode = 9, a = 79, b = 59, carry_in = 0
#                   49 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                   49         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=10100111
#                   52 TEST17 opcode = 6, a = 21, b = 241, carry_in = 1
#                   52 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                   52         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=00010001
#                   55 TEST18 opcode = 8, a = 76, b = 159, carry_in = 1
#                   55 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                   55         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=10011000
#                   58 TEST19 opcode = 2, a = 183, b = 159, carry_in = 0
#                   58 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=1, y=0
#                   58         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=1, y=01010110
#                   61 TEST20 opcode = 4, a = 137, b = 73, carry_in = 0
#                   61 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                   61         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=10001010
#                   64 TEST21 opcode = 6, a = 81, b = 150, carry_in = 0
#                   64 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                   64         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=00010000
#                   67 TEST22 opcode = 1, a = 200, b = 119, carry_in = 1
#                   67 ERROR 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=1, y=0
#                   67         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=00111111
#                   70 TEST23 opcode = 3, a = 126, b = 109, carry_in = 1
#                   70 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                   70         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=00010001
#                   73 TEST24 opcode = 5, a = 211, b = 133, carry_in = 0
#                   73 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=1
#                   73         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=11010010
#                   76 TEST25 opcode = 4, a = 73, b = 63, carry_in = 0
#                   76 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                   76         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=01001010
#                   79 TEST26 opcode = 2, a = 134, b = 142, carry_in = 0
#                   79 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=1, y=0
#                   79         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=1, y=00010100
#                   82 TEST27 opcode = 7, a = 38, b = 115, carry_in = 1
#                   82 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                   82         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=11011001
#                   85 TEST28 opcode = 10, a = 179, b = 95, carry_in = 0
#                   85 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                   85         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                   88 TEST29 opcode = 3, a = 203, b = 230, carry_in = 0
#                   88 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=1, carry_out=0, y=1
#                   88         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=1, carry_out=0, y=11100101
#                   91 TEST30 opcode = 9, a = 237, b = 218, carry_in = 1
#                   91 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=1
#                   91         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=11110110
#                   94 TEST31 opcode = 1, a = 223, b = 121, carry_in = 0
#                   94 ERROR 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=1, y=0
#                   94         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=01011000
#                   97 TEST32 opcode = 6, a = 42, b = 171, carry_in = 0
#                   97 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                   97         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=00101010
#                  100 TEST33 opcode = 3, a = 154, b = 253, carry_in = 1
#                  100 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=1, carry_out=0, y=1
#                  100         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=1, carry_out=0, y=10011101
run
#                  103 TEST34 opcode = 5, a = 78, b = 103, carry_in = 0
#                  103 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                  103         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=01001101
#                  106 TEST35 opcode = 2, a = 56, b = 121, carry_in = 0
#                  106 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=1
#                  106         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=10110001
#                  109 TEST36 opcode = 1, a = 147, b = 4, carry_in = 1
#                  109 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                  109         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=10010111
#                  112 TEST37 opcode = 2, a = 77, b = 217, carry_in = 1
#                  112 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=1, y=0
#                  112         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=1, y=00100111
#                  115 TEST38 opcode = 9, a = 202, b = 182, carry_in = 1
#                  115 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                  115         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=01100101
#                  118 TEST39 opcode = 3, a = 4, b = 247, carry_in = 1
#                  118 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=1, carry_out=0, y=0
#                  118         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=1, carry_out=0, y=00001101
#                  121 TEST40 opcode = 2, a = 136, b = 40, carry_in = 1
#                  121 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=1
#                  121         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=10110001
#                  124 TEST41 opcode = 6, a = 46, b = 8, carry_in = 0
#                  124 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                  124         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=00001000
#                  127 TEST42 opcode = 4, a = 41, b = 28, carry_in = 0
#                  127 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                  127         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=00101010
#                  130 TEST43 opcode = 3, a = 61, b = 102, carry_in = 0
#                  130 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=1, carry_out=0, y=1
#                  130         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=1, carry_out=0, y=11010111
#                  133 TEST44 opcode = 1, a = 186, b = 94, carry_in = 0
#                  133 ERROR 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=1, y=0
#                  133         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=00011000
#                  136 TEST45 opcode = 1, a = 26, b = 185, carry_in = 1
#                  136 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                  136         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=11010011
#                  139 TEST46 opcode = 7, a = 192, b = 38, carry_in = 0
#                  139 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                  139         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=00111111
#                  142 TEST47 opcode = 5, a = 220, b = 134, carry_in = 0
#                  142 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=1
#                  142         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=11011011
#                  145 TEST48 opcode = 0, a = 219, b = 207, carry_in = 1
#                  145 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                  145         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                  148 TEST49 opcode = 7, a = 97, b = 23, carry_in = 1
#                  148 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                  148         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=10011110
#                  151 TEST50 opcode = 6, a = 80, b = 245, carry_in = 1
#                  151 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                  151         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=01010000
#                  154 TEST51 opcode = 7, a = 193, b = 197, carry_in = 0
#                  154 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                  154         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=00111110
#                  157 TEST52 opcode = 9, a = 115, b = 236, carry_in = 0
#                  157 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                  157         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=10111001
#                  160 TEST53 opcode = 9, a = 168, b = 169, carry_in = 1
#                  160 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                  160         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=01010100
#                  163 TEST54 opcode = 10, a = 230, b = 159, carry_in = 0
#                  163 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                  163         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                  166 TEST55 opcode = 10, a = 141, b = 158, carry_in = 0
#                  166 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                  166         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                  169 TEST56 opcode = 7, a = 200, b = 202, carry_in = 1
#                  169 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                  169         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=00110111
#                  172 TEST57 opcode = 6, a = 199, b = 182, carry_in = 0
#                  172 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                  172         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=10000110
#                  175 TEST58 opcode = 0, a = 185, b = 146, carry_in = 0
#                  175 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                  175         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                  178 TEST59 opcode = 3, a = 134, b = 250, carry_in = 0
#                  178 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=1, carry_out=0, y=1
#                  178         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=1, carry_out=0, y=10001100
#                  181 TEST60 opcode = 4, a = 189, b = 132, carry_in = 0
#                  181 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=1
#                  181         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=10111110
#                  184 TEST61 opcode = 6, a = 169, b = 161, carry_in = 0
#                  184 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                  184         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=10100001
#                  187 TEST62 opcode = 5, a = 11, b = 239, carry_in = 1
#                  187 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                  187         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=00001010
#                  190 TEST63 opcode = 2, a = 117, b = 143, carry_in = 1
#                  190 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=1, y=0
#                  190         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=1, y=00000101
#                  193 TEST64 opcode = 10, a = 174, b = 155, carry_in = 0
#                  193 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                  193         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                  196 TEST65 opcode = 2, a = 45, b = 75, carry_in = 0
#                  196 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                  196         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=01111000
#                  199 TEST66 opcode = 8, a = 13, b = 236, carry_in = 0
#                  199 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                  199         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=00011010
#                  202 TEST67 opcode = 0, a = 134, b = 65, carry_in = 1
#                  202 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                  202         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                  205 TEST68 opcode = 3, a = 83, b = 86, carry_in = 1
#                  205 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=1, carry_out=0, y=1
#                  205         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=1, carry_out=0, y=11111101
#                  208 TEST69 opcode = 8, a = 4, b = 115, carry_in = 0
#                  208 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                  208         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=00001000
#                  211 TEST70 opcode = 5, a = 184, b = 57, carry_in = 1
#                  211 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=1
#                  211         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=10110111
#                  214 TEST71 opcode = 4, a = 43, b = 129, carry_in = 0
#                  214 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                  214         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=00101100
#                  217 TEST72 opcode = 5, a = 161, b = 31, carry_in = 0
#                  217 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=1
#                  217         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=10100000
#                  220 TEST73 opcode = 4, a = 150, b = 20, carry_in = 0
#                  220 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                  220         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=10010111
#                  223 TEST74 opcode = 3, a = 177, b = 85, carry_in = 1
#                  223 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                  223         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=01011100
#                  226 TEST75 opcode = 10, a = 245, b = 173, carry_in = 1
#                  226 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                  226         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                  229 TEST76 opcode = 3, a = 167, b = 231, carry_in = 1
#                  229 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=1, carry_out=0, y=1
#                  229         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=1, carry_out=0, y=11000000
#                  232 TEST77 opcode = 0, a = 219, b = 201, carry_in = 1
#                  232 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                  232         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                  235 TEST78 opcode = 7, a = 42, b = 250, carry_in = 1
#                  235 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                  235         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=11010101
#                  238 TEST79 opcode = 6, a = 124, b = 114, carry_in = 0
#                  238 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                  238         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=01110000
#                  241 TEST80 opcode = 9, a = 111, b = 134, carry_in = 0
#                  241 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=1
#                  241         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=10110111
#                  244 TEST81 opcode = 5, a = 64, b = 40, carry_in = 0
#                  244 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                  244         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=00111111
#                  247 TEST82 opcode = 0, a = 192, b = 116, carry_in = 1
#                  247 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                  247         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                  250 TEST83 opcode = 9, a = 60, b = 42, carry_in = 0
#                  250 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                  250         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=00011110
#                  253 TEST84 opcode = 0, a = 225, b = 23, carry_in = 1
#                  253 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                  253         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                  256 TEST85 opcode = 8, a = 134, b = 37, carry_in = 1
#                  256 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                  256         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=00001101
#                  259 TEST86 opcode = 5, a = 90, b = 7, carry_in = 0
#                  259 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                  259         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=01011001
#                  262 TEST87 opcode = 4, a = 113, b = 59, carry_in = 0
#                  262 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=0
#                  262         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=01110010
#                  265 TEST88 opcode = 10, a = 158, b = 92, carry_in = 1
#                  265 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                  265         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                  268 TEST89 opcode = 6, a = 160, b = 114, carry_in = 0
#                  268 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                  268         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=00100000
#                  271 TEST90 opcode = 9, a = 13, b = 75, carry_in = 1
#                  271 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=1
#                  271         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=10000110
#                  274 TEST91 opcode = 10, a = 253, b = 123, carry_in = 1
#                  274 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                  274         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                  277 TEST92 opcode = 5, a = 227, b = 29, carry_in = 1
#                  277 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=1
#                  277         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=11100010
#                  280 TEST93 opcode = 10, a = 149, b = 224, carry_in = 1
#                  280 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                  280         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                  283 TEST94 opcode = 7, a = 248, b = 141, carry_in = 0
#                  283 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                  283         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=00000111
#                  286 TEST95 opcode = 5, a = 70, b = 140, carry_in = 0
#                  286 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                  286         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=01000101
#                  289 TEST96 opcode = 2, a = 106, b = 132, carry_in = 0
#                  289 SUCCESS 	 EXPECTED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=1
#                  289         	 OBSERVED invalid_op=0, parity=0, zero=0, borrow=0, carry_out=0, y=11101110
#                  292 TEST97 opcode = 4, a = 96, b = 186, carry_in = 1
#                  292 SUCCESS 	 EXPECTED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=0
#                  292         	 OBSERVED invalid_op=0, parity=1, zero=0, borrow=0, carry_out=0, y=01100001
#                  295 TEST98 opcode = 0, a = 37, b = 50, carry_in = 0
#                  295 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                  295         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                  298 TEST99 opcode = 0, a = 20, b = 61, carry_in = 1
#                  298 SUCCESS 	 EXPECTED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=0
#                  298         	 OBSERVED invalid_op=1, parity=0, zero=1, borrow=0, carry_out=0, y=00000000
#                  300TEST RESULTS success_count = 97, error_count = 3, test_count = 100
*/		