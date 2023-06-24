
// Behavioural model of simple N-bit register 
// The output of register is same as the input as soon as the load value is set to high
// The output will not change until the load value is set to high

module gatedRegister (Load, InputData, Clear, OutputData, Enable);

	input Load, Clear, Enable; // 1-bit high or low signal
	
	parameter N = 4; // currently a 4-bit register but it can be changed
	
	input  [N-1 : 0] InputData;  // Data coming into the register
	output reg [N-1 : 0] OutputData; // Data going out of the register
	//output [0:6] displayOut; // only for seven segment display
	
	always @ (posedge Load, negedge Clear) 
		begin
			if (Clear == 1'b0) OutputData <= 0;
			else if (Load & Enable) OutputData <= InputData; // if register is enabled then only load a new value
			else OutputData <= OutputData; // if not enabled then keep the previous value
			
		end
		
//		
//	bin2sevenSegment bin2sevenSegment_inst
//	(
//		.BIN(OutputData) ,	// input [3:0] BIN_sig
//		.SEV(displayOut) 	// output [0:6] SEV_sig
//	);
			
endmodule
