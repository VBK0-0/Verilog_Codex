`timescale 1us/1ns
module tB_clock_div3();

	// Testbench variables
	reg clk = 0;
	reg reset_n;
	wire clock_out;
	
	// Instantiate the DUT
	clk_div3 CLK_DIV0
		(.clock_in(clk),
		 .reset_n(reset_n),
		 .clock_out(clock_out)
		);
		
		// Create the clock signal
		always begin #0.5 clk = ~clk; end
		
		// Create stimulus
		initial begin
			#1  ;           reset_n = 0;
			@(posedge clk); reset_n = 1;
			repeat(20) @(posedge clk); $stop;
		end
		
endmodule