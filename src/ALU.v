`include "ALU_constants.vh"

module top(
    input wire [1:0] a,        // input a
    input wire [1:0] b,        // input b
  	input wire [3:0] sel,      // 4bit Operation selector

    output reg [1:0] out,      // result
  	output reg 	     error,	   // error flag
    output wire      zero,     
    output wire      carry,    
    output wire      overflow 
);
    
    reg [2:0] full_result;  // Extra bit for carry

    always @* begin // combinational logic
        // Default assignments to avoid latches
        out = 2'b0;
        full_result = 3'b0;
        error = 1'b0;  // keep 0 when no error with sel - all combinations are valid
        
        case (sel)
            `OP_ADD: begin   // if adding
                full_result = a + b;
                out = full_result[1:0];
            end
            `OP_SUB: begin   // if subtracting
                full_result = a - b;
                out = full_result[1:0];
            end
            `OP_AND: begin // and
                out = a & b;
                full_result = {1'b0, out}; // No carry for logical ops
            end
            `OP_OR: begin // or
                out = a | b;
                full_result = {1'b0, out}; // No carry for logical ops
            end
            `OP_XOR: begin // xor
                out = a ^ b;
                full_result = {1'b0, out};
            end
            `OP_NOR: begin // nor
                out = ~(a | b);
                full_result = {1'b0, out};
            end
            `OP_NAND:begin // nand
                out = ~(a & b);
                full_result = {1'b0, out};
            end
            `OP_XNOR: begin // xnor
                out = a ~^ b;
                full_result = {1'b0, out};
            end
            `OP_MODULO: begin // modulo
                out = a % b;
                full_result = {1'b0, out};
            end
            default: begin // invalid opcode
                out = 2'b0;
                full_result = 4'b0;
              	error = 1'b1;
            end
        endcase
    end

    assign zero = (out == 2'b0);
    assign carry = full_result[2];
    assign overflow = (a[1] == b[1]) && (out[1] != a[1]) && ((sel == `OP_ADD) || (sel == `OP_SUB));
endmodule

/* NOTES
reg      signals can be assigned values
wire     can read but cannot assign vals, can only use "assign"

overflow flag => detects signed overflow errors.
    Signed numbers use the MSB for the sign bit – 0 for positive, 1 for negative. 
    In signed arithmetic, overflows happen when:
    - Adding two negative numbers results in a positive outcome
    - Adding two positive numbers results in a negative outcome

carry bit => indicates when the result of an arithmetic operation exceeds the available bits in the destination register.
    for example, in a 8bit alu if the result is over 255 the carry bbit is set to 1