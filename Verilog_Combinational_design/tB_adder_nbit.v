`timescale 1us/1ns
module tB_adder_nbit();

	parameter ADDER_WIDTH = 10;
	reg [ADDER_WIDTH-1:0] a;
	reg [ADDER_WIDTH-1:0] b;
	wire [ADDER_WIDTH:0]  sum;
	
	// Instantiate the parameterized DUT
	adder_nbit
	#(.N(ADDER_WIDTH))
	ADDER1
	(
		.a(a),
		.b(b),
		.sum(sum)
	);
	
	// Create stimulus
	initial begin
		$monitor($time, " a = %d, b = %d, sum = %d", a, b, sum);
		#1; a = 0  ; b = 0  ;
		#2; a = 1  ; b = 99 ;
		#1; a = 33 ; b = 47 ;
		#1; a = 100; b = 47 ;
	end
	
endmodule

/*
Output:
#                    0 a =    x, b =    x, sum =    x
#                    1 a =    0, b =    0, sum =    0
#                    3 a =    1, b =   99, sum =  100
#                    4 a =   33, b =   47, sum =   80
#                    5 a =  100, b =   47, sum =  147
*/