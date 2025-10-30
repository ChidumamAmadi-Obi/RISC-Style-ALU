//_____________________________________________________
//      4-bit ALU with 7-seg Display output
//_____________________________________________________

`include "ALU_constants.vh"

module top( 
    input wire [`OPERAND_WIDTH-1:0] a, // inputs and outputs for entire moddule
    input wire [`OPERAND_WIDTH-1:0] b, 
    input wire [`SEL_WIDTH-1:0] sel,
    output wire [`SEL_WIDTH-1:0] led,
    output wire error,
    output wire zero,
    output wire carry,
    output wire overflow,
    output wire [6:0] display
); 
    wire [`OPERAND_WIDTH-1:0] alu_result; 
    
    alu alu_instance (
        .a(a),
        .b(b),
        .sel(sel),
        .out(alu_result), // output of alu -> alu_result
        .led(led),
        .error(error),
        .zero(zero),
        .carry(carry),
        .overflow(overflow)
    );
    
    seven_seg_display display_instance (
        .alu_out(alu_result), // join output of ALU to input of 7 seg display module
        .seg_display_out(display)
    );
endmodule

//_____________________________________________________
module alu(
    input wire [`OPERAND_WIDTH-1:0] a,        // input a
    input wire [`OPERAND_WIDTH-1:0] b,        // input b
    input wire [`SEL_WIDTH-1:0] sel,          // operation selector

    output reg [`OPERAND_WIDTH-1:0] out,         // result
    output wire [`SEL_WIDTH:0] led,

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
        hi_reg =        `OPERAND_WIDTH'b0000;
        low_reg =       `OPERAND_WIDTH'b0000;
        out =           `OPERAND_WIDTH'b0000;
        full_result =   `FULL_RESULT_WIDTH'b00000;
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
                    3'b001:   out = {a[0], a[3], a[2] ,a[1]}; 
                    3'b010:   out = {a[1], a[0], a[3] ,a[2]};
                    3'b011:   out = {a[2], a[1], a[0], a[3]};        
                    default: begin  out = a; error = 1'b1; end
                endcase
                full_result = {1'b0, out};
            end
            `OP_ROTATE_LEFT: begin // rotate left by b bits
                case(b) 
                    3'b000:   out = a;
                    3'b001:   out = {a[2], a[1], a[0], a[3]};
                    3'b010:   out = {a[1], a[0], a[3], a[2]};
                    3'b011:   out = {a[0], a[3], a[2], a[1]};
                    default: begin  out = a; error = 1'b1; end
                endcase
                full_result = {1'b0, out};
            end //_____________________________________
            `OP_MULT: begin
                {full_result[`OPERAND_WIDTH] , hi_reg , low_reg} = a * b; // store the result of a*b in two registers
                out = low_reg; // output lowest bits of multiplication result
            end
            `OP_DIVIDE: begin
                if (b == `OPERAND_WIDTH'b0000) begin
                    out = `OPERAND_WIDTH'b0000;
                    error = 1'b1;
                    full_result = `FULL_RESULT_WIDTH'b0;
                end else begin 
                    out = a / b;
                    full_result = {1'b0, out};
                end
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
    assign led = ~sel; // display current opcode on onboard led array
endmodule 

//_____________________________________________________

module seven_seg_display( 
    input wire [`OPERAND_WIDTH-1:0] alu_out,
    output reg [6:0] seg_display_out // no decimal point, 6 signals out
    );

    always @* begin
        case(alu_out)
            4'b0000: begin // 0
                seg_display_out[0] = 1; // a
                seg_display_out[1] = 1; // b
                seg_display_out[2] = 1; // c
                seg_display_out[3] = 1; // d
                seg_display_out[4] = 1; // e
                seg_display_out[5] = 1; // f
                seg_display_out[6] = 0; // g
            end

            4'b0001: begin // 1 
                seg_display_out[0] = 0; // a
                seg_display_out[1] = 1; // b
                seg_display_out[2] = 1; // c
                seg_display_out[3] = 0; // d
                seg_display_out[4] = 0; // e
                seg_display_out[5] = 0; // f
                seg_display_out[6] = 0; // g
            end

            4'b0010: begin // 2 
                seg_display_out[0] = 1; // a
                seg_display_out[1] = 1; // b
                seg_display_out[2] = 0; // c
                seg_display_out[3] = 1; // d
                seg_display_out[4] = 1; // e
                seg_display_out[5] = 0; // f
                seg_display_out[6] = 1; // g
            end

            4'b0011: begin // 3
                seg_display_out[0] = 1; // a
                seg_display_out[1] = 1; // b
                seg_display_out[2] = 1; // c
                seg_display_out[3] = 1; // d
                seg_display_out[4] = 0; // e
                seg_display_out[5] = 0; // f
                seg_display_out[6] = 1; // g
            end
            
            4'b0100: begin // 4
                seg_display_out[0] = 0; // a
                seg_display_out[1] = 1; // b
                seg_display_out[2] = 1; // c
                seg_display_out[3] = 0; // d
                seg_display_out[4] = 0; // e
                seg_display_out[5] = 1; // f
                seg_display_out[6] = 1; // g
            end

            4'b0101: begin // 5 
                seg_display_out[0] = 1; // a
                seg_display_out[1] = 0; // b
                seg_display_out[2] = 1; // c
                seg_display_out[3] = 1; // d
                seg_display_out[4] = 0; // e
                seg_display_out[5] = 1; // f
                seg_display_out[6] = 1; // g
            end

            4'b0110: begin // 6
                seg_display_out[0] = 1; // a
                seg_display_out[1] = 0; // b
                seg_display_out[2] = 1; // c
                seg_display_out[3] = 1; // d
                seg_display_out[4] = 1; // e
                seg_display_out[5] = 1; // f
                seg_display_out[6] = 1; // g
            end

            4'b0111: begin // 7
                seg_display_out[0] = 1; // a
                seg_display_out[1] = 1; // b
                seg_display_out[2] = 1; // c
                seg_display_out[3] = 0; // d
                seg_display_out[4] = 0; // e
                seg_display_out[5] = 0; // f
                seg_display_out[6] = 0; // g
            end

            4'b1000: begin // 8
                seg_display_out[0] = 1; // a
                seg_display_out[1] = 1; // b
                seg_display_out[2] = 1; // c
                seg_display_out[3] = 1; // d
                seg_display_out[4] = 1; // e
                seg_display_out[5] = 1; // f
                seg_display_out[6] = 1; // g
            end

            4'b1001: begin // 9
                seg_display_out[0] = 1; // a
                seg_display_out[1] = 1; // b
                seg_display_out[2] = 1; // c
                seg_display_out[3] = 0; // d
                seg_display_out[4] = 0; // e
                seg_display_out[5] = 1; // f
                seg_display_out[6] = 1; // g
            end

            4'b1010: begin// A
                seg_display_out[0] = 1; // a
                seg_display_out[1] = 1; // b
                seg_display_out[2] = 1; // c
                seg_display_out[3] = 0; // d
                seg_display_out[4] = 1; // e
                seg_display_out[5] = 1; // f
                seg_display_out[6] = 1; // g
            end

            4'b1011: begin // B
                seg_display_out[0] = 0; // a
                seg_display_out[1] = 0; // b
                seg_display_out[2] = 1; // c
                seg_display_out[3] = 1; // d
                seg_display_out[4] = 1; // e
                seg_display_out[5] = 1; // f
                seg_display_out[6] = 1; // g
            end

            4'b1100: begin // C
                seg_display_out[0] = 1; // a
                seg_display_out[1] = 0; // b
                seg_display_out[2] = 0; // c
                seg_display_out[3] = 1; // d
                seg_display_out[4] = 1; // e
                seg_display_out[5] = 1; // f
                seg_display_out[6] = 0; // g
            end
            
            4'b1101: begin // D
                seg_display_out[0] = 0; // a
                seg_display_out[1] = 1; // b
                seg_display_out[2] = 1; // c
                seg_display_out[3] = 1; // d
                seg_display_out[4] = 1; // e
                seg_display_out[5] = 0; // f
                seg_display_out[6] = 1; // g
            end

            4'b1110: begin // E
                seg_display_out[0] = 1; // a
                seg_display_out[1] = 0; // b
                seg_display_out[2] = 0; // c
                seg_display_out[3] = 1; // d
                seg_display_out[4] = 1; // e
                seg_display_out[5] = 1; // f
                seg_display_out[6] = 1; // g
            end

            4'b1111: begin // F
                seg_display_out[0] = 1; // a
                seg_display_out[1] = 0; // b
                seg_display_out[2] = 0; // c
                seg_display_out[3] = 0; // d
                seg_display_out[4] = 1; // e
                seg_display_out[5] = 1; // f
                seg_display_out[6] = 1; // g
            end
            default:  begin // undefined 
                seg_display_out[0] = 0; // a
                seg_display_out[1] = 0; // b
                seg_display_out[2] = 0; // c
                seg_display_out[3] = 0; // d
                seg_display_out[4] = 0; // e
                seg_display_out[5] = 0; // f
                seg_display_out[6] = 0; // g
            end

        endcase
    end
endmodule