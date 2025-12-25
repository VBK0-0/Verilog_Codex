module ram_dp_async_read
		#(parameter WIDTH = 0,
		  parameter DEPTH = 16,
		  parameter DEPTH_LOG = $clog2(DEPTH))
		(input clk,
		 input we_n, //write_enable_n
		 input [DEPTH_LOG-1:0] addr_wr, // The address bus has a log2(DEPTH)
		 input [DEPTH_LOG-1:0] addr_rd,
		 input [WIDTH-1:0] data_wr,
		 output [WIDTH-1:0]data_rd
		);
		
	// Declare the RAM array
	reg [WIDTH-1:0] ram [0:DEPTH-1];
	
	// Write is synchronous
	always @(posedge clk) begin
		if (we_n)
			ram[addr_wr] <= data_wr;
	end
	
	// Read is asynchronous
	assign data_rd = ram[addr_rd];
	
endmodule

		 