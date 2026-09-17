# UART_RX Wave Script
quietly WaveActivateNextPane {} 0

# ---- Inputs ----
add wave -divider "=== INPUTS ==="
add wave -color Cyan   -label "CLK"      /UART_RX_tb/CLK
add wave -color Orange -label "RST"      /UART_RX_tb/RST
add wave -color Yellow -label "RX_IN"    /UART_RX_tb/RX_IN
add wave -color White  -label "PAR_EN"   /UART_RX_tb/PAR_EN
add wave -color White  -label "PAR_TYP"  /UART_RX_tb/PAR_TYP
add wave -color White  -label "Prescale" -radix unsigned /UART_RX_tb/Prescale

# ---- Outputs ----
add wave -divider "=== OUTPUTS ==="
add wave -color Green -label "P_DATA"       -radix hexadecimal /UART_RX_tb/P_DATA
add wave -color Green -label "data_valid"   /UART_RX_tb/data_valid
add wave -color Red   -label "Parity_Error" /UART_RX_tb/Parity_Error
add wave -color Red   -label "Stop_Error"   /UART_RX_tb/Stop_Error

# ---- FSM ----
add wave -divider "=== FSM ==="
add wave -color Magenta   -label "FSM State"   -radix symbolic /UART_RX_tb/uut/u_fsm/current_state
add wave -color LightBlue -label "sampled_bit" /UART_RX_tb/uut/sampled_bit
add wave -color LightBlue -label "edge_cnt"    -radix unsigned /UART_RX_tb/uut/edge_cnt
add wave -color LightBlue -label "bit_cnt"     -radix unsigned /UART_RX_tb/uut/bit_cnt

run -all
wave zoom full