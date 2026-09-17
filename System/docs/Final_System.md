# **<u>Final System</u>** 



<!-- Start of picture text -->
UART_Config<br>_ SynchronizerData Lt<br>SYS_CTRL<br><— RX_IN<br>* WR_INC<br>WrEn RdEn Addr Wr_D Rd_D Rd_D.Vid7 FUN ENTe rOEN Bu:ay UART<br>a RegFile a ALU [0a | 1™ TX_OUT.<br>A |_|<br>SYNC_RST Gate EN ‘ALU_CLK<br>RST Clock<br>RST | | 4 RST Clock<br>SYNUEZ Divider<br>UART_CLK -— im Divider<br>piv. Ratio<br><!-- End of picture text -->

- **Description: -** 

   **`1.` This system contains 10 blocks: - 1) Clock Domain 1 (REF_CLK)** 

         - **RegFile** 

         - **ALU** 

         - **Clock Gating** 

         - **SYS_CTRL** 

      - **Clock Domain 2 (UART_CLK)** 

         - **UART_TX** 

         - **UART_RX** 

         - **PULSE_GEN** 

         - **Clock Dividers** 

      - **Data Synchronizers** 

         - **RST Synchronizer** 

         - **Data Synchronizer** 

         - **ASYNC FIFO** 

### **<u>CLOCK Domain 1</u>** 

### **1) RegFile: -** 

#####  **Block Interface: -** 



<!-- Start of picture text -->
WrData RdData<br>Address RdData_Valid<br>———>| wren 8X16 REGO<br>Register<br>File<br>RdEn REG1<br>LK REG2<br>RST REG3<br><!-- End of picture text -->

#####  **Signal Description: -** 

|**Port**|**Direction**|**Width**|**Description**|**Connected to**|
|---|---|---|---|---|
|**CLK**|IN|1|Clock Signal|TOP Input Port<br>(REF_CLK)|
|**RST**|IN|1|Active Low Reset|RST_SYNC|
|**Address**|IN|Parameterized<br>(default : 4 bits)|Address bus|SYS_CTRL|
|**WrEn**|IN|1|Write Enable|SYS_CTRL|
|**RdEn**|IN|1|Read Enable|SYS_CTRL|
|**WrData**|IN|Parameterized<br>(default : 8 bits)|Write Data Bus|SYS_CTRL|
|**RdData**|OUT|Parameterized<br>(default : 8 bits)|Read Data Bus|SYS_CTRL|
|**RdData_Valid**|OUT|1|Read Data Valid|SYS_CTRL|
|**REG0**|OUT|Parameterized<br>(default : 8 bits)|Register at Address<br>0x0|ALU|
|**REG1**|OUT|Parameterized<br>(default : 8 bits)|Register at Address<br>0x1|ALU|
|**REG2**|OUT|Parameterized<br>(default : 8 bits)|Register at Address<br>0x2|UART|
|**REG3**|OUT|Parameterized<br>(default : 8 bits)|Register at Address<br>0x3|Clock Divider|



- **Reserved Registers Description: -** 

**1) REG0 (Address: 0x0)** ALU Operand A **2) REG1 (Address: 0x1)** ALU Operand B **3) REG2 (Address: 0x2)** UART Config **REG2[0]: Parity Enable (Default = 1) REG2[1]: Parity Type (Default = 0) REG2[7:2]: Prescale (Default = 32) 4) REG3 (Address: 0x3)** Div Ratio **REG3[7:0]: Division ratio (Default = 32)** 

### **2) ALU:** 

#####  **Block Interface: -** 



<!-- Start of picture text -->
A<br>B<br>ALU_OUT<br>Y~— ALU_FUN ALU<br>Enable OUT_VALID<br>————>] cik<br>RST<br><!-- End of picture text -->

#####  **Signal Description: -** 

|**Port**|**Direction**|**Width**|**Description**|**Connected to**|
|---|---|---|---|---|
|**CLK**|IN|1|Clock Signal|CLK_GATE|
|**RST**|IN|1|Active Low<br>Reset|RST_SYNC|
|**A**|IN|Parameterized<br>(default : 8 bits)|Operand A|RegFile<br>(REG0)|
|**B**|IN|Parameterized<br>(default : 8 bits)|Operand B|RegFile<br>(REG1)|
|**ALU_FUN**|IN|Parameterized<br>(default : 4 bits)|ALU Function|SYS_CTRL|
|**Enable**|IN|1|ALU Enable|SYS_CTRL|
|**ALU_OUT**|OUT|Parameterized<br>(default : 8 bits)|ALU Result|SYS_CTRL|
|**OUT_VALID**|OUT|1|Result Valid|SYS_CTRL|



### **3) Clock Gating: -** 

#####  **Block Interface: -** 



<!-- Start of picture text -->
CLK_EN<br>CLK_GATE GATED_CLK<br>—_———>| ck<br><!-- End of picture text -->

#####  **Signal Description: -** 

|**Port**|**Direction**|**Width**|**Description**|**Connected to**|
|---|---|---|---|---|
|**CLK**|IN|1|Clock Signal|TOP Input Port|
|||||(REF_CLK)|
|**CLK_EN**|IN|1|Clock Enable|SYS_CTRL|
|**GATED_CLK**|out|1|Gated Clock signal|ALU|



### **4) SYS_CTRL:** 

######  **Block Interface: -** 



<!-- Start of picture text -->
ALU_OUT ALU_EN |]_--—><br>OUT_Valid ALU_FUN<br>Sy RX_P_Data CLK_EN<br>Address<br>—————>| RX_D_vLD<br>Z wen |——_<br>RaData SYS_CTRL<br>RdEn<br>———>| RdData_valid<br>7 WrData<br>—_—>| elk TX_P_Data<br>RST TX_D_VLD<br>clk_div_en<br><!-- End of picture text -->

######  **Signal Description: -** 

|**Port**|**Direction**|**Width**|**Description**|**Connected to**|
|---|---|---|---|---|
|**CLK**|IN|1|Clock Signal|TOP Input Port<br>(REF_CLK)|
|**RST**|IN|1|Active Low Reset|RST_SYNC|
|**ALU_OUT**|IN|16|ALU Result|ALU|
|**OUT_Valid**|IN|1|ALU Result Valid|ALU|
|**ALU_FUN**|OUT|4|ALU Function signal|ALU|
|**EN**|OUT|1|ALU Enable signal|ALU|
|**CLK_EN**|OUT|1|Clock gate enable|CLK_GATE|
|**Address**|OUT|4|Address bus|RegFile|
|**WrEn**|OUT|1|Write Enable|RegFile|
|**RdEn**|OUT|1|Read Enable|RegFile|
|**WrData**|OUT|8|Write Data Bus|RegFile|
|**RdData**|IN|8|Read Data Bus|RegFile|
|**RdData_Valid**|IN|1|Read Data Valid|RegFile|
|**RX_P_DATA**|IN|8|UART_RX Data|UART_RX|
|**RX_D_VLD**|IN|1|RX Data Valid|UART_RX|
|**TX_P_DATA**|OUT|8|UART_TX Data|UART_TX|
|**TX_D_VLD**|OUT|1|TX Data Valid|UART_TX|
|**clk_div_en**|OUT|1|Clock divider enable|CLKDiv|



### **<u>CLOCK Domain 2</u>** 

### **1) Clock Divider: -** 

###  **Block Interface: -** 



<!-- Start of picture text -->
i_ref_clk<br>i_rst_n<br>ClkDiv o_div_clk<br>————>| i_clk_en<br>i_div_ratio<br><!-- End of picture text -->

######  **Signal Description: -** 

|**Port**|**Direction**|**Width**|**Description**|**Connected to**|
|---|---|---|---|---|
|**I_ref_clk**|IN|1|Clock Signal|TOP Input Port<br> (UART_CLK)|
|**I_rst_n**|IN|1|Active Low Async<br>Reset|RST_SYNC_2|
|**I_clk_en**|IN|1|Clock divider enable|1’b1(Supply)|
|**I_div_ratio**|IN|Parameterized<br>(default : 8 bits)|Division ratio|RegFile|
|**O_div_clk**|out|1|Divided clock|UART_TX<br>UART_RX|



### **2) UART_TX: -** 

###  **Block Interface: -** 



<!-- Start of picture text -->
P_DATA<br>TX_OUT<br>DATA_VALID<br>—————| PAR_EN<br>Configuration — UART™<br>PAR_TYP<br>cLK Busy<br>RST<br><!-- End of picture text -->

######  **Signal Description: -** 

|**Port**|**Direction**|**Width**|**Description**|**Connected to**|
|---|---|---|---|---|
|**CLK**|IN|1|Clock Signal|CLKDiv|
|**RST**|IN|1|Active Low<br>Reset|RST_SYNC_2|
|**PAR_EN**|IN|1|Parity Enable|RegFile|
|**PAR_TYP**|IN|1|Parity Type|RegFile|
|**P_DATA**|IN|Parameterized<br>(default : 8 bits)|Parallel IN Data|ASYNC_FIFO|
|**DATA_VALID**|IN|1|IN Data Valid|ASYNC_FIFO|
|**S_DATA**|OUT|1|frame serial bits|TOP Output Port<br>(TX_OUT)|
|**Busy**|OUT|1|Uart status signal|PULSE_GEN|



### **3) UART_RX: -** 

##  **Block Interface: -** 



<!-- Start of picture text -->
RX_IN<br>P_DATA<br>Prescale<br>—————>| PAR_EN<br>— UART<br>Configuration RX<br>PAR_TYP<br>————> cLk data_valid<br>RST<br><!-- End of picture text -->

####  **Signal Description: -** 

|**Port**|**Direction**|**Width**|**Description**|**Connected to**|
|---|---|---|---|---|
|**CLK**|IN|1|Clock Signal|TOP Input Port<br> (UART_CLK)|
|**RST**|IN|1|Active Low<br>Reset|RST_SYNC_2|
|**Prescale**|IN|6|Prescale|RegFile|
|**PAR_EN**|IN|1|Parity Enable|RegFile|
|**PAR_TYP**|IN|1|Parity Type|RegFile|
|**RX_IN**|IN|1|frame serial bits|TOP Input Port<br>(RX_IN)|
|**P_DATA**|OUT|Parameterized<br>(default : 8 bits)|Parallel Out Data|DATA_SYNC|
|**DATA_VLD**|OUT|1|Out Data Valid|DATA_SYNC|
|**PAR_ERR**|OUT|1|Frame parity error|TOP Output Port|
|**STP_ERR**|OUT|1|Frame stop error|TOP Output Port|



### **4) PULSE_GEN: -** 

##  **Block Interface: -** 



<!-- Start of picture text -->
———>| RsT<br>cLk PULSE_GEN PULSE_sIG<br>———>| LVL_sIG<br><!-- End of picture text -->

####  **Signal Description: -** 

|**Port**|**Direction**|**Width**|**Description**|**Connected to**|
|---|---|---|---|---|
|**CLK**|IN|1|Clock Signal|TOP Input Port|
|||||(UART_TX)|
|**RST**|IN|1|Active Low<br>Reset|RST_SYNC_2|
|**LVL_SIG**|IN|1|Level signal|UART_TX|
|**PULSE_SIG**|OUT|1|Pulse signal|ASYNC_FIFO|



### **<u>Synchronizers</u>** 

### **1) RST_Sync: -** 

###  **Block Interface: -** 



<!-- Start of picture text -->
RST<br>RST_SYNC syne _rst<br>cLK<br><!-- End of picture text -->

######  **Signal Description: -** 

|**Port**|**Direction**|**Width**|**Description**|
|---|---|---|---|
|**RST**|IN|1|Clock Signal|
|**CLK**|IN|1|Active Low Async<br>Reset|
|**SYNC_RST**|OUT|1|Active Low synchronized<br>Reset|



### **2) Data_Sync: -** 

###  **Block Interface: -** 



<!-- Start of picture text -->
unsync_bus<br>sync_bus<br>bus_enable<br>Data_Sync<br>———————>| dest_clk<br>enable_pulse |»<br>dest_rst<br><!-- End of picture text -->

######  **Signal Description: -** 

|**Port**|**Direction**|**Width**|**Description**|
|---|---|---|---|
|**unsync_bus**|IN|8|Unsynchronized<br>bus|
|**bus_enable**|IN|1|Bus enable signal|
|**dest_clk**|IN|1|Destination Clock Signal|
|**dest_rst**|IN|1|Destination Active Low<br>Reset|
|**sync_bus**|OUT|8|synchronized<br>bus|
|**enable_pulse_d**|OUT|1|enable pulse signal|



**3) ASYNC_FIFO: -** 

###  **Block Interface: -** 



<!-- Start of picture text -->
W_CLK<br>W_RST FULL<br>W_INC<br>R_CLK ASYC_FIFO RD_DATA<br>R_RST<br>RNC EMPTY<br>WR_DATA<br><!-- End of picture text -->

######  **Signal Description: -** 

|**Port**|**Width**|**Description**|**Connected to**|
|---|---|---|---|
|W_CLK|1|Source domain clock|TOP Input Port<br>(REF_CLK)|
|W_RST|1|Source domain Async reset|RST_SYNC_1|
|W_INC|1|Write operation enable|SYS_CTRL|
|R_CLK|1|Destination domain clock|RST_SYNC_2|
|R_RST|1|Destination domain Async<br>reset|RST_SYNC_2|
|R_INC|1|Read operation enable|PULSE_GEN|
|WR_DATA|Parameterized<br>default(8-bits)|Write Data Bus|SYS_CTRL|
|RD_DATA|Parameterized<br>default(8-bits)|Read Data Bus|UART_TX|
|FULL|1|FIFO Buffer full flag|SYS_CTRL|
|EMPTY|1|FIFO Buffer empty flag|UART_TX|



#### **Introduction** 

- The system is responsible to do some operation based on the received commands from the master through UART_RX interface, once the operation is done, the system is responsible to send the result to the master through UART_TX interface. 

- Supported Operations: - 

   -  **ALU Operations: -** 

      - **Addition** 

      - **Subtraction** 

      - **Multiplication** 

      - **Division** 

      - **AND** 

      - **OR** 

      - **NAND** 

      - **NOR** 

      - **XOR** 

      - **XNOR** 

      - **CMP: A = B** 

      - **CMP: A > B** 

      - **SHIFT: A >> 1** 

      - **SHIFT: A << 1** 

   -  **Register File Operations** 

      - **Register File Write** 

      - **Register File read** 

- Supported Commands: - 

   -  **Register File Write command (3 frames)** 



<!-- Start of picture text -->
Frame 2  Frame 1  Frame 0<br>RF_Wr_CMD<br>RF_Wr_Data  RF_Wr_Addr<br>(0xAA)<br><!-- End of picture text -->

######  **Register File Read command (2 frames)** 



<!-- Start of picture text -->
Frame 1  Frame 0<br>RF_Rd_CMD<br>RF_Rd_Addr<br>(0xBB)<br><!-- End of picture text -->

######  **ALU Operation command with operand (4 frames)** 



<!-- Start of picture text -->
Frame 3  Frame 2  Frame 1  Frame 0<br>ALU FUN  Operand B  Operand A  ALU_OPER_W_OP_CMD<br>(0xCC)<br><!-- End of picture text -->

-  **ALU Operation command with No operand (2 frames)** 



<!-- Start of picture text -->
Frame 1  Frame 0<br>ALU_OPER_W_NOP_CMD<br>ALU FUN<br>(0xDD)<br><!-- End of picture text -->

###### **System Specifications: -** 

- Reference clock (REF_CLK) is 50 MHz 

- UART clock (UART_CLK) is 3.6864 MHz 

- Clock Divider is always on (clock divider enable = 1) 

###### **Sequence of Operation (Must include in the testbench): -** 

- Initially configuration operations are performed through Register file write operations in addresses (0x2, 0x3). 

- The Master (Testbench) start to send different commands (RegFile Operations, ALU operations) 

- Our system will receive the command frames through UART_RX, it sent to the SYS_CTRL block to be processed 

- Once the operation of the command is performed using ALU/RegFile, SYS_CTRL sends the result to the master through UART_TX 

- Register File Address Range for normal write/read operations (From 0x4 to 0x15) 

- Register File Addresses reserved for configurations and ALU operands (From 0x0 to 0x3) 

