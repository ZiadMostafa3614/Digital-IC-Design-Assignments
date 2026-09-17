# ============================================================================
# Design For Testability (DFT) Insertion Script: dft_script.tcl
# Target Design: SYS_TOP_dft
# ============================================================================

# 1. Setup Libraries & Working Environment
set sc_dir "../lib"
set search_path [list . $sc_dir]

set target_library "scma_tt_1p2v_25c.db"
set link_library   "* $target_library dw_foundation.sldb"

file mkdir work_dft
define_design_lib WORK -path ./work_dft
set_svf SYS_TOP_dft.svf

# 2. Read All RTL Files including SYS_TOP_dft.v
analyze -format verilog ../rtl/Synchronizers/RST_SYNC.v
analyze -format verilog ../rtl/Synchronizers/DATA_SYNC.v
analyze -format verilog ../rtl/CLK_GATE/CLK_GATE.v
analyze -format verilog ../rtl/RegFile/RegFile.v
analyze -format verilog ../rtl/ALU/ALU.v
analyze -format verilog ../rtl/UART/UART_RX/UART_RX_FSM.v
analyze -format verilog ../rtl/UART/UART_RX/UART_RX_data_sampling.v
analyze -format verilog ../rtl/UART/UART_RX/UART_RX_deserializer.v
analyze -format verilog ../rtl/UART/UART_RX/UART_RX_edge_bit_counter.v
analyze -format verilog ../rtl/UART/UART_RX/UART_RX_parity_check.v
analyze -format verilog ../rtl/UART/UART_RX/UART_RX_strt_check.v
analyze -format verilog ../rtl/UART/UART_RX/UART_RX_stop_check.v
analyze -format verilog ../rtl/UART/UART_RX/UART_RX.v
analyze -format verilog ../rtl/SYS_CTRL/SYS_CTRL.v
analyze -format verilog ../rtl/Clock_Divider/clk_div.v
analyze -format verilog ../rtl/ASYNC_FIFO/fifo_mem.v
analyze -format verilog ../rtl/ASYNC_FIFO/rptr_empty.v
analyze -format verilog ../rtl/ASYNC_FIFO/sync_r2w.v
analyze -format verilog ../rtl/ASYNC_FIFO/sync_w2r.v
analyze -format verilog ../rtl/ASYNC_FIFO/wptr_full.v
analyze -format verilog ../rtl/ASYNC_FIFO/ASYNC_FIFO.v
analyze -format verilog ../rtl/PULSE_GEN/PULSE_GEN.v
analyze -format verilog ../rtl/UART/UART_TX/uart_fsm.v
analyze -format verilog ../rtl/UART/UART_TX/uart_mux.v
analyze -format verilog ../rtl/UART/UART_TX/uart_parity_calc.v
analyze -format verilog ../rtl/UART/UART_TX/uart_serializer.v
analyze -format verilog ../rtl/UART/UART_TX/UART_TX.v
analyze -format verilog ../rtl/SYS_TOP/SYS_TOP_dft.v

# 3. Elaborate Top DFT Design
elaborate SYS_TOP_dft
current_design SYS_TOP_dft
link
check_design > ./reports/check_design_pre_dft.rpt

# 4. Apply Functional & DFT Constraints
# Master Clocks
create_clock -name REF_CLK  -period 20.0    [get_ports REF_CLK]
create_clock -name UART_CLK -period 271.267 [get_ports UART_CLK]
create_clock -name SCAN_CLK -period 100.0   [get_ports scan_clk] ; # Scan Clock

# Generated Clocks
create_generated_clock -name ALU_CLK -source [get_ports REF_CLK] -divide_by 1 [get_pins u_clk_gate/GATED_CLK]
create_generated_clock -name TX_CLK  -source [get_ports UART_CLK] -divide_by 32 [get_pins u_clk_div/O_div_clk]

# Clock Uncertainty & Transition
set all_clks [get_clocks "REF_CLK UART_CLK SCAN_CLK ALU_CLK TX_CLK"]
set_clock_uncertainty -setup 0.2 $all_clks
set_clock_uncertainty -hold  0.1 $all_clks
set_clock_transition  0.05 [get_clocks "REF_CLK UART_CLK SCAN_CLK"]
set_dont_touch_network $all_clks

# Asynchronous Clock Grouping with SCAN_CLK
set_clock_groups -asynchronous \
    -group [get_clocks "REF_CLK ALU_CLK"] \
    -group [get_clocks "UART_CLK TX_CLK"] \
    -group [get_clocks "SCAN_CLK"]

# Delays & Driving Cells on Scan Ports
set_input_delay -max 20.0 -clock SCAN_CLK [get_ports {SI SE}]
set_input_delay -min 1.00 -clock SCAN_CLK [get_ports {SI SE}]

set_output_delay -max 20.0 -clock SCAN_CLK [get_ports SO]
set_output_delay -min 1.00 -clock SCAN_CLK [get_ports SO]

set_driving_cell -lib_cell BUFX2_TSMC [get_ports {SI SE}]
set_load 0.1 [get_ports SO]

# Force Test Mode Active during DFT timing analysis
set_case_analysis 1 [get_ports test_mode]

# 5. DFT Architecture & Signals Setup
set_scan_configuration -chain_count 1
set_dft_signal -type ScanEnable  -port SE
set_dft_signal -type TestMode    -port test_mode
set_dft_signal -type ScanDataIn  -port SI
set_dft_signal -type ScanDataOut -port SO
set_dft_signal -type ScanClock   -port scan_clk -timing [list 45 55]
set_dft_signal -type Reset       -port scan_rst -active_state 0

# 6. Create Test Protocol & Pre-DFT DRC
create_test_protocol
dft_drc > ./reports/pre_dft_drc.rpt

# 7. Preview & Insert DFT Scan Chains
preview_dft -show all > ./reports/preview_dft.rpt
insert_dft

# 8. Post-DFT DRC & Coverage Checks
dft_drc > ./reports/post_dft_drc.rpt

# Compile after scan insertion to resolve routing/timing
compile_ultra -incremental

# 9. Generate Reports
report_dft_coverage > ./reports/dft_coverage.rpt
report_scan_path -chain all > ./reports/scan_path.rpt
report_area -hierarchy > ./reports/area_dft.rpt
report_timing -delay_type max -max_paths 10 > ./reports/setup_timing_dft.rpt
report_timing -delay_type min -max_paths 10 > ./reports/hold_timing_dft.rpt
report_power > ./reports/power_dft.rpt
report_qor > ./reports/qor_dft.rpt

# 10. Save DFT Netlist, SDC, and STIL/SPF Protocol
write -format verilog -hierarchy -output ./results/SYS_TOP_dft_netlist.v
write_sdc ./results/SYS_TOP_dft.sdc
write_test_protocol -output ./results/SYS_TOP_dft.spf

set_svf -off
exit
