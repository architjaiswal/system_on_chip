//Verilog Model of an N-bit Serial-In Serial-Out Shift Register with active-low clear

module shiftRegister (A,Q,SHIFT,CLR);

	parameter N = 4; //declare default value for N
	input A; //declare data input
	input SHIFT, CLR; //declare shift and clear inputs
	output reg [N-1:0] Q; //declare N-bit data output

	integer i; //declare index variable
	
	always @ (posedge SHIFT, negedge CLR) //detect change of clock or clear	
	begin
	
		if (CLR == 1'b0) Q <= 0; //register loaded with all 0’s
		
//		else if (SHIFT == 1'b1)
		else
			begin //shift and load input A
				for (i = 1; i <= N-1; i = i + 1)
					begin Q[i] <= Q[i-1]; end
				Q[0] <= A;
			end
	end
	
endmodule
					
					
	
	
	