module shift_reg_pipo_buggy( 
	input reset_n,
	input clk,
	input [7:0] d,
	output reg [7:0] q
	);
	
	// We will intentionally insert an error in this circuit
	always @(posedge clk or negedge reset_n) begin
		if (!reset_n)
			q <= 0;
		else
			q[7:0] <= d[6:0]; // size mismatch (MSB not connected)
			// q[7:0] <= d[7:0]; // the correct version
			
		end
		
	endmodule