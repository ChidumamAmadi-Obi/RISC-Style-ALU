`ifndef _CONSTANTS_ // file guard
`define _CONSTANTS_

// op codes for ALU
`define OP_ADD              5'b00000
`define OP_SUB              5'b00001
`define OP_AND              5'b00010
`define OP_OR               5'b00011
`define OP_XOR              5'b00100
`define OP_NAND             5'b00101
`define OP_NOR              5'b00110
`define OP_XNOR             5'b00111 

`define OP_EQU              5'b01000
`define OP_GREATER_THAN     5'b01001
`define OP_LESS_THAN        5'b01010

`define OP_ROTATE_RIGHT     5'b01100
`define OP_ROTATE_LEFT      5'b01101

`define OP_MODULO           5'b01110
`define OP_DIVIDE           5'b01111
`define OP_MULT             5'b10000
`define OP_MFHI             5'b10001 // move from high register
`define OP_MFLO             5'b10010 // move from low register

// CONFIG
`define TESTS 21               // number of tests in ALU_tb.v
`define OPERAND_WIDTH 2             // define bit length 
`define MULT_WIDTH `ARG_WIDTH*2 // multiplication result
`define SEL_WIDTH 5 

`define MAX_BARREL_SHIFT 1 // alu can currently only bit shift once

`endif