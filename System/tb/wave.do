onerror {resume}
quietly WaveActivateNextPane {} 0

# -----------------------------------------------------------------------------
# 1. Clocks & Resets
# -----------------------------------------------------------------------------
add wave -noupdate -divider -height 25 { Clocks & Synchronized Resets }
add wave -noupdate -color Cyan        -radix binary sim:/SYS_TOP_tb/u_dut/REF_CLK
add wave -noupdate -color Cyan        -radix binary sim:/SYS_TOP_tb/u_dut/UART_CLK
add wave -noupdate -color Magenta     -radix binary sim:/SYS_TOP_tb/u_dut/RST
add wave -noupdate -color Magenta     -radix binary sim:/SYS_TOP_tb/u_dut/rst_sync_1
add wave -noupdate -color Magenta     -radix binary sim:/SYS_TOP_tb/u_dut/rst_sync_2
add wave -noupdate -color LightBlue   -radix binary sim:/SYS_TOP_tb/u_dut/gated_clk
add wave -noupdate -color LightBlue   -radix binary sim:/SYS_TOP_tb/u_dut/tx_clk

# -----------------------------------------------------------------------------
# 2. UART RX Domain
# -----------------------------------------------------------------------------
add wave -noupdate -divider -height 25 { UART RX (Input Domain) }
add wave -noupdate -color Yellow      -radix binary sim:/SYS_TOP_tb/u_dut/RX_IN
add wave -noupdate -color Orange      -radix decimal sim:/SYS_TOP_tb/u_dut/u_uart_rx/U0_FSM/current_state
add wave -noupdate -color Gold        -radix hex    sim:/SYS_TOP_tb/u_dut/rx_p_data_unsync
add wave -noupdate -color Gold        -radix binary sim:/SYS_TOP_tb/u_dut/rx_d_vld_unsync
add wave -noupdate -color Red         -radix binary sim:/SYS_TOP_tb/u_dut/PAR_ERR
add wave -noupdate -color Red         -radix binary sim:/SYS_TOP_tb/u_dut/STP_ERR

# -----------------------------------------------------------------------------
# 3. Data Synchronizer (CDC Crossing)
# -----------------------------------------------------------------------------
add wave -noupdate -divider -height 25 { Data Synchronizer (UART -> REF CDC) }
add wave -noupdate -color Green       -radix hex    sim:/SYS_TOP_tb/u_dut/rx_p_data_sync
add wave -noupdate -color Green       -radix binary sim:/SYS_TOP_tb/u_dut/rx_d_vld_sync

# -----------------------------------------------------------------------------
# 4. System Controller (FSM & Control Signals)
# -----------------------------------------------------------------------------
add wave -noupdate -divider -height 25 { System Controller (SYS_CTRL FSM) }
add wave -noupdate -color Orange      -radix decimal sim:/SYS_TOP_tb/u_dut/u_sys_ctrl/current_state
add wave -noupdate -color Lime        -radix binary sim:/SYS_TOP_tb/u_dut/u_sys_ctrl/rx_pulse
add wave -noupdate -color White       -radix hex    sim:/SYS_TOP_tb/u_dut/address
add wave -noupdate -color White       -radix binary sim:/SYS_TOP_tb/u_dut/wr_en
add wave -noupdate -color White       -radix binary sim:/SYS_TOP_tb/u_dut/rd_en
add wave -noupdate -color White       -radix hex    sim:/SYS_TOP_tb/u_dut/wr_data
add wave -noupdate -color White       -radix hex    sim:/SYS_TOP_tb/u_dut/rd_data
add wave -noupdate -color White       -radix binary sim:/SYS_TOP_tb/u_dut/rd_data_valid

# -----------------------------------------------------------------------------
# 5. ALU Unit
# -----------------------------------------------------------------------------
add wave -noupdate -divider -height 25 { ALU Unit (Gated Clock) }
add wave -noupdate -color Purple      -radix hex    sim:/SYS_TOP_tb/u_dut/operand_a
add wave -noupdate -color Purple      -radix hex    sim:/SYS_TOP_tb/u_dut/operand_b
add wave -noupdate -color Purple      -radix hex    sim:/SYS_TOP_tb/u_dut/alu_fun
add wave -noupdate -color Purple      -radix binary sim:/SYS_TOP_tb/u_dut/alu_en
add wave -noupdate -color Violet      -radix hex    sim:/SYS_TOP_tb/u_dut/alu_out
add wave -noupdate -color Violet      -radix binary sim:/SYS_TOP_tb/u_dut/alu_out_valid

# -----------------------------------------------------------------------------
# 6. ASYNC FIFO (REF -> TX_CLK CDC)
# -----------------------------------------------------------------------------
add wave -noupdate -divider -height 25 { Asynchronous FIFO (REF -> TX CDC) }
add wave -noupdate -color Cyan        -radix hex    sim:/SYS_TOP_tb/u_dut/tx_p_data_fifo
add wave -noupdate -color Cyan        -radix binary sim:/SYS_TOP_tb/u_dut/tx_d_vld_fifo
add wave -noupdate -color Red         -radix binary sim:/SYS_TOP_tb/u_dut/fifo_full
add wave -noupdate -color Yellow      -radix binary sim:/SYS_TOP_tb/u_dut/fifo_empty
add wave -noupdate -color Green       -radix binary sim:/SYS_TOP_tb/u_dut/fifo_r_inc
add wave -noupdate -color Cyan        -radix hex    sim:/SYS_TOP_tb/u_dut/tx_p_data_uart

# -----------------------------------------------------------------------------
# 7. UART TX Domain (Output)
# -----------------------------------------------------------------------------
add wave -noupdate -divider -height 25 { UART TX (Output Domain) }
add wave -noupdate -color Orange      -radix decimal sim:/SYS_TOP_tb/u_dut/u_uart_tx/u_fsm/current_state
add wave -noupdate -color Yellow      -radix binary sim:/SYS_TOP_tb/u_dut/uart_tx_busy
add wave -noupdate -color Green       -radix binary sim:/SYS_TOP_tb/u_dut/TX_OUT

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 250
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
