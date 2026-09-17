vlib work
vmap work work
vlog -f src_files.f
vsim -c -voptargs=+acc work.SYS_TOP_stress_tb
run -all
quit
