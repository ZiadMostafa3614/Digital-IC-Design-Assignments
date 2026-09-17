# ModelSim Waveform Configuration for DATA_SYNC_tb

quietly WaveActivateNextPane {} 0

# ---- Source Domain ----
add wave -divider "=== SOURCE DOMAIN (tx_clk) ==="
add wave -color Cyan      -label "tx_clk"       /DATA_SYNC_tb/tx_clk
add wave -color Yellow    -label "bus_enable"   /DATA_SYNC_tb/bus_enable
add wave -radix hexadecimal -color White -label "unsync_bus" /DATA_SYNC_tb/unsync_bus

# ---- Destination Domain Controls ----
add wave -divider "=== DESTINATION DOMAIN (CLK) ==="
add wave -color Cyan      -label "CLK"          /DATA_SYNC_tb/CLK
add wave -color Orange    -label "RST"          /DATA_SYNC_tb/RST

# ---- Internal Synchronizer Signals ----
add wave -divider "=== INTERNAL SIGNALS ==="
add wave -radix binary -color Magenta -label "sync_stage_reg" /DATA_SYNC_tb/uut/sync_stage_reg
add wave -color Gold      -label "enable_flop"  /DATA_SYNC_tb/uut/enable_flop
add wave -color Purple    -label "generated_pulse" /DATA_SYNC_tb/uut/generated_pulse

# ---- Destination Domain Outputs ----
add wave -divider "=== DESTINATION OUTPUTS ==="
add wave -radix hexadecimal -color Green -label "sync_bus" /DATA_SYNC_tb/sync_bus
add wave -color Lime      -label "enable_pulse" /DATA_SYNC_tb/enable_pulse

run -all
wave zoom full
