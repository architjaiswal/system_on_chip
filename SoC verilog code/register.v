
// Behavioural model of simple N-bit register 
// The output of register is same as the input as soon as the load value is set to high
// The output will not change until the load value is set to high

module register (Load, InputData, Clear, OutputData);

	input Load, Clear; // 1-bit high or low signal
	
	parameter N = 4; // currently a 4-bit register but it can be changed
	
	input  [N-1 : 0] InputData;  // Data coming into the register
	output reg [N-1 : 0] OutputData; // Data going out of the register
	
	always @ (posedge Load, posedge Clear) 
		begin
			if (Clear) OutputData <= 0;
			else if (Load) OutputData <= InputData;
		end
		
endmodule
