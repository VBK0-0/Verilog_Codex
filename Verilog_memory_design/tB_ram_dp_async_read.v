`timescale 1us/1ns
module tB_ram_dp_async_read();

	localparam WIDTH = 8;
	localparam DEPTH = 16;
	localparam DEPTH_LOG = $clog2(DEPTH);
	
	reg clk;
	reg we_n;
	reg [DEPTH_LOG-1:0] addr_wr;
	reg [DEPTH_LOG-1:0] addr_rd;
	reg [WIDTH-1:0] data_wr;
	wire [WIDTH-1:0] data_rd;
	
	integer i;
	integer num_tests = 0;   // how many tests to perform
	integer test_count = 0;
	integer success_count = 0;
	integer error_count = 0;
	reg [DEPTH_LOG-1:0] rand_addr_wr;
		
	// Instantiate the module
	ram_dp_async_read 
		#(.WIDTH(WIDTH),
		  .DEPTH(DEPTH)
		) ram_dual_port0
		(.clk    (clk    ),
		 .we_n   (we_n   ),
		 .addr_wr(addr_wr), 
		 .addr_rd(addr_rd),    	
		 .data_wr(data_wr),
		 .data_rd(data_rd)		
	);
	
	initial begin // Create the clock signal
		clk=0;
		forever begin
			#1 clk = ~clk;
		end
	end
	
	// Test scenario
	// Test 1: write random data at a specific address, read it back and
    //	       compare it with the written data.
	// Test 2: write at a random address data with a known pattern, read it back
	//         and compare it with the written data.
	
	initial begin
		#1;
		// Clear the statistics counters
		success_count = 0; error_count = 0; test_count = 0;
		num_tests = DEPTH;
		#1.3;
		
		$display($time, " Test1 Start");
		for (i=0; i<num_tests; i=i+1) begin
			data_wr = $random;
			write_data(data_wr, i);  // write random data at an address
			read_data(i);            // read that address back
			#0.1;					 // wait for output to stabilize 
		end
			
		
		$display($time, " Test2 Start");
		for (i=0; i<num_tests; i=i+1) begin
			rand_addr_wr = $random % DEPTH;
			data_wr = (rand_addr_wr << 4) | ((rand_addr_wr%2) ? 4'hA : 4'h5); // (even_position << 4) | 0x5
																			  // (odd_position  << 4) | 0
			write_data(data_wr, rand_addr_wr);	// write random data at a random address
			read_data (rand_addr_wr);			// read that address back
			#0.1;
			compare_data(rand_addr_wr, data_wr, data_rd);
		end
		
		
		// Print statistics
		$display($time, " TEST RESULTS success_count = %0d, error_count = %0d, test_count = %0d",
						success_count, error_count, test_count);
		#40 $stop;
	end
	
	// All the tasks are below the test scenario location
	task write_data(input[WIDTH-1:0] data_in, input[DEPTH_LOG-1:0] address_in);
		begin	
			@(posedge clk);
			we_n = 1; data_wr = data_in; addr_wr = address_in;
			@(posedge clk);
			we_n = 0;
		end
	endtask
	
	// Read the data asynchronously
	task read_data(input [DEPTH_LOG-1:0] address_in);
		begin
			addr_rd = address_in;
			// $display($time, "data_rd = %d", data_rd); // use for debug
		end 
	endtask
	
	// Compare write data with read data
	task compare_data(input [DEPTH_LOG-1:0] address,
					  input [WIDTH-1:0] expected_data,
					  input [WIDTH-1:0] observed_data);
					  
		begin
			if (expected_data === observed_data) begin // use case equality operator
				$display($time, "SUCCESS address = %0d, expected_data = %0x, observed_data = %0x",
								 address, expected_data, observed_data);
				success_count = success_count + 1;
			end else begin
				$display($time, " ERROR address = %0d, expected_data = %0x, observed_data = %0x",
								  address, expected_data, observed_data);
				error_count = error_count + 1;
			end
			test_count = test_count + 1;
		end
	endtask
	
endmodule
	
/*
#                    2 Test1 Start
#                   65 Test2 Start
#                   69SUCCESS address = 5, expected_data = 5a, observed_data = 5a
#                   73SUCCESS address = 10, expected_data = a5, observed_data = a5
#                   77SUCCESS address = 5, expected_data = 5a, observed_data = 5a
#                   81SUCCESS address = 7, expected_data = 7a, observed_data = 7a
#                   85SUCCESS address = 2, expected_data = 25, observed_data = 25
#                   89SUCCESS address = 15, expected_data = fa, observed_data = fa
#                   93SUCCESS address = 2, expected_data = 25, observed_data = 25
#                   97SUCCESS address = 14, expected_data = e5, observed_data = e5
#                  101SUCCESS address = 8, expected_data = 85, observed_data = 85
#                  105SUCCESS address = 5, expected_data = 5a, observed_data = 5a
#                  109SUCCESS address = 12, expected_data = c5, observed_data = c5
#                  113SUCCESS address = 13, expected_data = da, observed_data = da
#                  117SUCCESS address = 13, expected_data = da, observed_data = da
#                  121SUCCESS address = 5, expected_data = 5a, observed_data = 5a
#                  125SUCCESS address = 3, expected_data = 3a, observed_data = 3a
#                  129SUCCESS address = 10, expected_data = a5, observed_data = a5
#                  129 TEST RESULTS success_count = 16, error_count = 0, test_count = 16
*/