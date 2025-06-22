`timescale 1us/1ns
module tB_tristate_buffer_1bit();
	reg din;
	reg sel;
	wire dout;
	
	
	// Instantiate the DUT
	tristate_buffer_1bit TRI1(
		.din(din),
		.sel(sel),
		.dout(dout)
	);
	
	// Generate stimulus
	initial begin
		$monitor(" din = %b, sel = %b, dout = %b", din, sel, dout);
		#1; din = 0; sel = 0;
		#1; din = 1; sel = 0;
		#1; din = 0; sel = 1;
		#1; din = 1; sel = 0;
		#1; din = 1; sel = 1;
		#2; din = 0;
		#5; $stop;
	end

endmodule

/*
Output:
#  din = x, sel = x, dout = x
#  din = 0, sel = 0, dout = z
#  din = 1, sel = 0, dout = z
#  din = 0, sel = 1, dout = 0
#  din = 1, sel = 0, dout = z
#  din = 1, sel = 1, dout = 1
#  din = 0, sel = 1, dout = 0
*/