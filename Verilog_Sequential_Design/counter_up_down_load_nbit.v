module counter_up_down_load_nbit
	// Parameters section
	#(parameter CNT_WIDTH = 3)
	// Ports section
	(input clk,
	input reset_n,
	input load_en,
	input [CNT_WIDTH - 1:0] counter_in,
	input up_down,
	output reg [CNT_WIDTH - 1:0] counter_out);
	
	// Use non-blocking assignment for sequential logic
	always @(posedge clk or negedge reset_n) begin
		if (!reset_n)
			counter_out <= 0;
		else if (load_en) // loading has priority
			counter_out <= counter_in;
		else begin
			if (up_down == 1'b1) begin
				counter_out <= counter_out + 1'b1;
			end else begin
				counter_out <= counter_out - 1'b1;
			end
		end
	end

endmodule