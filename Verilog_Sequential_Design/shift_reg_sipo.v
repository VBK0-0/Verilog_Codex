module shift_reg_sipo(
	input reset_n,
	input clk,
	input sdi,	// Serial data in
	output reg [3:0] q
	);
	
	// Async negative reset_n is used
	// The input data is the same as the output data
	always @(posedge clk or negedge reset_n) begin
		if (!reset_n)
			q <= 4'b0;
		else
			q[3:0] <= {q[2:0], sdi};
		end
endmodule
	