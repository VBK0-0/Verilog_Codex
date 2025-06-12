module adder8bit_testbench(
	//no inputs in testbench
	);
	
	reg [7:0] a = 0;	//reg type is used for inputs
	reg [7:0] b = 0;
	
	wire [8:0] sum; 	//wire type is used for outputs
	
	//Instantiates the DUT
	//The syntax is <module_name><instance_name>
	adder8bit ADDER1(
		.a(a), // first a = port name, second a = variable
		.b(b),
		.sum(sum)
	);
	
	//Monitor the outputs and inputs
	initial begin
		$monitor("a=%d, b=%d, sum=%d", a, b, sum);
	end
	
	// Generate stimulus
	initial begin
		#1;		// wait 1 time unit
		a = 1;
		#1;
		b = 10;
		#1;
		a = 3; b = 99;
		#1;
		a = 101; b = 66;
		#1;
		a = 255; b = 255;
	end
endmodule

/*
Output:
# a=  0, b=  0, sum=  0
# a=  1, b=  0, sum=  1
# a=  1, b= 10, sum= 11
# a=  3, b= 99, sum=102
# a=101, b= 66, sum=167
# a=255, b=255, sum=510
*/