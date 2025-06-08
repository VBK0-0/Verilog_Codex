module vectors_example();

	reg [7:0] a = 0;    //8bit register (MSB_position=7, LSB_position=0)
	reg [6:0] b = 0;	//7bit register
	reg [7:0] d = 0;	//8bit register
	
	wire [1:0] c;		//8bit net
	
	// Continuous assignment between a net and a register
	// c[1] = a[3];
    // c[0] = a[2];
    assign c[1:0] = a[3:2]; //this is also called bit slicing
	
	//Procedure used to continuously monitor 'a', 'b', 'c' and 'd'
	initial begin
	  $monitor("PROC2 a=%b, b=%b, c=%b, d=%b", a, b, c, d);
	end
	
	// Another procedure example
	initial begin	
		//Change only the value of 'a' to see the effect on 'c'
		#1 a = 1;
		#1 a = 8'b1111_1010;
		#1 a = 8'b1111_1000;
		#1 a = 8'b0000_1000;
		#1 a = 8'b0;
		
		#1 b = 7'b111_1111;	//change the value of b
		#1 d[3:0] = a[3:0];	//change the value of d
		#1 d[7:4] = b[6:3];
		
		#1 a = 8'b0000_1110; //change the value of a
		#1 d = {a[3:0], b[3:0]}; //concatination
		#1 d = {b[3:0], a[7:4]}; //concatination
	end
	
endmodule

/*Output:
# PROC2 a=00000000, b=0000000, c=00, d=00000000
# PROC2 a=00000001, b=0000000, c=00, d=00000000
# PROC2 a=11111010, b=0000000, c=10, d=00000000
# PROC2 a=11111000, b=0000000, c=10, d=00000000
# PROC2 a=00001000, b=0000000, c=10, d=00000000
# PROC2 a=00000000, b=0000000, c=00, d=00000000
# PROC2 a=00000000, b=1111111, c=00, d=00000000
# PROC2 a=00000000, b=1111111, c=00, d=11110000
# PROC2 a=00001110, b=1111111, c=11, d=11110000
# PROC2 a=00001110, b=1111111, c=11, d=11101111
# PROC2 a=00001110, b=1111111, c=11, d=11110000
*/	