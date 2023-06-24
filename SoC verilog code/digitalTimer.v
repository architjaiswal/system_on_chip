
// design a digital timer which shows centi-seconds, seconds and minutes
// Input clock is 50 MHz and that has to be reduces to 100 Hz signal to feed to the centi-second timer
// gives an output pulse every hour

module digitalTimer (
							input clock, reset, On_Off, reset_centi, reset_sec,
							output [0:6] centi_0, centi_1, sec_0, sec_1, min_0, min_1 
						  );
							
							wire [3:0] c0, c1, s0, s1, m0, m1; // this will hold the counter value to in 4 bit and give it to the 7 segment decoder
							wire toggleOutput, f_10MHz, f_10khz, f_100Hz, f_10Hz, f_1Hz, every10sec, every1min, every10min, every1hour;
							
							wire [3:0] count5, count10; // this are the useless variables, just defined for instantiation purposes
							wire [6:0] count100; // this is also useless and only defined for instantiation 
							wire [9:0] count1000; // this is also useless and only defined for instantiation
							
							

	ToggleLatch ToggleLatch
	(
		.On_Off(On_Off) ,	// input  On_Off_sig
		.IN(clock) ,	// input  IN_sig
		.Clear(reset) ,	// input  Clear_sig
		.OUT(toggleOutput) 	// output  OUT_sig
	);
	
	divideBy5Counter divideBy5
	(
		.CLK(toggleOutput) ,	// input  50MHz clock 
		.CLEAR(reset) ,	// input  CLEAR_sig
		.OUT(f_10MHz) ,	// output  10MHz signal
		.Count(count5) 	// output [bitField-1:0] Count_sig -- it is useless 
	);
	
	divideBy1000Counter divideBy1000
	(
		.CLK(f_10MHz) ,	// input  10MHz signal
		.CLEAR(reset) ,	// input  CLEAR_sig
		.OUT(f_10KHz) ,	// output  10KHz signal
		.Count(count1000) 	// output [bitField-1:0] Count_sig -- it is also useless
	);
	
	divideBy100Counter divideBy100
	(
		.CLK(f_10KHz) ,	// input  10KHz signal
		.CLEAR(reset) ,	// input  CLEAR_sig
		.OUT(f_100Hz) ,	// output  100Hz signal
		.Count(count100) 	// output [bitField-1:0] Count_sig -- it is also useless
	);
	
	divideBy10Counter divideBy10_first
	(
		.CLK(f_100Hz) ,	// input  100Hz signal
		.CLEAR(reset && reset_centi) ,	// input  CLEAR_sig
		.OUT(f_10Hz) ,	// output  10Hz signal
		.Count(c0) 	// output [bitField-1:0] Count_sig -- it will represent centi_0
	);

	bin2sevenSegment centi_0_display
	(
		.BIN(c0) ,	// input [3:0] BIN_sig -- centi_0 
		.SEV(centi_0) 	// output [0:6] SEV_sig
	);
	
	divideBy10Counter divideBy10_second
	(
		.CLK(f_10Hz) ,	// input  10Hz signal
		.CLEAR(reset && reset_centi) ,	// input  CLEAR_sig
		.OUT(f_1Hz) ,	// output  1Hz signal
		.Count(c1) 	// output [bitField-1:0] Count_sig -- it will represent centi_1
	);

	bin2sevenSegment centi_1_display
	(
		.BIN(c1) ,	// input [3:0] BIN_sig -- centi_1 
		.SEV(centi_1) 	// output [0:6] SEV_sig
	);
	
	divideBy10Counter divideBy10_third
	(
		.CLK(f_1Hz) ,	// input  1Hz signal
		.CLEAR(reset && reset_sec) ,	// input  CLEAR_sig
		.OUT(every10sec) ,	// output  1Hz signal
		.Count(s0) 	// output [bitField-1:0] Count_sig -- it will represent sec_0
	);
	
	bin2sevenSegment sec_0_display
	(
		.BIN(s0) ,	// input [3:0] BIN_sig -- sec_0 
		.SEV(sec_0) 	// output [0:6] SEV_sig
	);
	
	divideBy6Counter divideBy6_first
	(
		.CLK(every10sec) ,	// input clocks after every 10 seconds
		.CLEAR(reset && reset_sec) ,	// input  CLEAR_sig
		.OUT(every1min) ,	// output  signals after every 1 minute
		.Count(s1) 	// output [bitField-1:0] Count_sig -- represents sec_1
	);
	
	bin2sevenSegment sec_1_display
	(
		.BIN(s1) ,	// input [3:0] BIN_sig -- sec_1 
		.SEV(sec_1) 	// output [0:6] SEV_sig
	);
		
	divideBy10Counter divideBy10_fourth
	(
		.CLK(every1min) ,	// input signal coming after every 1 minute
		.CLEAR(reset) ,	// input  CLEAR_sig
		.OUT(every10min) ,	// output signal after every 10 minutes
		.Count(m0) 	// output [bitField-1:0] Count_sig -- it will represent min_0
	);
	
	bin2sevenSegment min_0_display
	(
		.BIN(m0) ,	// input [3:0] BIN_sig -- min_0 
		.SEV(min_0) 	// output [0:6] SEV_sig
	);
	
	divideBy6Counter divideBy6_second
	(
		.CLK(every10min) ,	// input clocks after every 10 minutes
		.CLEAR(reset) ,	// input  CLEAR_sig
		.OUT(every1hour) ,	// output  signals after every 1 hour
		.Count(m1) 	// output [bitField-1:0] Count_sig -- represents sec_1
	);
	
	bin2sevenSegment min_1_display
	(
		.BIN(m1) ,	// input [3:0] BIN_sig -- min_1 
		.SEV(min_1) 	// output [0:6] SEV_sig
	);
	

endmodule 