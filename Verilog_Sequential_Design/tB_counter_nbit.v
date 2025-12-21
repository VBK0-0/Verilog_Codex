`timescale 1us/1ns
module tB_counter_nbit();

	// Testbench variables
	parameter CNT_WIDTH = 3;
	reg clk = 0;   // Initialization is mandatory
	reg reset_n;
	wire [CNT_WIDTH - 1:0] counter;
	
	// Instantiate the DUT
	counter_nbit
		// Parameters section
		#(.CNT_WIDTH(CNT_WIDTH))
			CNT_NBIT0
		// Ports section
		(.clk    (clk    ),
		 .reset_n(reset_n),
		 .counter(counter));
		 
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
	// Create stimulus
	initial begin
		$monitor($time, "counter = %d", counter);
		#1  ; reset_n = 0; // apply reset
		#1.2; reset_n = 1; // release reset
		#20 $stop;		   // stop the sim
	end
	

endmodule

/*
#                    1counter = 0
#                    3counter = 1
#                    4counter = 2
#                    5counter = 3
#                    6counter = 4
#                    7counter = 5
#                    8counter = 6
#                    9counter = 7
#                   10counter = 0
#                   11counter = 1
#                   12counter = 2
#                   13counter = 3
#                   14counter = 4
#                   15counter = 5
#                   16counter = 6
#                   17counter = 7
#                   18counter = 0
#                   19counter = 1
#                   20counter = 2
*/
