project -new LowpassFilter.prj
add_file FilterCoef.v
add_file FilterTapSystolicPreAddWvlIn.v
add_file subFilter.v
add_file Filter.v
add_file dsphdl_FIRFilter.v
add_file LowpassFilter.v
set_option -technology VIRTEX4
set_option -part XC4VSX35
set_option -synthesis_onoff_pragma 0
set_option -frequency auto
project -run synthesis
