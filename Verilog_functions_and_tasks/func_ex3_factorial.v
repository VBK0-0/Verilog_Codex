`timescale 1us/1ns
module func_ex3_factorial();

	// Recursive function example
	function automatic integer factorial (input integer N);
		// Interval variable for intermediate results
		// Have to be declared before "begin/end"
		integer result = 0;
		begin
			if (N == 0)
				result = 1;
			else
				result = N * factorial(N-1);
				
			factorial  = result;
		end
	endfunction
	
	initial begin
		#1 $display ($time, " factorial(2) = %d", factorial(2));
		#1 $display ($time, " factorial(5) = %d", factorial(5));
		#1 $display ($time, " factorial(10)= %d", factorial(10));
	end
	
endmodule

/*
#                    1 factorial(2) =           2
#                    2 factorial(5) =         120
#                    3 factorial(10)=     3628800
*/
