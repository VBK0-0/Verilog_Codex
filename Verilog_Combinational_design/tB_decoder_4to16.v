`timescale 1us/1ns
module tB_decoder_4to16();

	reg [3:0] a;
	wire [15:0] d;
	integer i;
	
	// Instantiate the DUT
	decoder_4to16 DEC4_16 (
		.a(a),
		.d(d)
	);
	
	//Create stimulus
	initial begin
		$monitor($time, " a = %d, d = %d", a, d);
		#1; a = 0;
		for (i = 0; i<16; i=i+1) begin
			#1; a = i;
		end
	end

endmodule

/*
Output:
#                    0 a =  x, d =     x
#                    1 a =  0, d =     1
#                    3 a =  1, d =     2
#                    4 a =  2, d =     4
#                    5 a =  3, d =     8
#                    6 a =  4, d =    16
#                    7 a =  5, d =    32
#                    8 a =  6, d =    64
#                    9 a =  7, d =   128
#                   10 a =  8, d =   256
#                   11 a =  9, d =   512
#                   12 a = 10, d =  1024
#                   13 a = 11, d =  2048
#                   14 a = 12, d =  4096
#                   15 a = 13, d =  8192
#                   16 a = 14, d = 16384
#                   17 a = 15, d = 32768

*/