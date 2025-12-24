`timescale 1us/1ns
module task_control_shift_reg ();

	// Testbench variables
	parameter REG_WIDTH = 0;
	reg load, shift_left_right;
	reg [REG_WIDTH-1:0] data_in;
	reg clk = 0;
	
	// This task is used to control a "Shift left/right register with load"
	// The operations below are happening on "posedge clk"
	// If load = 1 then the register is loaded with the value of data in
	// If load = 0 and shift_left_right = 1 then the register should shift left its content
	// If load = 0 and shift_left_right = 0 then the register should shift right its content
	// The task will change the value of some global "reg variables" which can be connected to a DUT
	// No DUT is present here
	task control_shift_reg (input i_load, i_shift_left_right, input [REG_WIDTH-1:0] i_data_in);
		begin
			@(posedge clk);		    // Control are applied on posedge
			load      = i_load;     // Global variables from LHS are updated with local values from RHS
			shift_left_right = i_shift_left_right;
			data_in   = i_data_in;
		end
	endtask
	
	// Create a clock signal
	always begin #1 clk = ~clk; end
	
	// Variables used for stimulus
	initial begin
		$monitor ($time, " load = %0b, shift_left_right = %0b, data_in = %8b", load, shift_left_right, data_in);
		// Call the task using the 'position' call for its input parameters
		control_shift_reg(1, 0, 8'd1);			// load with 1
		control_shift_reg(1, 0, 8'b1010_0101);	// load with 8'b1010_0101
		control_shift_reg(1, 1, $random);		// load with $random
		
		// Call the task using the 'position' call for its input parameters
		control_shift_reg(0, 1, 0);			// shift left
		control_shift_reg(1, 0, $random);	// load with random
		control_shift_reg(0, 0, $random);   // shift right
		$finish();
	end
endmodule

/*
#                    0 load = x, shift_left_right = x, data_in = 000000xx
#                    1 load = 1, shift_left_right = 0, data_in = 00000001
#                    5 load = 1, shift_left_right = 1, data_in = 00000000
#                    7 load = 0, shift_left_right = 1, data_in = 00000000
#                    9 load = 1, shift_left_right = 0, data_in = 00000001
#                   11 load = 0, shift_left_right = 0, data_in = 00000001
*/