vlib work
vlog -work work rtl/RST_SYNC.v tb/RST_SYNC_tb.v
vsim -voptargs=+acc work.RST_SYNC_tb
do wave.do
