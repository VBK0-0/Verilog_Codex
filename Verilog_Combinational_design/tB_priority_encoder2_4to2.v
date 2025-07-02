`timescale 1us/1ns
module tB_priority_encoder2_4to2();

	reg [3:0] d;	//DUT variables
	wire v;
	wire [1:0] q;
	integer i;		// testbench variable
	
	// Instantiate the DUT
	priority_encoder2_4to2 PRENC(
		.d(d),
		.q(q),
		.v(v)
	);
	
	// Create stimulus
	initial begin
		$monitor($time, " d = %b, q = %d, v = %d", d, q, v);
		#1; d = 0;
		for (i = 0; i<4; i=i+1) begin
			#1; d = (1 << i);
		end
		// Check the priority
		#1; d = 4'b1111;
		#1; d = 4'b1001;
		#1; d = 4'b0101;
		#1; d = 4'b0000;
		#1; $stop;
	end
	
endmodule

/*
#                    0 d = xxxx, q = x, v = x
#                    1 d = 0000, q = 0, v = 0
#                    2 d = 0001, q = 0, v = 1
#                    3 d = 0010, q = 1, v = 1
#                    4 d = 0100, q = 2, v = 1
#                    5 d = 1000, q = 3, v = 1
#                    6 d = 1111, q = 3, v = 1
#                    7 d = 1001, q = 3, v = 1
#                    8 d = 0101, q = 2, v = 1
#                    9 d = 0000, q = 0, v = 0
*/
