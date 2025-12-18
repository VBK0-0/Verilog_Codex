module tB_shift_reg_sipo();

	// Testbench variables
	reg sdi;
	reg clk = 0;
	reg reset_n;
	wire [3:0]q;
	
	// Instantiate the DUT
	shift_reg_sipo SIPO0(
		.reset_n(reset_n),
		.clk	(clk	),
		.sdi	(sdi	),
		.q	    (q      )
	);
	
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
	// Create stimulus
	initial begin
		#1; // apply reset to the circuit
		reset_n = 0; sdi = 0;
		#1.3; // release the reset
		reset_n = 1;
		repeat(2) @(posedge clk);
		
		// Set sdi for 1 clock
		@(posedge clk); sdi = 1'b1; @(posedge clk); sdi = 1'b0;
		
		// Set sdi for 2 clocks
		repeat(4) @(posedge clk);
		@(posedge clk); sdi = 1'b1;
		repeat(2) @(posedge clk); sdi = 1'b0;
		
		// Set sdi with '101' during 3 clocks
		repeat(3) @(posedge clk); sdi = 1'b1;
		@(posedge clk); sdi = 1'b0;
		@(posedge clk); sdi = 1'b1;
		@(posedge clk); sdi = 1'b0;
	end
	
	// This will stop the simulator when the time expires
	initial begin	
		#40 $finish;
	end
endmodule

		
		