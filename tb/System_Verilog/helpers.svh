`ifndef HELPERS // file guard
`define HELPERS

    `include "ALU_constants.svh"

    function ExpectedALUOutputs calcExpectedOutputs ( // calculate expected alu outputs
      logic [OPERAND_WIDTH-1:0] a,
      logic [OPERAND_WIDTH-1:0] b,
      real sel);

        logic [FULL_RESULT_WIDTH-1:0] fullResult='0; // internal stuff
        static logic [OPERAND_WIDTH-1:0] hiReg=0; // hi and lo reg persist between calls like in ALU
        static logic [OPERAND_WIDTH-1:0] lowReg=0;

        ExpectedALUOutputs expected = {default: '0};

        case (sel)
            OP_ADD: begin
                fullResult = a + b;
                expected.result = fullResult[OPERAND_WIDTH-1:0];
                expected.error=0;
            end
            OP_SUB: begin
                fullResult = a - b;
                expected.result = fullResult[OPERAND_WIDTH-1:0];
                expected.error=0;
            end
            OP_AND: begin
                expected.result = a & b;
                expected.error=0;          
            end
            OP_OR:begin
                expected.result = a | b;
                expected.error=0;          
            end
            OP_XOR:begin
                expected.result = a ^ b;
                expected.error=0;          
            end
            OP_NOR:begin
                expected.result = ~(a | b);
                expected.error=0;          
            end
            OP_NAND:begin
                expected.result = ~(a & b);
                expected.error=0;          
            end
            OP_XNOR:begin
                expected.result = ~(a ^ b);
                expected.error=0;          
            end
            OP_EQU:begin
                expected.result = a == b;
                expected.error=0;          
            end
            OP_GREATER_THAN:begin
                expected.result = a > b;
                expected.error=0;          
            end
            OP_LESS_THAN:begin
                expected.result = a < b;
                expected.error=0;          
            end
            /*OP_ROTATE_RIGHT: begin 
            end
            OP_ROTATE_LEFT: begin 
            end*/
            OP_MULT: begin
                {fullResult[OPERAND_WIDTH] , hiReg , lowReg} = a * b;
                expected.result = lowReg;
                expected.error=0;
            end
            OP_DIVIDE:  begin 
                if (b == 0) begin
                    expected.result=0;
                    expected.error=1;
                end else begin
                    fullResult= a / b;
                    expected.result = fullResult[OPERAND_WIDTH-1:0];
                    expected.error=0;
                end
            end
            OP_MFHI: begin expected.result = hiReg; expected.error=0; end
            OP_MFLO: begin expected.result = lowReg; expected.error=0; end
            default:  begin
                expected.result=0;
                fullResult=0;
                expected.error=1;
            end
        endcase

        expected.zero = expected.result == 0;
        expected.carry = fullResult[OPERAND_WIDTH];
        expected.overflow = (a[OPERAND_WIDTH-1] == b[OPERAND_WIDTH-1]) &&
                            (expected.result[OPERAND_WIDTH-1] != b[OPERAND_WIDTH-1]) &&
                            ((sel == OP_ADD) || (sel == OP_SUB));
        return expected;
    endfunction    
    function logic detectErrors ( // check out puts against inputs, return 1 if error isdetected
        ExpectedALUOutputs exp,
        logic [OPERAND_WIDTH-1:0] result,
        logic errorFlag,
        logic zeroFlag,
        logic overflowFlag,
        logic carryFlag);

        logic errorDetected = (result != exp.result) || 
                              (errorFlag != exp.error) || 
                              (zeroFlag != exp.zero) || 
                              (overflowFlag != exp.overflow) || 
                              (carryFlag != exp.carry);

        return errorDetected;
    endfunction
`endif