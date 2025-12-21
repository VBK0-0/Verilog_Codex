`timescale 1us/1ns
module tB_counter_modulo_n();
	// Testbench variables
	parameter CNT_WIDTH = 4;
	parameter N = 10;
	
	reg clk = 0;
	reg reset_n;
	reg enable;
	wire [CNT_WIDTH-1:0] counter_out;
	
	// Instantiate the DUT
	counter_modulo_n
		// Parameter section
		#(.N(N), .CNT_WIDTH(CNT_WIDTH))
			CNT_MODN0
		// Ports section
		(.clk        (clk        ),
		 .reset_n    (reset_n    ),
		 .enable     (enable     ),
		 .counter_out(counter_out));
		 
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
	// Create stimulus
	initial begin
		$monitor ($time, "enable = %b, counter_out = %d", 
					  enable, counter_out);
		#1  ; reset_n = 0; enable = 0;
		#1.2; reset_n = 1; // release reset
		repeat(3) @(posedge clk); enable = 1;
		repeat(14) @(posedge clk); $stop;
	end
	
endmodule
		
/*
#                    0enable = x, counter_out =  x
#                    1enable = 0, counter_out =  0
#                    5enable = 1, counter_out =  0
#                    6enable = 1, counter_out =  1
#                    7enable = 1, counter_out =  2
#                    8enable = 1, counter_out =  3
#                    9enable = 1, counter_out =  4
#                   10enable = 1, counter_out =  5
#                   11enable = 1, counter_out =  6
#                   12enable = 1, counter_out =  7
#                   13enable = 1, counter_out =  8
#                   14enable = 1, counter_out =  9
#                   15enable = 1, counter_out =  0
#                   16enable = 1, counter_out =  1
#                   17enable = 1, counter_out =  2
#                   18enable = 1, counter_out =  3
*/