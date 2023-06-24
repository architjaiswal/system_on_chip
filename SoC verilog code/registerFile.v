
// register file that utilizes the two-to-four decoder, n-bit register with enable (i.e. gated register), and four-to-one multiplexer

module registerFile #(parameter N = 4)
						(
							input [N-1 : 0] Din, // input data of length N-bits going to every register
							output [N-1 : 0] Dout, // output data of length N-bits coming out of the register file
							output [0:6] displayOut, // output declaration specially for bin2sevenSegment display
							input WA0, WA1, WrEn, 
							input CLK, RST,
							input RA0, RA1
						);
						
			wire 	[3:0] Q0, Q1, Q2, Q3, Y;
			
			
			Two2FourGatedDecoder Two2FourGatedDecoder_inst
			(
				.A(WA0) ,	// input  A_sig
				.B(WA1) ,	// input  B_sig
				.Enable(WrEn) ,	// input  Enable_sig
				.y(Y) 	// output [3:0] y_sig
			);
			
			
			
			gatedRegister gatedRegister0
			(
				.Load(CLK) ,	// input  Load_sig i.e. giving clocks to the register to load the value
				.InputData(Din) ,	// input [N-1:0] InputData_sig
				.Clear(RST) ,	// input  Clear_sig
				.OutputData(Q0) ,	// output [N-1:0] OutputData_sig
				.Enable(Y == 4'b0001) 	// input  Enable_sig
			);

										
			gatedRegister gatedRegister1
			(
				.Load(CLK) ,	// input  Load_sig i.e. giving clocks to the register to load the value
				.InputData(Din) ,	// input [N-1:0] InputData_sig
				.Clear(RST) ,	// input  Clear_sig
				.OutputData(Q1) ,	// output [N-1:0] OutputData_sig
				.Enable(Y == 4'b0010) 	// input  Enable_sig
			);
			
			gatedRegister gatedRegister2
			(
				.Load(CLK) ,	// input  Load_sig i.e. giving clocks to the register to load the value
				.InputData(Din) ,	// input [N-1:0] InputData_sig
				.Clear(RST) ,	// input  Clear_sig
				.OutputData(Q2) ,	// output [N-1:0] OutputData_sig
				.Enable(Y == 4'b0100) 	// input  Enable_sig
			);
			
			gatedRegister gatedRegister3
			(
				.Load(CLK) ,	// input  Load_sig i.e. giving clocks to the register to load the value
				.InputData(Din) ,	// input [N-1:0] InputData_sig
				.Clear(RST) ,	// input  Clear_sig
				.OutputData(Q3) ,	// output [N-1:0] OutputData_sig
				.Enable(Y == 4'b1000) 	// input  Enable_sig
			);
			
			
			Four2OneNbitMultiplixer Four2OneNbitMultiplixer_inst
			(
				.A(RA0) ,	// input  A_sig
				.B(RA1) ,	// input  B_sig
				.D0(Q0) ,	// input [N-1:0] D0_sig
				.D1(Q1) ,	// input [N-1:0] D1_sig
				.D2(Q2) ,	// input [N-1:0] D2_sig
				.D3(Q3) ,	// input [N-1:0] D3_sig
				.Y(Dout) 	// output [N-1:0] Y_sig
			);
			
			bin2sevenSegment HEX0
			(
				.BIN(Dout) ,	// input [3:0] BIN_sig
				.SEV(displayOut) 	// output [0:6] SEV_sig
			);


endmodule


			