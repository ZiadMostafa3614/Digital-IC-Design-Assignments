# Ass_DFT_1.0: Design for Testability (DFT) Scan Insertion

## Overview
Refer to `Ass_Syn_2.0`, after synthesizing `UART_TX`. Insert DFT logic and generate technology-dependent gate-level netlists post-DFT in Verilog format.

---

## Steps & Implementation Plan

### Step 1: RTL Preparation (`UART_TX.v`)
- Add scan ports: `SI`, `SE`, `SO`, `test_mode`, `scan_clk`, `scan_rst`
- Mux design clock with `scan_clk`: `clk_mux = test_mode ? scan_clk : CLK`
- Mux design reset with `scan_rst`: `rst_mux = test_mode ? scan_rst : RST`

### Step 2: Timing & Constraints Setup (`dft/cons.tcl`)
- **Clock Frequency**: 1 MHz ($T = 1000\text{ ns}$)
- **Clock Setup Uncertainty**: 0.025 ns
- **Clock Hold Uncertainty**: 0.01 ns
- **Input Delays**: 30% of clock period ($300\text{ ns}$) on all inputs except `CLK` & `RST`
- **Output Delays**: 30% of clock period ($300\text{ ns}$) on all outputs
- **Driving Cell**: Buffer (`BUFX2M`) for all input ports
- **Output Load**: 0.1 pF on all output ports
- **Dont Touch**: `dont_touch` on `CLK` & `RST`
- **Operating Conditions**: Set using slow (`ss_1p08v_125c`) and fast (`ff_1p32v_m40c`) libraries

### Step 3: DFT Script Commands (`dft/dft_script.tcl`)
1. Read `UART_TX` Verilog files
2. Configure scan chain style (`set_scan_configuration -clock_mixing bimodal -chain_count 1`)
3. Test-Ready Compile (`compile -scan`)
4. Define DFT Signals (`SI`, `SE`, `SO`, `test_mode`, `scan_clk`, `scan_rst`) using `set_dft_signal`
5. Create Test Protocol (`create_test_protocol`)
6. Pre-DFT DRC (`dft_drc -verbose`)
7. Preview DFT (`preview_dft -show scan_summary`)
8. Insert DFT logic (`insert_dft`)
9. Optimize Post-DFT Insertion (`compile -scan -incremental`)
10. Post-DFT DRC (`dft_drc -verbose -coverage_estimate`)
11. Write Post-DFT Verilog netlist (`UART_TX.v`)
12. Generate Power report (`power.rpt`)
13. Generate Area report (`Area.rpt`)
14. Generate Setup analysis report (`setup.rpt`)
15. Generate Hold analysis report (`hold.rpt`)
16. Generate Clocks report (`clocks.rpt`)
17. Generate Constraints report (`constraints.rpt`)
18. Generate Ports report (`ports.rpt`)
19. Generate Coverage report (`dft_drc_post_dft.rpt`)

---

## Required Deliverables
0. `dft_script.tcl`
1. `dft.log`
2. `UART_TX.v` (Post-DFT Netlist)
3. `Area.rpt`
4. `power.rpt`
5. `hold.rpt`
6. `setup.rpt`
7. `clocks.rpt`
8. `constraints.rpt`
9. `ports.rpt`
10. `dft_drc_post_dft.rpt`
