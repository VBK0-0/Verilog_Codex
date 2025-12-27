// Traffic light FSM (Melay)
module semaphore_fsm(
		input clk,
		input rst_n,
		input enable,
		output reg red,
		output reg yellow,
		output reg green,
		output [3:0] state_out // used for debug
		);
		
	// Declare the state values as parameters using ONE-HOT encoding 
	parameter [3:0] OFF    = 4'b0001,
					RED    = 4'b0010,
					YELLOW = 4'b0100,
					GREEN  = 4'b1000;
					
	// Declare the logic for the state machine
	reg [3:0] state;	   // the sequential part
	reg [3:0] next_state;  // the combinational part
	
	reg [5:0] timer;	   // the counter that keeps the gate open
	reg       timer_clear; // when set, it resets the timer value
	
	// Next state logic
	always @(*) begin
		next_state  = OFF;
		red			= 0;		// default values
		yellow      = 0;
		green       = 0;
		timer_clear = 0;
		case (state)
			OFF   		  : begin	
								if (enable) next_state = RED;
							end
			RED           : begin
								red = 1;
								if (timer == 6'd50) begin
									next_state  = YELLOW;
									timer_clear = 1;
								end else begin
									next_state = RED;
								end
							end
			YELLOW		  : begin
								yellow = 1;
								if (timer == 6'd10) begin
									next_state = GREEN;
								end else begin
									next_state = YELLOW;
								end
							end
			GREEN         : begin 
								green = 1;
								if (timer == 6'd30) begin
									next_state = RED;
									timer_clear = 1;
								end else begin
									next_state = GREEN;
								end
							end
			default: next_state = OFF; // best practice
		endcase
		
		// Return from any state to OFF if enable == 0
		if (!enable) begin
			next_state = OFF;
		end
	end
		
	// State sequencer logic
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			state <= OFF;
		else
			state <= next_state;
	end
	
	assign state_out = state; // connect with output port
	
	// Timer logic
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n)
			timer <= 0;
		else if ((timer_clear == 1) || (!enable))
			timer <= 0;
		else if (state != OFF)  // increment timer if state != OFF
			timer <= timer +1'b1;
	end
	
endmodule
