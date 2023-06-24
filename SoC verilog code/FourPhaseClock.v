
// Verilog Behavioural model for four phase clock
// It sends an output/clock to every phase/port alternatively .i.e., it will send it one at a time in cycle

module FourPhaseClock ( Clock, Reset, Phase );

		input Clock, Reset; // sets output to state 0 as soon as the reset is pressed
		output reg [0:3] Phase; // least significant bit to the most signigicant bit (0001 means 8 and 1000 means 1)

		parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
		
		reg [1:0] state, nextstate;
		
		always @ (posedge Clock, negedge Reset)
		begin
		
			if (Reset == 1'b0) state <= S0;
			else state <= nextstate;
			
		end
		
		always @ (state)
		begin
		
			case(state)
				S0: begin Phase = 4'b1000; nextstate = S1; end
				S1: begin Phase = 4'b0100; nextstate = S2; end
				S2: begin Phase = 4'b0010; nextstate = S3; end
				S3: begin Phase = 4'b0001; nextstate = S0; end
			endcase
			
		end
		
endmodule

	
				

	