`timescale 1us/1ns
module tB_mux_tristate(
	// no input here 
	);
	
	reg a, b;
	reg sel;
	wire dout;
	
	// Instantiate the DUT
	mux_tristate MUX1(
		.a(a),
		.b(b),
		.sel(sel),
		.dout(dout)
	);
	
	// Toggle sel (select line)
	initial begin
		$monitor(" a = %b, b = %b, sel = %b, dout = %b", a, b, sel, dout);
		#1; a = 0; b = 0; sel = 0;
		#1; a = 1; b = 0; sel = 0; 
		#1; a = 1; b = 0; sel = 1;
		#1; a = 0; b = 1; sel = 1;
		#1; a = 0; b = 0; sel = 0;
		#1;
	end
	
endmodule