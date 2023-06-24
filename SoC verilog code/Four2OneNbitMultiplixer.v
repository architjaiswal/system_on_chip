
// Four inputs coming inside the multiplixer and based on the "selection bits" the multiplixer should output only one of the four inputs
// the four inputs comming into the multiplixer can be N-bits long

module Four2OneNbitMultiplixer #(parameter N = 4) // N-bit length of the input values
											(
												input A, B, // selector input -- this will decide which input will go for the output
												input [N-1 : 0] D0, D1, D2, D3, // four inputs comming into the multiplixer which are N-bits in length
												output reg [N-1 : 0] Y // only output leaving the multiplixer which is N-bit long
											);
											
					always @ ( A, B, D0, D1, D2, D3)
						case({B,A})
							2'b00 : Y = D0;
							2'b01 : Y = D1;
							2'b10 : Y = D2;
							2'b11 : Y = D3;
						endcase
						
endmodule
