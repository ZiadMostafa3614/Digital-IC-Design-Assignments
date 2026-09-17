# RST Synchronizer

## 1. Introduction

Asynchronous reset has many issues during de-assertion as it may violate the **recovery** and **removal** times of the Flip Flop.

Therefore, a **Reset Synchronizer** in a digital circuit is needed to synchronize the de-assertion of the asynchronous reset with respect to the clock domain.

In other words, a reset synchronizer manipulates the asynchronous reset to have **synchronous de-assertion**.

## 2. Block Interface

### Ports

| Signal Name | Description | Width |
|---|---|---:|
| `RST` | Asynchronous reset | 1 |
| `CLK` | Destination domain clock | 1 |
| `SYNC_RST` | Synchronized Reset | 1 |

### Parameter

| Parameter Name | Description |
|---|---|
| `NUM_STAGES` | Number of Flip Flop Stages (default = 2) |

## 3. Required Work

1. Write Verilog code for `RST_SYNC` block.
2. Write a self-checking testbench (`RST_SYNC_tb.v`).
3. Verify immediate asynchronous assertion and clock-synchronous de-assertion.
