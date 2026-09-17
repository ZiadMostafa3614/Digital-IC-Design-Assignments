set_app_var power_enable_analysis true
set_app_var power_analysis_mode time_based
set power_vcd_time_unit 1ns

set report_dir /home/ICer/Labs/Lab_GLS_1.0/pt/report
file mkdir $report_dir

set Out_report Mult_pw
#------------------------------------------------------------------------------
# Libraries
#------------------------------------------------------------------------------
lappend search_path /home/ICer/Labs/Lab_GLS_1.0/std_cells

set TTLIB   scmetro_tsmc_cl013g_rvt_ss_1p08v_125c.db
set SSLIB   scmetro_tsmc_cl013g_rvt_tt_1p2v_25c.db
set FFLIB   scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c.db

set target_library [list $TTLIB $SSLIB $FFLIB]
set link_library   [list * $TTLIB $SSLIB $FFLIB]

#------------------------------------------------------------------------------
# Read Design Files
#------------------------------------------------------------------------------

# Read Verilog Netlist
read_verilog /home/ICer/Labs/Lab_GLS_1.0/syn/results_mul/alu8_top_netlist.v

current_design alu8_top

link_design

# Read SDC File
read_sdc /home/ICer/Labs/Lab_GLS_1.0/syn/results_mul/alu8_top.sdc

# Read SDF File
read_sdf /home/ICer/Labs/Lab_GLS_1.0/syn/results_mul/alu8_top.sdf

#------------------------------------------------------------------------------
# Read Switching Activity
#------------------------------------------------------------------------------
read_vcd -strip_path tb/dut /home/ICer/Labs/Lab_GLS_1.0/sim/VCD/Mult.vcd

update_power

#------------------------------------------------------------------------------
# Reports
#------------------------------------------------------------------------------
report_power                              > $report_dir/$Out_report.rpt

echo "----------------------------------------"
echo "PrimeTime PX Analysis Finished"
echo "Reports saved in:"
echo "$report_dir"
echo "----------------------------------------"
#start_gui
exit
