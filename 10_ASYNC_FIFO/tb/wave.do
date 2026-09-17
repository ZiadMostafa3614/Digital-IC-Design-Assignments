# ModelSim Waveform Configuration for ASYNC_FIFO_tb

quietly WaveActivateNextPane {} 0

# ---- Write Domain ----
add wave -divider "=== WRITE DOMAIN (100 MHz) ==="
add wave -color Cyan      -label "W_CLK"        /ASYNC_FIFO_tb/W_CLK
add wave -color Orange    -label "W_RST"        /ASYNC_FIFO_tb/W_RST
add wave -color Yellow    -label "W_INC"        /ASYNC_FIFO_tb/W_INC
add wave -radix hexadecimal -color White -label "WR_DATA" /ASYNC_FIFO_tb/WR_DATA
add wave -color Red       -label "FULL"         /ASYNC_FIFO_tb/FULL

# ---- Read Domain ----
add wave -divider "=== READ DOMAIN (40 MHz) ==="
add wave -color Cyan      -label "R_CLK"        /ASYNC_FIFO_tb/R_CLK
add wave -color Orange    -label "R_RST"        /ASYNC_FIFO_tb/R_RST
add wave -color Yellow    -label "R_INC"        /ASYNC_FIFO_tb/R_INC
add wave -radix hexadecimal -color Green -label "RD_DATA" /ASYNC_FIFO_tb/RD_DATA
add wave -color Lime      -label "EMPTY"        /ASYNC_FIFO_tb/EMPTY

# ---- Internal Pointers & Addresses ----
add wave -divider "=== INTERNAL POINTERS ==="
add wave -radix unsigned -color Magenta -label "waddr" /ASYNC_FIFO_tb/uut/waddr
add wave -radix unsigned -color Magenta -label "raddr" /ASYNC_FIFO_tb/uut/raddr
add wave -radix binary   -color Gold    -label "wptr (Gray)" /ASYNC_FIFO_tb/uut/wptr
add wave -radix binary   -color Gold    -label "rptr (Gray)" /ASYNC_FIFO_tb/uut/rptr
add wave -radix binary   -color Purple  -label "wq2_rptr" /ASYNC_FIFO_tb/uut/wq2_rptr
add wave -radix binary   -color Purple  -label "rq2_wptr" /ASYNC_FIFO_tb/uut/rq2_wptr

run -all
wave zoom full
