`timescale 1us/1ns
module tb_encrypt( );
	
   // Declare testbench variables
   reg clk = 0; 
   reg rst_n;
   
   reg load_seed;
   reg [7:0] seed_in;
   reg encrypt_en;
   reg [7:0] data_in;
   
   wire [7:0] data_out;
   wire [7:0] data_out_ref;
 
   // Create stimulus
   parameter HALF_PERIOD = 0.5;
	
   integer i;
   integer success_count = 0;
   integer test_count    = 0;
   integer error_count   = 0;
   
   // Instantiate the DUT
   top_encrypt ENCRYPT_MODULE(
            .rst_n     (rst_n     ),
            .clk       (clk       ),
            .load_seed (load_seed ),
            .seed_in   (seed_in   ),
            .encrypt_en(encrypt_en),
            .data_in   (data_in   ),
			.data_out  (data_out  ));

    // Instantiate the reference module (golden model)
    top_encrypt_golden ENCRYPT_MODULE_REF(
            .rst_n     (rst_n       ),
            .clk       (clk         ),
            .load_seed (load_seed   ),
            .seed_in   (seed_in     ),
            .encrypt_en(encrypt_en  ),
            .data_in   (data_in     ),
		    .data_out  (data_out_ref));
  

    always begin #HALF_PERIOD clk = ~clk; end    

    initial begin
        rst_n = 0;      // reset
        load_seed = 0;  // clear all input variables
        seed_in = 0;
        data_in = 0; 
        encrypt_en = 0;      
        #20;
        rst_n = 1;      // release reset
	    
        @(posedge clk);  // Encrypt a message with default SEED
        encrypt_data("R"); validate_data();
        encrypt_data("e"); validate_data();
        encrypt_data("d"); validate_data();
        encrypt_data(" "); validate_data();
        encrypt_data("a"); validate_data();
        encrypt_data("p"); validate_data();
        encrypt_data("p"); validate_data();
        encrypt_data("l"); validate_data();
        encrypt_data("e"); validate_data();
        encrypt_data("."); validate_data();
        
        #20;              // Decrypt the message
        load_new_seed(8'hCD); // reload the PRNG
        encrypt_data(8'hc8); validate_data();
        encrypt_data(8'h50); validate_data();
        encrypt_data(8'h0e); validate_data();
        encrypt_data(8'hf4); validate_data();
        encrypt_data(8'hc9); validate_data();
        encrypt_data(8'h21); validate_data();
        encrypt_data(8'hd3); validate_data();
        encrypt_data(8'h2a); validate_data();
        encrypt_data(8'he9); validate_data();
        encrypt_data(8'h36); validate_data(); 		
       
        if(error_count==0)
	        $display($time,(" TEST PASS: test_count=%d, success_count=%d, error_count=%d"),
			                test_count,success_count,error_count);
        else
	        $display($time,(" TEST FAIL: test_count=%d, success_count=%d, error_count=%d"),
			                test_count,success_count,error_count);
        
        #40 $stop; 
    end

	/*always @(data_out) // used to collect output data from log
	begin
	   $display($time,(" data_out= %x"),data_out);
	end */
	
	task load_new_seed;
	    input [7:0] seed;
	    begin
	        @(posedge clk);
	        load_seed = 1;
	        seed_in = seed;
	        //$display($time,(" seed=%s"),seed_in);
	        @(posedge clk);
	        load_seed = 0;  
	    end
	endtask

	task encrypt_data;
	    input [7:0] data;
	    begin
	        // Wait until positive edge of clock
	        @(posedge clk);
	        encrypt_en = 1;
	        data_in = data;
	        //$display($time,(" data_wr=%s "),data_in);
	        @(posedge clk);
	        encrypt_en = 0;  
	    end
	endtask
	
	task validate_data;
	    begin
	        @(posedge clk); // it takes 1 clock to compute
	        @(negedge clk); // the sample time
	        
	        test_count = test_count + 1; // increment the test counter operation
	        if((data_out_ref === data_out)) begin
	    	    $display($time,(" test_count=%d  PASS: data_out_ref=%x, data_out=%x"), 
				                  test_count, data_out_ref, data_out);
	    	    success_count = success_count +1;
	        end else begin
	    	    $display($time,(" test_count=%d  FAIL: data_out_ref=%x, data_out=%x"), 
				                  test_count, data_out_ref, data_out);      
	    	    error_count = error_count +1;         
	        end
	    end
	endtask
endmodule
/*
#                   24 test_count=          1  PASS: data_out_ref=c8, data_out=c8
#                   27 test_count=          2  PASS: data_out_ref=50, data_out=50
#                   30 test_count=          3  PASS: data_out_ref=0e, data_out=0e
#                   33 test_count=          4  PASS: data_out_ref=f4, data_out=f4
#                   36 test_count=          5  PASS: data_out_ref=c9, data_out=c9
#                   39 test_count=          6  PASS: data_out_ref=21, data_out=21
#                   42 test_count=          7  PASS: data_out_ref=d3, data_out=d3
#                   45 test_count=          8  PASS: data_out_ref=2a, data_out=2a
#                   48 test_count=          9  PASS: data_out_ref=e9, data_out=e9
#                   51 test_count=         10  PASS: data_out_ref=36, data_out=36
#                   76 test_count=         11  PASS: data_out_ref=52, data_out=52
#                   79 test_count=         12  PASS: data_out_ref=65, data_out=65
#                   82 test_count=         13  PASS: data_out_ref=64, data_out=64
#                   85 test_count=         14  PASS: data_out_ref=20, data_out=20
#                   88 test_count=         15  PASS: data_out_ref=61, data_out=61
#                   91 test_count=         16  PASS: data_out_ref=70, data_out=70
#                   94 test_count=         17  PASS: data_out_ref=70, data_out=70
#                   97 test_count=         18  PASS: data_out_ref=6c, data_out=6c
#                  100 test_count=         19  PASS: data_out_ref=65, data_out=65
#                  103 test_count=         20  PASS: data_out_ref=2e, data_out=2e
#                  103 TEST PASS: test_count=         20, success_count=         20, error_count=          0
*/