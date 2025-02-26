onbreak resume
onerror resume
vsim -voptargs=+acc work.LowpassFilter_tb

add wave sim:/LowpassFilter_tb/u_LowpassFilter/clk
add wave sim:/LowpassFilter_tb/u_LowpassFilter/reset
add wave sim:/LowpassFilter_tb/u_LowpassFilter/clk_enable
add wave sim:/LowpassFilter_tb/u_LowpassFilter/dataIn
add wave sim:/LowpassFilter_tb/u_LowpassFilter/validIn
add wave sim:/LowpassFilter_tb/u_LowpassFilter/ce_out
add wave sim:/LowpassFilter_tb/u_LowpassFilter/dataOut
add wave sim:/LowpassFilter_tb/dataOut_ref
add wave sim:/LowpassFilter_tb/u_LowpassFilter/validOut
add wave sim:/LowpassFilter_tb/validOut_ref
set ::dut_prefix /LowpassFilter_tb/u_
do LowpassFilter_noresetinitscript.tcl
run -all
