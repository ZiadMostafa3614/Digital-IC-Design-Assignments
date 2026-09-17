# ============================================================================
# Synthesis Script: syn_script.tcl
# Target Design: SYS_TOP
# ============================================================================

# 1. Setup Search Paths and Synthetic Target Libraries
set sc_dir "../../../lib"
set search_path [list . $sc_dir]

set target_library "scma_tt_1p2v_25c.db"
set link_library   "* $target_library dw_foundation.sldb"

# 2. Define Work Directory & Create Formality SVF File
file mkdir work_syn
define_design_lib WORK -path ./work_syn
set_svf SYS_TOP.svf

# 3. Read All RTL Files
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
analyze -format verilog ../rtl/SYS_TOP/SYS_TOP.v

# 4. Elaborate Top Design
elaborate SYS_TOP
current_design SYS_TOP

# 5. Link & Check Design
link
check_design > ./reports/check_design.rpt

# 6. Apply Constraints
source cons.tcl

# 7. Compile Design
compile_ultra -gate_clock

# 8. Generate Reports
report_area -hierarchy > ./reports/area.rpt
report_timing -delay_type max -max_paths 10 > ./reports/setup_timing.rpt
report_timing -delay_type min -max_paths 10 > ./reports/hold_timing.rpt
report_power > ./reports/power.rpt
report_qor > ./reports/qor.rpt
report_clock_gating > ./reports/clock_gating.rpt

# 9. Save Gate-Level Netlist & SDC
write -format verilog -hierarchy -output ./results/SYS_TOP_netlist.v
write_sdc ./results/SYS_TOP.sdc
write_sdf ./results/SYS_TOP.sdf
write -format ddc -hierarchy -output ./results/SYS_TOP.ddc

set_svf -off
exit
