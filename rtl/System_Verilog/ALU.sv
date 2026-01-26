//_____________________________________________________
//      8-bit ALU, handles unsigned numbers
//_____________________________________________________

`include "ALU_constants.vh"

module top(
    input logic clk,
    input logic rstN, // active low reset
    input logic writeEn, // enable writing to reg file
    input logic [2:0] writeAddress, // address of reg to write to
    input logic [OPERAND_WIDTH-1:0] inst,        // input b

  	output logic 	  error,	 
    output logic      zero,     
    output logic      carry,    
    output logic      overflow 
);

// internal signals and registers
    logic [FULLRESULT_WIDTH-1:0] fullResult;     // Extra bit for carry
    logic [OPERAND_WIDTH-1:0] result;
    logic [OPERAND_WIDTH-1:0] hiReg;        // internal registers for multiplication results
    logic [OPERAND_WIDTH-1:0] lowReg; 

    logic [OPERAND_WIDTH-1:0] instructionReg [0:2]; 

    always_ff @( posedge clk or negedge rstN ) begin
        if (!rstN) begin
            for (integer i=0; i<3; i++) begin
                instructionReg[i]<=0; // init all regs to zero
            end
            hiReg=0;
            lowReg=0;
            fullResult=0;  
            error=0;
            
        end else if (writeEn) begin
            instructionReg[writeAddress] <= inst;
        end
    end

    always @* begin // combinational logic
        // Default assignments to avoid latches
        hiReg=0;
        lowReg=0;
        fullResult=0;  
        error=0;
        
        case (instructionReg[0])
            OP_ADD: begin
                fullResult = instructionReg[1] + instructionReg[2];
                result = fullResult[OPERAND_WIDTH-1:0];
            end
            OP_SUB: begin 
                fullResult = instructionReg[1] - instructionReg[2];
                result = fullResult[OPERAND_WIDTH-1:0];                
            end 
            OP_AND: begin
                result = instructionReg[1] & instructionReg[2];
                fullResult = {1'b0, result}; // No carry for logical ops              
            end
            OP_OR: begin
                result = instructionReg[1] | instructionReg[2];
                fullResult = {1'b0, result};
            end
            OP_XOR: begin 
                result = instructionReg[1] ^ instructionReg[2];
                fullResult = {1'b0, result};
            end
            OP_NOR: begin 
                result = ~(instructionReg[1] | instructionReg[2]);
                fullResult = {1'b0, result};
            end
            OP_NAND:begin 
                result = ~(instructionReg[1] & instructionReg[2]);
                fullResult = {1'b0, result};
            end
            OP_XNOR: begin 
                result = ~(instructionReg[1] ^ instructionReg[2]);
                fullResult = {1'b0, result};
            end 
            OP_EQU: begin 
                result = instructionReg[1] == instructionReg[2];
                fullResult = {1'b0, result};
            end
            OP_GREATER_THAN: begin 
                result = instructionReg[1] > instructionReg[2];
                fullResult = {1'b0, result};                
            end
            OP_LESS_THAN: begin 
                result = instructionReg[1] < instructionReg[2];
                fullResult = {1'b0, result};                
            end
            OP_ROTATE_RIGHT: begin 
            end
            OP_ROTATE_LEFT: begin 
            end 
            OP_MULT: begin
                {fullResult[OPERAND_WIDTH] , hiReg , lowReg} = instructionReg[1] * instructionReg[2]; // store the result of a*b in two registers
                result = lowReg; // output lowest bits of multiplication result
            end
            OP_DIVIDE: begin 
                if (instructionReg[2] == 0) begin
                    result=0;
                    error=1;
                end else begin
                    fullResult=a/b;
                end
                result = fullResult[OPERAND_WIDTH-1:0];
            end
            OP_MFLO: out = lowReg; 
            OP_MFHI: out = hiReg; 
            default: begin // invalid opcode
                result=0;
                fullResult=0;
                error=1;
            end
        endcase
    end

    assign zero = (result == 0);
    assign carry = fullResult[OPERAND_WIDTH];
    assign overflow = (a[OPERAND_WIDTH-1] == b[OPERAND_WIDTH-1]) && (out[OPERAND_WIDTH-1] != a[OPERAND_WIDTH-1]) && ((sel == OP_ADD) || (sel == OP_SUB));
    assign led_array = ~sel; // display opcode on onboard led array
endmodule 
