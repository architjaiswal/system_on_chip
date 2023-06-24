
// N bit twisted ring counter

module twistedRingCounter ( Clock, Reset, OUT);
	
	parameter N = 4; // 4 bits but it can be changed to any integer
	
	input Clock, Reset;
	output reg [N-1 : 0] OUT;
	
	always@ (posedge Clock, negedge Reset)
	begin
	
		if (Reset == 1'b0) OUT <= 0;
		else
		begin
			
			OUT[0] <= ~OUT[N-1];
			OUT[N-1:1] <= OUT[N-2:0];
		end	
			
	end
	
endmodule
