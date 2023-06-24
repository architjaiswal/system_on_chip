
// Behavioural model for N-bit bnary counter

module binaryCounter ( CLR, Count, SUM);
	
	input CLR, Count;
	
	parameter N = 3;
	
	output reg [N-1 : 0] SUM;
	
	always @ (posedge Count, negedge CLR)
	begin
		if (CLR == 1'b0) SUM <=0;
		else
			if (SUM == 2**N - 1'b1) SUM = 0;
			else
				SUM <= SUM + 1'b1;
	end

endmodule
	