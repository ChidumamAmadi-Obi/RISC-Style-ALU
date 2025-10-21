// 2 bit ALU so far, will upgrade to 8 or 32bit

`include "ALU_constants.vh"

module top(
    input wire [`ARG_WIDTH-1:0] a,        // input a
    input wire [`ARG_WIDTH-1:0] b,        // input b
  	input wire [`SEL_WIDTH-1:0] sel,      // 5bit Operation selector

    output reg [`ARG_WIDTH-1:0] out,      // result
  	output reg 	     error,	   // error flag
    output wire      zero,     
    output wire      carry,    
    output wire      overflow 
);
    reg [2:0] full_result;  // Used to store output + carry bit

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
            end //_____________________________________
            `OP_AND: begin // and
                out = a & b;
                full_result = {1'b0, out}; // No carry for logical ops
            end
            `OP_OR: begin // or
                out = a | b;
                full_result = {1'b0, out};
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
            end //_____________________________________
            `OP_EQU: begin // equal to
                out = a == b;
            end
            `OP_GREATER_THAN: begin
                out = a > b;
                full_result = {1'b0, out};
            end
            `OP_LESS_THAN: begin
                out = a < b;
                full_result = {1'b0, out};
            end //_____________________________________
            `OP_ROTATE_RIGHT: begin // rotate right by b bits
                case(b)
                    2'b00: out = a;
                    2'b01: out = {a[0], a[1]};  // Rotate right by 1
                    default: out = a; error = 1'b1;
                endcase
                full_result = {1'b0, out};
            end
            `OP_ROTATE_LEFT: begin // rotate left by b bits
                case(b) 
                    2'b00: out = a;
                    2'b01: out = {a[0], a[1]};  // Rotate left by 1 (because ALU is only 2 bits ROTATE_RIGHT and ROTATE_LEFT by 1 will look the same)
                    default: out = a; error = 1'b1;
                endcase
                full_result = {1'b0, out};
            end
            `OP_MODULO: begin // modulo
                out = a % b;
                full_result = {1'b0, out};
            end
            default: begin // invalid opcode
                out = 2'b00;
                full_result = 3'b000;
              	error = 1'b1;
            end
        endcase
    end

    assign zero = (out == 2'b0);
    assign carry = full_result[2];
    assign overflow = (a[1] == b[1]) && (out[1] != a[1]) && ((sel == `OP_ADD) || (sel == `OP_SUB));
endmodule

/* NOTES
overflow flag => detects signed overflow errors.
    Signed numbers use the MSB for the sign bit – 0 for positive, 1 for negative. 
    In signed arithmetic, overflows happen when:
    - Adding two negative numbers results in a positive outcome
    - Adding two positive numbers results in a negative outcome

    if both inputs have the same sign bit                   (a[1] == b[1])
    and if the result has a different sign than the inputs  (out[1] != a[1])
    and if the ADD or SUB operation is being had            ((sel == `OP_ADD) || (sel == `OP_SUB))
    there is an overflow

carry bit => indicates when the result of an arithmetic operation exceeds the available bits in the destination register.
    for example, in a 8bit alu if the result is over 255 the carry bbit is set to 1

carry bit != overflow flag
*/
