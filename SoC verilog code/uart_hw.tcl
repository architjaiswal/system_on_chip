# TCL File Generated by Component Editor 18.1
# Sun Nov 08 12:41:04 CST 2020
# DO NOT MODIFY


# 
# uart "uart" v1.0
# Archit Jaiswal 2020.11.08.12:41:04
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module uart
# 
set_module_property DESCRIPTION ""
set_module_property NAME uart
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "ArchitJ IP Cores"
set_module_property AUTHOR "Archit Jaiswal"
set_module_property DISPLAY_NAME uart
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL new_component
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file uart.v VERILOG PATH uart.v TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file uart.v VERILOG PATH uart.v


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clk
# 
add_interface clk clock end
set_interface_property clk clockRate 0
set_interface_property clk ENABLED true
set_interface_property clk EXPORT_OF ""
set_interface_property clk PORT_NAME_MAP ""
set_interface_property clk CMSIS_SVD_VARIABLES ""
set_interface_property clk SVD_ADDRESS_GROUP ""

add_interface_port clk clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clk
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point avalon_bus
# 
add_interface avalon_bus avalon end
set_interface_property avalon_bus addressUnits WORDS
set_interface_property avalon_bus associatedClock clk
set_interface_property avalon_bus associatedReset reset
set_interface_property avalon_bus bitsPerSymbol 8
set_interface_property avalon_bus burstOnBurstBoundariesOnly false
set_interface_property avalon_bus burstcountUnits WORDS
set_interface_property avalon_bus explicitAddressSpan 0
set_interface_property avalon_bus holdTime 0
set_interface_property avalon_bus linewrapBursts false
set_interface_property avalon_bus maximumPendingReadTransactions 0
set_interface_property avalon_bus maximumPendingWriteTransactions 0
set_interface_property avalon_bus readLatency 0
set_interface_property avalon_bus readWaitTime 1
set_interface_property avalon_bus setupTime 0
set_interface_property avalon_bus timingUnits Cycles
set_interface_property avalon_bus writeWaitTime 0
set_interface_property avalon_bus ENABLED true
set_interface_property avalon_bus EXPORT_OF ""
set_interface_property avalon_bus PORT_NAME_MAP ""
set_interface_property avalon_bus CMSIS_SVD_VARIABLES ""
set_interface_property avalon_bus SVD_ADDRESS_GROUP ""

add_interface_port avalon_bus address address Input 2
add_interface_port avalon_bus chipselect chipselect Input 1
add_interface_port avalon_bus read read Input 1
add_interface_port avalon_bus write write Input 1
add_interface_port avalon_bus readdata readdata Output 32
add_interface_port avalon_bus writedata writedata Input 32
set_interface_assignment avalon_bus embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_bus embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_bus embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_bus embeddedsw.configuration.isPrintableDevice 0


# 
# connection point conduit_end
# 
add_interface conduit_end conduit end
set_interface_property conduit_end associatedClock clk
set_interface_property conduit_end associatedReset ""
set_interface_property conduit_end ENABLED true
set_interface_property conduit_end EXPORT_OF ""
set_interface_property conduit_end PORT_NAME_MAP ""
set_interface_property conduit_end CMSIS_SVD_VARIABLES ""
set_interface_property conduit_end SVD_ADDRESS_GROUP ""

add_interface_port conduit_end uart_tx new_signal Output 1
add_interface_port conduit_end uart_rx new_signal_1 Input 1
add_interface_port conduit_end uart_clk_out new_signal_2 Output 1


# 
# connection point uart_irq
# 
add_interface uart_irq interrupt end
set_interface_property uart_irq associatedAddressablePoint ""
set_interface_property uart_irq associatedClock clk
set_interface_property uart_irq associatedReset reset
set_interface_property uart_irq bridgedReceiverOffset ""
set_interface_property uart_irq bridgesToReceiver ""
set_interface_property uart_irq ENABLED true
set_interface_property uart_irq EXPORT_OF ""
set_interface_property uart_irq PORT_NAME_MAP ""
set_interface_property uart_irq CMSIS_SVD_VARIABLES ""
set_interface_property uart_irq SVD_ADDRESS_GROUP ""

add_interface_port uart_irq uart_irq irq Output 1

