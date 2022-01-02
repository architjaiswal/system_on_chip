# Experimental cleanup procedure to minimize student file packages

rm db -r
rm hps_isw_handoff -r
rm incremental_db -r
rm simulation -r
rm soc_system -r
rm stamp -r
rm .qsys_edit -r

rm c5_pin_model_dump.txt
rm hps_sdram_p0_summary.csv
rm hps_clock_info.xml
rm Makefile
rm soc_system.asm.rpt
rm soc_system.eda.rpt
rm soc_system.map.summary

rm soc_system.done
rm soc_system.dtb
rm soc_system.dts

# Fitter
rm soc_system.fit.rpt
rm soc_system.fit.smsg
rm soc_system.fit.summary

rm soc_system.flow.rpt

# IP regen
rm soc_system.ipregen.rpt

rm soc_system.jdi

# Map
rm soc_system.map.rpt
rm soc_system.map.smsg
rm soc_system.map.summary
rm soc_system.pin
rm soc_system.sld
rm soc_system.sopcinfo
rm soc_system.sof
rm soc_system.srf
rm soc_system.smsg
rm soc_system.sta.rpt
rm soc_system.sta.smsg
rm soc_system.sta.summary
rm soc_system_nativelink_simulation.rpt

# must not delete list
# soc_system.qsf 	soc chip will be unknown




