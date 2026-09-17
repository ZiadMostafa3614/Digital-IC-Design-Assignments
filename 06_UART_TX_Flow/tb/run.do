vlib work
vlog -work work rtl/UART_TX.v rtl/uart_fsm.v rtl/uart_serializer.v rtl/uart_parity_calc.v rtl/uart_mux.v tb/UART_TX_tb.v
vsim -voptargs=+acc work.UART_TX_tb
do wave.do
