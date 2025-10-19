
module top(
    input wire [1:0] a,        // input a
    input wire [1:0] b,        // input b
  	input wire [2:0] sel,      // Operation selector

    output reg [1:0] out,      // result
  	output reg 	     error,	   // error flag
    output wire      zero,     // zero flag
    output wire      carry,    // carry out flag
    output wire      overflow // overflow flag
);
    
    // Operation codes - using 2-bit to match sel input
  	localparam [2:0] 
        OP_ADD = 3'b000,
        OP_SUB = 3'b001,
        OP_AND = 3'b010,
        OP_OR  = 3'b011;
    
    reg [2:0] full_result;  // Extra bit for carry

    // Initialize all registers to avoid latches
    initial begin
        out = 2'b0;
        full_result = 3'b0;
      	error = 1'b0;  // keep when no error with 2-bit sel - all combinations are valid
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
              	error = 1'b1;
            end
        endcase
    end

    assign zero = (out == 2'b0);
    assign carry = full_result[2];
    assign overflow = (a[1] == b[1]) && (out[1] != a[1]) && ((sel == OP_ADD) || (sel == OP_SUB));
endmodule

// reg      signals can be assigned values
// wire     can read but cannot assign vals
//          can only use "assign"