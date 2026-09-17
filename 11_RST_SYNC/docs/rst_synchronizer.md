# RST Synchronizer

## 1. Introduction

Asynchronous reset has many issues during de-assertion as it may violate the **recovery** and **removal** times of the Flip Flop.

Therefore, a **Reset Synchronizer** in a digital circuit is needed to synchronize the de-assertion of the asynchronous reset with respect to the clock domain.

In other words, a reset synchronizer manipulates the asynchronous reset to have **synchronous de-assertion**.

---

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
| `NUM_STAGES` | Number of Flip Flop Stages |

---

## 3. Block Diagram

The source PDF contains a block diagram for the reset synchronizer.

**Hint from the source:** The above block diagram is used to synchronize the de-assertion of the **active-low reset**.

---

## 4. Functional Concept

The specified design takes an asynchronous reset and produces a synchronized reset for the destination clock domain.

The key requirement is to synchronize **reset de-assertion** with respect to `CLK`.

### Reset assertion

The input `RST` is an asynchronous reset.

### Reset de-assertion

The de-assertion of the asynchronous reset must be synchronized to the destination-domain clock.

The purpose is to avoid recovery/removal timing violations associated with asynchronous reset release.

---

## 5. Why Reset Synchronization Is Required

The source identifies two timing concerns:

### Recovery Time

Asynchronous reset de-assertion can violate the flip-flop recovery requirement if reset release occurs too close to a relevant clock edge.

### Removal Time

Asynchronous reset de-assertion can also violate the flip-flop removal requirement.

A reset synchronizer addresses these issues by controlling reset release so that **de-assertion is synchronous with the destination clock domain**.

---

## 6. Parameterization

### `NUM_STAGES`

`NUM_STAGES` specifies the **number of flip-flop stages** in the synchronizer.

The PDF does not specify a default value for this parameter.

The number of stages is therefore configurable.

---

## 7. Required RTL

The assignment requires:

1. Write a **Verilog Code** to capture the above block diagram.
2. Write a **testbench** to validate the de-assertion of the asynchronous reset to be synchronous with the clock edge.

---

## 8. Verification Requirement

The testbench must verify that when the asynchronous active-low reset is de-asserted, the resulting `SYNC_RST` de-assertion occurs synchronously with the destination `CLK`.

The verification should therefore exercise the relationship between:

- `RST`
- `CLK`
- `SYNC_RST`
- `NUM_STAGES`

---

## 9. Signal Summary

| Signal | Description | Width |
|---|---|---:|
| `RST` | Asynchronous reset | 1 |
| `CLK` | Destination domain clock | 1 |
| `SYNC_RST` | Synchronized Reset | 1 |

---

## 10. Architecture Summary

```text
                +----------------------+
RST ----------->|                      |
                |   RST Synchronizer   |-----> SYNC_RST
CLK ----------->|                      |
                +----------------------+
                         ^
                         |
                   NUM_STAGES
```

The exact internal block diagram should follow the diagram provided in the source PDF.

---

## 11. Requirements Checklist

### RTL

- [ ] Implement the RST Synchronizer in Verilog.
- [ ] Support asynchronous reset input `RST`.
- [ ] Use destination clock `CLK`.
- [ ] Generate synchronized reset `SYNC_RST`.
- [ ] Parameterize the number of flip-flop stages using `NUM_STAGES`.

### Testbench

- [ ] Generate a destination-domain clock.
- [ ] Apply the asynchronous reset.
- [ ] De-assert the reset at a time that is not necessarily aligned with the clock.
- [ ] Verify that `SYNC_RST` de-assertion is synchronized to a clock edge.
- [ ] Validate behavior according to the configured `NUM_STAGES`.

---

## 12. Source-Derived Information

The original PDF explicitly specifies:

- Asynchronous reset de-assertion can cause recovery/removal violations.
- A reset synchronizer is required to synchronize reset de-assertion with the clock domain.
- The reset is active low.
- The block has inputs `RST` and `CLK`.
- The block produces `SYNC_RST`.
- `NUM_STAGES` is the parameter controlling the number of flip-flop stages.
- The RTL must be written in Verilog.
- A testbench must validate synchronous reset de-assertion.

---

## 13. Information Not Explicitly Specified

The PDF does **not** explicitly specify:

- The actual Verilog RTL.
- The actual testbench.
- A default value for `NUM_STAGES`.
- Exact clock frequency.
- Exact reset timing values.
- Recovery/removal timing numbers.
- Detailed RTL equations.
- A simulator/tool requirement.
- A detailed textual description of every internal block in the diagram.

Therefore, these details should not be treated as requirements from the source without additional information.

---

## 14. Original Extracted Content

For reference, the source text is:

```text
Synchronizer
 
RST
 
 
 
Introduction: -
 
 
Asynchronous reset has many issues during de-assertion as it may 
violate the recovery and removal times of the Flip Flop, so Reset 
Synchronizer in digital circuit is needed to synchronize the de-assertion 
of the asynchronous reset with respect to the clock domain. In other 
words, a reset synchronizer manipulates the asynchronous reset to have 
. 
tion
r
asse
-
synchronous de
 
 
 
Block Interface
 
 
Ports Description
 
 
 
 
Width
 
Description
 
Signal Name
 
1
 
Asynchronous reset
 
RST
 
1
 
Destination domain clock
 
CLK
 
1
 
Synchronized Reset 
 
SYNC_RST
 


Parameter Description
 
 
 
 
Block Diagram
 
 
 
Hint: The above block diagram is used to synchronize the de-
assertion of the active low reset.
 
 
 
Required
 
 
1. Write a Verilog Code to capture the above block diagram. 
 
2. Write a testbench to validate the de-assertion of the 
asynchronous reset to be synchronous with the clock edge. 
 
Description
 
parameter Name
 
Number of Flip Flop Stages 
 
NUM_STAGES
 

```

---

## 15. Final Assignment Summary

The required project is an **RST Synchronizer** whose purpose is to convert the de-assertion of an asynchronous active-low reset into a reset de-assertion synchronized to the destination clock.

### Interface

```text
Parameter:
    NUM_STAGES = Number of Flip Flop Stages

Inputs:
    RST = Asynchronous reset
    CLK = Destination domain clock

Output:
    SYNC_RST = Synchronized Reset
```

### Required Work

1. Implement the block in Verilog.
2. Implement a testbench.
3. Verify that asynchronous reset de-assertion becomes synchronous with the destination clock edge.
