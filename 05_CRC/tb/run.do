vlib work
vlog src/*.v
vsim -c work.LFSR_tb
add wave *
run -all
quit -f
