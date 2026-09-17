onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /UART_TX_tb/CLK
add wave -noupdate /UART_TX_tb/RST
add wave -noupdate /UART_TX_tb/PAR_TYP
add wave -noupdate /UART_TX_tb/PAR_EN
add wave -noupdate /UART_TX_tb/DATA_VALID
add wave -noupdate -radix hexadecimal /UART_TX_tb/P_DATA
add wave -noupdate /UART_TX_tb/Busy
add wave -noupdate -divider {Comparison}
add wave -noupdate -color Orange /UART_TX_tb/expected_tx_bit
add wave -noupdate -color Green /UART_TX_tb/TX_OUT
add wave -noupdate -divider {Internal FSM}
add wave -noupdate /UART_TX_tb/uut/u_fsm/current_state
add wave -noupdate /UART_TX_tb/uut/u_serializer/bit_cnt
add wave -noupdate /UART_TX_tb/uut/u_serializer/shift_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 200
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {400 ns}
