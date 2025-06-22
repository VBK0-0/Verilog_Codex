module tristate_buffer_1bit(
	input din,
	input sel,
	output dout
	);
	
	//Tri-state buffer, Active high en.
	bufif1 B1 (dout, din, sel);
	
endmodule