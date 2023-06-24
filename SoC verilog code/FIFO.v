
// Verilog behavioural model of First-In-First-Out Buffer
// It is 9 bit wide and allows 16 entries long buffer ( 16 X 9 buffer)

module FIFO (
					output reg [8:0] DataOut, //Data output
					output [0:6] displayOut0, // only for instantiation 
					output [0:6] displayOut2, // only for instantiation 
					output [0:6] displayOut3, // only for instantiation 
					output Full, Empty, OV,   //Status outputs
					input [8:0] DataIn,       //Data input
					input Read, Write, Clock, Reset, ClearOV //Control inputs
				);
				
		reg [3:0] ReadPtr, WritePtr;  //Read and write pointers
		reg [4:0] PtrDiff; 				//Pointer difference
		reg [8:0] Stack [15:0]; 		//Storage array
		
		assign Empty=(PtrDiff==1'b0)?1'b1:1'b0; //Empty?
		assign Full=(PtrDiff>=5'd16)?1'b1:1'b0; //Full?
		assign OV=(PtrDiff>=5'd17)?1'b1:1'b0;   //Overflow?
		
		always @ (posedge Clock, negedge Reset)
		begin 
			
			if (~Reset) 
			begin //Test for Clear
				DataOut <= 1'b0; //Clear data out buffer
				ReadPtr <= 1'b0; //Clear read pointer
				WritePtr <= 1'b0; //Clear write pointer
				PtrDiff <= 1'b0; //Clear pointer difference
			end
			
			else if (~Read && !Empty)
			begin
				if (!OV) 
				begin
					DataOut <= Stack[ReadPtr]; //Transfer data to output
					ReadPtr <= ReadPtr + 1'b1; //Update read pointer
					PtrDiff <= PtrDiff - 1'b1; //update pointer difference
				end
				
				else 
				begin
					DataOut <= Stack[ReadPtr]; //Transfer data to output
					ReadPtr <= ReadPtr + 1'b1; //Update read pointer
					PtrDiff <= PtrDiff - 2'b10; //update pointer difference
				end
			end 
			
			else if (~Write) //Check for write
			begin		
				if (!Full) 
				begin //Check for Full
					Stack[WritePtr] <= DataIn; //If not full store data in stack
					WritePtr <= WritePtr + 1'b1; //Update write pointer
					PtrDiff <= PtrDiff + 1'b1; //Update pointer difference
				end
				
				else 
				begin
					PtrDiff <= 5'd17; //Update pointer difference
				end
			end
							
			else if (~ClearOV && OV)
			begin
				PtrDiff <= 5'd16;
			end
			
		end
		
			
		bin2sevenSegment HEX0
		(
			.BIN({Full, OV, Empty}) ,	// input [3:0] BIN_sig
			.SEV(displayOut0) 	// output [0:6] SEV_sig
		);
		
		bin2sevenSegment HEX2
		(
			.BIN(ReadPtr) ,	// input [3:0] BIN_sig
			.SEV(displayOut2) 	// output [0:6] SEV_sig
		);
		
		bin2sevenSegment HEX3
		(
			.BIN(WritePtr) ,	// input [3:0] BIN_sig
			.SEV(displayOut3) 	// output [0:6] SEV_sig
		);
		
		
	
endmodule		

