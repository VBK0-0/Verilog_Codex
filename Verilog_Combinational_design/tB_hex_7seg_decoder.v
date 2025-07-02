`timescale 1us/1ns

module tB_hex_7seg_decoder();
	
	// Testbench variables
    reg  [3:0]in;
    wire a, b, c, d, e, f, g;
    wire dot;
    integer i; 
	
    // Instantiate the DUT 
	hex_7seg_decoder DEC_7SEG(
		.in(in),
		.a(a),
		.b(b),
		.c(c),
		.d(d),
		.e(e),
		.f(f),
		.g(g),
		.dot(dot)
		);
		
	//Create stimulus
	initial begin
		$monitor($time, " in = %d, seven_seg_code = %7b dot = %1b",
				 in, {a, b, c, d, e, f, g}, dot);
		#1; in = 0;
		for (i = 0; i<16; i=i+1) begin
			#1; in = i;
		end
	end

endmodule

/*
Output:
#                    0 in =  x, seven_seg_code = xxxxxxx dot = 1
#                    1 in =  0, seven_seg_code = 1111110 dot = 1
#                    3 in =  1, seven_seg_code = 0110000 dot = 1
#                    4 in =  2, seven_seg_code = 1101101 dot = 1
#                    5 in =  3, seven_seg_code = 1111001 dot = 1
#                    6 in =  4, seven_seg_code = 0110011 dot = 1
#                    7 in =  5, seven_seg_code = 1011011 dot = 1
#                    8 in =  6, seven_seg_code = 1011111 dot = 1
#                    9 in =  7, seven_seg_code = 1110000 dot = 1
#                   10 in =  8, seven_seg_code = 1111111 dot = 1
#                   11 in =  9, seven_seg_code = 1111011 dot = 1
#                   12 in = 10, seven_seg_code = 1110111 dot = 1
#                   13 in = 11, seven_seg_code = 0011111 dot = 1
#                   14 in = 12, seven_seg_code = 1001110 dot = 1
#                   15 in = 13, seven_seg_code = 0111101 dot = 1
#                   16 in = 14, seven_seg_code = 1001111 dot = 1
#                   17 in = 15, seven_seg_code = 1000111 dot = 1

*/
		
  
