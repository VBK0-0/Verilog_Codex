`timescale 1us/1ns
module tb_adder_4bit_behav();
  
    // Declare variables and nets for module ports
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire [3:0]sum;
    wire cout; 
  
    integer i, j; // used for verification
    parameter LOOP_LIMIT = 4;
  
    // Instantiate the module
    adder_4bit_behavioral ADD_4BIT(
        .a(a),
        .b(b),
        .carry_in(cin),
        .sum(sum),
        .carry_out(cout)
        );
  
    // Generate stimulus and monitor module ports
    initial begin     
        // Change the values of LOOP_LIMIT observe the effects      
        for (i=LOOP_LIMIT; i>0; i=i-1) begin
            for (j=LOOP_LIMIT; j>0; j=j-1) begin
                a = i; b = j; cin = i%2;
				#1;
				$display($time, " a=%0d, b=%0d, carry_in=%0b, sum=%0d, carry_out=%b", 
				                  a, b, cin, sum, cout);
            end
        end
		
	    #10; $stop;
    end
  
endmodule

/*
output:
#                    1 a=4, b=4, carry_in=0, sum=8, carry_out=0
#                    2 a=4, b=3, carry_in=0, sum=7, carry_out=0
#                    3 a=4, b=2, carry_in=0, sum=6, carry_out=0
#                    4 a=4, b=1, carry_in=0, sum=5, carry_out=0
#                    5 a=3, b=4, carry_in=1, sum=8, carry_out=0
#                    6 a=3, b=3, carry_in=1, sum=7, carry_out=0
#                    7 a=3, b=2, carry_in=1, sum=6, carry_out=0
#                    8 a=3, b=1, carry_in=1, sum=5, carry_out=0
#                    9 a=2, b=4, carry_in=0, sum=6, carry_out=0
#                   10 a=2, b=3, carry_in=0, sum=5, carry_out=0
#                   11 a=2, b=2, carry_in=0, sum=4, carry_out=0
#                   12 a=2, b=1, carry_in=0, sum=3, carry_out=0
#                   13 a=1, b=4, carry_in=1, sum=6, carry_out=0
#                   14 a=1, b=3, carry_in=1, sum=5, carry_out=0
#                   15 a=1, b=2, carry_in=1, sum=4, carry_out=0
#                   16 a=1, b=1, carry_in=1, sum=3, carry_out=0
*/
