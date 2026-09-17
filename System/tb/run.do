vlib work
vlog -f src_files.f
vsim -voptargs=+acc work.SYS_TOP_tb
do wave.do
run -all

