`timescale 1us/1ns
module tB_mux_4x_nbit();
	parameter BUS_WIDTH = 8;
	reg [BUS_WIDTH-1:0] a;
	reg [BUS_WIDTH-1:0] b;
	reg [BUS_WIDTH-1:0] c;
	reg [BUS_WIDTH-1:0] d;
	reg [1:0] sel;
	wire [BUS_WIDTH-1:0] y;
	integer i;
	
	// Instantiate the DUT
	mux_4x_nbit
		#(.BUS_WIDTH(BUS_WIDTH))
		MUX0 (
		.a(a),
		.b(b),
		.c(c),
		.d(d),
		.sel(sel),
		.y(y)
	);
	
	//Create stimulus
	initial begin
		$monitor($time, " a = %d, b = %d, c = %d, d = %d, 
				sel = %d, y = %d", a, b, c, d, sel, y);
	#1; sel = 0; a = 0; b = 0; d = 0;
		for (i = 0; i<8; i=i+1) begin
			#1; sel = $urandom%4; a = $urandom; b = $urandom; 
				c = $urandom; d = $urandom;
		end
	end
endmodule

/*
Output:
#                    0 a =   x, b =   x, c =   x, d =   x, sel = x, y =   x
#                    1 a =   0, b =   0, c =   x, d =   0, sel = 0, y =   0
#                    2 a = 102, b = 182, c = 198, d =  70, sel = 2, y = 198
#                    3 a =  46, b = 103, c =  58, d = 106, sel = 2, y =  58
#                    4 a = 111, b =  86, c =  53, d = 212, sel = 0, y = 111
#                    5 a = 125, b = 219, c =   5, d = 227, sel = 2, y =   5
#                    6 a = 229, b =   5, c =  37, d = 233, sel = 0, y = 229
#                    7 a = 138, b =  88, c = 139, d =  86, sel = 1, y =  88
#                    8 a = 185, b =  64, c = 128, d =  14, sel = 1, y =  64
#                    9 a = 142, b = 192, c = 151, d =  37, sel = 0, y = 142
*/
		
		