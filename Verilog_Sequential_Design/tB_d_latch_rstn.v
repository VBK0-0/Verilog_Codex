`timescale 1us/1ns
module tB_d_latch_rstn();
	
	// Testbench variables
	reg d;
	reg enable;
	reg reset_n;
	wire q;
	wire q_not;
	
	// Instantiate the DUT
	d_latch_rstn DL0(
	.d(d),
	.enable(enable),
	.reset_n(reset_n),
	.q(q),
	.q_not(q_not)
	);
	
	// Create stimulus
	initial begin
		$monitor ($time, " enable = %b, d = %b, q = %b, q_not = %b",
					   enable, d, q, q_not);
		enable = 0; reset_n = 0;
		#2  ; d = 0;
		#0.5; d = 1;
		#1  ; d = 0;
		#1  ; d = 1;
		#1.5; enable = 1;
		#0.1; d = 1;
		#0.2; d = 0; reset_n = 1;
		#0.3; d = 1;
		#1  ; enable = 0; d = 0;
		#1  ; d = 1; reset_n = 0;
		#2  ; d = 0;
	end
	
	// This will stop the simulator when the time expires
	initial begin
		#40 $finish;
	end
	
endmodule

/*
Output:
#                    0 enable = 0, d = x, q = 0, q_not = 1
#                    2 enable = 0, d = 0, q = 0, q_not = 1
#                    3 enable = 0, d = 1, q = 0, q_not = 1
#                    4 enable = 0, d = 0, q = 0, q_not = 1
#                    5 enable = 0, d = 1, q = 0, q_not = 1
#                    6 enable = 1, d = 1, q = 0, q_not = 1
#                    6 enable = 1, d = 0, q = 0, q_not = 1
#                    7 enable = 1, d = 1, q = 1, q_not = 0
#                    8 enable = 0, d = 0, q = 1, q_not = 0
#                    9 enable = 0, d = 1, q = 0, q_not = 1
#                   11 enable = 0, d = 0, q = 0, q_not = 1
*/               