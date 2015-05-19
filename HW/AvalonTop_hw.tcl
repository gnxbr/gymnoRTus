# TCL File Generated by Component Editor 15.0
# Tue May 19 20:29:26 BRT 2015
# DO NOT MODIFY


# 
# AvalonTop "AvalonTop" v1.0
#  2015.05.19.20:29:26
# 
# 

# 
# request TCL package from ACDS 15.0
# 
package require -exact qsys 15.0


# 
# module AvalonTop
# 
set_module_property DESCRIPTION ""
set_module_property NAME AvalonTop
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME AvalonTop
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL mkAvalonTop
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file mkAvalonTop.v VERILOG PATH mkAvalonTop.v TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_n reset_n Input 1


# 
# connection point avalon_slave
# 
add_interface avalon_slave avalon end
set_interface_property avalon_slave addressUnits WORDS
set_interface_property avalon_slave associatedClock clock
set_interface_property avalon_slave associatedReset reset
set_interface_property avalon_slave bitsPerSymbol 8
set_interface_property avalon_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_slave burstcountUnits WORDS
set_interface_property avalon_slave explicitAddressSpan 0
set_interface_property avalon_slave holdTime 0
set_interface_property avalon_slave linewrapBursts false
set_interface_property avalon_slave maximumPendingReadTransactions 1
set_interface_property avalon_slave maximumPendingWriteTransactions 0
set_interface_property avalon_slave readLatency 0
set_interface_property avalon_slave readWaitTime 1
set_interface_property avalon_slave setupTime 0
set_interface_property avalon_slave timingUnits Cycles
set_interface_property avalon_slave writeWaitTime 0
set_interface_property avalon_slave ENABLED true
set_interface_property avalon_slave EXPORT_OF ""
set_interface_property avalon_slave PORT_NAME_MAP ""
set_interface_property avalon_slave CMSIS_SVD_VARIABLES ""
set_interface_property avalon_slave SVD_ADDRESS_GROUP ""

add_interface_port avalon_slave read read Input 1
add_interface_port avalon_slave write write Input 1
add_interface_port avalon_slave writedata writedata Input 32
add_interface_port avalon_slave readdata readdata Output 32
add_interface_port avalon_slave waitrequest waitrequest Output 1
add_interface_port avalon_slave readdatavalid readdatavalid Output 1
add_interface_port avalon_slave address address Input 2
set_interface_assignment avalon_slave embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_slave embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_slave embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_slave embeddedsw.configuration.isPrintableDevice 0


# 
# connection point interrupt_sender
# 
add_interface interrupt_sender interrupt end
set_interface_property interrupt_sender associatedAddressablePoint ""
set_interface_property interrupt_sender associatedClock clock
set_interface_property interrupt_sender associatedReset reset
set_interface_property interrupt_sender bridgedReceiverOffset 0
set_interface_property interrupt_sender bridgesToReceiver ""
set_interface_property interrupt_sender ENABLED true
set_interface_property interrupt_sender EXPORT_OF ""
set_interface_property interrupt_sender PORT_NAME_MAP ""
set_interface_property interrupt_sender CMSIS_SVD_VARIABLES ""
set_interface_property interrupt_sender SVD_ADDRESS_GROUP ""

add_interface_port interrupt_sender ins irq Output 1


# 
# connection point conduit_adc
# 
add_interface conduit_adc conduit end
set_interface_property conduit_adc associatedClock clock_adc
set_interface_property conduit_adc associatedReset ""
set_interface_property conduit_adc ENABLED true
set_interface_property conduit_adc EXPORT_OF ""
set_interface_property conduit_adc PORT_NAME_MAP ""
set_interface_property conduit_adc CMSIS_SVD_VARIABLES ""
set_interface_property conduit_adc SVD_ADDRESS_GROUP ""

add_interface_port conduit_adc AD_SSTRB1 ad_sstrb1 Input 1
add_interface_port conduit_adc AD_DOUT0 ad_dout0 Input 1
add_interface_port conduit_adc AD_DOUT1 ad_dout1 Input 1
add_interface_port conduit_adc AD_SSTRB0 ad_sstrb0 Input 1
add_interface_port conduit_adc AD_DIN ad_din Output 1


# 
# connection point clock_adc
# 
add_interface clock_adc clock end
set_interface_property clock_adc clockRate 0
set_interface_property clock_adc ENABLED true
set_interface_property clock_adc EXPORT_OF ""
set_interface_property clock_adc PORT_NAME_MAP ""
set_interface_property clock_adc CMSIS_SVD_VARIABLES ""
set_interface_property clock_adc SVD_ADDRESS_GROUP ""

add_interface_port clock_adc clk_adsclk clk Input 1


# 
# connection point conduit_led
# 
add_interface conduit_led conduit end
set_interface_property conduit_led associatedClock clock
set_interface_property conduit_led associatedReset ""
set_interface_property conduit_led ENABLED true
set_interface_property conduit_led EXPORT_OF ""
set_interface_property conduit_led PORT_NAME_MAP ""
set_interface_property conduit_led CMSIS_SVD_VARIABLES ""
set_interface_property conduit_led SVD_ADDRESS_GROUP ""

add_interface_port conduit_led LED led Output 8


# 
# connection point clock_slow
# 
add_interface clock_slow clock end
set_interface_property clock_slow clockRate 0
set_interface_property clock_slow ENABLED true
set_interface_property clock_slow EXPORT_OF ""
set_interface_property clock_slow PORT_NAME_MAP ""
set_interface_property clock_slow CMSIS_SVD_VARIABLES ""
set_interface_property clock_slow SVD_ADDRESS_GROUP ""

add_interface_port clock_slow clk_slowclk clk Input 1

