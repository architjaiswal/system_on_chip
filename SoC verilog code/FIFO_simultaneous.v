
// Verilog behavioural model of First-In-First-Out Buffer, with READ and WRITE occuring SIMULTANEOUSLY 
// It is 9 bit wide and allows 16 entries long buffer ( 16 X 9 buffer)

module FIFO_simultaneous (
									output reg [8:0] DataOut, //Data output
									output [0:6] DisplayOut0, // only for instantiation 
									output [0:6] DisplayOut2, // only for instantiation 
									output [0:6] DisplayOut3, // only for instantiation 
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
			begin
				DataOut <= 1'b0;
				ReadPtr <= 1'b0;
			end
			
			else if (~Read && !Empty)
			begin 
				DataOut <= Stack[ReadPtr];
				ReadPtr <= ReadPtr + 1'b1;
			end
			
		end
		
		
		always @ (posedge Clock, negedge Reset)
		begin
			
			if (~Reset)
			begin
				WritePtr <= 1'b0;
			end
			
			else if (~Write && !Full)
			begin	
				Stack[WritePtr] <= DataIn;
				WritePtr <= WritePtr + 1'b1;
			end
			
		end
		
		always @ (posedge Clock, negedge Reset)
		begin
			
			if (~Reset)
			begin 
				PtrDiff <= 1'b0;
			end
			
			else if (~Read && !Empty)
			begin
			
				if (!OV)
				begin
					PtrDiff <= PtrDiff - 1'b1;
				end
				
				else
				begin
					PtrDiff <= PtrDiff - 2'b10;
				end
				
			end
			
			else if (~Write)
			begin
				
				if (!Full)
				begin
					PtrDiff <= PtrDiff + 1'b1;
				end
				
				else
				begin
					PtrDiff <= 5'd17;
				end
			
			end
			
			else if (ClearOV && OV)
			begin
				PtrDiff <= 5'd16;
			end
			
			
		end
			
			
		bin2sevenSegment HEX0
		(
			.BIN({Full, OV, Empty}) ,	// input [3:0] BIN_sig
			.SEV(DisplayOut0) 	// output [0:6] SEV_sig
		);
		
		bin2sevenSegment HEX2
		(
			.BIN(ReadPtr) ,	// input [3:0] BIN_sig
			.SEV(DisplayOut2) 	// output [0:6] SEV_sig
		);
		
		bin2sevenSegment HEX3
		(
			.BIN(WritePtr) ,	// input [3:0] BIN_sig
			.SEV(DisplayOut3) 	// output [0:6] SEV_sig
		);
		
		
	
endmodule		

