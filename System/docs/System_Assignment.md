# System 

You have to go through the digital backend flow including: - 

- Synthesis 

- Formality post-synthesis 

- DFT 

- Formality post-dft 

## <u>Steps: -</u> 

1. Create Projects folder inside IC directory 

2. Copy System folder from your computer into the virtual machine inside Projects folder  Synthesis Stage: - 

      - i.Add the following constraints in cons.tcl file. 

      - `O` Create your master clocks 

         - REF_CLK (50 MHz) 

         - UART_CLK (3.686 MHz) 

      - `O` Create your generated clocks 

         - ALU_CLK (master_clk = REF_CLK , div_ratio = 1) 

         - RX_CLK (master_clk = UART_CLK , div_ratio = 1) 

         - TX_CLK (master_clk = UART_CLK , div_ratio = 32) 

      - `O` Create a clock uncertainty with 0.2 ns for setup (master & generated clocks) `o` Create a clock uncertainty with 0.1 ns for hold (master & generated clocks) `o` Create a clock transition with 0.05 ns for all master clocks 

      - Set_dont_touch on all the master and generated clocks 

      - `o` Clock Grouping 

      - Input delays on all input ports except (CLK & RST) with 20% clock period 

      - output delays on all output ports with 20% clock period 

      - Add Buffer driving cell for all input ports except (CLK & RST) 

      - Add load of 0.1 pf on all output ports 

      - Set operation condition using slow and fast libraries 

      - ii.Run synthesis and check the followings 

      - No Errors, loops and latches in syn.log file 

      - Check Setup timing analysis report for Violating paths 

      - Check Hold timing analysis report for Violating paths 

   - Formality post-synthesis Stage: - 

      - i. Run Formality and check it is succeeded with no failing points 

###  DFT Stage: - 

- i.Define a new file with name SYS_TOP_dft.v inside SYS_TOP folder 

ii.Do the rtl preparation in SYS_TOP_dft.v including:- 

1. Adding scan ports with the exact names as shown: - 



<!-- Start of picture text -->
module SYS_TOP # ( parameter DATAWIDTH = 8 , RF_ADDR = 4 , NUM_OF_CHAINS = 3)<br>(<br>input wire ‘scan_clk ,<br>input wire scan_rst ,<br>input wire test_mode |<br>input wire SE,<br>input wire [NUM_OF_CHAINS-1:0] sI,<br>output wire NUM_OF CHAINS-1:0 Fie)<br>input wire RST_N,<br>input wire UART_CLK,<br>input wire REF _CLK,<br>input wire UART_RX_IN,<br>output wire UART_TX_0,<br>output wire parity error,<br>output wire framing_error<br>Ve<br><!-- End of picture text -->

- 2.adding Muxs on clocks and resets ports 

iii. Add the following constraints inside the cons.tcl 

1. Add scan clock constraint using create_clock 

2. Add SCAN_CLK group in clock grouping command 

3. Input delays on scan input ports (SI,SE) with 20% clock period 

4. output delays on scan output ports (SO) with 20% clock period 

5. Add Buffer driving cell on scan input ports (SI,SE) 

6. Add load of 0.1 pf on scan output ports (SO) 

7. Add set_case_analysis 1 [get_port test_mode] command to run timing analysis using scan clock 

iv. Add all the dft sections: - 

         - 1.Archirecture Scan Chains 

         - 2.Define DFT Signals 

         - 3.Create Test Protocol 

         - 4.Pre-DFT Design Rule Checking 

         - 5.Preview DFT 

         - 6.Insert DFT 

         - 7.Design Rule Checking post dft insertion 

   - v. Run dft and check the followings 

      - No Errors, loops and latches in dft.log file 

      - Check Setup timing analysis report for Violating paths 

      - Check Hold timing analysis report for Violating paths 

      - Check dft coverage > 98 % 

- Formality post-dft Stage: - 

i. Run Formality and check it is succeeded with no failing points 

