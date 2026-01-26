`ifndef _CONSTANTS_ // file guard
`define _CONSTANTS_

// op codes for ALU
parameter OP_ADD=0;
parameter OP_SUB=1;
parameter OP_AND=2;
parameter OP_OR=3;
parameter OP_XOR=4;
parameter OP_NAND=5;
parameter OP_NOR=6;
parameter OP_XNOR=7;

parameter OP_EQU=8;
parameter OP_GREATER_THAN=9;
parameter OP_LESS_THAN=10;

parameter OP_ROTATE_RIGHT=11;
parameter OP_ROTATE_LEFT=12;

parameter OP_DIVIDE=13;
parameter OP_MULT=14;
parameter OP_MFHI=15;// move from high register
parameter OP_MFLO=16; // move from low register

// CONFIG
parameter OPERAND_WIDTH=8;               // define bit length 
parameter FULL_RESULT_WIDTH=OPERAND_WIDTH+1;
parameter SEL_WIDTH=5;  
parameter TESTS=22;

`endif
