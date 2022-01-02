// Simultaneous Read and Write FIFO for UART IP Project
// UART IP Module: SoC Project
// Archit Jaiswal


//-----------------------------------------------------------------------------
// Hardware Target
//-----------------------------------------------------------------------------

// Target Platform: DE1-SoC Board

// Verilog behavioural model of First-In-First-Out Buffer, with READ and WRITE occuring SIMULTANEOUSLY 
// It is 9 bit wide and allows 16 entries long buffer ( 16 X 9 buffer)

module fifo (
					output reg [8:0] DataOut, 				                //Data output
					output reg [3:0] ReadPtr, WritePtr,                 // Read and write pointers
					output 			  Full, Empty, OV,                   //Status outputs
					input [8:0]      DataIn,                            //Data input
					input            Read, Write, Clock, Reset, ClearOV //Control inputs
				);

		//reg [3:0] ReadPtr, WritePtr;  //Read and write pointers
		reg [4:0] PtrDiff; 				//Pointer difference
		reg [8:0] Stack [15:0]; 		//Storage array
		
		assign Empty=(PtrDiff==1'b0)?1'b1:1'b0; //Empty?
		assign Full=(PtrDiff>=5'd16)?1'b1:1'b0; //Full?
		assign OV=(PtrDiff>=5'd17)?1'b1:1'b0;   //Overflow?
		
		
		always @ (posedge Clock, posedge Reset)
		begin
		
			if (Reset)
			begin
				DataOut <= 1'b0;
				ReadPtr <= 1'b0;
			end
			
			else if (Read && !Empty)
			begin 
				DataOut <= Stack[ReadPtr];
				ReadPtr <= ReadPtr + 1'b1;
			end
			
		end
		
		
		always @ (posedge Clock, posedge Reset)
		begin
			
			if (Reset)
			begin
				WritePtr <= 1'b0;
			end
			
			else if (Write && !Full)
			begin	
				Stack[WritePtr] <= DataIn;
				WritePtr <= WritePtr + 1'b1;
			end
			
		end
		
		always @ (posedge Clock, posedge Reset)
		begin
			
			if (Reset)
			begin 
				PtrDiff <= 1'b0;
			end
			
			else if (Read && !Empty)
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
			
			else if (Write)
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
	
endmodule		

