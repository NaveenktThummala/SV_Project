vlib work

vlog 8088.svp +acc
vlog IOMfsm.sv +acc
vlog IOMfsm_tb.sv +acc

vsim work.top
add wave -r *

run -all