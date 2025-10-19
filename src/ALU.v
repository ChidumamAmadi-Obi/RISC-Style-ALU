
module top(
    input wire [1:0] a,        // input a
    input wire [1:0] b,        // input b
    input wire [1:0] sel,      // Operation selector

    output reg [1:0] out,      // result
    output wire      zero,     // zero flag
    output wire      carry,    // carry out flag
    output wire      overflow, // overflow flag
    output wire      error     // error flag
);
    
    // Operation codes - using 2-bit to match sel input
    localparam [1:0] 
        OP_ADD = 2'b00,
        OP_SUB = 2'b01,
        OP_AND = 2'b10,
        OP_OR  = 2'b11;
    
    reg [2:0] full_result;  // Extra bit for carry

    // Initialize all registers to avoid latches
    initial begin
        out = 2'b0;
        full_result = 3'b0;
    end

    always @* begin // combinational logic
        // Default assignments to avoid latches
        out = 2'b0;
        full_result = 3'b0;
        
        case (sel)
            OP_ADD: begin   // if adding
                full_result = a + b;
                out = full_result[1:0];
            end
            OP_SUB: begin   // if subtracting
                full_result = a - b;
                out = full_result[1:0];
            end
            OP_AND: begin
                out = a & b;
                full_result = {1'b0, out}; // No carry for logical ops
            end
            OP_OR: begin
                out = a | b;
                full_result = {1'b0, out}; // No carry for logical ops
            end
            default: begin
                out = 2'b0;
                full_result = 3'b0;
            end
        endcase
    end

    assign zero = (out == 2'b0);
    assign carry = full_result[2];
    assign overflow = (a[1] == b[1]) && (out[1] != a[1]) && ((sel == OP_ADD) || (sel == OP_SUB));
    assign error = 1'b0; // No error with 2-bit sel - all combinations are valid
endmodule

// reg      signals can be assigned values
// wire     can read but cannot assign vals
//          can only use "assign"