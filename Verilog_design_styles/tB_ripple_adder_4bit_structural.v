module tB_ripple_adder_4bit_structural();

	// Declare variables and nets for module ports
	reg [3:0] a;
	reg [3:0] b;
	reg cin;
	wire [3:0] sum;
	wire cout;
	
	integer i, j; // used for verification
	
	// Instantiate the module
	ripple_adder_4bit_structural RIPPLE_ADD_BIT(
        .a(a),
        .b(b),
        .carry_in(cin),
        .sum(sum),
        .carry_out(cout)
        );
  
    // Generate stimulus and monitor module ports
    initial begin
      $monitor("a=%b, b=%b, carry_in=%0b, sum=%0d, carry_out=%b", a, b, cin, sum, cout);
    end  
  
    initial begin
        #1; a = 4'b0000; b = 4'b0000; cin = 0;
        #1; a = 4'b0000; b = 4'b0000; cin = 1;
        #1; a = 4'b0001; b = 4'b0001; cin = 0;
        #1; a = 4'b0001; b = 4'b0001; cin = 1;
        #1; a = 4'd3;    b = 4'd6;    cin = 0;
        // Change the values of a and b and observe the effects
      
        for (i=0; i<2; i=i+1) begin
            for (j=0; j<2; j=j+1) begin
                #1 a = i; b = j; cin = 0;
            end
        end
        // Change the loops limits observe the effects

    end
  
endmodule

/*
Output:
# a=xxxx, b=xxxx, carry_in=x, sum=x, carry_out=x
# a=0000, b=0000, carry_in=0, sum=0, carry_out=0
# a=0000, b=0000, carry_in=1, sum=1, carry_out=0
# a=0001, b=0001, carry_in=0, sum=2, carry_out=0
# a=0001, b=0001, carry_in=1, sum=3, carry_out=0
# a=0011, b=0110, carry_in=0, sum=9, carry_out=0
# a=0000, b=0000, carry_in=0, sum=0, carry_out=0
# a=0000, b=0001, carry_in=0, sum=1, carry_out=0
# a=0001, b=0000, carry_in=0, sum=1, carry_out=0
# a=0001, b=0001, carry_in=0, sum=2, carry_out=0
*/	