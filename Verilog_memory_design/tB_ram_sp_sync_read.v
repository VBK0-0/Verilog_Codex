`timescale 1us/1ns
module tB_ram_sp_sync_read();

	// Testbench variables
	reg clk = 0;
	reg [7:0] data_in;   // 8bit input word
	reg [3:0] address;   // for 32 locations
	reg write_en; 		 // active high
	wire [7:0] data_out; // 8 bit output word
	reg [1:0] delay;
	reg [7:0] wr_data;
	integer success_count, error_count, test_count;
	integer i;
	
	// Instantiate the DUT
	ram_sp_sync_read RAM0(
		.clk     (clk     ),
		.data_in (data_in ),    // 8bit input word
		.address (address ),    // for 32 locations
		.write_en(write_en),	// for active high
		.data_out(data_out)		// 8bit output word
	);
	
	// We will use no outputs as we will use the global variables
	// connected to the modules ports
	task write_data(input [3:0] address_in, input [7:0] d_in);
		begin
			@(posedge clk); // sync to positive edge of clock
			write_en = 1;
			address = address_in;
			data_in = d_in;
		end
	endtask
	
	task read_data(input [3:0] address_in);
		begin
			@(posedge clk); // sync to positive edge of clock
			write_en = 0;
			address = address_in;
		end
	endtask
	
	// Compare write data with read data
	task compare_data(input [3:0] address, input [7:0] expected_data, input [7:0] observed_data);
		begin
			if (expected_data === observed_data) begin // use case equality operator
				$display($time, " SUCCESS address = %0d, expected_data = %2x, observed_data = %2x",
								  address, expected_data, observed_data);
				success_count = success_count + 1;
			end else begin
				$display($time, " ERROR address = %0d, expected_data= %2x, observed_data = %2x",
								  address, expected_data, observed_data);
				error_count = error_count + 1;
			end
		end
	endtask
	
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
	// Crate stimulus
	initial begin
		#1;
		// Clear the statistics counters
		success_count = 0; error_count = 0; test_count = 0;
		
		#1.3;
		for (i=0; i<17; i=i+1) begin
			wr_data = $random; 
			write_data(i, wr_data);	// write random data at an address
			read_data(i);			// read that address back
			#0.1;                   // wait for output to stabilize
			compare_data(i, wr_data, data_out);
			delay = $random;
			#(delay); // wait between tests
		end
		
		read_data(7);  // Show the read behaviour
		read_data(8);
		
		// Print statistics
		$display($time, " TEST RESULTS success_count = %0d, error_count = %0d, test_count = %0d",
						success_count, error_count, test_count);
		#40 $stop;
	end
endmodule
	
/*
#                    4 SUCCESS address = 0, expected_data = 24, observed_data = 24
#                    7 SUCCESS address = 1, expected_data = 09, observed_data = 09
#                   12 SUCCESS address = 2, expected_data = 0d, observed_data = 0d
#                   15 SUCCESS address = 3, expected_data = 65, observed_data = 65
#                   19 SUCCESS address = 4, expected_data = 01, observed_data = 01
#                   22 SUCCESS address = 5, expected_data = 76, observed_data = 76
#                   25 SUCCESS address = 6, expected_data = ed, observed_data = ed
#                   27 SUCCESS address = 7, expected_data = f9, observed_data = f9
#                   31 SUCCESS address = 8, expected_data = c5, observed_data = c5
#                   35 SUCCESS address = 9, expected_data = e5, observed_data = e5
#                   40 SUCCESS address = 10, expected_data = 12, observed_data = 12
#                   45 SUCCESS address = 11, expected_data = f2, observed_data = f2
#                   49 SUCCESS address = 12, expected_data = e8, observed_data = e8
#                   52 SUCCESS address = 13, expected_data = 5c, observed_data = 5c
#                   55 SUCCESS address = 14, expected_data = 2d, observed_data = 2d
#                   58 SUCCESS address = 15, expected_data = 63, observed_data = 63
#                   62 SUCCESS address = 0, expected_data = 80, observed_data = 80
#                   64 TEST RESULTS success_count = 17, error_count = 0, test_count = 0

There is one clock cycle difference between the change in address and the data_out value
*/