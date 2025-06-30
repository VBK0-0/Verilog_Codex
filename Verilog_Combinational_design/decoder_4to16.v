module decoder_4to16
	(input [3:0] a,
	 output [15:0] d
	);
	
	decoder_3to8 DEC1 (
		.a(a[2:0]),
		.enable(~a[3]),
		.y(d[7:0])
	);
	
	decoder_3to8 DEC2 (
		.a(a[2:0]),
		.enable(a[3]),
		.y(d[15:8])
	);
	
endmodule
