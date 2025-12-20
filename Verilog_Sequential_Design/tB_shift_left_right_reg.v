`timescale 1us/1ns

module tB_shift_left_right_reg();

	// Testbench variables
	reg reset_n;
	reg clk = 0;
	reg load_enable;
	reg shift_left_right;
	reg  [7:0] I;
	wire [7:0] q;
	
	// Instantiate the DUT
	shift_left_right_load_reg SRL0(
			.reset_n    	 (reset_n		  ),
			.clk	    	 (clk			  ),
			.I 				 (I 			  ),
			.load_enable	 (load_enable	  ),
			.shift_left_right(shift_left_right),
			.q				 (q				  )
	);
	
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
	//create stimulus
	initial begin
		$monitor($time," I = %8b, load_enable=%1B, shift_left_right=%1b, q=%8b",
					I, load_enable, shift_left_right, q);
		
		// Apply reset to the circuit
		reset_n = 0; I = 0; load_enable = 0; shift_left_right = 0;
		#1.3; reset_n = 1; // Release the reset
		
		//Set the value of I
		@(posedge clk); I = 8'b1111_1111;
		@(posedge clk); load_enable = 1'b1; // Enable shifting left
		
		
		// Wait for the bits to shift left
		repeat (5) @(posedge clk);
		@(posedge clk); load_enable = 1'b0; I = 8'b1010_1000;
		@(posedge clk); load_enable = 1'b1; shift_left_right = 1;
	end
	
	// This will stop the simulator when the time expires
	initial begin #40 $finish; end
endmodule	

/*
#                    0 I = 00000000, load_enable=0, shift_left_right=0, q=00000000
#                    2 I = 11111111, load_enable=0, shift_left_right=0, q=00000000
#                    3 I = 11111111, load_enable=1, shift_left_right=0, q=11111111
#                    4 I = 11111111, load_enable=1, shift_left_right=0, q=11111110
#                    9 I = 10101000, load_enable=0, shift_left_right=0, q=11111110
#                   10 I = 10101000, load_enable=1, shift_left_right=1, q=10101000
#                   11 I = 10101000, load_enable=1, shift_left_right=1, q=01010100
*/