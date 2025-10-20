# RISC_Style on the Tang Nano 9k FPGA (🚧 In Progress)
Configurable ALU capable of performing 16 unique arithmetic, logic, and comparative operations. With robust, self-checking testbench system.

### Demos
#### Basic 6-bit counter example
[](https://github.com/user-attachments/assets/b11a7958-a44b-474c-aaa3-fad2576f609f)

![](https://github.com/user-attachments/assets/b11a7958-a44b-474c-aaa3-fad2576f609f)

#### ALU Testbench Output
![testbenchhhh](https://github.com/user-attachments/assets/aeed3be7-3324-45e0-bcb4-759ae91585a7)

### Features
* Parameterized Design: Easily configurable data width for scalability.
* Comprehensive Operation Set: Supports 16 operations:<br>
  * Arithmetic: ADD, SUB, INCREMENT, DECREMENT, MODULO <br>
  * Bitwise Logic: AND, NAND, OR, NOR, XOR, XNOR, NOT <br>
  * Comparison: EQUAL, GREATER_THAN, LESS_THAN<br>
  * Flag Generation: Correctly asserts Zero, Carry, Overflow, and Error flags based on operation results. <br>
* Advanced Verification: Features a fully automated self-checking testbench with a custom bitmask-based error-tracking system for precise fault isolation.

### Roadmap
Phase 0: Validate Design Flow
- [x] **FPGA Hardware Implementation** (6-bit counter)

Phase 1: Core ALU _(Complete)_
- [x] **Arithmetic Operations** (ADD, SUB with status flags)
- [x] **Bitwise Logic Unit** (AND, OR, XOR, NAND, NOR, XNOR)
- [x] **Verification Suite** (Self-checking testbench)
- [x] **FPGA Validation** (6-bit counter hardware demo)
      
Phase 2: Enhanced Operations
- [ ] **Barrel Shifter** (Logical & arithmetic shifts, rotates)
- [x] **Comparison Unit** (EQU, GREATER_THAN, LESS_THAN from opcodes)
- [ ] **Multiplication Unit** (2-bit => 4-bit result with pipeline)
- [ ] **Division & Modulo** (Restoring division algo)

Phase 3: System Integration
- [ ] **8-bit Scalable Architecture** (Parameterized design)
- [ ] **Control Unit Integration** (Instruction decode & sequencing)
- [ ] **Seven-Segment Display Driver** (Hex output for debugging)

### Tools
- **HDL:** Verilog
- **FPGA:** Gowin Tang Nano 9K (GW1NR-LV9)
- **IDE:** VSCode
- **Extensions:**
        Verilog-HDL/SystemVerilog/Bluespec SystemVerilog by Masahiro Hiramori
        WaveTrace by wavetrace
        Lushay Code by Lushay Labs
- **Simulation & Synthesis Tool:** Icarus Verilog

### Repository Structure
```
        /src        -> Verilog source files
        /tb         -> Testbench files
        /doc        -> Documentation, block diagrams
        /constraints-> Physical constraint files (.cst)
```
### Useful Links
[Verilog Cheat Sheet](https://cheatsheetshero.com/user/all/476-verilog-cheatsheet.pdf) <br>
[Tang Nano 9k Information & Resources](https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html) <br>
[Icarus Verilog](https://steveicarus.github.io/iverilog/) <br>
[EDA Playground](https://www.edaplayground.com/)
