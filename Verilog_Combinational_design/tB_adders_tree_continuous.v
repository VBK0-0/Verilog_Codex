`timescale 1us/1ns
module tB_adders_tree_continuous();
	
   reg [3:0] a, b;
   reg [7:0] c, d;
   wire [4:0] sum1;
   wire [8:0] sum2;
   wire [9:0] sum3;
	
    // Instantiate the DUT
    adders_tree_continuous ADD(
       .a(a),
       .b(b),
       .c(c),
       .d(d),
       .sum1(sum1),
       .sum2(sum2),
       .sum3(sum3)      
    );
  
    // Create stimulus
    initial begin
      $monitor(" a = %d, b = %d, c = %d, d = %d, sum1 = %d, sum2 = %d, sum3 = %d",
                 a ,b ,c, d, sum1, sum2, sum3);
       #1; a = 4'd0  ; b = 4'd3  ; c = 8'd1 ; d = 8'd255 ;
       #1; a = 4'd10 ; b = 4'd13 ; c = 8'd9 ; d = 8'd10 ;
       #1; a = 4'd15 ; b = 4'd15 ; c = 8'd109 ; d = 8'd37 ;
       #1; a = 4'd0  ; b = 4'd9  ; c = 8'd45 ; d = 8'd45 ;
       #1;
    end
  
endmodule

/*
Output:
#  a =  x, b =  x, c =   x, d =   x, sum1 =  x, sum2 =   x, sum3 =    x
#  a =  0, b =  3, c =   1, d = 255, sum1 =  3, sum2 = 256, sum3 =  259
#  a = 10, b = 13, c =   9, d =  10, sum1 = 23, sum2 =  19, sum3 =   42
#  a = 15, b = 15, c = 109, d =  37, sum1 = 30, sum2 = 146, sum3 =  176
#  a =  0, b =  9, c =  45, d =  45, sum1 =  9, sum2 =  90, sum3 =   99
*/
