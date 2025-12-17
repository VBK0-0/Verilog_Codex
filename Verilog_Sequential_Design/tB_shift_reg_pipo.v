`timescale 1us/1ns
module tB_shift_reg_pipo();

	// Testbench variables
	reg [3:0] d;
	reg clk = 0;
	reg reset_n;
	wire [3:0] q;
	integer i;
	
	// Initiate the DUT
	shift_reg_pipo PIPO0(
		.reset_n(reset_n),
		.clk    (clk    ),
		.d      (d      ),
		.q      (q      )
	);
	
	//create the clock signal
	always begin
		#0.5 clk = ~clk;
	end
	
	// Create stimulus
	initial begin
		#0.5 clk = ~clk;
	end
	
	//Create stimulus
	initial begin
		#1; //apply reset to the circuit
		reset_n = 0; d = 0;
		#1.3; // relese the reset
		reset_n = 1;
		
		// Wait for the positive edge of clk
		// and change the data input d
		for(i = 0; i<5; i=i+1) begin
			@(posedge clk); d = $random;
		end
	end
	
	// This will stop the simulator when the time expires
	initial begin
		#20 $finish;
	end
endmodule