# RISC-Style ALU on Tang Nano 9k FPGA
Configurable ALU capable of performing 16+ unique arithmetic, logic, and comparative operations. With robust, self-checking testbench system. This project demonstrates a full digital design workflow from simulation to synthesis.

### Demos
#### 4-Bit Demo with 7-Seg Display
[](https://github.com/user-attachments/assets/7767e430-2b86-4e6b-9053-a797b878ebaf)
![](https://github.com/user-attachments/assets/7767e430-2b86-4e6b-9053-a797b878ebaf)

#### ALU Testbench Example Output
<img width="1031" height="880" alt="image" src="https://github.com/user-attachments/assets/4ac05799-ecb9-4851-9441-e90c56de1fff" />

#### Waveform Generated 
<img width="1847" height="429" alt="image" src="https://github.com/user-attachments/assets/59e6dc6a-8352-4552-b55d-2952295461fd" />

### Features
* **Parameterized Design:** Scalable data width (default 8-bit) for easy reuse and testing.
* **Comprehensive Operation Set:** Supports 16 operations like:<br>
  * Arithmetic: ADD, SUB, MULTIPLY, DIVIDE <br>
  * Bitwise Logic: AND, NAND, OR, NOR, XOR, XNOR <br>
  * Comparison: EQUAL, GREATER_THAN, LESS_THAN<br>
  * Barrel Shifting: ROTATE_LEFT, ROTATE_RIGHT <br>
* **Full Flag Generation:** Correctly asserts Zero, Carry, Overflow, and Error flags based on operation results. <br>
* **Advanced Verification:** Features a fully automated self-checking testbench with:
  * Custom bitmask-based error-tracking system for precise fault isolation.
  * Clear pass/fail report for reliability.
* **FPGA Validated:** Successfully synthesized and run on a Gowin Tang Nano 9K, with results displayed via a seven-segment display driver.
  
### Tools
- **HDL:** Verilog
- **FPGA:** Gowin Tang Nano 9K (GW1NR-LV9)
- **IDE:** VSCode
- **Extensions:** <br>
  - Verilog-HDL/SystemVerilog/Bluespec SystemVerilog by Masahiro Hiramori <br>
  - WaveTrace by wavetrace <br>
  - Lushay Code by Lushay Labs <br>
- **Simulation & Synthesis Tool:** Icarus Verilog



### Quick Start

1. Clone repo

```bash
    git clone https://github.com/chidumamamadi-obi/risc-style-alu.git
    cd risc-style-alu
```

2. Run Testbench with [EDAPlayground](https://www.edaplayground.com/) or VSCode (requires Icarus Verilog)

```bash
    cd tb
    iverilog -o ALU_tb ALU_tb.v
    vvp ALU_tb
```
*^ will execute the self-checking testbench and print the results to the console.*

3. View Waveforms
```bash
    open alu_tb.vcd # This will open in GTKWave or your default viewer
```

### Repository Structure
```
        /src        -> Verilog source files
        /tb         -> Testbench files
        /doc        -> Documentation, block diagrams
        /constraints-> Physical constraint files (.cst)
        /demo       -> Verilog source files synthesized on the FPGA
```

### Roadmap
Phase 0: Validate Design Flow
- [x] **FPGA Hardware Implementation** (6-bit counter)

Phase 1: Core ALU _(Complete)_
- [x] **Arithmetic Operations** (ADD, SUB with status flags)
- [x] **Bitwise Logic Unit** (AND, OR, XOR, NAND, NOR, XNOR)
- [x] **Verification Suite** (Self-checking testbench)
- [x] **FPGA Validation** (6-bit counter hardware demo)
      
Phase 2: Enhanced Operations
- [x] **Barrel Shifter** (Logical & arithmetic shifts, rotates)
- [x] **Comparison Unit** (EQU, GREATER_THAN, LESS_THAN from opcodes)
- [x] **Modulo**
- [x] **Multiplication & Division Unit** (2-bit => 4-bit multiplication result with pipeline)

Phase 3: System Integration
- [x] **8-bit Scalable Architecture** (Parameterized design)
- [x] **Synthesize** (Run full ALU on FPGA hardware)
- [x] **Seven-Segment Display Driver** (Hex output for debugging)

Future Improvements:
- [ ] **Control Unit Integration** (Instruction decode & sequencing)

### Useful Links
[Verilog Cheat Sheet](https://cheatsheetshero.com/user/all/476-verilog-cheatsheet.pdf) <br>
[Tang Nano 9k Information & Resources](https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html) <br>
[Icarus Verilog](https://steveicarus.github.io/iverilog/) <br>
[EDA Playground](https://www.edaplayground.com/)
