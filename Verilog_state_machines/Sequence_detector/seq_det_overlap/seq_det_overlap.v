module seq_det_overlap(
		input clk,
		input rst_n,
		input seq_in,
		output reg detected,
		output [1:0] state_out // used for debug
		);
		
	// Declare the state values as parameters using binary values
	parameter [1:0] S1   = 2'd0,
					S10  = 2'd1,
					S101 = 2'd2;
					
	// Declare the logic for the state machine
	reg [3:0] state;		// the sequential part
	reg [3:0] next_state;   // the combinational part
	
	
	// Next state logic
	always @(*) begin
		detected = 1'b0;
		case (state)
			S1  : begin   // wait for the first 1
					if (seq_in == 1) next_state = S10;
					else			 next_state = S1;
				end
			S10 : begin   // wait next for a 0
					if (seq_in ==0) next_state = S101;
					else			next_state = S10;
				end
			S101: begin
					if (seq_in == 1) begin
						next_state = S10;
						detected = 1'b1;
					end else begin 
						next_state = S1;
					end
				end
			default: next_state = S1; // best practice
		endcase
	end
	
	// State sequencer logic
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			state <= next_state;
		else
			state <= next_state;
	end
	
	assign state_out = state; // connect with output port
	
endmodule
		
