vlib work
vlog -work work DATA_SYNC.v DATA_SYNC_tb.v
vsim -voptargs=+acc work.DATA_SYNC_tb
do wave.do
