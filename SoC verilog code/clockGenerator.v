
// Verilog code for a clock generator which generates clock of a specified period with refrence to the input clock

module clockGenerator (input CLK, output reg OUT);

	reg [31:0] count;
	
	parameter period = 4;
	
	always@(posedge CLK)
	begin
		
		if (count == period/2 - 1)
		begin
			count <= 1'b0;
			OUT <= ~OUT;
		end
		
		else
		begin
			count <= count + 1'b1;
			OUT <= OUT;
		end
	end
	
endmodule

