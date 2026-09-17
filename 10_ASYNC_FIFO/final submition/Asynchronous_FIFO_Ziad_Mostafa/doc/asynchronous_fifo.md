# Asynchronous FIFO

## 1. Introduction

- Asynchronous FIFO is a 2-port memory with certain depth.
- It has two clocks, one for read (`R_CLK`) and one for write (`W_CLK`).
- It has two addresses, one for read and one for write.
- Writing happens at the location specified by the write address.
- Reading happens at the location specified by the read address.

## 2. Block Interface

### 2.1 Parameters

| Parameter Name | Description |
|---|---|
| `DATA_WIDTH` | Data Bus width (default = 8) |
| `ADDR_SIZE` | Memory address size (default = 3, Depth = 8) |

### 2.2 Ports

| Signal Name | Description | Width |
|---|---|---:|
| `W_CLK` | Source domain clock | 1 |
| `W_RST` | Source domain Async reset | 1 |
| `W_INC` | Write operation enable | 1 |
| `R_CLK` | Destination domain clock | 1 |
| `R_RST` | Destination domain Async reset | 1 |
| `R_INC` | Read operation enable | 1 |
| `WR_DATA` | Write Data Bus | Parameterized (8 bits) |
| `RD_DATA` | Read Data Bus | Parameterized (8 bits) |
| `FULL` | FIFO Buffer full flag | 1 |
| `EMPTY` | FIFO Buffer empty flag | 1 |

## 3. Required RTL Blocks

1. `FIFO_MEM_CNTRL.v` — FIFO Buffer
2. `DF_SYNC.v` — Double Flop Synchronizer
3. `FIFO_WR.v` — Generate FIFO write address & FIFO full flag
4. `FIFO_RD.v` — Generate FIFO read address & FIFO empty flag
5. `ASYNC_FIFO.v` — Top Module

## 4. Testbench Requirements

- **Reading frequency:** `40 MHz`
- **Writing frequency:** `100 MHz`
- **Writing Data Bytes:** `9 Bytes`
- **Calculated FIFO Depth:** `8 entries` (`ADDR_SIZE = 3`)
