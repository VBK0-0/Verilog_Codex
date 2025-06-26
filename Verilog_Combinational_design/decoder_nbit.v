module decoder_nbit
	// Parameters section
	#( parameter N = 3)
	// Ports section
	(input [N-1:0] a,
	 input enable,
	 output reg [2**N-1:0] y
	);
	
	always @(*) begin
		if (enable == 0)
			y = 0;
		else
			y = (1 << a);
	end
		
endmodule