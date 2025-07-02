module demux_nbit_x4
	//Parameters selection
   #( parameter BUS_WIDTH = 8)
    // Ports section
   ( input [BUS_WIDTH-1:0] y,
     input [1:0] sel,
	 output reg [BUS_WIDTH-1:0] a,
	 output reg [BUS_WIDTH-1:0] b,
	 output reg [BUS_WIDTH-1:0] c,
	 output reg [BUS_WIDTH-1:0] d
	);
	
	always @(*) begin
	  a = 0; b = 0; c = 0; d = 0;
	  case (sel)
		 2'd0 : begin a = y; end
		 2'd1 : begin b = y; end
		 2'd2 : begin c = y; end
		 2'd3 : begin d = y; end
		 default: begin a = y; end
	  endcase
	end
	
endmodule