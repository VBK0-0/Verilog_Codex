 module bitwise_operators(
	//no inputs here
	);
	
	reg [5:0] x = 0;      //6bit variable
	reg [5:0] y = 0;	  //6bit variable
	reg [5:0] result = 0; //6bit variable
	
	//Procedure used to continuously monitor 'x', 'y', and 'result'
	initial begin
	$monitor("MON x = %b, y = %b, result = %b", x, y, result);
	end
	
	//Procedure used to generate stimulus
	initial begin
	#1;  //wait some time between examples
	x = 6'b00_0101;
	y = 6'b11_0011;
	result = x & y; //AND
	
	#1;  // Use the same values for x and y from above (reg stores the value)
	result = ~(x & y); //NAND
	#1;
	//result = x ~& y; //See the difference between the two NAND examples
	
	#1;
	x = 6'b10_0101;
	y = 6'b01_1011;
	result = x | y; //OR
	
	#1;
	result = ~(x | y); //NOR
	#1;
	//result = x ~| y; //See the difference between the two NOR examples
	
	#1;
	x = 6'b01_0110;
	y = 6'b01_1011;
	result = x ^ y; //XOR
	
	#1; //NXOR is used to check if x = y
	result = x ~^ y; //NXOR
	
	#1;
	x = y; //This should make all the bits 1
	result = ~(x ^ y); //NXOR
	end
	
endmodule
	
/*
Output:
# MON x = 000000, y = 000000, result = 000000
# MON x = 000101, y = 110011, result = 000001
# MON x = 000101, y = 110011, result = 111110
# MON x = 100101, y = 011011, result = 111111
# MON x = 100101, y = 011011, result = 000000
# MON x = 010110, y = 011011, result = 001101
# MON x = 010110, y = 011011, result = 110010
# MON x = 011011, y = 011011, result = 111111
*/

/*
How do I assign values to vector variables?
For example I have :

reg [6:0] b = 0; // 7bit register
b = 7'b0; // Assigns all the 7bits to 0 BUT
b = 7'b1 // Assigns the LSB to 0 that is 000 0001
Am I correct ?

You are completely right that 7'b1 has the value 1, so only the LSB is set. if you want to set all the bits you could do:

b = 7'b111_1111;

b = 2**3-1;

b = {7{1'b1}}; // replication operator

The easiest way to prevent a mistake is to use hexadecimal or decimal formats. b = 7'd1 means that Verilog has to assign the decimal value 1 to b. As you practice more, this kind of things will eventually become trivial.

I also attached a small exercise to see how b changes when different values are assigned.
'timescale 1ns/1ps
module vector_test();
	
	reg [6:0] b;
	
	initial begin
		$monitor(" b= %7b", b);
	end
	
	initial begin
		b = 0;
		#1 b = 7'b0;
		#1 b = 7'b1;
		#1 b = 7'b11;
		#1 b = 7'd11;
		#1 b = 7'h11;
		#1 b = {7{1'b1}};
	end
	
endmodule
*/

/* Results
#  b= 0000000
#  b= 0000001
#  b= 0000011
#  b= 0001011
#  b= 0010001
#  b= 1111111
*/
	

