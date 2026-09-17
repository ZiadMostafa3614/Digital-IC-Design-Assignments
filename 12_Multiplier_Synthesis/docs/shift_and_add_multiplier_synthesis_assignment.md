# Shift-and-Add Multiplier — Synthesis & Timing Optimization

## 1. Motivation

In the ALU assignment, arithmetic operations such as addition, subtraction, multiplication, and division can be written directly using `+`, `-`, `*`, and `/`. The synthesis tool then decides how to implement these operators.

However, direct operators do not always provide the best architecture for a particular **timing, area, or power** target. Specific arithmetic architectures can instead be selected to obtain different trade-offs.

### Adder architectures mentioned

- Ripple Carry Adder (RCA)
- Carry Look-Ahead Adder (CLA)
- Kogge-Stone Adder
- Brent-Kung Adder

### Multiplier architectures mentioned

- Booth Multiplier
- Wallace Tree Multiplier
- Baugh-Wooley Multiplier
- Shift-and-Add Multiplier

This assignment focuses on the **Shift-and-Add Multiplier** and how its architecture affects design performance.

---

## 2. Shift-and-Add Multiplier

A Shift-and-Add multiplier performs multiplication using **shifting and addition** rather than directly using the `*` operator.

The multiplier is examined bit by bit. If a multiplier bit is `1`, a shifted version of the multiplicand is added to the accumulated result. The shift amount corresponds to the bit position.

For an 8-bit multiplier:

```text
A × B = (A × b0)
      + ((A × b1) << 1)
      + ...
      + ((A × b7) << 7)
```

### Advantages

- Simple architecture
- Area efficient

### Limitation

The multiple additions can produce a long **critical path**, limiting maximum frequency compared with more advanced multiplier architectures.

---

## 3. 8-bit Example: 31 × 42

### Binary representation

```text
A = 31 = 00011111₂
B = 42 = 00101010₂
```

### Partial Product Generation

```text
PP[0] = A & B[0] = 00000000₂
PP[1] = A & B[1] = 00011111₂
PP[2] = A & B[2] = 00000000₂
PP[3] = A & B[3] = 00011111₂
PP[4] = A & B[4] = 00000000₂
PP[5] = A & B[5] = 00011111₂
PP[6] = A & B[6] = 00000000₂
PP[7] = A & B[7] = 00000000₂
```

### Align, Shift and Accumulate

```text
  00000000 00000000₂   (PP[0] << 0)
+ 00000000 00111110₂   (PP[1] << 1)
+ 00000000 00000000₂   (PP[2] << 2)
+ 00000000 11111000₂   (PP[3] << 3)
+ 00000000 00000000₂   (PP[4] << 4)
+ 00000011 11100000₂   (PP[5] << 5)
+ 00000000 00000000₂   (PP[6] << 6)
+ 00000000 00000000₂   (PP[7] << 7)
------------------------------------
  00000101 00010110₂
```

Therefore:

```text
31 × 42 = 1302
```

The source includes **Figure 1: Block diagram for the multiplier**.

---

## 4. ALU Design Overview

The `alu8_top` module is an **8-bit ALU** supporting:

- Addition
- Multiplication

The design uses a **2-stage pipelined architecture**:

```text
Input Flip-Flops
       ↓
Combinational Logic
       ↓
Output Flip-Flops
```

The pipeline is used to stabilize signals and handle clock-boundary timing.

### `alu8_top` Top Wrapper

The top wrapper:

- Routes inputs `a` and `b` to both sub-modules.
- Selects the final output according to `mode`.

```text
mode = 0 → Addition
mode = 1 → Multiplication
```

The source includes **Figure 2: Design overview**.

---

## 5. Adder Unit

The Adder Unit is an **8-bit Adder**.

Its operation is:

1. Input operands are latched on the clock edge.
2. Sum and carry-out are calculated combinationally.
3. The final **9-bit result** is registered on the next clock edge.

Conceptually:

```text
a, b
 ↓
Input Registers
 ↓
8-bit Addition
 ↓
Sum + Carry
 ↓
Output Register
 ↓
9-bit Result
```

---

## 6. `Mult_unit`

`Mult_unit` implements multiplication using the Shift-and-Add architecture.

### Partial Product Generation

It uses an:

```text
8 × 8 AND array
```

to generate partial products.

### Accumulation

The partial products are accumulated using:

```text
Combinational shift-add logic
```

### Output

The final product is:

```text
16 bits
```

and is registered at the output stage.

Conceptually:

```text
A × B
  ↓
8 × 8 AND Array
  ↓
Partial Products
  ↓
Shift / Align
  ↓
Combinational Accumulation
  ↓
16-bit Product Register
```

---

## 7. Initial Pipeline Latency

The source states that the waveform demonstrates:

> two-cycle pipeline latency from when inputs are applied to when valid goes high and data is ready

Therefore:

```text
Initial latency = 2 cycles
```

The source includes:

- **Figure 3: Design waveform**
- **Figure 4: Simple testbench results**

The testbench is identified as:

```text
tb.v
```

and is used to test simple cases to ensure the design functions correctly.

---

# 8. Synthesis and Timing Assignment

## Requirement 1 — Initial Synthesis

Run synthesis on the given design starting with:

```text
Clock period = 10 ns
```

Then gradually decrease the clock period.

The goal is to find the:

> Maximum frequency achievable without any timing violations.

### Constraint

**No constraints should be changed except the clock period.**

Therefore, the experiment must isolate the effect of the clock period.

---

## 9. Frequency vs. Clock Period

The fundamental relationship is:

```text
f = 1 / T
```

When `T` is in nanoseconds:

```text
f(MHz) = 1000 / T(ns)
```

For example:

```text
T = 10 ns
f = 100 MHz
```

The assignment requires progressively reducing `T` until timing violations occur.

The smallest clock period that still passes timing determines the achievable maximum frequency:

```text
fmax = 1 / Tmin_pass
```

---

# 10. Requirement 2 — Critical Path Analysis

After the initial synthesis:

1. Identify the **critical path**.
2. Determine which design unit contributes the most to the critical delay.

Potential units described by the design include:

- Adder Unit
- `Mult_unit`
- Top-level/wrapper logic

The actual critical unit must be obtained from the synthesis timing report. The PDF does not provide the synthesis result itself.

### Why the multiplier is important

The Shift-and-Add multiplier contains multiple additions:

```text
Partial Products
      ↓
Shift / Align
      ↓
Multiple Additions
```

This can create a long combinational path and potentially make the multiplier the timing bottleneck. However, this is a design expectation, **not a result stated by the source**; the actual critical unit must be verified by synthesis.

---

# 11. Requirement 3 — Pipeline the Critical Path

Modify the critical unit by adding a **pipeline register** to the critical path.

### Before pipelining

```text
Register
   ↓
Long Combinational Path
   ↓
Register
```

### After pipelining

```text
Register
   ↓
Combinational Path 1
   ↓
Pipeline Register
   ↓
Combinational Path 2
   ↓
Register
```

The added register divides the long combinational path into shorter timing paths.

### Latency impact

The source explicitly states:

```text
Original maximum latency = 2 cycles
New maximum latency = 3 cycles
```

Thus, the optimization intentionally trades increased latency for improved timing potential.

---

# 12. Requirement 4 — Re-Synthesis

After adding the pipeline register:

1. Run synthesis again.
2. Repeat the clock-period sweep.
3. Continue reducing the clock period.
4. Find the new maximum frequency without timing violations.

The purpose is to determine whether the additional pipeline stage improves the achievable operating frequency.

---

# 13. Complete Experiment Flow

```text
Original 2-stage ALU
        ↓
Synthesis
        ↓
Start at 10 ns
        ↓
Decrease clock period
        ↓
Find minimum passing period
        ↓
Calculate initial Fmax
        ↓
Analyze critical path
        ↓
Identify unit contributing most delay
        ↓
Add pipeline register
        ↓
Latency: 2 → 3 cycles
        ↓
Synthesis again
        ↓
Repeat clock-period sweep
        ↓
Find new minimum passing period
        ↓
Calculate new Fmax
        ↓
Compare results
```

---

# 14. Expected Before/After Comparison

| Metric | Original Design | Modified Design |
|---|---:|---:|
| Pipeline latency | 2 cycles | 3 cycles |
| Starting period | 10 ns | Follow synthesis procedure |
| Minimum passing period | To be determined | To be determined |
| Maximum frequency | To be determined | To be determined |
| Critical unit | To be determined by synthesis | Modified critical unit |
| Timing improvement | — | To be determined |

---

# 15. Measurements to Record

## Original Design

Record:

- Clock period for each synthesis run
- Timing pass/fail
- Critical path delay
- Critical path endpoints
- Critical path logic
- Design unit contributing most delay
- Minimum passing clock period
- Maximum frequency

## Modified Design

Record:

- Unit modified
- Pipeline-register location
- New latency
- Clock period for each synthesis run
- Timing pass/fail
- New critical path
- New critical delay
- Minimum passing clock period
- New maximum frequency

---

# 16. Engineering Trade-off

The assignment demonstrates a fundamental timing/latency trade-off.

### Without the additional pipeline stage

```text
2-cycle latency
      ↓
Longer combinational path
      ↓
Lower possible Fmax
```

### With the additional pipeline stage

```text
3-cycle latency
      ↓
Shorter combinational paths
      ↓
Potentially higher Fmax
```

The extra register also adds sequential hardware and increases latency.

---

# 17. Important Constraint

The synthesis experiment must not change constraints other than:

```text
Clock period
```

Do not modify other timing or synthesis constraints to artificially improve the result.

---

# 18. What the Assignment Is Teaching

The assignment connects:

```text
RTL Architecture
      ↓
Gate-level Structure
      ↓
Critical Path
      ↓
Timing Delay
      ↓
Maximum Frequency
```

It demonstrates that functional correctness alone does not guarantee high performance.

An architecture containing a long combinational path can limit the maximum clock frequency. Pipelining can break that path into smaller sections, potentially allowing a shorter clock period.

---

# 19. Key Concepts

### Shift-and-Add Multiplication

```text
Multiplier bits
      ↓
Partial products
      ↓
Shift / Align
      ↓
Add / Accumulate
      ↓
Product
```

### Pipelining

```text
Long path
   ↓
Insert register
   ↓
Two shorter paths
```

### Timing Optimization

```text
Critical delay ↓
      ↓
Minimum clock period ↓
      ↓
Maximum frequency ↑
```

### Latency Trade-off

```text
2 cycles → 3 cycles
```

---

# 20. Assignment Requirements — Checklist

## Initial Design

- [ ] Run synthesis.
- [ ] Start at a 10 ns clock period.
- [ ] Gradually reduce clock period.
- [ ] Keep all constraints unchanged except clock period.
- [ ] Find the maximum frequency without timing violations.

## Critical Path

- [ ] Identify the critical path.
- [ ] Determine the design unit contributing most to critical delay.

## Optimization

- [ ] Add a pipeline register to the critical path.
- [ ] Confirm the latency increases from 2 to 3 cycles.

## Final Synthesis

- [ ] Re-run synthesis.
- [ ] Repeat the clock-period sweep.
- [ ] Find the new maximum frequency without timing violations.
- [ ] Compare the original and modified results.

---

# 21. Information Not Provided by the Source

The PDF does not provide actual synthesis results. Therefore, the following cannot be determined from the document alone:

- Initial `Fmax`
- Initial minimum passing clock period
- Actual critical path
- Exact unit responsible for the largest delay
- New `Fmax`
- New minimum passing clock period
- Exact timing improvement
- Exact area/power change
- Exact location where the new pipeline register should be inserted

These values must come from the actual synthesis run and timing reports.

---

# 22. Source Fidelity Note

This Markdown preserves the architecture, numerical example, pipeline description, and synthesis requirements stated in the uploaded PDF.

Where the source does not provide synthesis measurements, this document explicitly marks them as **to be determined** rather than inventing results.

