# ============================================================================
# Design Constraints File: cons.tcl
# Target System: SYS_TOP
# ============================================================================

# 1. Master Clock Definitions
create_clock -name REF_CLK  -period 20.0    [get_ports REF_CLK]  ; # 50 MHz
create_clock -name UART_CLK -period 271.267 [get_ports UART_CLK] ; # 3.6864 MHz

# 2. Generated Clock Definitions
create_generated_clock -name ALU_CLK \
    -source [get_ports REF_CLK] \
    -divide_by 1 \
    [get_pins u_clk_gate/GATED_CLK]

create_generated_clock -name TX_CLK \
    -source [get_ports UART_CLK] \
    -divide_by 32 \
    [get_pins u_clk_div/O_div_clk]

# 3. Clock Uncertainty & Transition
set all_clks [get_clocks "REF_CLK UART_CLK ALU_CLK TX_CLK"]

set_clock_uncertainty -setup 0.2 $all_clks
set_clock_uncertainty -hold  0.1 $all_clks
set_clock_transition  0.05 [get_clocks "REF_CLK UART_CLK"]

# 4. Don't Touch Attribute on Clocks
set_dont_touch_network $all_clks

# 5. Asynchronous Clock Grouping
set_clock_groups -asynchronous \
    -group [get_clocks "REF_CLK ALU_CLK"] \
    -group [get_clocks "UART_CLK TX_CLK"]

# 6. Input / Output Delays & Driving Cells
# Input Delay (20% of UART_CLK period = ~54.25 ns)
set_input_delay -max 54.25 -clock UART_CLK [get_ports RX_IN]
set_input_delay -min 1.00  -clock UART_CLK [get_ports RX_IN]

# Output Delays (20% of TX_CLK period = ~1736.1 ns)
set_output_delay -max 1736.1 -clock TX_CLK [get_ports TX_OUT]
set_output_delay -min 10.0   -clock TX_CLK [get_ports TX_OUT]

set_output_delay -max 54.25 -clock UART_CLK [get_ports {PAR_ERR STP_ERR}]
set_output_delay -min 1.00  -clock UART_CLK [get_ports {PAR_ERR STP_ERR}]

# Driving Cell & Load
set_driving_cell -lib_cell BUFX2_TSMC [get_ports RX_IN]
set_load 0.1 [all_outputs]

# 7. Operating Conditions
set_operating_conditions -analysis_type on_chip_variation
