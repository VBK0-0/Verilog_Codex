`timescale 1us/1ns

module tB_counter_up_down_load_nbit();
	//Testbench variables
	parameter CNT_WIDTH = 3;
	reg clk = 0;
	reg reset_n;
	reg load_en;
	reg [CNT_WIDTH-1:0] counter_in;
	reg up_down;
	wire [CNT_WIDTH-1:0] counter_out;
	
	//Instantiate the DUT
	counter_up_down_load_nbit
		// Parameters section
		#(.CNT_WIDTH(CNT_WIDTH))
			CNT_UP_DOWN0
		// Ports section
		(.clk        (clk        ),
		 .reset_n    (reset_n    ),
		 .load_en    (load_en    ),
		 .up_down    (up_down    ),
		 .counter_in (counter_in ),
		 .counter_out(counter_out));
		 
	// Create the clock signal 
	always begin #0.5 clk = ~clk; end
	
	//Create stimulus
	initial begin
		$monitor ($time, " load_en = %b, up_down = %b, counter_in = %d, counter_out = %d",
						load_en, up_down, counter_in, counter_out);
		
		#1  ; reset_n = 0; load_en = 0; counter_in = 0; up_down = 0; //count down
		#1.2; reset_n = 1;  // release reset
		@(posedge clk); 
		repeat(2) @(posedge clk); counter_in = 3; load_en = 1;
		@(posedge clk); load_en = 0; up_down = 1;					 // Count up
		
		wait (counter_out == 0) up_down = 0; 						 // Count down
	end
	
	// This will stop the simulator when the time expires 
	initial begin
		#20 $stop;
	end
endmodule

/*
#                    0 load_en = x, up_down = x, counter_in = x, counter_out = x
#                    1 load_en = 0, up_down = 0, counter_in = 0, counter_out = 0
#                    3 load_en = 0, up_down = 0, counter_in = 0, counter_out = 7
#                    4 load_en = 0, up_down = 0, counter_in = 0, counter_out = 6
#                    5 load_en = 1, up_down = 0, counter_in = 3, counter_out = 5
#                    6 load_en = 0, up_down = 1, counter_in = 3, counter_out = 3
#                    7 load_en = 0, up_down = 1, counter_in = 3, counter_out = 4
#                    8 load_en = 0, up_down = 1, counter_in = 3, counter_out = 5
#                    9 load_en = 0, up_down = 1, counter_in = 3, counter_out = 6
#                   10 load_en = 0, up_down = 1, counter_in = 3, counter_out = 7
#                   11 load_en = 0, up_down = 0, counter_in = 3, counter_out = 0
#                   12 load_en = 0, up_down = 0, counter_in = 3, counter_out = 7
#                   13 load_en = 0, up_down = 0, counter_in = 3, counter_out = 6
#                   14 load_en = 0, up_down = 0, counter_in = 3, counter_out = 5
#                   15 load_en = 0, up_down = 0, counter_in = 3, counter_out = 4
#                   16 load_en = 0, up_down = 0, counter_in = 3, counter_out = 3
#                   17 load_en = 0, up_down = 0, counter_in = 3, counter_out = 2
#                   18 load_en = 0, up_down = 0, counter_in = 3, counter_out = 1
#                   19 load_en = 0, up_down = 0, counter_in = 3, counter_out = 0
#                   20 load_en = 0, up_down = 0, counter_in = 3, counter_out = 7	
*/
		
