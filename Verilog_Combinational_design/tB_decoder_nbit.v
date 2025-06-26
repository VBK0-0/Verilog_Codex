`timescale 1us/1ns
module tB_decoder_nbit();

	parameter DEC_WIDTH = 3;
	reg [DEC_WIDTH-1:0] a;
	reg enable;
	wire [2**DEC_WIDTH-1:0] y;
	
	integer i; // used in the for loop
	
	// Instantiate the parameterized DUT
	decoder_nbit
	#(.N(DEC_WIDTH))
	DEC1
	(
		.a(a),
		.enable(enable),
		.y(y)
	);
	
	// Create stimulus
	initial begin
		$monitor($time, " a = %d, enable = %b, y = %b", a, enable, y);
		#1; a = 0; enable = 0;
		for (i = 0; i<2**DEC_WIDTH; i=i+1) begin
			#1; a = i; enable = 1;
		end
	end
		
endmodule

/*
Output:
#                    0 a = x, enable = x, y = xxxxxxxx
#                    1 a = 0, enable = 0, y = 00000000
#                    2 a = 0, enable = 1, y = 00000001
#                    3 a = 1, enable = 1, y = 00000010
#                    4 a = 2, enable = 1, y = 00000100
#                    5 a = 3, enable = 1, y = 00001000
#                    6 a = 4, enable = 1, y = 00010000
#                    7 a = 5, enable = 1, y = 00100000
#                    8 a = 6, enable = 1, y = 01000000
#                    9 a = 7, enable = 1, y = 10000000
*/