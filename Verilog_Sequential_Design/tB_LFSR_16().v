`timescale 1us/1ns
module tB_LFSR_16();

	// Testbench variable
	reg clk = 0;
	reg reset_n;
	reg enable;
	wire [15:0] lfsr;
	
	// Instantiate the DUT
	LFSR_16 LFSR1(
			.clk    (clk    ),
			.reset_n(reset_n),
			.enable (enable ),
			.lfsr   (lfsr   )
            );

	// Create the 1MHz clock signal
	always begin #0.5 clk = ~clk; end
	
	// Create stimulus
	initial begin
		$monitor($time, " enable = %d, lfsr = %16b", enable, lfsr);
		#1  ; reset_n = 0; enable = 0; //apply reset
		#1.2; reset_n = 1; // release reset
		repeat (2) @ (posedge clk);
		enable = 1;
		
		repeat(10) @(posedge clk);
		enable = 0;
	end
	
	// This will stop the simulator when the time expires
	initial begin
		#20 $stop;
	end
endmodule
/*										    14 11
	                                     16  13          1 
#                    0 enable = x, lfsr = xxxxxxxxxxxxxxxx
#                    1 enable = 0, lfsr = 0001000000000001
#                    4 enable = 1, lfsr = 0001000000000001
#                    5 enable = 1, lfsr = 0010000000000011
#                    6 enable = 1, lfsr = 0100000000000111
#                    7 enable = 1, lfsr = 1000000000001110
#                    8 enable = 1, lfsr = 0000000000011101
#                    9 enable = 1, lfsr = 0000000000111010
#                   10 enable = 1, lfsr = 0000000001110100
#                   11 enable = 1, lfsr = 0000000011101000
#                   12 enable = 1, lfsr = 0000000111010000
#                   13 enable = 1, lfsr = 0000001110100000
#                   14 enable = 0, lfsr = 0000011101000000
*/