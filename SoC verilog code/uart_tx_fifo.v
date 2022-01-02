// Archit Jaiswal
// Transmit FIFO for the UART IP Module : SoC project


//-----------------------------------------------------------------------------
// Hardware Target
//-----------------------------------------------------------------------------

// Target Platform: DE1-SoC Board

// FIFO is 9 bit wide and 16 word long, only supposed to write when the write signal is toggled (not supposed to write when write signal is ON due to bus latency)

module uart_tx_fifo ( input        		Clock, Reset, Read, Write, ClearOV, ChipSelect,
							 output       		Full, OV, Empty, 
							 input  [1:0]     Address,
							 input  [8:0]  	DataIn,
							 output [8:0] 		DataOut,
							 output [3:0] 		ReadPtr, WritePtr
						  );
							
						  wire edgeDetect_write; 		// it contains filtered write signal to solve extended signal problem on bus
						  //wire edgeDetect_read;       // it contains filtered read signal to solve extended signal problem on bus
						  
						edgeDetector edgeDetector_write
						(
							.Clock(Clock) ,				// input  Clock_sig
							.Reset(Reset) ,				// input  Reset_sig
							.In(Write) ,					// input  In_sig
							.ChipSelect(ChipSelect) ,	// input  ChipSelect_sig
							.Address(Address) ,			// input [1:0] Address_sig
							.Out(edgeDetect_write) ,	// output  Out_sig
						);
						
						  
						fifo fifo_inst
						(
							.DataOut(DataOut) ,		// output [8:0] DataOut_sig
							.ReadPtr(ReadPtr) ,		// output [3:0] ReadPtr_sig
							.WritePtr(WritePtr) ,	// output [3:0] WritePtr_sig
							.Full(Full) ,				// output  Full_sig
							.Empty(Empty) ,			// output  Empty_sig
							.OV(OV) ,					// output  OV_sig
							.DataIn(DataIn) ,			// input [8:0] DataIn_sig
							.Read(Read) ,				// input  Read_sig
							.Write(edgeDetect_write) ,	// input  Write_sig
							.Clock(Clock) ,			// input  Clock_sig
							.Reset(Reset) ,			// input  Reset_sig
							.ClearOV(ClearOV) 		// input  ClearOV_sig
						);



						  
endmodule
		




