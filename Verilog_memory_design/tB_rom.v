`timescale 1us/1ns
module tB_rom();

	localparam WIDTH = 8;
	localparam DEPTH = 16;
	localparam DEPTH_LOG = $clog2(DEPTH);
	
	reg clk = 0;
	reg [DEPTH_LOG-1:0] addr_rd;
	wire [WIDTH-1:0] data_rd;
	
	integer i;
	
	// Instantiate the module
	rom #(.WIDTH(WIDTH),
		  .DEPTH(DEPTH)
		) ROM0
		(.clk	  (clk    ),
		 .addr_rd (addr_rd),
		 .data_out(data_rd)
		);
		
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	initial begin
		#1;
		$display($time, " ROM content:");
		for (i=0; i<DEPTH; i=i+1) begin
			read_data(i);
		end
		#40 $stop;
	end
	
	// Read the data asynchronously
	task read_data(input[DEPTH_LOG-1:0] address_in);
		begin
			@(posedge clk);
			addr_rd = address_in;
			@(posedge clk);
			#0.1; // wait for the data to propogate
			$display($time, " address = %2d, data_rd = %x", addr_rd, data_rd);
		end
	endtask
endmodule

/*
#                    1 ROM content:
#                    3 address =  0, data_rd = a0
#                    5 address =  1, data_rd = a1
#                    7 address =  2, data_rd = a2
#                    9 address =  3, data_rd = a3
#                   11 address =  4, data_rd = a4
#                   13 address =  5, data_rd = a5
#                   15 address =  6, data_rd = a6
#                   17 address =  7, data_rd = a7
#                   19 address =  8, data_rd = a8
#                   21 address =  9, data_rd = a9
#                   23 address = 10, data_rd = aa
#                   25 address = 11, data_rd = ab
#                   27 address = 12, data_rd = ac
#                   29 address = 13, data_rd = ad
#                   31 address = 14, data_rd = ae
#                   33 address = 15, data_rd = af
*/