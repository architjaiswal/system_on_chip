

// Behavioural model for 5 state counter (it counts till 5 and produces a signal as soon as a 5th event occurs)
// This is a N stage counter where changing N can allow to triger a signal when Nth event occurs

module divideBy5Counter (CLK, CLEAR, OUT, Count);


	parameter N = 3'd5; // d5 = decimal 5 and 3 specifies that four bits will be required to represent the number 5 in binary
	parameter bitField = 3; // since 3 binary bits are needed to represent 5 in binary bitfield = 3
	
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
					
			
	
	