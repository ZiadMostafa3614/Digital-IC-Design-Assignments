vlib work
vlog -f src_files.f
vlog SYS_TOP_stress_tb.v
vsim -voptargs=+acc work.SYS_TOP_stress_tb
add wave -position insertpoint sim:/SYS_TOP_stress_tb/u_dut/*
run -all
