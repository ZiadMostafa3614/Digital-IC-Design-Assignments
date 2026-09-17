# Integer Clock Divider

## Introduction

A clock divider is a circuit that takes an input signal of a frequency `fin` and generates an output signal of a frequency `fout`, where:

```text
fout = fin / n
```

where `n` is an integer.

## Block Interface

| Signal Name | Description | Width |
|---|---|---:|
| `I_ref_clk` | Reference Frequency | 1 |
| `I_rst_n` | Active Low Asynchronous Reset | 1 |
| `I_clk_en` | Clock Divider Block Enable | 1 |
| `I_div_ratio` | The divided ratio (integer value) | 8 |

## Waveforms

## Corner Cases

1. You have to check `I_div_ratio` not equals Zero or One before enable the clock divider.

## Requirements

1. Write a Verilog Code to capture the above specifications.
2. Write a testbench to test generation of different frequencies of both odd and even divided ratio of the reference frequency.

## Clock Divider Enable Condition

```verilog
ClK_DIV_EN = I_clk_en && ( I_div_ratio != Zero) && ( I_div_ratio != One)
```
