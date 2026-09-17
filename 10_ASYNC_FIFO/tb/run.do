vlib work
vlog -work work rtl/FIFO_MEM_CNTRL.v rtl/DF_SYNC.v rtl/FIFO_WR.v rtl/FIFO_RD.v rtl/ASYNC_FIFO.v tb/ASYNC_FIFO_tb.v
vsim -voptargs=+acc work.ASYNC_FIFO_tb
do wave.do
