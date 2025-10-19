# 32-Bit ALU on the Tang Nano 9k FPGA

32-bit Arithmetic Logic Unit (ALU) on the Gowin Tang Nano 9K FPGA using Verilog. This project aims to deepen my understanding of digital design, Verilog, and FPGA workflows.

## Project Status
🚧 In Progress

## Demos
### Basic 6-bit counter example

[](https://github.com/user-attachments/assets/b11a7958-a44b-474c-aaa3-fad2576f609f)

![](https://github.com/user-attachments/assets/b11a7958-a44b-474c-aaa3-fad2576f609f)

## Features (Planned)
- [x] Basic Arithmetic (ADD, SUB)
- [x] Bitwise Logic (AND, OR, XOR, NOT)
- [ ] Barrel Shifter
- [ ] Multiply/Divide (Extension)
- [ ] Seven-Segment Display Output
- [ ] UART Debugging Interface

## Tools
- **HDL:** Verilog
- **FPGA:** Gowin Tang Nano 9K (GW1NR-LV9)
- **IDE:** VSCode
- **Extensions:**
        Verilog-HDL/SystemVerilog/Bluespec SystemVerilog by Masahiro Hiramori
        WaveTrace by wavetrace
        Lushay Code by Lushay Labs
- **Simulation & Synthesis Tool:** Icarus Verilog

## Repository Structure
```
        /src        -> Verilog source files
        /tb         -> Testbench files
        /doc        -> Documentation, block diagrams
        /constraints-> Physical constraint files (.cst)
```
## Useful Links
[Verilog Cheat Sheet](https://cheatsheetshero.com/user/all/476-verilog-cheatsheet.pdf)

[Tang Nano 9k Information & Resources](https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html)

[Icarus Verilog](https://steveicarus.github.io/iverilog/)
