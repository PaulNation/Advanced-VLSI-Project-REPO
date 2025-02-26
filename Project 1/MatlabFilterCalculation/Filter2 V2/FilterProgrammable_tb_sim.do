onbreak resume
onerror resume
vsim -voptargs=+acc work.FilterProgrammable_tb
add wave sim:/FilterProgrammable_tb/u_FilterProgrammable/clk
add wave sim:/FilterProgrammable_tb/u_FilterProgrammable/clk_enable
add wave sim:/FilterProgrammable_tb/u_FilterProgrammable/reset
add wave sim:/FilterProgrammable_tb/u_FilterProgrammable/filter_in
add wave sim:/FilterProgrammable_tb/u_FilterProgrammable/write_enable
add wave sim:/FilterProgrammable_tb/u_FilterProgrammable/write_done
add wave sim:/FilterProgrammable_tb/u_FilterProgrammable/write_address
add wave sim:/FilterProgrammable_tb/u_FilterProgrammable/coeffs_in
add wave sim:/FilterProgrammable_tb/u_FilterProgrammable/filter_out
add wave sim:/FilterProgrammable_tb/filter_out_ref
run -all
