// Transmitter for the UART IP module
// Archit Jaiswal


//-----------------------------------------------------------------------------
// Hardware Target
//-----------------------------------------------------------------------------

// Target Platform: DE1-SoC Board
// Transmitter outputs to a physical pin on the GPIO

// Verilog behavioural model for UART transmitter

module transmitter (clk, clk_enable, reset, DATA, TX_OUT, stateOUT, tx_request, tx_ack);
	
		input clk, reset; // common 50 MHz
		output reg TX_OUT;
		input clk_enable; // output clock comming from baud rate generator
//		input word_size;  // word_size = 1 (8-bits data), word_size = 0 (7-bits data)
		input tx_request; // FIFO will request to transmit if FIFO -> !Empty
		output reg tx_ack;    // this module will acknowledge and it will connect to READ signal of the FIFO
		
//		input [1:0] parity;  // 00 = off, 01 = use DATA[8], 10 = even, 11 = odd
		input [8:0] DATA; // comes from the FIFO
		output [3:0] stateOUT;
		
		// internal registers
		reg [3:0] state;
		
		// A = Idle state
		parameter A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011, E = 4'b0100, F = 4'b0101, G = 4'b0110, H = 4'b0111, I = 4'b1000,
					 J = 4'b1001, K = 4'b1010, L = 4'b1011, M = 4'b1100;
				
		
		// controls output of the transmitter
		always @(posedge clk or posedge reset)
		begin
		
			if (reset)
			begin
				state 	<= A;
				TX_OUT 	<= 1'b1;
			end
			else
			begin
						
				case(state)
					A: begin TX_OUT <= 1'b1;		  // IDLE state
								if(!tx_request)
									state <= A;
								else if (tx_request)
								begin
									tx_ack <= 1'b1;
									state <= B; 
								end
						end
					
					B: begin TX_OUT <= 1'b0;        // Start bit = 0
								state <= C; end
								
					C: begin TX_OUT <= DATA[0];	  // Least significant Data bit
								state <= D; end
								
					D: begin TX_OUT <= DATA[1];
								state <= E; end
					
					E: begin TX_OUT <= DATA[2];
								state <= F; end
								
					F: begin TX_OUT <= DATA[3];
								state <= G; end
								
					G: begin TX_OUT <= DATA[4];
								state<= H;  end
								
					H: begin TX_OUT <= DATA[5];
								state <= I; end
								
					I: begin TX_OUT <= DATA[6];
								state <= J; end
					
					J: begin TX_OUT <= DATA[7];
								state <= K; end
								
					K: begin TX_OUT <= DATA[8];
								state <= L; end
								
					L: begin TX_OUT <= 1'b1; 	// Stop bit
								if (!tx_request) 
									state <= A; 
									
								else
									state <= B;
						end   
					
					default: state <= A;
					
				endcase
				
			end
		
		end
		
		assign stateOUT = state;
endmodule		


		
		
		
		
		