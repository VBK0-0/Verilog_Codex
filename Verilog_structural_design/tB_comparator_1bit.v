`timescale 1us/1ns
module tB_comparator_1bit();

	reg a, b;
	wire smaller, greater, equal;
	
	// Instantiate the DUT
	comparator_1bit CMP1(
		.a(a),
		.b(b),
		.smaller(smaller),
		.equal(equal),
		.greater(greater)
	);
	
	initial begin
		$monitor(" a = %b, b = %b, smaller = %b, equal = %b, greater = %b",
				   a, b, smaller, equal, greater);
	
		#1; a = 0; b = 0;
		#1; a = 1; b = 0;
		#1; a = 1; b = 0;
		#1; a = 0; b = 1;
		#1; a = 1; b = 1;
		#1; $stop;
		end
		
endmodule

/*
Output:
#  a = x, b = x, smaller = x, equal = x, greater = x
#  a = 0, b = 0, smaller = 0, equal = 1, greater = 0
#  a = 1, b = 0, smaller = 0, equal = 0, greater = 1
#  a = 0, b = 1, smaller = 1, equal = 0, greater = 0
#  a = 1, b = 1, smaller = 0, equal = 1, greater = 0
*/