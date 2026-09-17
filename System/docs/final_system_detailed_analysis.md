# Final System — Detailed Block-by-Block Analysis

## 1. Scope

This document analyzes the uploaded **Final System** specification block by block. It preserves the source-defined interfaces, connections, command formats, clock specifications, and required sequence of operation, while adding explanatory structure. Implementation details not provided by the source are explicitly identified rather than invented.

## 2. Architecture

The system is divided into two clock domains plus CDC/reset logic.

```text
MASTER/TB
   |
   | UART serial
   v
UART_RX (UART_CLK)
   |
   | P_DATA / DATA_VLD
   v
SYS_CTRL (REF_CLK)
   |\
   | +----> RegFile ----> ALU
   |\
   | +----> Clock Gating ----> ALU clock
   |
   +----> ASYNC_FIFO ----> UART_TX ----> MASTER/TB

Supporting blocks:
RST_Sync, Data_Sync, PULSE_GEN, Clock Divider
```

The source states that the system contains 10 blocks, but its detailed list names RegFile, ALU, Clock Gating, SYS_CTRL, UART_TX, UART_RX, PULSE_GEN, Clock Divider, RST_Sync, Data_Sync, and ASYNC_FIFO — 11 named components. This apparent inconsistency is preserved rather than silently corrected.

---

# 3. Clock Domain 1 — REF_CLK

The source places these blocks in Clock Domain 1:

- RegFile
- ALU
- Clock Gating
- SYS_CTRL

System specification:

```text
REF_CLK = 50 MHz
```

## 3.1 RegFile

### Interface

| Port | Dir | Width | Description | Connected to |
|---|---|---:|---|---|
| CLK | IN | 1 | Clock (`REF_CLK`) | TOP |
| RST | IN | 1 | Active-low reset | RST_SYNC |
| Address | IN | parameterized, default 4 | Address bus | SYS_CTRL |
| WrEn | IN | 1 | Write enable | SYS_CTRL |
| RdEn | IN | 1 | Read enable | SYS_CTRL |
| WrData | IN | parameterized, default 8 | Write data | SYS_CTRL |
| RdData | OUT | parameterized, default 8 | Read data | SYS_CTRL |
| RdData_Valid | OUT | 1 | Read-data-valid | SYS_CTRL |
| REG0 | OUT | parameterized, default 8 | Register at `0x0` | ALU |
| REG1 | OUT | parameterized, default 8 | Register at `0x1` | ALU |
| REG2 | OUT | parameterized, default 8 | Register at `0x2` | UART |
| REG3 | OUT | parameterized, default 8 | Register at `0x3` | Clock Divider |

### Address map

```text
0x0 -> REG0 -> ALU operand A
0x1 -> REG1 -> ALU operand B
0x2 -> REG2 -> UART configuration
0x3 -> REG3 -> Clock-divider ratio
0x4..0x15 -> normal RegFile read/write range
```

### REG2 fields

```text
REG2[0]   = Parity Enable, default 1
REG2[1]   = Parity Type,   default 0
REG2[7:2] = Prescale,      default 32
```

### REG3

```text
REG3[7:0] = Division ratio
Default    = 32
```

### Conceptual role

The RegFile is both a normal register storage interface and a source of special configuration/operand registers.

```text
SYS_CTRL --> Address/WrEn/RdEn/WrData --> RegFile
SYS_CTRL <-- RdData/RdData_Valid ------ RegFile

RegFile REG0/REG1 --> ALU
RegFile REG2 ------> UART configuration
RegFile REG3 ------> Clock Divider
```

---

## 3.2 ALU

### Interface

| Port | Dir | Width | Description | Connected to |
|---|---|---:|---|---|
| CLK | IN | 1 | Clock | CLK_GATE |
| RST | IN | 1 | Active-low reset | RST_SYNC |
| A | IN | parameterized, default 8 | Operand A | RegFile REG0 |
| B | IN | parameterized, default 8 | Operand B | RegFile REG1 |
| ALU_FUN | IN | parameterized, default 4 | ALU function | SYS_CTRL |
| Enable | IN | 1 | ALU enable | SYS_CTRL |
| ALU_OUT | OUT | parameterized, default 8 | ALU result | SYS_CTRL |
| OUT_VALID | OUT | 1 | Result valid | SYS_CTRL |

### Data path

```text
REG0 --> A --+
             |
             v
            ALU --> ALU_OUT --> SYS_CTRL
             ^
             |
REG1 --> B --+

SYS_CTRL --> ALU_FUN
SYS_CTRL --> Enable
```

### Supported operations

1. Addition
2. Subtraction
3. Multiplication
4. Division
5. AND
6. OR
7. NAND
8. NOR
9. XOR
10. XNOR
11. CMP: `A = B`
12. CMP: `A > B`
13. SHIFT: `A >> 1`
14. SHIFT: `A << 1`

The source does **not** specify the 4-bit encoding of `ALU_FUN`; that must come from the RTL/project files.

---

## 3.3 Clock Gating

### Interface

| Port | Dir | Width | Description | Connected to |
|---|---|---:|---|---|
| CLK | IN | 1 | `REF_CLK` | TOP |
| CLK_EN | IN | 1 | Clock enable | SYS_CTRL |
| GATED_CLK | OUT | 1 | Gated clock | ALU |

### Concept

```text
REF_CLK --> Clock Gating --> GATED_CLK --> ALU
                    ^
                    |
                  CLK_EN
                    |
                 SYS_CTRL
```

The exact implementation of the clock gate is not specified.

---

## 3.4 SYS_CTRL

SYS_CTRL is the central controller coordinating command reception, RegFile access, ALU operation, clock gating, and UART transmission.

### Interface

| Port | Dir | Width | Description | Connected to |
|---|---|---:|---|---|
| CLK | IN | 1 | `REF_CLK` | TOP |
| RST | IN | 1 | Active-low reset | RST_SYNC |
| ALU_OUT | IN | 16 | ALU result | ALU |
| OUT_Valid | IN | 1 | ALU result valid | ALU |
| ALU_FUN | OUT | 4 | ALU function | ALU |
| EN | OUT | 1 | ALU enable | ALU |
| CLK_EN | OUT | 1 | Clock-gate enable | CLK_GATE |
| Address | OUT | 4 | Address | RegFile |
| WrEn | OUT | 1 | Write enable | RegFile |
| RdEn | OUT | 1 | Read enable | RegFile |
| WrData | OUT | 8 | Write data | RegFile |
| RdData | IN | 8 | Read data | RegFile |
| RdData_Valid | IN | 1 | Read-data valid | RegFile |
| RX_P_DATA | IN | 8 | RX parallel data | UART_RX |
| RX_D_VLD | IN | 1 | RX data valid | UART_RX |
| TX_P_DATA | OUT | 8 | TX parallel data | UART_TX |
| TX_D_VLD | OUT | 1 | TX data valid | UART_TX |
| clk_div_en | OUT | 1 | Divider enable | Clock Divider |

### Main conceptual path

```text
UART_RX --> RX_P_DATA/RX_D_VLD --> SYS_CTRL
                                      |
                    +-----------------+----------------+
                    |                 |                |
                    v                 v                v
                 RegFile             ALU          Clock Gating
                    |                 |                |
                    +---------> result/control <-------+
                                      |
                                      v
                                 UART_TX data
```

The exact SYS_CTRL FSM/state encoding is not given.

---

# 4. Clock Domain 2 — UART_CLK

The source places these blocks in Clock Domain 2:

- Clock Divider
- UART_TX
- UART_RX
- PULSE_GEN

System specification:

```text
UART_CLK = 3.6864 MHz
Clock Divider enable = 1
```

## 4.1 Clock Divider

### Interface

| Port | Dir | Width | Description | Connected to |
|---|---|---:|---|---|
| I_ref_clk | IN | 1 | `UART_CLK` | TOP |
| I_rst_n | IN | 1 | Active-low async reset | RST_SYNC_2 |
| I_clk_en | IN | 1 | Divider enable | `1'b1` |
| I_div_ratio | IN | parameterized, default 8 | Division ratio | RegFile |
| O_div_clk | OUT | 1 | Divided clock | UART_TX/UART_RX |

### Data flow

```text
UART_CLK --> Clock Divider --> O_div_clk --> UART_TX
                                      |
                                      +-----> UART_RX

REG3 --> I_div_ratio
```

The exact division formula is not specified in the source.

---

## 4.2 UART_TX

### Interface

| Port | Dir | Width | Description | Connected to |
|---|---|---:|---|---|
| CLK | IN | 1 | Clock | Clock Divider |
| RST | IN | 1 | Active-low reset | RST_SYNC_2 |
| PAR_EN | IN | 1 | Parity enable | RegFile |
| PAR_TYP | IN | 1 | Parity type | RegFile |
| P_DATA | IN | parameterized, default 8 | Parallel input | ASYNC_FIFO |
| DATA_VALID | IN | 1 | Input valid | ASYNC_FIFO |
| S_DATA | OUT | 1 | Serial frame bits | TOP `TX_OUT` |
| Busy | OUT | 1 | UART status | PULSE_GEN |

### Conceptual path

```text
ASYNC_FIFO --> P_DATA/DATA_VALID --> UART_TX --> S_DATA/TX_OUT
                                      |
                                      +--> Busy --> PULSE_GEN

REG2 --> PAR_EN/PAR_TYP
```

The source does not provide the detailed UART transmitter FSM/frame timing.

---

## 4.3 UART_RX

### Interface

| Port | Dir | Width | Description | Connected to |
|---|---|---:|---|---|
| CLK | IN | 1 | `UART_CLK` | TOP |
| RST | IN | 1 | Active-low reset | RST_SYNC_2 |
| Prescale | IN | 6 | Prescale | RegFile |
| PAR_EN | IN | 1 | Parity enable | RegFile |
| PAR_TYP | IN | 1 | Parity type | RegFile |
| RX_IN | IN | 1 | Serial input | TOP `RX_IN` |
| P_DATA | OUT | parameterized, default 8 | Parallel output | DATA_SYNC |
| DATA_VLD | OUT | 1 | Output valid | DATA_SYNC |
| PAR_ERR | OUT | 1 | Parity error | TOP |
| STP_ERR | OUT | 1 | Stop error | TOP |

### Conceptual path

```text
RX_IN --> UART_RX --> P_DATA --> Data_Sync
             |
             +----> DATA_VLD --> Data_Sync
             +----> PAR_ERR
             +----> STP_ERR

REG2 --> parity configuration
REG2[7:2] --> prescale-related configuration
```

The exact UART frame/state-machine implementation is not specified.

---

## 4.4 PULSE_GEN

### Interface

| Port | Dir | Width | Description | Connected to |
|---|---|---:|---|---|
| CLK | IN | 1 | Clock | TOP/UART_TX clock |
| RST | IN | 1 | Active-low reset | RST_SYNC_2 |
| LVL_SIG | IN | 1 | Level signal | UART_TX |
| PULSE_SIG | OUT | 1 | Pulse signal | ASYNC_FIFO |

### Concept

```text
UART_TX Busy/LVL_SIG --> PULSE_GEN --> PULSE_SIG --> ASYNC_FIFO R_INC
```

The source does not define the exact pulse-generation implementation.

---

# 5. Synchronizers

## 5.1 RST_Sync

### Interface

| Port | Dir | Width | Description |
|---|---|---:|---|
| RST | IN | 1 | Active-low asynchronous reset |
| CLK | IN | 1 | Clock |
| SYNC_RST | OUT | 1 | Active-low synchronized reset |

Conceptually:

```text
Async RST --> RST_Sync --> SYNC_RST --> domain logic
                    ^
                    |
                   CLK
```

The number of synchronization stages is not specified.

---

## 5.2 Data_Sync

### Interface

| Port | Dir | Width | Description |
|---|---|---:|---|
| unsync_bus | IN | 8 | Unsynchronized bus |
| bus_enable | IN | 1 | Bus enable |
| dest_clk | IN | 1 | Destination clock |
| dest_rst | IN | 1 | Destination active-low reset |
| sync_bus | OUT | 8 | Synchronized bus |
| enable_pulse_d | OUT | 1 | Enable pulse |

Conceptually:

```text
unsync_bus + bus_enable
        |
        v
   Data_Sync
        |
        +--> sync_bus
        +--> enable_pulse_d
        |
   dest_clk/dest_rst
```

The source does not specify the exact CDC circuit.

---

## 5.3 ASYNC_FIFO

### Interface

| Port | Width | Description | Connected to |
|---|---:|---|---|
| W_CLK | 1 | Source-domain clock (`REF_CLK`) | TOP |
| W_RST | 1 | Source-domain async reset | RST_SYNC_1 |
| W_INC | 1 | Write enable | SYS_CTRL |
| R_CLK | 1 | Destination-domain clock | UART domain |
| R_RST | 1 | Destination-domain async reset | RST_SYNC_2 |
| R_INC | 1 | Read enable | PULSE_GEN |
| WR_DATA | 8 | Write data | SYS_CTRL |
| RD_DATA | 8 | Read data | UART_TX |
| FULL | 1 | FIFO full flag | SYS_CTRL |
| EMPTY | 1 | FIFO empty flag | UART_TX |

### Data flow

```text
REF_CLK domain                         UART_CLK domain

SYS_CTRL                                UART_TX
   |                                       ^
   | WR_DATA                               | RD_DATA
   | W_INC                                 |
   v                                       |
+-------------------------------------------+
|               ASYNC_FIFO                  |
+-------------------------------------------+
   ^                                       ^
   | W_CLK                                 | R_CLK
   |                                       |
 REF_CLK                                UART_CLK

SYS_CTRL checks FULL
UART_TX checks EMPTY
PULSE_GEN controls R_INC
```

The FIFO is the explicitly specified data-transfer mechanism between the two clock domains.

---

# 6. System-Level Purpose

The system receives commands from the master through `UART_RX`, performs the requested operation, and sends the result back through `UART_TX`.

```text
MASTER
  |
  | command
  v
UART_RX
  |
  v
SYS_CTRL
  |
  +--> RegFile / ALU
  |
  v
Result
  |
  v
UART_TX
  |
  v
MASTER
```

---

# 7. Command Protocol

## 7.1 Register File Write — 3 Frames

```text
Frame 2       Frame 1        Frame 0
RF_Wr_CMD     RF_Wr_Data     RF_Wr_Addr
0xAA
```

So the command begins with:

```text
0xAA
```

and contains write data and write address.

## 7.2 Register File Read — 2 Frames

```text
Frame 0       Frame 1
RF_Rd_CMD     RF_Rd_Addr
0xBB
```

## 7.3 ALU Operation With Operand — 4 Frames

```text
Frame 0              Frame 1       Frame 2       Frame 3
ALU_OPER_W_OP_CMD    Operand A     Operand B     ALU FUN
0xCC
```

## 7.4 ALU Operation Without Operand — 2 Frames

```text
Frame 0              Frame 1
ALU_OPER_W_NOP_CMD   ALU FUN
0xDD
```

This command uses operands already available in the system rather than transmitting them in this command frame, consistent with the source naming; the exact controller behavior should be verified from RTL.

---

# 8. System Specifications

The source explicitly specifies:

```text
REF_CLK  = 50 MHz
UART_CLK = 3.6864 MHz
Clock Divider Enable = 1
```

---

# 9. Required Testbench Sequence

The testbench must include the following sequence.

## Step 1 — Initial Configuration

Perform RegFile writes to:

```text
0x2
0x3
```

These configure:

```text
REG2 -> UART configuration
REG3 -> Clock-divider ratio
```

## Step 2 — Master Sends Commands

The master/testbench sends different:

- RegFile operations
- ALU operations

## Step 3 — UART_RX Receives

The system receives command frames through `UART_RX`.

## Step 4 — SYS_CTRL Processes

The received command is sent to `SYS_CTRL` for processing.

## Step 5 — Operation Executes

The requested operation is performed using the `ALU` and/or `RegFile`.

## Step 6 — Result Returns

`SYS_CTRL` sends the result through `UART_TX` to the master.

Complete conceptual sequence:

```text
Configure 0x2/0x3
      |
      v
Master sends command
      |
      v
UART_RX
      |
      v
SYS_CTRL
      |
      +----> RegFile / ALU
      |
      v
Result
      |
      v
UART_TX
      |
      v
Master
```

---

# 10. Address Map Summary

| Address | Register | Function |
|---|---|---|
| `0x0` | REG0 | ALU operand A |
| `0x1` | REG1 | ALU operand B |
| `0x2` | REG2 | UART configuration |
| `0x3` | REG3 | Clock-divider ratio |
| `0x4`–`0x15` | Normal RegFile range | Normal read/write |

---

# 11. Recommended Verification Coverage

These are logical verification categories derived from the source specification; exact vectors are not supplied.

## RegFile

- Normal write/read addresses `0x4..0x15`
- Reserved registers `0x0..0x3`
- Read-data-valid behavior

## ALU

Exercise all 14 listed operations.

## UART

- RX command reception
- TX result transmission
- parity enable/type configurations
- parity error
- stop error
- prescale configuration

## CDC

- reset synchronization
- Data_Sync behavior
- ASYNC_FIFO write/read
- FULL and EMPTY handling

## Clocking

- Clock Divider enabled
- division-ratio configuration
- ALU clock gating

These verification suggestions are not additional source requirements.

---

# 12. Important Missing Information

The uploaded specification does not define:

- ALU function-code encoding
- exact UART frame timing/bit format
- exact UART TX/RX FSM states
- exact clock-divider formula
- FIFO depth
- FIFO pointer implementation
- synchronizer stage count
- exact Data_Sync architecture
- exact SYS_CTRL FSM
- exact test vectors
- exact cycle-by-cycle command latency

These details must come from the RTL/project files if needed.

---

# 13. Viva Questions

### What are the two clock domains?

`REF_CLK` and `UART_CLK`.

### What are their frequencies?

```text
REF_CLK  = 50 MHz
UART_CLK = 3.6864 MHz
```

### What is REG0?

Address `0x0`; connected to ALU operand A.

### What is REG1?

Address `0x1`; connected to ALU operand B.

### What is REG2?

Address `0x2`; UART configuration containing parity enable, parity type, and prescale.

### What is REG3?

Address `0x3`; clock-divider division ratio.

### Why is an ASYNC_FIFO used?

It provides the specified data-transfer path between the source (`REF_CLK`) and destination (`UART_CLK`) domains.

### What is `OUT_VALID`?

The ALU result-valid signal.

### What is `RdData_Valid`?

The RegFile read-data-valid signal.

### What does `0xAA` represent?

Register File Write command.

### What does `0xBB` represent?

Register File Read command.

### What does `0xCC` represent?

ALU Operation With Operand command.

### What does `0xDD` represent?

ALU Operation With No Operand command.

---

# 14. Final Mental Model

```text
                  MASTER
                    |
                    | UART command
                    v
               +---------+
               | UART_RX |
               +----+----+
                    |
                    v
               +---------+
               | SYS_CTRL|
               +----+----+
                    |
          +---------+---------+
          |                   |
          v                   v
      +--------+          +-------+
      | RegFile|--------->|  ALU  |
      +--------+          +---+---+
          |                   |
          |                   |
          +-------------------+
                    |
                    v
               ASYNC_FIFO
                    |
                    v
               +---------+
               | UART_TX |
               +----+----+
                    |
                    v
                  MASTER

Support:
RST_Sync | Data_Sync | Clock Gating | Clock Divider | PULSE_GEN
```

## Core Concept

> **Receive a command through UART_RX → SYS_CTRL decodes/controls the operation → RegFile and/or ALU perform the requested work → the result crosses the required clock-domain boundary → UART_TX sends the result back to the master.**

---

# 15. Source Reference

The uploaded Final System specification contains the block interfaces on pages 1–13 and the system purpose, commands, clocks, and required testbench sequence on pages 14–15. It explicitly specifies the REF_CLK/UART_CLK frequencies and the configuration addresses `0x2` and `0x3`.

---

# 16. Submission/Study Checklist

- [ ] Understand the two clock domains.
- [ ] Memorize `REF_CLK = 50 MHz`.
- [ ] Memorize `UART_CLK = 3.6864 MHz`.
- [ ] Understand REG0–REG3.
- [ ] Understand all 14 ALU operations.
- [ ] Understand SYS_CTRL connections.
- [ ] Understand Clock Gating.
- [ ] Understand Clock Divider.
- [ ] Understand UART_TX/UART_RX interfaces.
- [ ] Understand RST_Sync and Data_Sync roles.
- [ ] Understand ASYNC_FIFO write/read sides.
- [ ] Memorize command IDs `AA`, `BB`, `CC`, `DD`.
- [ ] Follow the required initial configuration sequence.
- [ ] Verify normal RegFile range `0x4..0x15`.
- [ ] Do not assume unspecified ALU encodings, UART timing, FIFO depth, or FSM details without checking the RTL.
