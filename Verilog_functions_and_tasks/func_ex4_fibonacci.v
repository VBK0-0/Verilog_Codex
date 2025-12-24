`timescale 1us/ 1ns
module func_ex4_fibonacci ();

	// Recursive function example
	function automatic integer fibonacci (input integer N);
		// Internal variable for intermediatory results
		// Have to be declared before "begin/end"
		integer result = 0;
		begin 	
			if (N==0)
				result = 0;
			else if (N==1)
				result = 1;
			else 
				result = fibonacci(N-1) + fibonacci(N-2);
				
			fibonacci = result;
		end
	endfunction
	
	initial begin
		#1 $display ($time, " fibonacci(2) = %d", fibonacci(2));
		#1 $display ($time, " fibonacci(5) = %d", fibonacci(5));
		#1 $display ($time, " fibonacci(10)= %d", fibonacci(10));
	end

endmodule

/*
#                    1 fibonacci(2) =           1
#                    2 fibonacci(5) =           5
#                    3 fibonacci(10)=          55
*/