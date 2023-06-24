
// Behavioural model for 6 state counter (it counts till 6 and produces a signal as soon as a 6th event occurs)
// This is a N stage counter where changing N can allow to triger a signal when Nth event occurs

module divideBy6Counter (CLK, CLEAR, OUT, Count);


	parameter N = 3'd6; // d6 = decimal 6 and 3 specifies that four bits will be required to represent the number 6 in binary
	parameter bitField = 3; // since 3 binary bits are needed to represent 6 in binary bitfield = 3
	
	input CLK, CLEAR;
	output reg [bitField-1 : 0] Count; 
	output reg OUT; 
	
	always@ (negedge CLK, negedge CLEAR) // execute the block on falling edge of CLK and CLEAR
		begin
			
			if (CLEAR == 1'b0) // Reset the counter and OFF the signal when CLEAR is pressed
				begin Count <= 3'b0; OUT <= 1'b0; end
				
			else
				begin // Count starts at 0 so (N-1) is the last state and it should triger signal as soon as the last state occurs
					if (Count == N - 2'd2) begin OUT <= 1'b1; Count <= N - 1'd1; end
					
					else if (Count == N-1'd1) begin OUT <= 1'b0; Count <= 0; end
					
					else begin OUT <= 1'b0; Count <= Count + 1'd1; end
				end
				
		end
		
endmodule	
					
			
	
	