`timescale 1us/1ns

module tB_ALU();
	
	// Testbench variables
    parameter BUS_WIDTH = 8;
    reg  [3:0] opcode;
    reg [BUS_WIDTH-1:0] a, b;
    reg carry_in;
    wire [BUS_WIDTH-1:0] y;
    wire carry_out;
    wire borrow;
    wire zero;
    wire parity;
    wire invalid_op;

    // Instantiate the DUT 
    ALU
    // Parameters section
    #(.BUS_WIDTH(BUS_WIDTH))
    ALU0
   (.a(a),
   .b(b),
   .carry_in(carry_in),
   .opcode(opcode),
   .y(y),
   .carry_out(carry_out),
   .borrow(borrow),
   .zero(zero),
   .parity,
   .invalid_op(invalid_op)
    );
  
    // Create stimulus
    initial begin
        $monitor($time, " opcode = %d, a = %d, b = %d, y = %d, carry_out=%b, borrow=%b, zero=%b, parity=%b, invalid_op=%b", 
	                  opcode, a, b, y, carry_out, borrow, zero, parity, invalid_op);
        #1; opcode = 0; // 
        // Test OP_ADD
        #1 opcode = 1; a = 9; b = 33; carry_in = 0; 
        // Test OP_ADD_CARRY
        #1 opcode = 2; a = 9; b = 33; carry_in = 1; 
        // Test OP_SUB
        #1 opcode = 3; a = 65; b = 64; carry_in = 0; 
        #1 opcode = 3; a = 65; b = 66; carry_in = 0; 
        // Test OP_INC
        #1 opcode = 4; a = 233; b = 69; carry_in = 1; 
        // Test OP_DEC
        #1 opcode = 5; a = 0; b = 3; carry_in = 0; 
        // Test OP_AND
        #1 opcode = 6; a = 8'b0000_0010; b = 8'b0000_0011; 
        // Test OP_NOT
        #1 opcode = 7; a = 8'b1111_1111;  
        // Test OP_ROL
        #1 opcode = 8; a = 8'b0000_0001; 
        // Test OP_ROR
        #1 opcode = 9; a = 8'b1000_0000;
        #1 $stop;
    end
  
endmodule 

/*
Output:
#                    0 opcode =  x, a =   x, b =   x, carry_in = x, y =   x, carry_out=x, borrow=x, zero=x, parity=x, invalid_op=x
#                    1 opcode =  0, a =   x, b =   x, carry_in = x, y =   0, carry_out=0, borrow=0, zero=1, parity=0, invalid_op=1
#                    2 opcode =  1, a =   9, b =  33, carry_in = 0, y =  42, carry_out=0, borrow=0, zero=0, parity=1, invalid_op=0
#                    3 opcode =  2, a =   9, b =  33, carry_in = 1, y =  43, carry_out=0, borrow=0, zero=0, parity=0, invalid_op=0
#                    4 opcode =  3, a =  65, b =  64, carry_in = 0, y =   1, carry_out=0, borrow=0, zero=0, parity=1, invalid_op=0
#                    5 opcode =  3, a =  65, b =  66, carry_in = 0, y = 255, carry_out=0, borrow=1, zero=0, parity=0, invalid_op=0
#                    6 opcode =  4, a = 233, b =  69, carry_in = 1, y = 234, carry_out=0, borrow=0, zero=0, parity=1, invalid_op=0
#                    7 opcode =  5, a =   0, b =   3, carry_in = 0, y = 255, carry_out=0, borrow=1, zero=0, parity=0, invalid_op=0
#                    8 opcode =  6, a =   2, b =   3, carry_in = 0, y =   2, carry_out=0, borrow=0, zero=0, parity=1, invalid_op=0
#                    9 opcode =  7, a = 255, b =   3, carry_in = 0, y =   0, carry_out=0, borrow=0, zero=1, parity=0, invalid_op=0
#                   10 opcode =  8, a =   1, b =   3, carry_in = 0, y =   2, carry_out=0, borrow=0, zero=0, parity=1, invalid_op=0
#                   11 opcode =  9, a = 128, b =   3, carry_in = 0, y =  64, carry_out=0, borrow=0, zero=0, parity=1, invalid_op=0
*/