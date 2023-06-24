
module extraCredit ( input Clock, Reset, Enable, A, B, C,
							output baud_out, f_1Hz);
							
			reg [31:0] Y;
			wire f_10MHz, f_10KHz, f_10Hz;
			wire [3:0] count5, count10, c0; // this are the useless variables, just defined for instantiation purposes
			wire [6:0] count100; // this is also useless and only defined for instantiation 
			wire [9:0] count1000, count1001; // this is also useless and only defined for instantiation
			
			
			always @ (posedge Clock, negedge Reset)
			begin
			
				case({C,B,A})
					3'b000: Y <= 32'h28B0AA;
					3'b001: Y <= 32'h145885;
					3'b010: Y <= 32'h28B0A;
					3'b011: Y <= 32'h1B207;
					3'b100: Y <= 32'h1B20;
					3'b101: Y <= 32'hD90;
					3'b110: Y <= 32'h6C8;
					3'b111: Y <= 32'h364;
				endcase
				
			end
			
	baudRateGenerator baudRateGenerator_inst
	(
		.Clock(Clock) ,	// input  Clock_sig
		.Enable(Enable) ,	// input  Enable_sig
		.Reset(Reset) ,	// input  Reset_sig
		.BRD(Y) ,	// input [31:0] BRD_sig
		.baud_out(baud_out) 	// output  baud_out_sig
	);
	
	
	divideBy5Counter divideBy5
	(
		.CLK(Clock) ,	// input  50MHz clock 
		.CLEAR(Reset) ,	// input  CLEAR_sig
		.OUT(f_10MHz) ,	// output  10MHz signal
		.Count(count5) 	// output [bitField-1:0] Count_sig -- it is useless 
	);
	
	divideBy1000Counter divideBy1000
	(
		.CLK(f_10MHz) ,	// input  10MHz signal
		.CLEAR(Reset) ,	// input  CLEAR_sig
		.OUT(f_10KHz) ,	// output  10KHz signal
		.Count(count1000) 	// output [bitField-1:0] Count_sig -- it is also useless
	);
	
	divideBy1000Counter divideBy1000second
	(
		.CLK(f_10KHz) ,	// input  10MHz signal
		.CLEAR(Reset) ,	// input  CLEAR_sig
		.OUT(f_10Hz) ,	// output  10KHz signal
		.Count(count1001) 	// output [bitField-1:0] Count_sig -- it is also useless
	);
	
	divideBy10Counter divideBy10_first
	(
		.CLK(f_10Hz) ,	// input  100Hz signal
		.CLEAR(Reset) ,	// input  CLEAR_sig
		.OUT(f_1Hz) ,	// output  10Hz signal
		.Count(c0) 	// output [bitField-1:0] Count_sig -- it is also useless
	);
	
endmodule
