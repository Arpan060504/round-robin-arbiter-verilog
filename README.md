# Round Robin Arbiter (Verilog HDL)

A synthesizable **4-input Round Robin Arbiter** implemented in Verilog HDL.

The arbiter fairly allocates a shared resource among multiple requesters by rotating the priority after every successful grant, preventing starvation unlike a fixed-priority arbiter.

The project also includes a **self-checking testbench** and waveform verification using **GTKWave**.

---

# Features

- 4 Request Inputs
- One-Hot Grant Output
- Fair Round Robin Scheduling
- Starvation-Free Arbitration
- Synthesizable Verilog RTL
- Self-checking Testbench
- GTKWave Simulation Support

---

# Problem Statement

Consider four masters trying to access a shared memory.

```
Master0
Master1
Master2
Master3
      │
      ▼
+----------------------+
| Round Robin Arbiter  |
+----------------------+
      │
      ▼
 Shared Resource
```

If multiple masters request simultaneously, the arbiter grants access according to a rotating priority instead of a fixed priority.

---

# Why Round Robin?

A fixed priority arbiter always gives preference to the highest priority requester.

Example:

```
Priority Order

0 > 1 > 2 > 3
```

If Master0 continuously requests,

```
Master0 = 1
Master1 = 1
Master2 = 1
Master3 = 1
```

Master1, Master2 and Master3 may never receive access.

This problem is called **starvation**.

Round Robin eliminates starvation by rotating the priority after every successful grant.

---

# Arbitration Algorithm

The arbiter stores a pointer indicating where the next arbitration should begin.

Example:

Current Pointer

```
Pointer = 2
```

Requests

```
req = 1011
```

Search Order

```
2
↓

3
↓

0
↓

1
```

The first active requester is granted access.

After granting,

```
pointer = winner + 1
```

Thus the next arbitration begins from the next requester.

---

# Inputs

| Signal | Width | Description |
|---------|------:|-------------|
| clk | 1 | System Clock |
| reset | 1 | Active High Reset |
| req | 4 | Request Inputs |

---

# Outputs

| Signal | Width | Description |
|---------|------:|-------------|
| grant | 4 | One-Hot Grant |

Example

```
req = 1010

grant = 1000
```

Master3 receives access.

---

# Internal Architecture

Registers

```
pointer
winner
next_1
next_2
next_3
```

The pointer stores the starting position for the next arbitration cycle.

Temporary indices are generated to perform circular searching.

---

# RTL Flow

```
               Request Inputs
                      │
                      ▼
             Start Search from Pointer
                      │
                      ▼
         Check Current Requester
                      │
      ┌───────────────┴───────────────┐
      │                               │
      ▼                               ▼
 Request Found                  Move to Next
      │
      ▼
 Generate Grant
      │
      ▼
 Update Winner
      │
      ▼
Pointer <= Winner + 1
```

---

# Simulation

Simulation Tool

- Icarus Verilog

Waveform Viewer

- GTKWave

Compile

```bash
iverilog -o simv rtl/round_robin_arbiter.v tb/round_robin_arbiter_tb.v
```

Run

```bash
vvp simv
```

Open Waveform

```bash
gtkwave robin_test.vcd
```

---

# Test Cases

### Single Request

```
req = 1000

grant = 1000
```

---

### Single Request

```
req = 0001

grant = 0001
```

---

### Multiple Requests

```
req = 1001
```

Expected Grants

```
Cycle 1

0001

Cycle 2

1000
```

---

### Multiple Requests

```
req = 0110
```

Expected Grants

```
Cycle 1

0010

Cycle 2

0100
```

---

### Idle State

```
req = 0000

grant = 0000
```

---

# Waveform

Insert GTKWave screenshot here.

Example

```
waveform/
    waveform.png
```

---

# Learning Outcomes

This project demonstrates:

- Verilog RTL Design
- Combinational Logic
- Sequential Logic
- Blocking vs Non-Blocking Assignments
- Pointer-Based Arbitration
- Round Robin Scheduling
- Self-checking Testbench Development
- Functional Verification
- GTKWave Debugging

---

# Future Improvements

- Parameterized N-input Arbiter
- Weighted Round Robin Arbiter
- Mask-Based Round Robin Arbiter
- SystemVerilog Assertions
- Randomized Testbench
- UVM Verification Environment

---

# Author

**Arpan Chandra**
**NIT Durgapur**

B.Tech Electrical Engineering 2023-27

National Institute of Technology Durgapur

Interested in Digital Design, RTL Design, Computer Architecture and VLSI.
