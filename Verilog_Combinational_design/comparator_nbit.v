module comparator_nbit
	// Parameters section
	#( parameter N = 4)
	// Ports section
	(input [N-1:0] a,
	 input [N-1:0] b,
	 output reg smaller,
	 output reg equal,
	 output reg greater
	 );
	 
	 // Wildcard operator is best for the procedure's
	 // sensitivity list (control list)
	 always @(*) begin
		smaller = (a < b);
		equal   = (a==b);
		greater = (a > b);
	end

endmodule