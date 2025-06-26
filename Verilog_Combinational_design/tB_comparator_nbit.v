`timescale 1us/1ns
module tB_comparator_nbit();

	parameter CMP_WIDTH = 10;
	reg [CMP_WIDTH-1:0] a;
	reg [CMP_WIDTH-1:0] b;
	wire smaller;
	wire equal;
	wire greater;
	
	// Instantiate the parameterized DUT
	comparator_nbit
	#(.N(CMP_WIDTH))
	CMP1
	(
		.a		(a		),
		.b		(b		),
		.smaller(smaller),
		.equal  (equal	),
		.greater(greater)
	);
	
	// Create stimulus
	initial begin
		$monitor($time, " a = %d, b = %d, smaller = %d, equal = %d, greater = %d",
						a, b, smaller, equal, greater);
			#1; a = 0  ; b = 0  ;
			#2; a = 5  ; b = 99 ;
			#1; a = 66 ; b = 66 ;
			#1; a = 100; b = 47 ;
			#1; $stop;
	end

endmodule

/*
Output:
#                    0 a =    x, b =    x, smaller = x, equal = x, greater = x
#                    1 a =    0, b =    0, smaller = 0, equal = 1, greater = 0
#                    3 a =    5, b =   99, smaller = 1, equal = 0, greater = 0
#                    4 a =   66, b =   66, smaller = 0, equal = 1, greater = 0
#                    5 a =  100, b =   47, smaller = 0, equal = 0, greater = 1
			