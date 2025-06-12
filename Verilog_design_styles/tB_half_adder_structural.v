module tB_half_adder_structural();

	// Declare variables and nets for module ports
	reg a;
	reg b;
	wire sum;
	wire carry;
	
	
	//Instantiate the module using the "dot name" style
	half_adder_structural HALF_ADD(
	.a(a),
	.b(b),
	.sum(sum),
	.carry(carry)
	);
	
	// Generate stimulus and monitor module ports
	initial begin
		$monitor("a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
	end
	
	initial begin
		#1; a = 0; b = 0;
		#1; a = 0; b = 1;
		#1; a = 1; b = 0;
		#1; a = 1; b = 1;
		#1; a = 0; b = 0;
	end
	
endmodule

/*
Output:
# a=x, b=x, sum=x, carry=x
# a=0, b=0, sum=0, carry=0
# a=0, b=1, sum=1, carry=0
# a=1, b=0, sum=1, carry=0
# a=1, b=1, sum=0, carry=1
# a=0, b=0, sum=0, carry=0
*/