# **Assignment_GLS_1.0** 

### **1. Synthesis** 

- Refer to Lab_GLS_1.0. Set the generate variable to 0 in _alu8_top.v_ to instantiate the **Adder** module. 

- Generates key files for GLS: 

   - _alu8_top_netlist.v (Gate-level netlist)_ 

   - _alu8_top.sdc (Design constraints)_ 

   - _alu8_top.sdf (Timing and delay information)_ 

### **2. Gate-Level Simulation (GLS)** 

- **TB Setup:** Comment out multiplier testcases, uncomment **Adder** testcases, and dump _Adder.vcd._ 

- **Required Files:** 

   - _Gate-level netlist (alu8_top_netlist.v),_ 

   - _alu8_top.sdf,_ 

   - _Testbench , and_ 

   - _standard cell model (Lib.v)._ 

####  **Run Command (QuestaSim):** 

### **_vsim -do run.do &_** 

### **3. Power Analysis** 

- Run PrimeTime power analysis using the dumped Adder.vcd to estimate dynamic power consumption. 

- **Required Files:** 

   - _Adder.vcd,_ 

   - _alu8_top_netlist.v,_ 

   - _alu8_top.sdf,_ 

   - _alu8_top.sdc, and Lib_ 

####  **Run Command (PrimeTime):** 

## **_pt_shell -f PT.tcl | tee pw.log_** 

### **4. Deliverables:** 

####  **Synthesis results** : 

- _alu8_top_Netlist.v_ 

- _alu8_top_Netlist.ddc_ 

- _alu8_top.sdc_ 

- _alu8_top.sdf_ 

####  **Synthesis reports:** 

- _Setup.rpt_ 

- _Hold.rpt_ 

- _Constraints.rpt_ 

- _Area.rpt_ 

- _Power.rpt_ 

####  **PDF file** 

- _Demonstrates successful GLS execution, including the simulation waveform and results log._ 

####  **Power report:** 

- _Adder_Power.rpt_ 

