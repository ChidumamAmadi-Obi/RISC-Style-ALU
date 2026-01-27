`ifndef _CONSTANTS_ // file guard
`define _CONSTANTS_

`timescale 1ns/1ps // specifies the time units and precision for sim

// CONFIG
parameter OPERAND_WIDTH=8;               // define bit length 
parameter FULL_RESULT_WIDTH=OPERAND_WIDTH+1;
parameter INST_ADDR_LENGTH=3;
parameter INST_REG_FILE_SIZE=3;

// op codes for ALU
typedef enum {
    OP_ADD,             // 0
    OP_SUB,             // 1
    OP_AND,             // 2
    OP_OR,              // 3
    OP_XOR,             // 4
    OP_NAND,            // 5
    OP_NOR,             // 6
    OP_XNOR,            // 7
    OP_EQU,             // 8
    OP_GREATER_THAN,    // 9
    OP_LESS_THAN,       // 10
    OP_ROTATE_RIGHT,    // 11
    OP_ROTATE_LEFT,     // 12
    OP_DIVIDE,          // 13
    OP_MULT,            // 14
    OP_MFHI,            // 15 ,move from low register
    OP_MFLO             // 16 ,move from high register
} ALUOpcodes;

`endif
