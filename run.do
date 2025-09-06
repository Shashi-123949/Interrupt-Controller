vlib work
vlog intrp_cntrl_tb.v
vsim tb +testcase=LOW_PHERI_WITH_LOW_PRI_VALUE
add wave -r sim:/tb/dut/*
run -all
