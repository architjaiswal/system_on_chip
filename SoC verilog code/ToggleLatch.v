
// Verilog behavioural model of On-Off switch 
// If the switch is ON then the INPUT to switch will be set as the OUTPUT
// If the switch is OFF then the OUTPUT will be ZERO

module ToggleLatch (
							input On_Off, IN, Clear,
							output OUT
						 );
						 
			reg state, nextstate;
			
			parameter ON = 1'b1, OFF = 1'b0;
			
			always @ (negedge On_Off, negedge Clear)
			begin
				
				if (Clear == 1'b0) state <= OFF; // Clear will turn off the switch
				else state <= nextstate;
				
			end
			
			
			always @ (state) // as the state is changed, change the next state to keep toggling
			begin
				
				case(state)
					
					OFF : nextstate <= ON;
					ON : nextstate <= OFF;
					
				endcase
				
			end
			
			assign OUT = state * IN; // OUT = IN if the state is ON, otherwise OUT = 0
			
endmodule


				
			
				
							