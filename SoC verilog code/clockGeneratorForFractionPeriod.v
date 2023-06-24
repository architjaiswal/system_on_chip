
// verilog behavioural model of a clock generator which produces the clocks whose time period = 2 * N 
// N can be any odd or even number, it can be a fraction as well 

// If the period = 4, then N = 2 and one clock will consist of 4 initial clock cycles

// IMPORTANT ASSUMPTION: The reset has to be pressed to make the clock generator function, without pressing RESET it will NOT WORK!!!
// This program developed for the accuracy of 3 decimal point values in binary

// 3.5 in the base 10 (i.e. decimal) is represented by 11.1 in the base 2 (i.e. binary)

module clockGeneratorForFractionPeriod ( Clock, Reset, N, count, target, Nout );

	input Clock, Reset;
	input [31:0] N;
	output reg [31:0] count, target;
	output reg Nout;
	
	always@ (posedge Clock, negedge Reset)
	begin 
		
		if (Reset == 1'b0)
		begin 
			Nout <= 1'b0;
			count <= 32'b0;
			target <= N;
		end
		
		else
		begin
			count <= count + 4'b1000;
			
			if (count[31:3] == target[31:3])
			begin
				target <= target + N;
				Nout <= ~Nout;
			end
			
			else	Nout <= Nout;			
		end

	end
	
endmodule
