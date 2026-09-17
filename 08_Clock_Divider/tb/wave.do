# ModelSim Waveform Configuration for ClkDiv_tb

quietly WaveActivateNextPane {} 0

# ---- Inputs ----
add wave -divider "=== INPUTS ==="
add wave -color Cyan      -label "i_ref_clk"   /ClkDiv_tb/i_ref_clk
add wave -color Orange    -label "i_rst_n"     /ClkDiv_tb/i_rst_n
add wave -color Yellow    -label "i_clk_en"    /ClkDiv_tb/i_clk_en
add wave -radix unsigned -color White -label "i_div_ratio" /ClkDiv_tb/i_div_ratio

# ---- Controls & Flags ----
add wave -divider "=== CONTROL & FLAGS ==="
add wave -color Gold      -label "clk_div_en"  /ClkDiv_tb/uut/clk_div_en
add wave -color Gold      -label "is_odd"      /ClkDiv_tb/uut/is_odd

# ---- Internal Counters & Signals ----
add wave -divider "=== INTERNAL SIGNALS ==="
add wave -radix unsigned -color LightBlue -label "pos_cnt" /ClkDiv_tb/uut/pos_cnt
add wave -color Magenta   -label "p_clk"       /ClkDiv_tb/uut/p_clk
add wave -color Magenta   -label "n_clk"       /ClkDiv_tb/uut/n_clk
add wave -color Purple    -label "divided_clk" /ClkDiv_tb/uut/divided_clk

# ---- Output ----
add wave -divider "=== OUTPUT ==="
add wave -color Green     -label "o_div_clk"   /ClkDiv_tb/o_div_clk

run -all
wave zoom full
