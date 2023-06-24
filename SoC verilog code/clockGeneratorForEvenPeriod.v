
// verilog behavioural model of a clock generator which produces the clocks whose time period = N * system_clock

// It the period = 4, then one clock will consist of 4 initial clock cycles

// IMPORTANT ASSUMPTION: The reset has to be pressed to make the clock generator function, without pressing RESET it will NOT WORK!!!
// This program developed for the N to be an INTEGER and an EVEN number, so no fractions or odd numbers

module clockGeneratorForEvenPeriod ( Clock, Reset, N, OUT);

	input Clock, Reset; // clock is the system clock thats taken as a reference
	
	input [31:0] N;
	
	output reg OUT;
	
	reg [31:0] count; // this is the counter
	reg [31:0] target; // this is the number at which OUT will be toggled to generate a square wave
	
	always@ (posedge Clock, negedge Reset)
	begin 
		
		if (Reset == 1'b0)
		begin
			count <= 32'b0;
			target <= 32'b0;
			OUT <= 1'b0;
		end
		
		else
		begin
			count <= count + 1'b1;
			
			if (count == target)
			begin
			
				target <= target + N/2;
				OUT <= ~OUT;
			end
			
			else OUT <= OUT;
		end
		
	end
	
endmodule

	