`timescale 1us/1ns
module tB_shift_reg_pipo_buggy();

	// Testbench variables
	reg [7:0] d;
	reg clk = 0;
	reg reset_n;
	wire [7:0] q;
	reg [1:0] delay;
	integer success_count, error_count, test_count;
	integer i;
	
	// Instantiate the DUT
	shift_reg_pipo_buggy PIPO0(
		.reset_n(reset_n),
		.clk    (clk    ),
		.d      (d      ),
		.q      (q      )
	);
	
	// We will use no inputs as we will use the global variables
	// connected to the module's ports
	task load_check_pipo_reg();
		begin
			@(posedge clk); // sync to positive edge of clock
			d = $random;
			@(posedge clk); // wait 1 clock for the data to be loaded
			#0.1; // compare the data after the output is stable
			compare_data(d, q);
		end
	endtask
	
	task compare_data(input [7:0] expected_data, input [7:0] observed_data);
		begin
			if (expected_data === observed_data) begin // use case equality
				$display($time, " SUCCESS expeccted_data = %8b, obeserved_data = %8b", expected_data, observed_data);
				success_count = success_count + 1;
			end else begin
				$display($time, " ERROR expected_data = %8b, observed_data = %8b", expected_data, observed_data);
				error_count = error_count + 1;
				
			end
			test_count = test_count + 1;
		end
	endtask
	
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
	// Create stimulus
	initial begin
		#1;
		// Clear the ststics counters
		success_count = 0; error_count = 0; test_count = 0;
		reset_n = 0; //apply reset to the circuit
		
		#1.3; // release the reset
		reset_n = 1;
		for (i=0; i<10; i=i+1) begin
			load_check_pipo_reg();
			delay = $random; //wait between tests
		end
		
		// Print statistics
		$display($time, " TEST RESULTS success_count = %0d, error_count = %0d, test_count = %0d",
					success_count, error_count, test_count);
		#40 $stop;
		
	end
	
endmodule

/*
#                    4 SUCCESS expeccted_data = 00100100, obeserved_data = 00100100
#                    6 SUCCESS expeccted_data = 00001001, obeserved_data = 00001001
#                    8 SUCCESS expeccted_data = 00001101, obeserved_data = 00001101
#                   10 SUCCESS expeccted_data = 01100101, obeserved_data = 01100101
#                   12 SUCCESS expeccted_data = 00000001, obeserved_data = 00000001
#                   14 SUCCESS expeccted_data = 01110110, obeserved_data = 01110110
#                   16 ERROR expected_data = 11101101, observed_data = 01101101
#                   18 ERROR expected_data = 11111001, observed_data = 01111001
#                   20 ERROR expected_data = 11000101, observed_data = 01000101
#                   22 ERROR expected_data = 11100101, observed_data = 01100101
#                   22 TEST RESULTS success_count = 6, error_count = 4, test_count = 10
*/