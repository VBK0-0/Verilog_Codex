`timescale 1us/1ns
module tB_semaphore_fsm();

	reg clk = 0;
	reg rst_n;
	reg enable;
	wire red	;
	wire yellow ;
	wire green  ;
	wire [3:0] state_out;
	
	// Parameters used for testbench flow
	parameter [3:0] OFF	   = 4'b0001,
					RED	   = 4'b0010,
					YELLOW = 4'b0100,
					GREEN  = 4'b1000;
					
	// Instantiate the module
	semaphore_fsm SEM0(
		.clk	  (clk	    ),
		.rst_n    (rst_n    ),
		.enable   (enable   ),
		.red      (red      ),
		.yellow   (yellow   ),
		.green    (green    ),
		.state_out(state_out)	// used for debug
		);
		
	initial begin // Create the clock signal
		forever begin
			#1 clk = ~clk;
		end
	end
	
	initial begin
		$monitor($time, " enable = %b, red = %b, yellow = %b, green = %b",
						enable, red, yellow, green);
						
		rst_n = 0; #2.5; rst_n = 1;	// reset sequence
		enable = 0;
		repeat(10) @(posedge clk);  // wait some time
		enable = 1;
		
		// Let the semaphore cycle 2 times
		repeat(2) begin
			wait (state_out === GREEN);
			@(state_out); // wait for GREEN to be over
		end
		
		// Disable the semaphore during Yellow state_out
		wait (state_out === YELLOW);
		@(posedge clk); enable = 0;
		
		// Enable the semaphore again
		repeat(10) @(posedge clk);
		@(posedge clk); enable = 1;
		
		#40 $stop;
	end
	
endmodule

/*
#                    0 enable = x, red = 0, yellow = 0, green = 0
#                    3 enable = 0, red = 0, yellow = 0, green = 0
#                   21 enable = 1, red = 0, yellow = 0, green = 0
#                   23 enable = 1, red = 1, yellow = 0, green = 0
#                  125 enable = 1, red = 0, yellow = 1, green = 0
#                  147 enable = 1, red = 0, yellow = 0, green = 1
#                  187 enable = 1, red = 1, yellow = 0, green = 0
#                  289 enable = 1, red = 0, yellow = 1, green = 0
#                  311 enable = 1, red = 0, yellow = 0, green = 1
#                  351 enable = 1, red = 1, yellow = 0, green = 0
#                  453 enable = 1, red = 0, yellow = 1, green = 0
#                  475 enable = 1, red = 0, yellow = 0, green = 1
#                  515 enable = 1, red = 1, yellow = 0, green = 0
#                  617 enable = 1, red = 0, yellow = 1, green = 0
#                  639 enable = 1, red = 0, yellow = 0, green = 1
#                  679 enable = 1, red = 1, yellow = 0, green = 0
#                  781 enable = 1, red = 0, yellow = 1, green = 0
*/
		
		