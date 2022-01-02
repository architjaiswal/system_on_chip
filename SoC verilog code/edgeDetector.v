// Rising Edge Detector for the input signals coming from the bus
// Component of UART IP Module - System On Chip Project
// Archit Jaiswal

//-----------------------------------------------------------------------------
// Hardware Target
//-----------------------------------------------------------------------------

// Target Platform: DE1-SoC Board

// This is an edge detector circuit and it sends 1 only if the previous input was 0
// So it detects a transitions of 0 -> 1 at every clock and sends 1 to the output

module edgeDetector ( input  Clock,
							 input  Reset,
							 input  In,
							 input  ChipSelect,
							 input [1:0] Address, // when the data is written to DATA_REGISTER which is at address 00
							 output Out
						  );
						  
		
			reg lastIn = 1'b1;
							  
			always @ (posedge Clock or posedge Reset) 
			begin
			
				if (Reset)
					lastIn <= 1'b1;
				else
					lastIn <= In;
			end
			
			assign Out = In & !lastIn & ChipSelect & (Address == 2'b00); // if chipselect is ON and address is set to the data register
			
			
//			always @ (posedge Clock)
//			begin
//				Out <= In & !lastIn;
//			end
		
endmodule
							 