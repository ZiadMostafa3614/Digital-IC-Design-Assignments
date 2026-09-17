vlib work
vmap work

# Compile Standard Cell Library
vlog -sv /home/ICer/Labs/Assignment_GLS_1.0/std_cells/tsmc13_m.v

# Compile Gate-Level Netlist
vlog -sv /home/ICer/Labs/Assignment_GLS_1.0/syn/results/alu8_top_netlist.v

# Compile Testbench
vlog -sv tb.v

# Start Simulation with SDF timing back-annotation
vsim -sdfmax /tb/dut=/home/ICer/Labs/Assignment_GLS_1.0/syn/results/alu8_top.sdf -sdfnoerror work.tb

# Load waveform 
do wave.do

# Run simulation
run -all
