
// Verilog Behavioural code for the Baud Rate Generator, it tells the hardware about when to sample the TX line on UART
// In this specific project, the microcontroller code of UART will multiply the baud rate with 16, so here we have to divide by 16

// This program can generate the following baud rates and there corrosponding hexadecimal inputs are mentioned as below:
// 1) 230400 bps -- 0x364
// 2) 115200 bps -- 0x6C8
// 3)  57600 bps -- 0xD90
// 4)  28800 bps -- 0x1B20
// 5)   1800 bps -- 0x1B207
// 6)   1200 bps -- 0x28B0A
// 7)    150 bps -- 0x145855
// 8)     75 bps -- 0x28BOAA
// Calculations Required for above numbers are present in class notebook.

// Input clock is comming at 50 MHz so that has to divided such that the output clock will be 230400 Hz,...


module baudRateGenerator (Clock, Enable, Reset, BRD, baud_out);

	input Clock, Enable, Reset; // Enable will work as an ON/OFF switch for the Baud Rate Generator
	input [31:0] BRD; // BRD == Baud Rate Divider, 50e6 will be divided by (16*BRD) to get the required baud_out
	// bits from 0 to 5 consists fractional part and bits from 6 to 31 consists integer part
	// [31 ... 6 | 5 ... 0]
	// [Integer  | Fraction]
	
	output reg baud_out;
	
	reg [31:0] count, target;
	
	always @ (posedge Clock, negedge Reset)
	begin
		
		if (Reset == 1'b0)
		begin
			baud_out <= 32'b0;
			count 	<= 32'b0;
			target	<= BRD;
		end
		
		else if (Enable == 1'b1)
		begin
			
			count <= count + 8'b10000000;
			
			if (count [31:7] == target [31:7])
			begin
				target <= target + BRD;
				baud_out <= ~baud_out;
			end
		
			else baud_out <= baud_out;
			
		end
		
	end
	
endmodule

			
		