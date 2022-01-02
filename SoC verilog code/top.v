// GPIO IP Example
// Top-level Verilog (top.v)
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

//-----------------------------------------------------------------------------
// This file is partially based on material from Terasic
// particularly, the hps reset and reset edge detection configuration
// Copyright (c) 2013 by Terasic Technologies Inc.
//-----------------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.

module top
(
    // Clocks
    input          CLOCK2_50,
    input          CLOCK3_50,
    input          CLOCK4_50,
    input          CLOCK_50,

    // Hard processor subsystem
    inout          HPS_CONV_USB_N,
    output [14:0]  HPS_DDR3_ADDR,
    output  [2:0]  HPS_DDR3_BA,
    output         HPS_DDR3_CAS_N,
    output         HPS_DDR3_CKE,
    output         HPS_DDR3_CK_N,
    output         HPS_DDR3_CK_P,
    output         HPS_DDR3_CS_N,
    output  [3:0]  HPS_DDR3_DM,
    inout  [31:0]  HPS_DDR3_DQ,
    inout   [3:0]  HPS_DDR3_DQS_N,
    inout   [3:0]  HPS_DDR3_DQS_P,
    output         HPS_DDR3_ODT,
    output         HPS_DDR3_RAS_N,
    output         HPS_DDR3_RESET_N,
    input          HPS_DDR3_RZQ,
    output         HPS_DDR3_WE_N,
    output         HPS_ENET_GTX_CLK,
    inout          HPS_ENET_INT_N,
    output         HPS_ENET_MDC,
    inout          HPS_ENET_MDIO,
    input          HPS_ENET_RX_CLK,
    input   [3:0]  HPS_ENET_RX_DATA,
    input          HPS_ENET_RX_DV,
    output  [3:0]  HPS_ENET_TX_DATA,
    output         HPS_ENET_TX_EN,
    inout   [3:0]  HPS_FLASH_DATA,
    output         HPS_FLASH_DCLK,
    output         HPS_FLASH_NCSO,
    inout          HPS_GSENSOR_INT,
    inout          HPS_I2C1_SCLK,
    inout          HPS_I2C1_SDAT,
    inout          HPS_I2C2_SCLK,
    inout          HPS_I2C2_SDAT,
    inout          HPS_I2C_CONTROL,
    inout          HPS_KEY,
    inout          HPS_LED,
    inout          HPS_LTC_GPIO,
    output         HPS_SD_CLK,
    inout          HPS_SD_CMD,
    inout   [3:0]  HPS_SD_DATA,
    output         HPS_SPIM_CLK,
    input          HPS_SPIM_MISO,
    output         HPS_SPIM_MOSI,
    inout          HPS_SPIM_SS,
    input          HPS_UART_RX,
    output         HPS_UART_TX,
    input          HPS_USB_CLKOUT,
    inout   [7:0]  HPS_USB_DATA,
    input          HPS_USB_DIR,
    input          HPS_USB_NXT,
    output         HPS_USB_STP,

      // LTC2308CUF 8-channel, 12-bit ADC
    inout          ADC_CS_N,
    output         ADC_DIN,
    input          ADC_DOUT,
    output         ADC_SCLK,

    // WM8731 audio CODEC
    input          AUD_ADCDAT,
    inout          AUD_ADCLRCK,
    inout          AUD_BCLK,
    output         AUD_DACDAT,
    inout          AUD_DACLRCK,
    output         AUD_XCK,

    // 32M x 16b SDRAM
    output [12:0]  DRAM_ADDR,
    output  [1:0]  DRAM_BA,
    output         DRAM_CAS_N,
    output         DRAM_CKE,
    output         DRAM_CLK,
    output         DRAM_CS_N,
    inout  [15:0]  DRAM_DQ,
    output         DRAM_LDQM,
    output         DRAM_RAS_N,
    output         DRAM_UDQM,
    output         DRAM_WE_N,

    // Fan
    output         FAN_CTRL,

    // FPGA
    output         FPGA_I2C_SCLK,
    inout          FPGA_I2C_SDAT,

    // GPIO box headers
    inout  [35:0]  GPIO_0,
    inout  [35:0]  GPIO_1,

    // 7-segment displays 
    output  [6:0]  HEX0,
    output  [6:0]  HEX1,
    output  [6:0]  HEX2,
    output  [6:0]  HEX3,
    output  [6:0]  HEX4,
    output  [6:0]  HEX5,

    // IrDA (IR emitter/detector pair)
    input          IRDA_RXD,
    output         IRDA_TXD,

    // Key push buttons
    input   [3:0]  KEY,

    // 10 discrete red LEDs
    output  [9:0]  LEDR,

    // PS/2 keyboard mouse (mini-DIN)
    inout          PS2_CLK,
    inout          PS2_CLK2,
    inout          PS2_DAT,
    inout          PS2_DAT2,

    // Ten slide switches
    input   [9:0]  SW,

    // ADV7180 Video decoder (RCA jack)
    input          TD_CLK27,
    input   [7:0]  TD_DATA,
    input          TD_HS,
    output         TD_RESET_N,
    input          TD_VS,

    // ADV7123 VGA controller (DB-15HD) 
    output  [7:0]  VGA_B,
    output         VGA_BLANK_N,
    output         VGA_CLK,
    output  [7:0]  VGA_G,
    output         VGA_HS,
    output  [7:0]  VGA_R,
    output         VGA_SYNC_N,
    output         VGA_VS
);

    // HPS reset signals
    wire        hps_fpga_reset_n;
    wire [2:0]  hps_reset_req;
    wire        hps_cold_reset;
    wire        hps_warm_reset;
    wire        hps_debug_reset;

    // Assignments to module signals 
    assign ADC_DIN = 1'b0;
    assign ADC_SCLK = 1'b0;
    assign ADC_CS_N = 1'bz;
  
    assign AUD_DACDAT  = 1'b0;
    assign AUD_XCK     = 1'b0;
    assign AUD_ADCLRCK = 1'bz;
    assign AUD_BCLK    = 1'bz;
    assign AUD_DACLRCK = 1'bz;

    assign DRAM_ADDR = 13'b0;
    assign DRAM_BA = 2'b0;
    assign DRAM_CAS_N = 1'b1;
    assign DRAM_RAS_N = 1'b1;
    assign DRAM_WE_N = 1'b1;
    assign DRAM_CKE = 1'b0;
    assign DRAM_CLK = 1'b0;
    assign DRAM_CS_N = 1'b1;
    assign DRAM_DQ = 16'bzzzzzzzzzzzzzzzz;
    assign DRAM_LDQM = 1'b1;
    assign DRAM_UDQM = 1'b1;

    assign FAN_CTRL = 1'b0;

    assign FPGA_I2C_SCLK = 1'b0;
    assign FPGA_I2C_SDAT = 1'bz;

    assign GPIO_0 = 36'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;
    assign GPIO_1[35:32] = 4'bzzzz;

    assign HEX0 = 7'b1111111;
    assign HEX1 = 7'b1111111;
    assign HEX2 = 7'b1111111;
    assign HEX3 = 7'b1111111;
    assign HEX4 = 7'b1111111;
    assign HEX5 = 7'b1000010; // G

    assign IRDA_TXD = 1'b0;

    assign LEDR = 10'b0000000000;

    assign PS2_CLK  = 1'bz;
    assign PS2_DAT  = 1'bz;
    assign PS2_CLK2 = 1'bz;
    assign PS2_DAT2 = 1'bz;

    assign TD_RESET_N = 1'b1;

    assign VGA_R       = 8'b00000000;
    assign VGA_G       = 8'b00000000;
    assign VGA_B       = 8'b00000000;
    assign VGA_BLANK_N = 1'b1;
    assign VGA_CLK     = 1'b0;
    assign VGA_HS      = 1'b0;
    assign VGA_SYNC_N  = 1'b1;
    assign VGA_VS      = 1'b0;

    // SoC System
    soc_system u0 (
        .port_data                             (GPIO_1[31:0]),
        .memory_mem_a                          (HPS_DDR3_ADDR),
        .memory_mem_ba                         (HPS_DDR3_BA),
        .memory_mem_ck                         (HPS_DDR3_CK_P),
        .memory_mem_ck_n                       (HPS_DDR3_CK_N),
        .memory_mem_cke                        (HPS_DDR3_CKE),
        .memory_mem_cs_n                       (HPS_DDR3_CS_N),
        .memory_mem_ras_n                      (HPS_DDR3_RAS_N),
        .memory_mem_cas_n                      (HPS_DDR3_CAS_N),
        .memory_mem_we_n                       (HPS_DDR3_WE_N),
        .memory_mem_reset_n                    (HPS_DDR3_RESET_N),
        .memory_mem_dq                         (HPS_DDR3_DQ),
        .memory_mem_dqs                        (HPS_DDR3_DQS_P),
        .memory_mem_dqs_n                      (HPS_DDR3_DQS_N),
        .memory_mem_odt                        (HPS_DDR3_ODT),
        .memory_mem_dm                         (HPS_DDR3_DM),
        .memory_oct_rzqin                      (HPS_DDR3_RZQ),
       		
        .hps_0_hps_io_hps_io_emac1_inst_TX_CLK (HPS_ENET_GTX_CLK),
        .hps_0_hps_io_hps_io_emac1_inst_TXD0   (HPS_ENET_TX_DATA[0]),
        .hps_0_hps_io_hps_io_emac1_inst_TXD1   (HPS_ENET_TX_DATA[1]),
        .hps_0_hps_io_hps_io_emac1_inst_TXD2   (HPS_ENET_TX_DATA[2]),
        .hps_0_hps_io_hps_io_emac1_inst_TXD3   (HPS_ENET_TX_DATA[3]),
        .hps_0_hps_io_hps_io_emac1_inst_RXD0   (HPS_ENET_RX_DATA[0]),
        .hps_0_hps_io_hps_io_emac1_inst_MDIO   (HPS_ENET_MDIO),
        .hps_0_hps_io_hps_io_emac1_inst_MDC    (HPS_ENET_MDC),
        .hps_0_hps_io_hps_io_emac1_inst_RX_CTL (HPS_ENET_RX_DV),
        .hps_0_hps_io_hps_io_emac1_inst_TX_CTL (HPS_ENET_TX_EN),
        .hps_0_hps_io_hps_io_emac1_inst_RX_CLK (HPS_ENET_RX_CLK),
        .hps_0_hps_io_hps_io_emac1_inst_RXD1   (HPS_ENET_RX_DATA[1]),
        .hps_0_hps_io_hps_io_emac1_inst_RXD2   (HPS_ENET_RX_DATA[2]),
        .hps_0_hps_io_hps_io_emac1_inst_RXD3   (HPS_ENET_RX_DATA[3]),
         
        .hps_0_hps_io_hps_io_qspi_inst_IO0     (HPS_FLASH_DATA[0]),
        .hps_0_hps_io_hps_io_qspi_inst_IO1     (HPS_FLASH_DATA[1]),
        .hps_0_hps_io_hps_io_qspi_inst_IO2     (HPS_FLASH_DATA[2]),
        .hps_0_hps_io_hps_io_qspi_inst_IO3     (HPS_FLASH_DATA[3]),
        .hps_0_hps_io_hps_io_qspi_inst_SS0     (HPS_FLASH_NCSO),
        .hps_0_hps_io_hps_io_qspi_inst_CLK     (HPS_FLASH_DCLK),
        
        .hps_0_hps_io_hps_io_sdio_inst_CMD     (HPS_SD_CMD),
        .hps_0_hps_io_hps_io_sdio_inst_D0      (HPS_SD_DATA[0]),
        .hps_0_hps_io_hps_io_sdio_inst_D1      (HPS_SD_DATA[1]),
        .hps_0_hps_io_hps_io_sdio_inst_CLK     (HPS_SD_CLK),
        .hps_0_hps_io_hps_io_sdio_inst_D2      (HPS_SD_DATA[2]),
        .hps_0_hps_io_hps_io_sdio_inst_D3      (HPS_SD_DATA[3]),
        		  
        .hps_0_hps_io_hps_io_usb1_inst_D0      (HPS_USB_DATA[0]),
        .hps_0_hps_io_hps_io_usb1_inst_D1      (HPS_USB_DATA[1]),
        .hps_0_hps_io_hps_io_usb1_inst_D2      (HPS_USB_DATA[2]),
        .hps_0_hps_io_hps_io_usb1_inst_D3      (HPS_USB_DATA[3]),
        .hps_0_hps_io_hps_io_usb1_inst_D4      (HPS_USB_DATA[4]),
        .hps_0_hps_io_hps_io_usb1_inst_D5      (HPS_USB_DATA[5]),
        .hps_0_hps_io_hps_io_usb1_inst_D6      (HPS_USB_DATA[6]),
        .hps_0_hps_io_hps_io_usb1_inst_D7      (HPS_USB_DATA[7]),
        .hps_0_hps_io_hps_io_usb1_inst_CLK     (HPS_USB_CLKOUT),
        .hps_0_hps_io_hps_io_usb1_inst_STP     (HPS_USB_STP),
        .hps_0_hps_io_hps_io_usb1_inst_DIR     (HPS_USB_DIR),
        .hps_0_hps_io_hps_io_usb1_inst_NXT     (HPS_USB_NXT),
        		  
        .hps_0_hps_io_hps_io_spim1_inst_CLK    (HPS_SPIM_CLK),
        .hps_0_hps_io_hps_io_spim1_inst_MOSI   (HPS_SPIM_MOSI),
        .hps_0_hps_io_hps_io_spim1_inst_MISO   (HPS_SPIM_MISO),
        .hps_0_hps_io_hps_io_spim1_inst_SS0    (HPS_SPIM_SS),
      		
        .hps_0_hps_io_hps_io_uart0_inst_RX     (HPS_UART_RX),
        .hps_0_hps_io_hps_io_uart0_inst_TX     (HPS_UART_TX),
		
        .hps_0_hps_io_hps_io_i2c0_inst_SDA     (HPS_I2C1_SDAT),
        .hps_0_hps_io_hps_io_i2c0_inst_SCL     (HPS_I2C1_SCLK),
		
        .hps_0_hps_io_hps_io_i2c1_inst_SDA     (HPS_I2C2_SDAT),
        .hps_0_hps_io_hps_io_i2c1_inst_SCL     (HPS_I2C2_SCLK),
        
        .hps_0_hps_io_hps_io_gpio_inst_GPIO09  (HPS_CONV_USB_N),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO35  (HPS_ENET_INT_N),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO40  (HPS_LTC_GPIO),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO48  (HPS_I2C_CONTROL),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO53  (HPS_LED),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO54  (HPS_KEY),
        .hps_0_hps_io_hps_io_gpio_inst_GPIO61  (HPS_GSENSOR_INT),
        .clk_clk                               (CLOCK_50),
        .reset_reset_n                         (hps_fpga_reset_n),
        .hps_0_h2f_reset_reset_n               (hps_fpga_reset_n),
        .hps_0_f2h_warm_reset_req_reset_n      (~hps_warm_reset),
        .hps_0_f2h_debug_reset_req_reset_n     (~hps_debug_reset),
        .hps_0_f2h_cold_reset_req_reset_n      (~hps_cold_reset)
    );

// Reset conditioning
// HPS Reset and edge detector IP
hps_reset hps_reset_inst 
(
    .source_clk (CLOCK_50),
    .source     (hps_reset_req)
);

altera_edge_detector pulse_cold_reset 
(
    .clk       (CLOCK_50),
    .rst_n     (hps_fpga_reset_n),
    .signal_in (hps_reset_req[0]),
    .pulse_out (hps_cold_reset)
);
  defparam pulse_cold_reset.PULSE_EXT = 6;
  defparam pulse_cold_reset.EDGE_TYPE = 1;
  defparam pulse_cold_reset.IGNORE_RST_WHILE_BUSY = 1;

altera_edge_detector pulse_warm_reset 
(
    .clk       (CLOCK_50),
    .rst_n     (hps_fpga_reset_n),
    .signal_in (hps_reset_req[1]),
    .pulse_out (hps_warm_reset)
);
  defparam pulse_warm_reset.PULSE_EXT = 2;
  defparam pulse_warm_reset.EDGE_TYPE = 1;
  defparam pulse_warm_reset.IGNORE_RST_WHILE_BUSY = 1;
  
altera_edge_detector pulse_debug_reset 
(
    .clk       (CLOCK_50),
    .rst_n     (hps_fpga_reset_n),
    .signal_in (hps_reset_req[2]),
    .pulse_out (hps_debug_reset)
);
  defparam pulse_debug_reset.PULSE_EXT = 32;
  defparam pulse_debug_reset.EDGE_TYPE = 1;
  defparam pulse_debug_reset.IGNORE_RST_WHILE_BUSY = 1;

endmodule
