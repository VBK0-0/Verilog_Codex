module shift_operators();
reg [11:0] a = 12'b0101_1010_1101; // 12bit value (unsigned)
reg [11:0] b;

// Procedure used to continuously monitor 'a', and 'b'
initial begin
	$monitor("MON a = %12b, b = %12b, a = %0d, b = %0d", a, b, a, b);
end

// Procedure used to generate stimulus
initial begin
b = a << 1; // b = a*2
#1; // wait some time between examples
b = 0;

#1; b = a * 2; // Write on 1 line to save space

#1; b = a << 5;
#1; b = b >> 2;
#1; b = b >> 7;
#1; b = b << 1;
#1; b = (a << 1) >> 6; // always use paranthesis

// Change the values of a and b and perform different logical shifts between them
// Ex: a = a << 12
end
endmodule

/*
Output:
# MON a = 010110101101, b = 101101011010, a = 1453, b = 2906
# MON a = 010110101101, b = 000000000000, a = 1453, b = 0
# MON a = 010110101101, b = 101101011010, a = 1453, b = 2906
# MON a = 010110101101, b = 010110100000, a = 1453, b = 1440
# MON a = 010110101101, b = 000101101000, a = 1453, b = 360
# MON a = 010110101101, b = 000000000010, a = 1453, b = 2
# MON a = 010110101101, b = 000000000100, a = 1453, b = 4
# MON a = 010110101101, b = 000000101101, a = 1453, b = 45
*/
