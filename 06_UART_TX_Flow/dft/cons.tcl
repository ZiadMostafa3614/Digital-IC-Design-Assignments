####################################################################################
# Constraints (DFT Flow)
# ----------------------------------------------------------------------------
#
# 0. Design Compiler variables
# 1. Master Clock Definitions
# 2. Generated Clock Definitions
# 3. Clock Uncertainties
# 4. Clock Latencies 
# 5. Clock Relationships
# 6. Set input/output delay on ports
# 7. Driving cells
# 8. Output load
# 9. Case Analysis
# ----------------------------------------------------------------------------

#################################################################################### 
           #########################################################
                  #### Section 0 : DC Variables ####
           #########################################################
#################################################################################### 

# Prevent assign statements in the generated netlist
set_fix_multiple_port_nets -all -buffer_constants -feedthroughs

#################################################################################### 
           #########################################################
                  #### Section 1 : Clock Definition ####
           #########################################################
#################################################################################### 

#################################### FUNC Clock ####################################
set CLK_NAME TX_CLK
set CLK_PER 1000.0
set CLK_SETUP_SKEW 0.025
set CLK_HOLD_SKEW 0.01
set CLK_LAT 0
set CLK_RISE 0.1
set CLK_FALL 0.1

create_clock -name $CLK_NAME -period $CLK_PER -waveform "0 [expr $CLK_PER/2]" [get_ports CLK]
set_clock_uncertainty -setup $CLK_SETUP_SKEW [get_clocks $CLK_NAME]
set_clock_uncertainty -hold $CLK_HOLD_SKEW  [get_clocks $CLK_NAME]
set_clock_transition -rise $CLK_RISE  [get_clocks $CLK_NAME]
set_clock_transition -fall $CLK_FALL  [get_clocks $CLK_NAME]
set_clock_latency $CLK_LAT [get_clocks $CLK_NAME]

#################################### SCAN Clock ####################################
set DFT_CLK_NAME SCAN_CLK
set DFT_CLK_PER 1000.0
set DFT_CLK_SETUP_SKEW 0.025
set DFT_CLK_HOLD_SKEW 0.01
set DFT_CLK_LAT 0
set DFT_CLK_RISE 0.1
set DFT_CLK_FALL 0.1

create_clock -name $DFT_CLK_NAME -period $DFT_CLK_PER -waveform "0 [expr $DFT_CLK_PER/2]" [get_ports scan_clk]
set_clock_uncertainty -setup $DFT_CLK_SETUP_SKEW [get_clocks $DFT_CLK_NAME]
set_clock_uncertainty -hold $DFT_CLK_HOLD_SKEW  [get_clocks $DFT_CLK_NAME]
set_clock_transition -rise $DFT_CLK_RISE  [get_clocks $DFT_CLK_NAME]
set_clock_transition -fall $DFT_CLK_FALL  [get_clocks $DFT_CLK_NAME]
set_clock_latency $DFT_CLK_LAT [get_clocks $DFT_CLK_NAME]

set_dont_touch_network [get_clocks "$CLK_NAME $DFT_CLK_NAME"]
set_dont_touch [get_ports RST] true

####################################################################################
           #########################################################
                  #### Section 2 : Clocks Relationships ####
           #########################################################
####################################################################################

set_clock_groups -logically_exclusive -group [get_clocks "$CLK_NAME"] \
                                      -group [get_clocks "$DFT_CLK_NAME"]

####################################################################################
           #########################################################
             #### Section 3 : Set input/output delay on ports ####
           #########################################################
####################################################################################

set in_delay  [expr 0.3 * $CLK_PER]
set out_delay [expr 0.3 * $CLK_PER]

# Constrain Input Paths (all inputs except CLK & RST)
set all_inputs_no_clk_rst [remove_from_collection [all_inputs] [get_ports {CLK RST}]]
set_input_delay $in_delay -clock $CLK_NAME $all_inputs_no_clk_rst

# Constrain Output Paths (all output ports)
set_output_delay $out_delay -clock $CLK_NAME [all_outputs]

####################################################################################
           #########################################################
                  #### Section 4 : Driving cells ####
           #########################################################
####################################################################################

set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [all_inputs]

####################################################################################
           #########################################################
                  #### Section 5 : Output load ####
           #########################################################
####################################################################################

set_load 0.1 [all_outputs]

####################################################################################
           #########################################################
                 #### Section 6 : Operating Conditions ####
           #########################################################
####################################################################################

set_operating_conditions -min_library "scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c" \
                         -min "scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c" \
                         -max_library "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c" \
                         -max "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c"

####################################################################################
           #########################################################
                  #### Section 7 : Wireload Model ####
           #########################################################
####################################################################################

set_wire_load_model -name tsmc13_wl30 -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c

####################################################################################
           #########################################################
                  #### Section 8 : Case Analysis ####
           #########################################################
####################################################################################

set_case_analysis 0 [get_port test_mode]

####################################################################################

