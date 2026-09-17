# ModelSim Waveform Configuration for RST_SYNC_tb

quietly WaveActivateNextPane {} 0

# ---- Input Controls ----
add wave -divider "=== INPUT CONTROLS ==="
add wave -color Cyan      -label "CLK"             /RST_SYNC_tb/CLK
add wave -color Orange    -label "RST (Async Input)" /RST_SYNC_tb/RST

# ---- 2-Stage Synchronizer Outputs ----
add wave -divider "=== 2-STAGE SYNCHRONIZER ==="
add wave -radix binary   -color Magenta -label "sync_reg (2-stage)" /RST_SYNC_tb/uut_2stage/sync_reg
add wave -color Lime      -label "SYNC_RST (2-stage)" /RST_SYNC_tb/SYNC_RST_2stage

# ---- 4-Stage Synchronizer Outputs ----
add wave -divider "=== 4-STAGE SYNCHRONIZER ==="
add wave -radix binary   -color Purple  -label "sync_reg (4-stage)" /RST_SYNC_tb/uut_4stage/sync_reg
add wave -color Green     -label "SYNC_RST (4-stage)" /RST_SYNC_tb/SYNC_RST_4stage

run -all
wave zoom full
