// Metro turnstile - Melay FSM
module fsm1(
		input clk,
		input rst_n,
		input validate_code,
		input [3:0] access_code, 		// 4 bit metro access code
		output reg open_access_door,
		output [1:0] state_out			// used for debug
		);
		
	// Declare the state values as parameters (not DEFINE because gives better synthesis results)
	parameter [1:0] IDLE		   = 2'b0,
					CHECK_CODE     = 2'b01,
					ACCESS_GRANTED = 2'b10;
					
	// Declare the logic for the state machine
	reg [1:0] state;		  // the sequential part
	reg [1:0] next_state; // the combinational part
	
	reg [3:0] timer;      // the counter that keeps the gate open_access_door
	
	// Next state logic
	always @(*) begin
		next_state = IDLE;		// default values
		open_access_door = 0;   // door is closed
		case (state)
			IDLE			: begin
								if (validate_code) next_state = CHECK_CODE;
							end
			CHECK_CODE      : begin
								if ((access_code >= 4'd4) && (access_code <= 4'd11))
									next_state = ACCESS_GRANTED;
							end
			ACCESS_GRANTED  : begin
								open_access_door = 1;
								if  (timer == 4'hF) next_state = IDLE;
								else				next_state = ACCESS_GRANTED;
							end
			default: next_state = IDLE; // best practice
		endcase
	end
	
	// State sequencer logic
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			state <= IDLE;
		else
			state <= next_state;
	end
	
	assign state_out = state; // connect with output port
	
	// Timer logic
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			timer <= 0;
		else if (state == ACCESS_GRANTED)
			timer <= timer + 1'b1; // increment timer only in this state
		else 
			timer <= 0;
	end
	
endmodule
		
