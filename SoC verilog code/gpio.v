// GPIO IP Example
// GPIO Verilog Implementation (gpio.v)
// Jason Losh

//-----------------------------------------------------------------------------
// Hardware Target
//-----------------------------------------------------------------------------

// Target Platform: DE1-SoC Board

// Hardware configuration:
// GPIO Port:
//   GPIO_1[31-0] is used as a general purpose GPIO port
// HPS interface:
//   Mapped to offset of 0 in light-weight MM interface aperature
//   IRQ80 is used as the interrupt interface to the HPS

//-----------------------------------------------------------------------------

module gpio (clk, reset, irq, address, byteenable, chipselect, writedata, readdata, write, read, data);

    // Clock, reset, and interrupt
    input   clk, reset;
    output  irq;

    // Avalon MM interface (8 word aperature)
    input             read, write, chipselect;
    input [2:0]       address;
    input [3:0]       byteenable;
    input [31:0]      writedata;
    output reg [31:0] readdata;
    
    // gpio interface
    inout reg [31:0]  data;

    // internal    
    reg [31:0] latch_data;
    reg [31:0] out;
    reg [31:0] od;
    reg [31:0] int_enable;
    reg [31:0] int_positive;
    reg [31:0] int_negative;
    reg [31:0] int_edge_mode;
    reg [31:0] int_status;
    reg [31:0] int_clear_request;
    
    // register map
    // ofs  fn
    //   0  data (r/w)
    //   4  out (r/w)
    //   8  od (r/w)
    //  12  int_enable (r/w)
    //  16  int_positive (r/w)
    //  20  int_negative (r/w)
    //  24  int_edge_mode (r/w)
    //  28  int_status_clear (r/w1c)
    
    // register numbers
    parameter DATA_REG             = 3'b000; // reading and writing from different registers when it comes to this register
    parameter OUT_REG              = 3'b001;
    parameter ODR_REG              = 3'b010;
    parameter INT_ENABLE_REG       = 3'b011;
    parameter INT_POSITIVE_REG     = 3'b100;
    parameter INT_NEGATIVE_REG     = 3'b101;
    parameter INT_EDGE_MODE_REG    = 3'b110;
    parameter INT_STATUS_CLEAR_REG = 3'b111;
    
    // read register  ----------------------------------- blocking statements are used!!!
    always @ (*)
    begin
        if (read & chipselect)
            case (address)
                DATA_REG: 
                    readdata = data; // this are the direct values of physical pins
                OUT_REG:
                    readdata = out;
                ODR_REG: 
                    readdata = od;
                INT_ENABLE_REG: 
                    readdata = int_enable;
                INT_POSITIVE_REG:
                    readdata = int_positive;
                INT_NEGATIVE_REG:
                    readdata = int_negative;
                INT_EDGE_MODE_REG:
                    readdata = int_edge_mode;
                INT_STATUS_CLEAR_REG: // reading STATUS CLEAR register will tell us about what interupt has occured
                    readdata = int_status;
            endcase
        else
            readdata = 32'b0;
    end        

    // write register
    always @ (posedge clk or posedge reset)
    begin
        if (reset)
        begin
            latch_data[31:0] <= 32'b0;
            out <= 32'b0;
            od <= 32'b0;
            int_enable <= 32'b0;
            int_positive <= 32'b0;
            int_negative <= 32'b0;
            int_edge_mode <= 32'b0;
            int_clear_request <= 32'b0;
        end
        else
        begin
            if (write & chipselect)
            begin
                case (address)
                    DATA_REG: 
                        latch_data <= writedata; // writing to a latch_reg which is different then what we read from.
                    OUT_REG: 
                        out <= writedata;
                    ODR_REG: 
                        od <= writedata;
                    INT_ENABLE_REG: 
                        int_enable <= writedata;
                    INT_POSITIVE_REG: 
                        int_positive <= writedata;
                    INT_NEGATIVE_REG: 
                        int_negative <= writedata;
                    INT_EDGE_MODE_REG: 
                        int_edge_mode <= writedata;
                    INT_STATUS_CLEAR_REG: 
                        int_clear_request <= writedata;
                endcase
            end
            else
                int_clear_request <= 32'b0;
        end
    end
    
    // pin control
    // OUT LATCH ODR   PIN
    //  0    x    x    hi-Z
    //  1    0    x     0
    //  1    1    0     1
    //  1    1    1    hi-Z
    integer i;
    always @ (posedge clk)
    begin
        for (i = 0; i < 32; i = i + 1)
        begin
            if (out[i])
                if (latch_data[i])
                begin
                    if (od[i])
                        data[i] <= 1'bz;
                    else
                        data[i] <= 1'b1;
                end
                else
                    data[i] <= 1'b0;
            else
                data[i] <= 1'bz;
        end
    end
    
    // interrupt generation
    reg [31:0] last_data;
    always @ (posedge clk, posedge reset)
    begin
        if (reset)
        begin
            last_data <= 32'b0;
            int_status <= 32'b0;
        end
        else if (int_clear_request != 32'b0)
            int_status <= int_status & ~int_clear_request;
        else
        begin
            last_data <= data;
            for (i = 0; i < 32; i = i + 1)
            begin
                if (int_enable[i])
                begin
                    if (int_edge_mode[i])
                    begin
                        if (int_positive[i] & data[i] & !last_data[i])
                            int_status[i] <= 1'b1;
                        if (int_negative[i] & !data[i] & last_data[i])
                            int_status[i] <= 1'b1;
                    end
                    else
                    begin
                        if (int_positive[i] & data[i])
                            int_status[i] <= 1'b1;
                        if (int_negative[i] & !data[i])
                            int_status[i] <= 1'b1;
                    end
                end
            end
        end
    end
    assign irq = int_status != 32'b0;
endmodule
