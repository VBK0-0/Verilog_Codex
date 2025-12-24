`timescale 1us/1ns
module tB_compare_nbit_function();

	// Testbench variables
	parameter CMP_WIDTH = 5;
	reg [CMP_WIDTH-1:0] a, b;
	wire greater, equal, smaller;
	
	// Instantiate the DUT
	compare_nbit_func
		#(.CMP_WIDTH(CMP_WIDTH))
		CMP0
		(.a      (a      ),
		 .b      (b      ),
		 .greater(greater),
		 .equal  (equal  ),
		 .smaller(smaller));
		 
	initial begin
			$monitor($time, " a = %d, b = %d, greater = %b, equal = %b, smaller = %b",
							a, b, greater, equal, smaller);
		#1 a = 3; b = 2;
		#1 b = 3;
		#1 a = 9; b = 11;
	end
	
endmodule
/*
#                    0 a =  x, b =  x, greater = x, equal = x, smaller = x
#                    1 a =  3, b =  2, greater = 1, equal = 0, smaller = 0
#                    2 a =  3, b =  3, greater = 0, equal = 1, smaller = 0
#                    3 a =  9, b = 11, greater = 0, equal = 0, smaller = 1
*/				