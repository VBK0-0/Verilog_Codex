module shift_reg_piso(
		input clk,
		input reset_n,
		input sdi, // serial data in
		input pl,  // preload
		input [3:0] d,
		output sdo
		);

			// Internal 4 bit wide register
			reg [3:0] piso;
			wire [3:0] data_src; //nets after the mux'es
			
			// If pl == 1 uses the parallel input as data source
			assign data_src = pl ? d : {piso[2:0], sdi};
			
			// Async negative reset is used
			always @(posedge clk or negedge reset_n) begin
				if (!reset_n)
						piso <= 4'b0;
				else
						piso[3:0] <= data_src;
			end
			
		// connect the sdo net to the register MSB
		assign sdo = piso[3];
		
	endmodule
	