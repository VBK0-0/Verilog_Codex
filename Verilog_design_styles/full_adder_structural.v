module full_adder_structural(
	input a,
	input b,
	input carry_in,
	output sum,
	output carry_out
	);
	
// Declare nets to connect the half adders
wire sum1;
wire carry1;
wire carry2;

// Initiate two half_adder_structural modules
half_adder_structural HA1(
	.a(a),
	.b(b),
	.sum(sum1),
	.carry(carry1)
	);
	
	half_adder_structural HA2(
	.a(sum1),
	.b(carry_in),
	.sum(sum),
	.carry(carry2)
	);
	
// Use Verilog primitive 
	or (carry_out, carry1, carry2);
  
endmodule


module half_adder_structural(
    input a,
    input b,
    output sum,
    output carry
    );
  
    // Instantiate Verilog built-in primitives and connect them with nets
    xor XOR1 (sum,  a, b); // instantiate a XOR gate
    and AND1 (carry, a, b);  
  
endmodule

