`timescale 1us/1ns
module tB_demux_nbit_x4();
	parameter BUS_WIDTH = 8;
	wire [BUS_WIDTH-1:0] a;
	wire [BUS_WIDTH-1:0] b;
	wire [BUS_WIDTH-1:0] c;
	wire [BUS_WIDTH-1:0] d;
	reg [1:0] sel;
	reg [BUS_WIDTH-1:0] y;
	
	integer i;
	
	// Instantiate the DUT
	demux_nbit_x4
		#(.BUS_WIDTH(BUS_WIDTH))
		DEMUX0 (
		.y(y),
		.sel(sel),
		.a(a),
		.b(b),
		.c(c),	
		.d(d)
	);
	
	//Create stimulus
	initial begin
		$monitor($time, " sel = %d, y = %d, a = %d, b = %d,c = %d, d = %d", 
						  sel, y, a, b, c, d);
		#1; sel = 0; y = 0;
		for (i = 0; i<8; i=i+1) begin
			#1; sel = i%4; y = $urandom();
		end
	end
	
endmodule

/*
Output:
#                    0 sel = x, y =   x, a =   x, b =   x,c =   x, d =   x
#                    1 sel = 0, y =   0, a =   0, b =   0,c =   0, d =   0
#                    2 sel = 0, y =  38, a =  38, b =   0,c =   0, d =   0
#                    3 sel = 1, y = 102, a =   0, b = 102,c =   0, d =   0
#                    4 sel = 2, y = 182, a =   0, b =   0,c = 182, d =   0
#                    5 sel = 3, y = 198, a =   0, b =   0,c =   0, d = 198
#                    6 sel = 0, y =  70, a =  70, b =   0,c =   0, d =   0
#                    7 sel = 1, y = 114, a =   0, b = 114,c =   0, d =   0
#                    8 sel = 2, y =  46, a =   0, b =   0,c =  46, d =   0
#                    9 sel = 3, y = 103, a =   0, b =   0,c =   0, d = 103
*/
		
		