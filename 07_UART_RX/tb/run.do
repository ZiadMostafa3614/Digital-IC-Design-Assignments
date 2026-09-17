vlib work
vlog data_sampling.v edge_bit_counter.v deserializer.v strt_check.v parity_check.v stp_check.v uart_rx_fsm.v UART_RX.v UART_RX_tb.v
vsim -voptargs=+acc work.UART_RX_tb
do wave.do
run -all
