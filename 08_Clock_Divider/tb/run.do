vlib work
vlog -work work ClkDiv.v ClkDiv_tb.v
vsim -voptargs=+acc work.ClkDiv_tb
do wave.do
run -all
