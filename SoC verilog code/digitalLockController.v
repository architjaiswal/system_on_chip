
// Verilog for digital lock controller

// only unlocks if the input sequence of 1-1-0-0-1-0 is entered
// Enter switch tells it to read the input
// Once the lock is open, it remains unlocked until the reset button is pressed

module digitalLockController ( input       x, Enter, ResetLock, // input declaration
										 output reg  Open,
										 output [0:6] stateout);              // output declaration
										 
										reg [2:0] state, nextstate;		 // 3 bit current state and next state variables
										
										parameter A=3'b000, B=3'b001, C=3'b010, D=3'b011, E=3'b100, F=3'b101, G=3'b110, H=3'b111;
										// assigning a binary number to the state variables
										
										always @ (negedge Enter, negedge ResetLock) // checking for the changes in Enter and Reset buttons
											if (ResetLock == 1'b0)  
												state <= A;	
												
											else 
												state <= nextstate; 
												
												
										always @ (state, x)
											case(state)                   // defining the state machine
												A: begin if(x) nextstate = B; 
															else nextstate = H; end
															
												B: begin if(x) nextstate = C;
															else nextstate = H; end
															
												C: begin if(x) nextstate = H;
															else nextstate = D; end
															
												D: begin if(x) nextstate = H;
															else nextstate = E; end
															
												E: begin if(x) nextstate = F;
															else nextstate = H; end
															
												F: begin if(x) nextstate = H;
															else nextstate = G; end
															
												G: begin if(x) nextstate = G;
															else nextstate = G; end
															
												H: begin if(x) nextstate = H;
															else nextstate = H; end
															
												default nextstate = A;
												
											endcase
											
										always @ (state, x)
											case (state)					// defining the state outputs
												A,B,C,D,E,F,H: Open = 1'b0;
												
																G: Open = 1'b1;
											endcase
											
											// adding Binary to 7 Segment decoder for displaying the current state of the machine
											
										bin2sevenSegment bin2sevenSegment_inst
										(
											.BIN(state),
											.SEV(stateout)
										);
											
											
endmodule

															
															
											
											
											