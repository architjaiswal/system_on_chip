// UART IP 
// UART Verilog Implementation (uart.v)
// Archit Jaiswal

//-----------------------------------------------------------------------------
// Hardware Target
//-----------------------------------------------------------------------------

// Target Platform: DE1-SoC Board

// Hardware configuration:
// UART IP module
//   UART_TX: pin 2 GPIO_0 on JP1 box header
//	  UART_RX: pin 4 GPIO_0 on JP1 box header
//   UART_CLK_OUT: pin 6 GPIO_0 on JP1 box header
//   debug_in and debug_out
//   
// HPS interface:
//   Mapped to offset of 0x400 in light-weight MM interface aperature

//-----------------------------------------------------------------------------

module uart (clk, reset, address, chipselect, writedata, readdata, write, read, uart_tx, uart_rx, uart_clk_out, displayOut0, displayOut1, displayOut2);
		// also implement irq

    // Clock, reset and interrupt or alert signals
    input 			clk, reset;
	 output [0:6]  displayOut0; 				// output declaration specially for bin2sevenSegment display
	 output [0:6]  displayOut1; 				// output declaration specially for bin2sevenSegment display
	 output [0:6]  displayOut2; 				// output declaration specially for bin2sevenSegment display
	 
	 // Avalon memory mapped interface (4 registers .i.e., 4 words and each register is 32 bits long) (1 word is 4 bytes = 4 * 8 bits = 32 bits)
    input 					read, write, chipselect;
	 input  [1:0] 			address; // only 2 bits are needed to assign 4 different addresses
	 input [31:0] 			writedata;
	 output reg [31:0] 	readdata;
	 
	 // UART module interface
	 input      uart_rx;
	 output uart_tx, uart_clk_out; // not sure should it be output or output reg ??
	 
	 // debug_in and debug_out width ??? should be 4 because that will go to Bin2seven display
	 reg [3:0]  tx_read_ptr, tx_write_ptr;
	 reg [3:0]  rx_read_ptr, rx_write_ptr;
	 
	 wire baud_out, transmitter_clk;
	 wire tx_FIFO_read_signal, rx_FIFO_write_signal; //--------------------------------------------------------------------------TEMPORARY both should come transmitter and receiver instantiation
	 wire tx_FIFO_out;
	 wire [9:0] useless;
	 wire [3:0] stateOUT;
	 // internal registers
	 reg 	[8:0]	 tx_FIFO_output, rx_FIFO_input; //-------------------------------------------------------------------------------TEMPORARY this should go to transmitter instantation and receiver instantiation
	 //reg 	[8:0]  wr_data, rd_data;	  // data written to the FIFO and data begin read from the FIFO -- TEMPORARY
	 reg [31:0]  data_reg; 				  // holds the value that needs to be outputed in DATA register
	 reg [31:0]  status_reg; 		     // interupt status register, it is read only kind of register for the program, when user writes here it writes to "status_clear_request"
	 reg [31:0]  status_clear_request; // user writes to this register in order to clear any status bit
	 reg [31:0]  control_reg;		     // 
	 reg [31:0]  brd_reg;				  // contains the baud rate entered by the user
	 
	 
	 // register map
	 // ofs -- function
	 //---------------------------------
	 //   0 -- data 		  (r/w)
	 //   1 -- status_reg  (r/w)
	 //   2 -- control_reg (r/w)
	 //   3 -- brd_reg 	  (r/w)
	 
	 
	 // register numbers
    parameter DATA_REG           = 2'b00;
    parameter STATUS_REG         = 2'b01;
    parameter CONTROL_REG        = 2'b10;
	 parameter BRD_REG   	   	= 2'b11;
	 
	 
	 // read register
	 always @ (*)
	 begin
	 
	 	if (read & chipselect)
		begin
			case (address)
				DATA_REG:	 	begin     								end
										
				STATUS_REG: 	begin readdata = status_reg; 		end
						
				CONTROL_REG: 	begin readdata = control_reg; 	end
						
				BRD_REG: 		begin readdata = brd_reg;			end
			endcase
		end
			
		else
			readdata = 32'b0;
	 	
	 end

	 
	 // write register
	 always @(posedge clk or posedge reset)
	 begin
	 
		if (reset)
		begin
			//writedata		  			<= 32'b0;
			status_clear_request    <= 32'b0;
			control_reg      			<= 32'b0;
			brd_reg          			<= 32'b0;
		end
		else 
		begin
				if (write && chipselect)
				begin
					case (address)
					
						DATA_REG:	 	begin 											   end
											
						STATUS_REG: 	begin status_clear_request <= writedata; 	end
							
						CONTROL_REG: 	begin control_reg <= writedata; 			   end
							
						BRD_REG: 		begin brd_reg <= writedata; 				   end
							
					endcase
				end
			
				else
					status_clear_request <= 32'b0; 
		end
		
    end 
	 
	 
	 // making a sticky bit on status_register
	 reg rx_overflow, tx_overflow, frame_error, parity_error; 
	 	 
	 always @ (*)
	 begin
		
		if (status_reg[0] == 1'b1)
		begin
		rx_overflow <= 1'b1;
		end
		
		if (status_reg[3] == 1'b1)
		begin
		tx_overflow <= 1'b1;
		end	
	
		if (status_reg[6] == 1'b1)
		begin
		frame_error <= 1'b1;
		end		
		
		if (status_reg[7] == 1'b1)
		begin
		parity_error <= 1'b1;
		end		
		
	 end
	 
	 
	 // Updating and handling status register
	 
	 always @ (posedge clk or posedge reset)
	 begin
		
		if (reset)
		begin
			status_reg <= 32'b0;
		end
		else if (status_clear_request != 32'b0)
		begin
			status_reg <= status_reg & ~status_clear_request;
		end
		
	 end
	 
	 
	 uart_tx_fifo uart_tx_fifo_inst
	 (
		.Clock(clk) ,						// input  Clock_sig
		.Reset(reset | ~control_reg[3]) ,					// input  Reset_sig
		.Read(tx_FIFO_read_signal) ,						// input  Read_sig <------------------------------------------- needs to be changed after transmitter instantiation is ready
		.Write(write) ,					// input  Write_sig
		.ClearOV(status_clear_request[3]) ,				// input  ClearOV_sig
		.ChipSelect(chipselect) ,		// input  ChipSelect_sig
		.Full(status_reg[4]) ,						// output  Full_sig
		.OV(status_reg[3]) ,					// output  OV_sig <----------------------------------------OVERFLOW clears automatically as soon as a read occurs, THIS NEEDS TO BE FIXED
		.Empty(status_reg[5]) ,					// output  Empty_sig
		.Address(address) ,				// input [1:0] Address_sig
		.DataIn(writedata[8:0]) ,		// input [8:0] DataIn_sig <------ Getting input directly from the input of UART module which is a 32 bit reg
		.DataOut(tx_FIFO_output) ,		// output [8:0] DataOut_sig
		.ReadPtr(tx_read_ptr) ,			// output [3:0] ReadPtr_sig
		.WritePtr(tx_write_ptr) 		// output [3:0] WritePtr_sig
	 );

	 uart_rx_fifo uart_rx_fifo_inst
	 (
		.Clock(clk) ,						// input  Clock_sig
		.Reset(reset | ~control_reg[3]) ,					// input  Reset_sig
		.Read(tx_FIFO_read_signal) ,						// input  Read_sig
		.Write(rx_FIFO_write_signal) ,					// input  Write_sig <------------------------------------------- needs to be changed after transmitter instantiation is ready
		.ClearOV(status_clear_request[0]) ,				// input  ClearOV_sig
		.ChipSelect(chipselect) ,		// input  ChipSelect_sig
		.Full(status_reg[1]) ,						// output  Full_sig
		.OV(status_reg[0]) ,				// output  OV_sig  <----------------------------------------OVERFLOW clears automatically as soon as a read occurs, THIS NEEDS TO BE FIXED
		.Empty(status_reg[2]) ,					// output  Empty_sig
		.Address(address) ,				// input [1:0] Address_sig
		.DataIn(rx_FIFO_input) ,		// input [8:0] DataIn_sig
		.DataOut(readdata[8:0]) ,		// output [8:0] DataOut_sig <----- Showing output directly to the output of UART module which is a 32 bit reg
		.ReadPtr(rx_read_ptr) ,			// output [3:0] ReadPtr_sig
		.WritePtr(rx_write_ptr) 		// output [3:0] WritePtr_sig
	 );
	 
	 
	 baudRateGenerator baudRateGenerator_inst
	 (
		.Clock(clk) ,								// input  Clock_sig
		.Enable(control_reg[4]) ,				// input  Enable_sig
		.Reset(reset | ~control_reg[3]) ,	// input  Reset_sig
		.BRD(brd_reg) ,							// input [31:0] BRD_sig
		.baud_out(baud_out) 				// output  baud_out_sig
	 );
	 
	 divideBy16 divideBy16_inst
	 (
		.CLK(baud_out) ,				// input  CLK_sig
		.CLEAR(!reset) ,				// input  CLEAR_sig ---- negative edge
		.OUT(transmitter_clk) ,		// output  OUT_sig
		.Count(useless) 				// output [bitField-1:0] Count_sig
	 );
	
	 transmitter transmitter_inst
	 (
		.clk(transmitter_clk) ,		// input  clk_sig
		.clk_enable(control_reg[3]) ,			// input  clk_enable_sig
		.reset(reset) ,				// input  reset_sig
		.DATA(tx_FIFO_out) ,				// input [8:0] DATA_sig
		.TX_OUT(uart_tx) ,				// output  TX_OUT_sig
		.stateOUT(stateOUT) ,	// output [3:0] stateOUT_sig
		.tx_request(status_reg[2]) ,		// input  tx_request_sig
		.tx_ack(tx_FIFO_read_signal) 					// output  tx_ack_sig
	 );





	 
endmodule
