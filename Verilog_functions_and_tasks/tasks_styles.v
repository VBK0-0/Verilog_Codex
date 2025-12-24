// Task style 1 : input and output ports are declared between ()
task compare1 (input [7:0] a, input [7:0] b, output equal);
	begin
		equal = (a == b);
	end
endtask

// Task style 2 : input and output ports are declared inside the task
task compare2;
	input [7:0] a;
	input [7:0] b;
	output equal;
	begin
		equal = (a == b);
	end
endtask

// Task style 3 : NO input/output ports are declared
// They are global variables from the testbench
reg [7:0] a, b;
reg equal;

task compare3;
	begin
		equal = (a == b);
	end
endtask