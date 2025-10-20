`ifndef _CONSTANTS_ // file guard
`define _CONSTANTS_

// op codes for ALU
`define OP_ADD              4'b0000
`define OP_SUB              4'b0001
`define OP_AND              4'b0010
`define OP_OR               4'b0011
`define OP_XOR              4'b0100
`define OP_NAND             4'b0101
`define OP_NOR              4'b0110
`define OP_XNOR             4'b0111 

`define OP_EQU              4'b1000
`define OP_GREATER_THAN     4'b1001
`define OP_LESS_THAN        4'b1010

`define OP_MULTIPLY         4'b1100
`define OP_DIVIDE           4'b1101
`define OP_MODULO           4'b1110
`define OP_B_SHIFT_RIGHT    4'b1111

`define TESTS 19 // number of tests in ALU_tb.v

`endif