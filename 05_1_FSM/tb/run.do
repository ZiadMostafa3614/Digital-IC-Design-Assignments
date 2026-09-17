vlib work
vlog src/*.v
vsim -c work.Garage_Door_Controller_tb
add wave *
run -all
quit -f
