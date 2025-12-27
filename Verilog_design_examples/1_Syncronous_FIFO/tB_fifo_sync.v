`timescale 1us/1ns
module tB_fifo_sync();
	
	// Testbench variables
	parameter FIFO_DEPTH = 8;
	parameter DATA_WIDTH = 32;
    reg clk = 0; 
    reg rst_n;
    reg cs;	 
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
	wire empty;
	wire full;
	
    integer i;
	
	// Instantiate the DUT
	fifo_sync 
	    #(.FIFO_DEPTH(FIFO_DEPTH),
	     .DATA_WIDTH(DATA_WIDTH))
        FIFO0
  	    (.clk     (clk     ), 
         .rst_n   (rst_n   ),
         .cs      (cs      ),	 
         .wr_en   (wr_en   ), 
         .rd_en   (rd_en   ), 
         .data_in (data_in ), 
         .data_out(data_out), 
	     .empty   (empty   ),
	     .full    (full    ));

    task write_data(input [DATA_WIDTH-1:0] d_in);
	    begin
		    @(posedge clk); // sync to positive edge of clock
			cs = 1; wr_en = 1;
			data_in = d_in;
			$display($time, " write_data data_in = %0d", data_in);
			@(posedge clk);
		    cs = 1; wr_en = 0;
		end
	endtask
	
	task read_data();
	    begin
		    @(posedge clk);  // sync to positive edge of clock
			cs = 1; rd_en = 1;
			@(posedge clk);
			#0.1;
		    $display($time, " read_data data_out = %0d", data_out);
		    cs = 1; rd_en = 0;
		end
	endtask
	
	// Create the clock signal
	always begin #0.5 clk = ~clk; end
	
    // Create stimulus	  
    initial begin
	    #1; 
		rst_n = 0; rd_en = 0; wr_en = 0;
		
		#1.3; 
		rst_n = 1;
		$display($time, "\n SCENARIO 1");
		write_data(1);
		write_data(10);
		write_data(100);
		read_data();
		read_data();
		read_data();
		read_data();
		
        $display($time, "\n SCENARIO 2");
		for (i=0; i<FIFO_DEPTH; i=i+1) begin
		    write_data(2**i);
			read_data();        
		end

        $display($time, "\n SCENARIO 3");		
		for (i=0; i<=FIFO_DEPTH; i=i+1) begin
		    write_data(2**i);
		end
		
		for (i=0; i<FIFO_DEPTH; i=i+1) begin
			read_data();
		end
		
	    #40 $stop;
	end
endmodule
/*
#  SCENARIO 1
#                    3 write_data data_in = 1
#                    5 write_data data_in = 10
#                    7 write_data data_in = 100
#                   10 read_data data_out = 1
#                   12 read_data data_out = 10
#                   14 read_data data_out = 100
#                   16 read_data data_out = 100
#                   16
#  SCENARIO 2
#                   17 write_data data_in = 1
#                   20 read_data data_out = 1
#                   21 write_data data_in = 2
#                   24 read_data data_out = 2
#                   25 write_data data_in = 4
#                   28 read_data data_out = 4
#                   29 write_data data_in = 8
#                   32 read_data data_out = 8
#                   33 write_data data_in = 16
#                   36 read_data data_out = 16
#                   37 write_data data_in = 32
#                   40 read_data data_out = 32
#                   41 write_data data_in = 64
#                   44 read_data data_out = 64
#                   45 write_data data_in = 128
#                   48 read_data data_out = 128
#                   48
#  SCENARIO 3
#                   49 write_data data_in = 1
#                   51 write_data data_in = 2
#                   53 write_data data_in = 4
#                   55 write_data data_in = 8
#                   57 write_data data_in = 16
#                   59 write_data data_in = 32
#                   61 write_data data_in = 64
#                   63 write_data data_in = 128
#                   65 write_data data_in = 256
#                   68 read_data data_out = 1
#                   70 read_data data_out = 2
#                   72 read_data data_out = 4
#                   74 read_data data_out = 8
#                   76 read_data data_out = 16
#                   78 read_data data_out = 32
#                   80 read_data data_out = 64
#                   82 read_data data_out = 128
 In SCENARIO 3 the FIFO is full after 8 read data
*/