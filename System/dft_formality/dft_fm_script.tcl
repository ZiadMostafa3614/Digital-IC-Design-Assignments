# ============================================================================
# Formality Post-DFT Formal Equivalence Verification Script
# Target Design: SYS_TOP_dft
# ============================================================================

# 1. Define Target Technology Library & Read SVF File
set syn_lib "../lib/scma_tt_1p2v_25c.db"
read_sdb $syn_lib

set_svf ../dft/SYS_TOP_dft.svf

# 2. Read Reference Design (RTL or Post-Synthesis Netlist)
read_verilog -container Ref \
    { \
        ../rtl/Synchronizers/RST_SYNC.v \
        ../rtl/Synchronizers/DATA_SYNC.v \
        ../rtl/CLK_GATE/CLK_GATE.v \
        ../rtl/RegFile/RegFile.v \
        ../rtl/ALU/ALU.v \
        ../rtl/UART/UART_RX/UART_RX_FSM.v \
        ../rtl/UART/UART_RX/UART_RX_data_sampling.v \
        ../rtl/UART/UART_RX/UART_RX_deserializer.v \
        ../rtl/UART/UART_RX/UART_RX_edge_bit_counter.v \
        ../rtl/UART/UART_RX/UART_RX_parity_check.v \
        ../rtl/UART/UART_RX/UART_RX_strt_check.v \
        ../rtl/UART/UART_RX/UART_RX_stop_check.v \
        ../rtl/UART/UART_RX/UART_RX.v \
        ../rtl/SYS_CTRL/SYS_CTRL.v \
        ../rtl/Clock_Divider/clk_div.v \
        ../rtl/ASYNC_FIFO/fifo_mem.v \
        ../rtl/ASYNC_FIFO/rptr_empty.v \
        ../rtl/ASYNC_FIFO/sync_r2w.v \
        ../rtl/ASYNC_FIFO/sync_w2r.v \
        ../rtl/ASYNC_FIFO/wptr_full.v \
        ../rtl/ASYNC_FIFO/ASYNC_FIFO.v \
        ../rtl/PULSE_GEN/PULSE_GEN.v \
        ../rtl/UART/UART_TX/uart_fsm.v \
        ../rtl/UART/UART_TX/uart_mux.v \
        ../rtl/UART/UART_TX/uart_parity_calc.v \
        ../rtl/UART/UART_TX/uart_serializer.v \
        ../rtl/UART/UART_TX/UART_TX.v \
        ../rtl/SYS_TOP/SYS_TOP_dft.v \
    }

set_top r:/WORK/SYS_TOP_dft

# 3. Read Implementation Design (Post-DFT Netlist)
read_verilog -container Imp -netlist ../dft/results/SYS_TOP_dft_netlist.v
set_top i:/WORK/SYS_TOP_dft

# 4. Set Constants for Functional Equivalence Mode (test_mode=0, SE=0)
set_constant r:/WORK/SYS_TOP_dft/test_mode 0
set_constant i:/WORK/SYS_TOP_dft/test_mode 0
set_constant r:/WORK/SYS_TOP_dft/SE 0
set_constant i:/WORK/SYS_TOP_dft/SE 0

# 5. Match Points and Verify
match
verify > dft_fm_post_dft.log

# 6. Output Verification Status Report
if {[get_status] == "SUCCEEDED"} {
    echo "=========================================================="
    echo " FORMALITY POST-DFT EQUIVALENCE CHECK PASSED!            "
    echo "=========================================================="
} else {
    echo "=========================================================="
    echo " FORMALITY POST-DFT EQUIVALENCE CHECK FAILED!            "
    echo "=========================================================="
}

exit
