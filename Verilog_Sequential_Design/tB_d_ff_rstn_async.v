`timescale 1us/1ns
module tB_d_ff_rstn_async();

	// Testbench variables
	reg d;
	reg clk = 0;
	reg reset_n;
	wire q;
	wire q_not;
	reg [1:0] delay;
	integer i;
	
	// Instantiate the DUT
	d_ff_async_rstn DFF0(
		.reset_n(reset_n),
		.clk    (clk    ),
		.d      (d      ),
		.q      (q      ),
		.q_not  (q_not  )
		);
		
	// Create the clk signal 
	always begin
		#0.5 clk = ~clk;
	end
			
	// Create stimulus
	initial begin
		reset_n = 0; d = 0;
			for (i=0; i<5; i=i+1) begin
				// delay = $random+1;
				delay = $urandom_range(1,3);
				#(delay) d = ~d;
			end
			
			reset_n = 1;
			for (i=0; i<5; i= i+1) begin
				// delay = $random+1;
				delay = $urandom_range(1,3);
				#(delay) d = ~d; // toggle the FF at random timescale
			end
		
		d = 1'b1; //To make sure D is set
		#(0.2); reset_n = 0; // reset the FF again
	end
			
	// This will stop the simulator when the time expires
	initial begin
		#40 $finish;
	end
			
endmodule
			
	