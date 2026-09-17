# System Backend Flow Assignment — Detailed Analysis

## 1. Assignment Overview

The assignment requires taking the **System** design through the digital backend flow stages:

1. Synthesis
2. Formality post-synthesis
3. DFT
4. Formality post-DFT

The source explicitly lists these four stages. The purpose of the assignment is to synthesize the RTL, verify equivalence after synthesis, prepare the design for scan/DFT insertion, insert and check DFT, and finally verify equivalence again after DFT.

> **Source note:** This document explains exactly what is stated in the assignment. Where the source does not provide an exact command, filename, cell name, or port list, this document does not invent one.

---

## 2. Initial Project Setup

### Required directory setup

The first step is:

- Create a `Projects` folder inside the `IC` directory.
- Copy the `System` folder from the user's computer into the virtual machine, inside `Projects`.

Conceptually:

```text
IC/
└── Projects/
    └── System/
        ├── RTL / source files
        ├── constraints
        └── backend scripts/files
```

The assignment does not specify the complete internal file hierarchy of the `System` folder, so the exact contents should follow the supplied project environment.

---

# 3. Synthesis Stage

The synthesis stage converts the RTL System design into a gate-level implementation using the target standard-cell libraries and the timing/environment constraints defined in `cons.tcl`.

The assignment specifically requires adding several categories of constraints to `cons.tcl` before running synthesis.

---

## 3.1 Master Clocks

The assignment requires creating two master clocks:

| Clock | Frequency | Approx. Period |
|---|---:|---:|
| `REF_CLK` | 50 MHz | 20 ns |
| `UART_CLK` | 3.686 MHz | ≈271.49 ns |

The source explicitly specifies `REF_CLK (50 MHz)` and `UART_CLK (3.686 MHz)`. fileciteturn9file0L11-L16

### What is a master clock?

A master clock is a primary clock entering the design directly as an external clock source. Timing analysis uses it as the reference from which sequential timing relationships are established.

### Period calculation

For a clock:

\[
T=\frac{1}{f}
\]

For `REF_CLK`:

\[
T_{REF}=\frac{1}{50\times10^6}=20\ ns
\]

For `UART_CLK`:

\[
T_{UART}=\frac{1}{3.686\times10^6}\approx271.29\ ns
\]

The exact constraint should follow the assignment/environment's expected clock definition.

---

# 4. Generated Clocks

The assignment requires three generated clocks:

| Generated Clock | Master Clock | Division Ratio |
|---|---|---:|
| `ALU_CLK` | `REF_CLK` | 1 |
| `RX_CLK` | `UART_CLK` | 1 |
| `TX_CLK` | `UART_CLK` | 32 |

These are explicitly required in the synthesis constraints. fileciteturn9file0L16-L19

## 4.1 Why generated clocks are needed

A generated clock is derived from another clock inside or around the design. Static timing analysis needs to know the relationship between the generated clock and its source/master clock.

### ALU_CLK

```text
REF_CLK
   │
   └── divide by 1 ──> ALU_CLK
```

Because the division ratio is 1, the generated clock has the same fundamental period as `REF_CLK`.

### RX_CLK

```text
UART_CLK
   │
   └── divide by 1 ──> RX_CLK
```

Again, divide-by-1 means the generated clock has the same fundamental period as its master.

### TX_CLK

```text
UART_CLK
   │
   └── divide by 32 ──> TX_CLK
```

The intended relationship is a much slower generated TX clock:

\[
T_{TX}\approx32T_{UART}
\]

The assignment gives the division ratio as 32. fileciteturn9file0L16-L19

---

# 5. Clock Uncertainty

The assignment requires clock uncertainty for both master and generated clocks:

- **Setup uncertainty = 0.2 ns**
- **Hold uncertainty = 0.1 ns**

This is explicitly stated in the source. fileciteturn9file0L20-L21

## 5.1 Setup uncertainty

Setup uncertainty reduces the available timing margin for data arriving before the active clock edge.

Conceptually:

```text
Available setup time
        ↓
Clock period ─── uncertainty ───> usable timing window
```

A larger setup uncertainty makes setup timing more difficult.

## 5.2 Hold uncertainty

Hold uncertainty affects the amount of time data must remain stable after the active clock edge.

A larger hold uncertainty makes hold timing more difficult.

### Required values

```text
Setup uncertainty = 0.2 ns
Hold uncertainty  = 0.1 ns
```

These values must be applied to the relevant master and generated clocks as requested by the assignment.

---

# 6. Clock Transition

The assignment requires:

```text
Clock transition = 0.05 ns
```

for **all master clocks**. fileciteturn9file0L22-L23

Clock transition represents the assumed slew/transition characteristic of the clock signal at the clock definition point.

The assignment specifically says to apply the transition to master clocks.

---

# 7. Dont-Touch on Clocks

The assignment requires:

> Set `dont_touch` on all master and generated clocks.

This is explicitly specified in the source. fileciteturn9file0L22-L24

The purpose in the context of the assignment is to protect the clock objects from unintended optimization/modification during the synthesis flow.

Important distinction:

- The assignment asks for `dont_touch` on the **clock objects**.
- This is not the same statement as putting `dont_touch` on every clock buffer/cell in the design.

Follow the exact interpretation expected by the supplied flow/scripts.

---

# 8. Clock Grouping

The assignment requires **clock grouping**. fileciteturn9file0L24-L24

Clock grouping tells the timing engine which clock domains should be treated as related or unrelated according to the intended design environment.

The source does not explicitly specify the exact `set_clock_groups` options or which clocks belong to which groups.

Therefore, the exact clock-group command should be taken from the project's intended timing methodology rather than invented from this PDF alone.

---

# 9. Input Delays

The assignment requires:

> Input delays on all input ports except `CLK` and `RST` with 20% of the clock period.

This is explicitly stated. fileciteturn9file0L24-L26

## Why input delay is needed

The design does not operate in isolation. External logic drives its inputs. Input delay models the amount of time after a reference clock edge that an external signal is assumed to arrive.

For a clock period \(T\):

\[
Input\ Delay=0.2T
\]

### Examples

For `REF_CLK = 50 MHz`:

\[
T=20ns
\]

\[
Input\ Delay=0.2(20)=4ns
\]

For `UART_CLK ≈ 3.686 MHz`:

\[
T\approx271.3ns
\]

\[
Input\ Delay\approx54.3ns
\]

The exact clock association for each port depends on the design's clock-domain relationship.

### Exceptions

The assignment explicitly excludes:

- `CLK`
- `RST`

from the general input-delay requirement.

---

# 10. Output Delays

The assignment requires:

> Output delays on all output ports with 20% clock period.

This is explicitly stated. fileciteturn9file0L25-L26

The conceptual formula is:

\[
Output\ Delay=0.2T
\]

Output delay models the timing requirement imposed by the external environment receiving the System's outputs.

As with input delays, the correct reference clock depends on the relevant interface/clock domain.

---

# 11. Input Driving Cell

The assignment requires adding a **buffer driving cell** for all input ports except:

- `CLK`
- `RST`

This requirement is explicitly stated. fileciteturn9file0L26-L28

## Why a driving cell is modeled

Synthesis timing analysis needs a realistic representation of how external logic drives the design inputs. A driving-cell model provides an assumed source drive strength and therefore affects input transition and timing calculations.

The PDF does not specify the exact buffer cell name. Therefore, the correct cell name must come from the technology library/project setup.

---

# 12. Output Load

The assignment requires:

```text
Output load = 0.1 pF
```

on **all output ports**. fileciteturn9file0L27-L28

## Why load is important

The output load affects:

- output transition
- cell delay
- timing
- potentially synthesis optimization

A larger load generally makes it harder for a driver to switch quickly.

The required value is:

\[
C_L=0.1pF
\]

---

# 13. Operating Conditions

The assignment requires setting the operating condition using both:

- **slow libraries**
- **fast libraries**

This is explicitly required. fileciteturn9file0L28-L29

## Why slow and fast conditions matter

Digital timing changes with process/environment conditions.

A simplified interpretation is:

```text
Slow condition → cells tend to be slower → important for setup
Fast condition → cells tend to be faster → important for hold
```

The exact library names and operating-condition names are not provided in the PDF, so they must come from the project's technology/library files.

---

# 14. Synthesis Execution and Checks

After adding the required constraints, the assignment says to run synthesis and check three main categories:

1. Synthesis log
2. Setup timing
3. Hold timing

The source explicitly states these checks. fileciteturn9file0L30-L33

---

## 14.1 Synthesis Log

The assignment requires:

> No errors, loops and latches in `syn.log`.

Therefore, after synthesis inspect:

```text
syn.log
```

and verify that there are:

- no synthesis errors
- no unintended combinational/sequential loops
- no unintended latches

### Why latches matter

An unintended latch usually indicates incomplete combinational assignment or an RTL coding problem. It can change the intended hardware and complicate timing verification.

### Why loops matter

A combinational loop creates a feedback path without an intended storage element. This can prevent meaningful timing analysis or indicate an RTL/design issue.

---

# 15. Setup Timing Check

The assignment requires checking the **setup timing analysis report** for violating paths. fileciteturn9file0L30-L33

## Setup concept

For a register-to-register path:

```text
Launch FF ── combinational logic ──> Capture FF
```

The data must arrive sufficiently early before the capture edge.

Conceptually:

\[
T_{clk} \ge T_{cq}+T_{comb}+T_{setup}+T_{uncertainty}
\]

A setup violation means the data path is too slow for the required timing constraint.

The assignment does not specify a numerical maximum allowed setup slack; therefore, do not assume one beyond the flow's expected clean/no-violation requirement.

---

# 16. Hold Timing Check

The assignment also requires checking the **hold timing analysis report** for violating paths. fileciteturn9file0L30-L33

## Hold concept

After the capture clock edge, the data must remain stable for the required hold interval.

Conceptually:

\[
T_{cq(min)}+T_{comb(min)} \ge T_{hold}+T_{uncertainty}
\]

A hold violation usually means the data reaches the destination too quickly.

The assignment requires checking the report for violations; the PDF does not provide a separate numerical hold target.

---

# 17. Formality Post-Synthesis

After synthesis, the next stage is **Formality post-synthesis**.

The assignment requires:

> Run Formality and check it is succeeded with no failing points.

This is explicitly stated. fileciteturn9file0L34-L35

## Purpose

Formality performs formal equivalence checking between two representations of the design.

At this stage, the conceptual comparison is:

```text
RTL / Reference Design
          │
          │ Formal Equivalence
          ▼
Synthesized Design
```

The purpose is to verify that synthesis did not change the intended logical behavior.

## Required result

The assignment's success criterion is:

```text
Formality = SUCCESS
Failing points = 0
```

The PDF does not specify the exact Formality TCL script or exact reference/implementation file names, so those must come from the project environment.

---

# 18. DFT Stage

After successful post-synthesis Formality, the assignment moves to DFT.

DFT means **Design for Test**. In this assignment, the specified DFT flow centers around scan chains and test-mode control.

The source requires creating a new file:

```text
SYS_TOP_dft.v
```

inside the `SYS_TOP` folder. fileciteturn9file0L37-L39

---

# 19. SYS_TOP_dft.v

The assignment says that `SYS_TOP_dft.v` must contain the RTL preparation needed for DFT.

Specifically, it requires:

1. Adding scan ports with the **exact names as shown** in the assignment.
2. Adding muxes on clocks and resets.

These requirements are explicitly stated. fileciteturn9file0L38-L41

### Important

The PDF text available here does not expose the actual scan-port names referred to by “exact names as shown”. Therefore, this analysis does **not** invent SI/SE/SO-related top-level names beyond the names explicitly appearing later in the constraints section.

---

# 20. Clock and Reset Muxes for DFT

The assignment requires adding muxes on:

- clocks
- resets

The basic idea is that normal functional operation and scan/test operation may need different control sources.

Conceptually:

```text
                 ┌──────────────┐
Functional CLK ──┤              │
SCAN_CLK ────────┤ Clock MUX     ├──> Design clock
                 │              │
                 └──────┬───────┘
                        │
                       SE / test control
```

The exact mux implementation and test-mode connectivity must follow the project requirements; the PDF only specifies that the muxes must be added.

---

# 21. DFT Constraints in cons.tcl

The assignment requires several additional constraints in `cons.tcl`.

They are:

1. Scan clock constraint using `create_clock`
2. Add `SCAN_CLK` group in clock grouping
3. Input delays on scan input ports `SI`, `SE`
4. Output delay on scan output port `SO`
5. Buffer driving cells on `SI`, `SE`
6. Load of 0.1 pF on `SO`
7. `set_case_analysis 1 [get_port test_mode]`

These requirements are explicitly listed in the source. fileciteturn9file0L42-L50

---

# 22. Scan Clock Constraint

The assignment requires creating the scan clock using:

```tcl
create_clock
```

The source calls the scan clock `SCAN_CLK`. fileciteturn9file0L42-L44

The exact period/value is not provided in the PDF excerpt, so it should come from the project's scan-test specification.

---

# 23. SCAN_CLK Clock Group

The assignment requires adding a `SCAN_CLK` group to the clock grouping command. fileciteturn9file0L43-L45

This ensures the timing environment explicitly accounts for the scan clock domain according to the intended clock-group methodology.

Again, the PDF does not provide the complete grouping command.

---

# 24. Scan Input Delays

The assignment requires input delays on:

- `SI`
- `SE`

with **20% of the scan clock period**. fileciteturn9file0L45-L46

Conceptually:

\[
Delay_{SI}=Delay_{SE}=0.2T_{SCAN}
\]

where \(T_{SCAN}\) is the scan-clock period.

---

# 25. Scan Output Delay

The assignment requires an output delay on:

```text
SO
```

with 20% of the scan-clock period. fileciteturn9file0L45-L46

Therefore:

\[
Delay_{SO}=0.2T_{SCAN}
\]

---

# 26. Scan Input Driving Cells

The assignment requires a buffer driving cell on:

- `SI`
- `SE`

This is explicitly stated. fileciteturn9file0L46-L48

The exact library buffer name is not supplied in the PDF and must be taken from the technology library/project setup.

---

# 27. Scan Output Load

The assignment requires:

```text
SO load = 0.1 pF
```

This is explicitly stated. fileciteturn9file0L47-L48

---

# 28. test_mode Case Analysis

The assignment requires:

```tcl
set_case_analysis 1 [get_port test_mode]
```

The source explicitly says this command is used to run timing analysis using the scan clock. fileciteturn9file0L49-L50

## Meaning

Setting:

```text
test_mode = 1
```

forces the timing analysis into the test/scan configuration.

This allows the timing tool to analyze the design as it operates in scan mode rather than normal functional mode.

---

# 29. DFT Sections Required

The assignment explicitly requires adding all of the following DFT sections:

1. Architecture Scan Chains
2. Define DFT Signals
3. Create Test Protocol
4. Pre-DFT Design Rule Checking
5. Preview DFT
6. Insert DFT
7. Design Rule Checking post DFT insertion

These seven sections are listed in the source. fileciteturn9file0L51-L58

---

## 29.1 Architecture Scan Chains

This section defines the scan-chain architecture.

The purpose is to specify how the sequential elements will be connected into scan chains for test access.

Conceptually:

```text
SI → Scan FF → Scan FF → Scan FF → ... → Scan FF → SO
```

The exact number of chains and scan-cell architecture are not specified in the PDF.

---

## 29.2 Define DFT Signals

The DFT flow needs to know the signals controlling and observing test operation.

The assignment separately identifies signals including:

- `SI`
- `SE`
- `SO`
- `SCAN_CLK`
- `test_mode`

The exact declaration/assignment methodology is not specified beyond the required DFT flow.

---

## 29.3 Create Test Protocol

A test protocol describes the intended sequence/conditions used to operate the design during scan testing.

The PDF requires this section but does not provide the exact protocol commands or test vectors.

---

## 29.4 Pre-DFT Design Rule Checking

Before inserting scan logic, DFT design-rule checks must be performed.

The purpose is to detect structural problems that would prevent successful scan insertion or reduce testability.

The assignment requires this stage but does not provide the detailed rule list.

---

## 29.5 Preview DFT

Preview DFT is performed before actual insertion to inspect what the DFT tool intends to implement.

This is useful for checking the planned scan architecture before modifying the design.

---

## 29.6 Insert DFT

This is the actual scan/DFT insertion step.

Conceptually:

```text
Synthesized design
       │
       ▼
DFT / Scan insertion
       │
       ▼
Scan-enhanced design
```

The result is the DFT-modified design representation.

---

## 29.7 Post-DFT Design Rule Checking

After DFT insertion, the design must be checked again.

The assignment explicitly requires **Design Rule Checking post DFT insertion**. fileciteturn9file0L56-L58

This verifies that the inserted DFT structures satisfy the required DFT rules.

---

# 30. DFT Execution Checks

After running DFT, the assignment requires four categories of checks:

1. DFT log errors
2. Setup timing
3. Hold timing
4. DFT coverage

The source explicitly specifies all four. fileciteturn9file0L59-L63

---

## 30.1 DFT Log

The assignment requires:

> No errors, loops and latches in `dft.log`.

Therefore:

```text
dft.log
```

must be inspected for:

- errors
- loops
- latches

This is analogous to the synthesis-log check but is performed after/within the DFT flow.

---

# 31. Post-DFT Setup Timing

The assignment requires checking the setup timing report for violating paths after DFT. fileciteturn9file0L59-L62

This is important because DFT insertion adds test-related structures and can alter timing paths.

The desired outcome is no violating paths under the assignment's constraints.

---

# 32. Post-DFT Hold Timing

The assignment also requires checking the hold timing report for violating paths after DFT. fileciteturn9file0L59-L62

Again, the DFT modifications must not leave unacceptable hold violations under the defined test timing environment.

---

# 33. DFT Coverage

The assignment explicitly requires:

\[
DFT\ Coverage > 98\%
\]

This is one of the clearest numerical acceptance criteria in the assignment. fileciteturn9file0L59-L63

Therefore:

```text
Coverage > 98%
```

must be achieved.

The PDF does not define which individual coverage components are included in the reported percentage, so the exact coverage report format should follow the DFT tool/project methodology.

---

# 34. Formality Post-DFT

The final required stage is Formality after DFT.

The assignment requires:

> Run Formality and check it is succeeded with no failing points.

This is explicitly stated. fileciteturn9file0L64-L65

The conceptual comparison is:

```text
Reference / expected design
            │
            │ Formal equivalence
            ▼
       Post-DFT design
```

Required result:

```text
Formality = SUCCESS
Failing points = 0
```

The source does not specify the exact Formality setup scripts or file names, so those should be taken from the provided project environment.

---

# 35. Complete Assignment Flow

The entire assignment can be visualized as:

```text
                 ┌─────────────────────┐
                 │   System RTL        │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │     Synthesis       │
                 │                     │
                 │ cons.tcl            │
                 │ clocks              │
                 │ generated clocks    │
                 │ uncertainty         │
                 │ input/output delay  │
                 │ drive/load           │
                 │ operating condition │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │ Synthesized Design  │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │ Formality           │
                 │ Post-Synthesis     │
                 └──────────┬──────────┘
                            │
                     SUCCESS / 0 FAIL
                            │
                            ▼
                 ┌─────────────────────┐
                 │      DFT            │
                 │                     │
                 │ SYS_TOP_dft.v       │
                 │ Scan ports          │
                 │ Clock/reset muxes   │
                 │ Scan constraints    │
                 │ Scan chains         │
                 │ Test protocol       │
                 │ DRC                 │
                 │ Preview             │
                 │ Insert DFT          │
                 │ Post-DFT DRC        │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │ Post-DFT Checks     │
                 │                     │
                 │ dft.log             │
                 │ Setup               │
                 │ Hold                │
                 │ Coverage > 98%      │
                 └──────────┬──────────┘
                            │
                            ▼
                 ┌─────────────────────┐
                 │ Formality           │
                 │ Post-DFT            │
                 └──────────┬──────────┘
                            │
                     SUCCESS / 0 FAIL
                            │
                            ▼
                    Assignment Complete
```

---

# 36. What You Must Configure in cons.tcl

A practical checklist directly derived from the assignment is:

## Functional/Synthesis constraints

- [ ] Create `REF_CLK` at 50 MHz
- [ ] Create `UART_CLK` at 3.686 MHz
- [ ] Create `ALU_CLK` generated from `REF_CLK`, divide ratio 1
- [ ] Create `RX_CLK` generated from `UART_CLK`, divide ratio 1
- [ ] Create `TX_CLK` generated from `UART_CLK`, divide ratio 32
- [ ] Setup uncertainty = 0.2 ns
- [ ] Hold uncertainty = 0.1 ns
- [ ] Clock transition = 0.05 ns for master clocks
- [ ] `dont_touch` master and generated clocks
- [ ] Clock grouping
- [ ] Input delays = 20% clock period, excluding CLK/RST
- [ ] Output delays = 20% clock period
- [ ] Buffer driving cell for inputs excluding CLK/RST
- [ ] Output load = 0.1 pF
- [ ] Slow/fast operating conditions

## DFT constraints

- [ ] Create `SCAN_CLK`
- [ ] Add `SCAN_CLK` to clock grouping
- [ ] SI input delay = 20% scan period
- [ ] SE input delay = 20% scan period
- [ ] SO output delay = 20% scan period
- [ ] Driving cell on SI
- [ ] Driving cell on SE
- [ ] Load = 0.1 pF on SO
- [ ] `set_case_analysis 1 [get_port test_mode]`

---

# 37. Acceptance Criteria

The assignment can be summarized by the following pass/fail criteria.

| Stage | Required Result |
|---|---|
| Synthesis | No errors, loops, or latches in `syn.log` |
| Synthesis timing | Check setup violations |
| Synthesis timing | Check hold violations |
| Formality post-synthesis | Successful, no failing points |
| DFT | No errors, loops, or latches in `dft.log` |
| Post-DFT timing | Check setup violations |
| Post-DFT timing | Check hold violations |
| DFT coverage | **> 98%** |
| Formality post-DFT | Successful, no failing points |

The individual requirements are directly stated in the assignment. fileciteturn9file0L30-L35 fileciteturn9file0L59-L65

---

# 38. Important Things the PDF Does NOT Specify

To avoid accidentally inventing information, the following are not explicitly given in the supplied two-page PDF:

- Exact standard-cell buffer driving-cell name
- Exact standard-cell library names
- Exact slow/fast operating-condition names
- Exact `set_clock_groups` command syntax/group membership
- Exact scan-clock period
- Exact SI/SE/SO top-level port declaration syntax
- Exact scan-chain count
- Exact scan-chain configuration
- Exact DFT tool commands
- Exact test-protocol commands
- Exact Formality TCL commands
- Exact synthesis TCL setup/read/elaborate commands
- Exact report filenames for timing after DFT
- Exact coverage breakdown

Therefore, these details should be obtained from the supplied project files, technology library, or instructor methodology rather than guessed.

---

# 39. Viva / Interview Questions You Should Be Able to Answer

## Synthesis

### Q1. Why do we create clocks?

Because STA needs the timing reference used to determine when data is launched and captured.

### Q2. Why do we create generated clocks?

Because clocks derived from other clocks need their timing relationship explicitly described to the timing engine.

### Q3. Why do we use setup uncertainty?

To reserve timing margin for clock-related uncertainty and make the setup requirement more realistic/conservative.

### Q4. Why do we use hold uncertainty?

To account for uncertainty affecting the minimum-time/hold requirement.

### Q5. Why exclude CLK and RST from ordinary input delay?

The assignment explicitly requires the 20%-period input delay on input ports **except CLK and RST**.

### Q6. Why add an input driving cell?

To model how external logic drives the input and therefore provide a realistic input transition/drive assumption.

### Q7. Why add output load?

Because external load affects output transition and cell delay.

---

## Formality

### Q8. What does post-synthesis Formality check?

It checks formal equivalence between the reference representation and the synthesized implementation.

### Q9. What is the required result?

The assignment requires Formality to succeed with no failing points.

---

## DFT

### Q10. What is DFT?

Design for Test: adding structures and controls that make manufacturing-test operations possible and improve controllability/observability.

### Q11. Why do we add scan chains?

Scan chains allow sequential elements to be connected into a controllable serial path so test data can be shifted in and observed/shifted out.

### Q12. Why are clock/reset muxes needed?

They allow the design's clock/reset behavior to be controlled appropriately between functional and test modes.

### Q13. Why is `test_mode` forced to 1 for the specified timing analysis?

Because the assignment explicitly requires `set_case_analysis 1 [get_port test_mode]` so timing is analyzed under the scan/test configuration.

### Q14. What is the required DFT coverage?

Greater than 98%.

### Q15. Why run Formality again after DFT?

Because DFT insertion modifies the synthesized design, so equivalence must be checked again to ensure the intended functional behavior has been preserved according to the equivalence setup.

---

# 40. Final Mental Model

The easiest way to remember the assignment is:

```text
RTL
 │
 │ 1. Apply timing/environment constraints
 ▼
SYNTHESIS
 │
 │ Check log + setup + hold
 ▼
SYNTHESIZED NETLIST
 │
 │ 2. Prove equivalence
 ▼
FORMALITY #1
 │
 │ Must succeed / 0 failing points
 ▼
DFT PREPARATION
 │
 │ Add scan ports + clock/reset muxes
 │ Add scan constraints
 ▼
DFT FLOW
 │
 │ Scan architecture
 │ DFT signals
 │ Test protocol
 │ Pre-DFT DRC
 │ Preview
 │ Insert
 │ Post-DFT DRC
 ▼
POST-DFT CHECKS
 │
 │ dft.log
 │ setup
 │ hold
 │ coverage > 98%
 ▼
FORMALITY #2
 │
 │ Must succeed / 0 failing points
 ▼
DONE
```

The core idea is therefore:

**Constrain → Synthesize → Verify → Add Testability → Verify Timing/Coverage → Verify Equivalence Again.**

---

## Source

This analysis is based on the supplied **System Assignment.pdf**, which is a two-page assignment specifying the synthesis, post-synthesis Formality, DFT, post-DFT Formality, constraints, and required checks. fileciteturn9file0L2-L35 fileciteturn9file0L37-L65
