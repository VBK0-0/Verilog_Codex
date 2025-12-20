module shift_left_right_load_reg(
	input reset_n,
	input clk,
	input [7:0]I,
	input load_enable,  //0 for load and 1 for enable shifting
	input shift_left_right,  // 0 for left shift and 1 for right shift
	output reg [7:0]q
	);
	
	//Async negative register is used
	always@(posedge clk or negedge reset_n) begin
		if(!reset_n)
			q <= 8'b0;
		
		else if (load_enable == 1'b0) 		// Load register
			q <= I;
		else begin 
			if(shift_left_right == 1'b0) begin	// Shift register
				q <= {I[6:0],1'b0};				// Left shift
			end else begin
				q <= {1'b0,I[7:1]};				// Right shift
			end
		end
	end
endmodule
		
		
		
	
		
	
		 