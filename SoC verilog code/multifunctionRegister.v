
// N-bit multi-function register ( one gated register which is capable of shifting the bits, counting up or incrementing up, loading new bits, reseting and storing the N-bits )
// ClockEn     -- Enables the device to function (active high)
// CLK         -- Gives clocks to the device (active high)
// RST         -- Resets the device and the output is setback to 0 (active high)
// [1:0] M     -- 2 bit mode control inputs
// [N-1:0] Din -- N-bit parallel data input
// [N-1:0] Q   -- N-bit parallel data output

// Here <= in the assignment means non-blocking or concurrent assignment

// If RST = 1, then Q = 0 
// If RST = 0 && ClockEn = 0, then register should hold its current value 
// If RST = 0 && ClockEn = 1, then the M1 and M0 will select the operations
//									M = 00 --> Hold the register content (same as RST = 0 && ClockEn = 0)
// 								M = 01 --> Shift one bit to the right
// 								M = 10 --> Increment the value by one
// 								M = 11 --> load the new value to the register

module multifunctionRegister #(parameter N = 4)
		 ( 
			input CLK, RST, 				// Clock and reset for the register (both are active high, means loads or clears the data from register during the rising edge)
			input ClockEn, 				// A gate to enable the clock to the register and makes it behave as a gated register
			input [N-1 : 0] Din, 		// Data which is comming to the register
			input [1:0] M, 				// Selects what operation needs to be performed on the computer
			output reg [N-1 : 0] Q,		// ouput from the register
			output [0:6] Qout			// output of bin2sevenSegment instantiation (no direct use in code)
		 );
		 
		 always @ (posedge ClockEn or posedge RST) 
			begin 
				if (RST == 1'b1) Q <= 0; // non-blocking or concurrent assignment 
				else if (ClockEn == 1'b1) 
						begin
							if (M == 2'b01) Q <= Q >>1'b1; // shift right by one bit
							else if (M == 2'b10) Q <= Q + 1'b1; // increment the value of Q by 1-bit
							else if (M == 2'b11) Q <= Din; // load the value of input to the register
						end
			end
			
endmodule

							