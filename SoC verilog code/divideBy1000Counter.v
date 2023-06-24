
// Behavioural model for 1000 state counter (it counts till 1000 and produces a signal as soon as a 1000th event occurs)
// This is a N stage counter where changing N can allow to triger a signal when Nth event occurs

module divideBy1000Counter (CLK, CLEAR, OUT, Count);


	parameter N = 10'd1000; // d1000 = decimal 1000 and 10 specifies that four bits will be required to represent the number 10 in binary
	parameter bitField = 10; // since 10 binary bits are needed to represent 1000 in binary bitfield = 10
	
	input CLK, CLEAR;
	output reg [bitField-1 : 0] Count; 
	output reg OUT; 
	
	always@ (negedge CLK, negedge CLEAR) // execute the block on falling edge of CLK and CLEAR
		begin
			
			if (CLEAR == 1'b0) // Reset the counter and OFF the signal when CLEAR is pressed
				begin Count <= 10'b0; OUT <= 1'b0; end
				
			else
				begin // Count starts at 0 so (N-1) is the last state and it should triger signal as soon as the last state occurs
					if (Count == N - 2'd2) begin OUT <= 1'b1; Count <= N - 1'd1; end
					
					else if (Count == N-1'd1) begin OUT <= 1'b0; Count <= 10'b0; end
					
					else begin OUT <= 1'b0; Count <= Count + 1'd1; end
				end
				
		end
		
endmodule	
					
			
	
	