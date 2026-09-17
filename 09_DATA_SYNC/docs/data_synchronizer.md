# Data Synchronizer

## Introduction

Clock Domain Crossing (CDC) in digital domain is defined as the process of passing a signal or vector (multi bit signal) from one clock domain to another clock domain which introduce many issues as metastability, data incoherence and data loss.

There are many techniques to synchronize asynchronous signals to avoid CDC issues as:

- **Synchronized MUX-Select Synchronization Scheme:** Used to synchronize multiple bits.

## Block Interface

### Parameters

| Parameter Name | Description |
|---|---|
| `NUM_STAGES` | Number of Flip Flop Stages |
| `BUS_WIDTH` | Width of synchronized bus |

### Ports

| Signal Name | Description | Width |
|---|---|---:|
| `Unsync_bus` | Unsynchronized bus | Parameterized (default = 8) |
| `bus_enable` | Source domain enable signal | 1 |
| `CLK` | Destination domain clock | 1 |
| `RST` | Destination domain Active Low Asynchronous Reset | 1 |
| `sync_bus` | Synchronized bit/bus | Parameterized (default = 8) |
| `enable_pulse` | destination domain enable signal | 1 |

## Block Diagram

The source document contains a block diagram illustrating the data synchronizer.

> **Hint:** Number of stages is parameterized.

## Required

1. Write a Verilog Code to capture the above block diagram.
2. Write a testbench to your data synchronizer.
