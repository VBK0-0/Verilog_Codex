module priority_encoder1_4to2 (
	input [3:0] d,
	output reg [1:0] q,
	output reg v
	);
	
	//Decode the priority of the set bits
	always @(*) begin
		if (d[3])
			q = 2'd3;
		else if (d[2])
			q = 2'd2;
		else if (d[1])
			q = 2'd1;
		else 
			q = 2'd0;
	end
	
	// Valid is asserted when any bit is set
	always @(*) begin
		if (!d)
			v = 0;
		
		else
			v = 1;
	end

endmodule
