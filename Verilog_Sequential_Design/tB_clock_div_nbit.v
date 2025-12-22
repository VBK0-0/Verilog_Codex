`timescale 1us/1ns
module tB_clock_div_nbit();

	// Testbench variable
	parameter CNT_WIDTH = 4;
	reg clk = 0;
	reg reset_n;
	wire clk_div2;
	wire [CNT_WIDTH-1:0] counter;
	
	// Instantiate the DUT
	clock_div_nbit
		// parameters section
		#(.CNT_WIDTH(CNT_WIDTH))
		  CLK_DIV0
		// Ports section
		(.clk     (clk     ),
		 .reset_n (reset_n ),
		 .clk_div2(clk_div2),
		 .counter (counter ));
		 
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
	// Create stimulus
	initial begin
		#1  ; reset_n = 0;  // apply reset
		#1.2; reset_n = 1;  // release reset
		repeat(20) @(posedge clk); $stop;
	end
	
endmodule