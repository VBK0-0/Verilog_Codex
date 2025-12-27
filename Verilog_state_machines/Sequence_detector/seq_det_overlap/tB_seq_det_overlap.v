`timescale 1us/1ns
module tB_seq_det_overlap();

	reg clk = 0;
	reg rst_n;
	reg seq_in;
	wire detected;
	wire [1:0] state_out;
	
	reg [0:13] test_vect = 14'b00_1100_0101_0101;
	integer i;
	
	// Instantiate the module
	seq_det_overlap SEQ_DET0(
		.clk      (clk      ),
		.rst_n    (rst_n    ),
		.seq_in   (seq_in   ),
		.detected (detected ),
		.state_out(state_out)
		);
		
	initial begin // Create the clock signal
		forever begin
			#1 clk = ~clk;
			
			end
		end
		
	initial begin
		$monitor($time , "seq_in = %b, detected = %b", seq_in, detected);
		
		rst_n = 0; #2.5; rst_n = 1; // reset sequence
		repeat(2) @(posedge clk);   // wait some time
		
		for(i=0; i<14; i=i+1) begin
			seq_in = test_vect[i];
			@(posedge clk); 
		end
		
		for(i=0; i<15; i=i+1) begin
			seq_in = $random;
			@(posedge clk);
		end
		
		// Enable the semaphore again
		repeat(10) @(posedge clk);
		@(posedge clk);
		
		#40 $stop;
	end
	
endmodule

/*
#                    0seq_in = x, detected = x
#                    5seq_in = 0, detected = 0
#                    9seq_in = 1, detected = 0
#                   13seq_in = 0, detected = 0
#                   19seq_in = 1, detected = 0
#                   21seq_in = 0, detected = 0
#                   23seq_in = 1, detected = 1
#                   25seq_in = 0, detected = 0
#                   27seq_in = 1, detected = 1
#                   29seq_in = 0, detected = 0
#                   31seq_in = 1, detected = 1
#                   33seq_in = 0, detected = 0
#                   35seq_in = 1, detected = 1
#                   37seq_in = 1, detected = 0
#                   47seq_in = 0, detected = 0
#                   49seq_in = 1, detected = 1
#                   51seq_in = 1, detected = 0
#                   53seq_in = 0, detected = 0
#                   55seq_in = 1, detected = 1
#                   57seq_in = 1, detected = 0
#                   59seq_in = 0, detected = 0
#                   61seq_in = 1, detected = 1
#                   63seq_in = 1, detected = 0
*/