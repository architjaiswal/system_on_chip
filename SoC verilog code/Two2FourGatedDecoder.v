
// 2 to 4 decoder with an Enable (2 to 4 gated decoder)
// 2 inputs will decoded into 1, 2, 3, 4
// decoder is not suppose to decode anything when the gate is OFF 

module Two2FourGatedDecoder (
									  input A, B, Enable, // B is the most significant bit, A is the least significant bit and Enable is the gate of decoder
									  output reg [3:0] y  // it is the output of the decoder
								    );
								
		always @ ( Enable, A, B)
			
			if (Enable == 1'b0) y = 4'b0000; // outputs all zeros if it is not enabled  
			else
				case({B,A})
					
					2'b00 : y = 4'b0001;
					2'b01 : y = 4'b0010;
					2'b10 : y = 4'b0100;
					2'b11 : y = 4'b1000;
				endcase
endmodule
