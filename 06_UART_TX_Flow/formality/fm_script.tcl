###################################################################
########################### Variables #############################
###################################################################

################## Design Compiler Library Files #setup ######################

puts "###########################################"
puts "#      #setting Design Libraries           #"
puts "###########################################"

#Add the path of the libraries to the search_path variable
lappend search_path /home/ICer/Labs/UART_TX/std_cells
lappend search_path /home/ICer/Labs/UART_TX/rtl
lappend search_path /home/ICer/Labs/UART_TX/syn

set SSLIB "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c.db"
set TTLIB "scmetro_tsmc_cl013g_rvt_tt_1p2v_25c.db"
set FFLIB "scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c.db"


###################################################################
############################ Guidance #############################
###################################################################

# Synopsys setup variable
set synopsys_auto_setup true

# Formality Setup File
set_svf UART_TX.svf

###################################################################
###################### Reference Container ########################
###################################################################

# Read Reference Design Verilog Files
read_verilog -container Ref ../rtl/uart_serializer.v
read_verilog -container Ref ../rtl/uart_parity_calc.v
read_verilog -container Ref ../rtl/uart_mux.v
read_verilog -container Ref ../rtl/uart_fsm.v
read_verilog -container Ref ../rtl/UART_TX.v

# Read Reference technology libraries
read_db -container Ref [list $SSLIB $TTLIB $FFLIB]

# set the top Reference Design 
set_reference_design UART_TX
set_top UART_TX


###################################################################
#################### Implementation Container #####################
###################################################################

# Read Implementation Design Files
read_verilog -container Imp -netlist UART_TX_netlist.v

# Read Implementation technology libraries
read_db -container Imp [list $SSLIB $TTLIB $FFLIB]

# set the top Implementation Design
set_implementation_design UART_TX
set_top UART_TX

###################### Matching Compare points ####################

match

######################### Run Verification ########################

set successful [verify]
if {!$successful} {
diagnose
analyze_points -failing
}

########################### Reporting ############################# 
report_passing_points  > "passing_points.rpt"
report_failing_points  > "failing_points.rpt"
report_aborted_points  > "aborted_points.rpt"
report_unverified_points > "unverified_points.rpt"


start_gui

