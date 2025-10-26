//_____________________________________________________
//      8-bit ALU, handles unsigned numbers
//_____________________________________________________

`include "ALU_constants.vh"

module top(
    input wire [`OPERAND_WIDTH-1:0] a,        // input a
    input wire [`OPERAND_WIDTH-1:0] b,        // input b
    input wire [`SEL_WIDTH-1:0] sel,          // operation selector

    output reg [`OPERAND_WIDTH-1:0] out,         // result

  	output reg 	     error,	 
    output wire      zero,     
    output wire      carry,    
    output wire      overflow 
);
    reg [`FULL_RESULT_WIDTH-1:0] full_result;     // Extra bit for carry
    reg [`OPERAND_WIDTH-1:0] hi_reg;        // internal registers for multiplication results
    reg [`OPERAND_WIDTH-1:0] low_reg; 

    always @* begin // combinational logic
        // Default assignments to avoid latches
        hi_reg =        `OPERAND_WIDTH'b00000000;
        low_reg =       `OPERAND_WIDTH'b00000000;
        out =           `OPERAND_WIDTH'b00000000;
        full_result =   `FULL_RESULT_WIDTH'b000000000;
        error = 1'b0;  // keep 0 when no error with sel - all combinations are valid
        
        case (sel)
            `OP_ADD: begin   // if adding
                full_result = a + b;
                out = full_result[`OPERAND_WIDTH-1:0];
            end
            `OP_SUB: begin   // if subtracting
              full_result = a - b;
                out = full_result[`OPERAND_WIDTH-1:0];
            end //_____________________________________
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
            end //_____________________________________
            `OP_EQU: begin // equal to
                out = a == b;
            end
            `OP_GREATER_THAN: begin //geater than
                out = a > b;
                full_result = {1'b0, out};
            end
            `OP_LESS_THAN: begin // less than
                out = a < b;
                full_result = {1'b0, out};
            end
            `OP_ROTATE_RIGHT: begin // rotate right by b bits
                case(b)
                    3'b000:   out = a;
                    3'b001:   out = {a[0], a[7], a[6] ,a[5], a[4], a[3], a[2], a[1]}; 
                    3'b010:   out = {a[1], a[0], a[7] ,a[6], a[5], a[4], a[3], a[2]};        
                    3'b011:   out = {a[2], a[1], a[0] ,a[7], a[6], a[5], a[4], a[3]};
                    3'b100:   out = {a[3], a[2], a[1] ,a[0], a[7], a[6], a[5], a[4]};
                    3'b101:   out = {a[4], a[3], a[2] ,a[1], a[0], a[7], a[6], a[5]};
                    3'b110:   out = {a[5], a[4], a[3] ,a[2], a[1], a[0], a[7], a[6]};
                    3'b111:   out = {a[6], a[5], a[4] ,a[3], a[2], a[1], a[0], a[7]};
                    default: begin  out = a; error = 1'b1; end
                endcase
                full_result = {1'b0, out};
            end
            `OP_ROTATE_LEFT: begin // rotate left by b bits
                case(b) 
                    3'b000:   out = a;
                    3'b001:   out = {a[6], a[5], a[4], a[3], a[2], a[1], a[0], a[7]};   
                    3'b010:   out = {a[5], a[4], a[3], a[2], a[1], a[0], a[7], a[6]};
                    3'b011:   out = {a[4], a[3], a[2], a[1], a[0], a[7], a[6], a[5]}; 
                    3'b100:   out = {a[3], a[2], a[1], a[0], a[7], a[6], a[5], a[4]}; 
                    3'b101:   out = {a[2], a[1], a[0], a[7], a[6], a[5], a[4], a[3]};
                    3'b110:   out = {a[1], a[0], a[7], a[6], a[5], a[4], a[3], a[2]}; 
                    3'b111:   out = {a[0], a[7], a[6], a[5], a[4], a[3], a[2], a[1]};
                    default: begin  out = a; error = 1'b1; end
                endcase
                full_result = {1'b0, out};
            end //_____________________________________
            `OP_MULT: begin
                {full_result[`OPERAND_WIDTH] , hi_reg , low_reg} = a * b; // store the result of a*b in two registers
                out = low_reg; // output lowest bits of multiplication result
            end
            `OP_DIVIDE: begin // divide
                if (b == `OPERAND_WIDTH'b00000000) begin
                    out = `OPERAND_WIDTH'b00000000;
                    error = 1'b1;
                end else begin 
                    full_result = a / b;
                end
                    out = full_result[`OPERAND_WIDTH-1:0];
            end
            `OP_MFLO: out = low_reg; 
            `OP_MFHI: out = hi_reg; 
            default: begin // invalid opcode
                out = `OPERAND_WIDTH'b0;
                full_result = `FULL_RESULT_WIDTH'b0;
              	error = 1'b1;
            end
        endcase
    end

    assign zero = (out == `OPERAND_WIDTH'b0);
    assign carry = full_result[`OPERAND_WIDTH];
    assign overflow = (a[`OPERAND_WIDTH-1] == b[`OPERAND_WIDTH-1]) && (out[`OPERAND_WIDTH-1] != a[`OPERAND_WIDTH-1]) && ((sel == `OP_ADD) || (sel == `OP_SUB));
    assign led_array = ~sel; // display opcode on onboard led array
endmodule 

/* NOTES
reg      signals can be assigned values
wire     can read but cannot assign vals, can only use "assign"

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
*/