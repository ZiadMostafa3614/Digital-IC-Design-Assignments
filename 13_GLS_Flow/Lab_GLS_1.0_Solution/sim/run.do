vlib work
vmap work

# Compile Standard Cell Library
vlog -sv /home/ICer/Labs/Lab_GLS_1.0/std_cells/tsmc13_m.v

# Compile Gate-Level Netlist
vlog -sv /home/ICer/Labs/Lab_GLS_1.0/syn/results_mul/alu8_top_netlist.v

# Compile Testbench
vlog -sv tb.v

# Start Simulation
vsim -sdfmax /tb/dut=/home/ICer/Labs/Lab_GLS_1.0/syn/results_mul/alu8_top.sdf -sdfnoerror work.tb

# Load waveform 
do wave.do

# Run
run -all
