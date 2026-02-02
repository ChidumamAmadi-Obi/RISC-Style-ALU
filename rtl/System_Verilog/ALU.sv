/*SYSTEM VERILOG IMPLIMENTATION 
*/

`include "ALU_constants.svh"

module top(
    input logic clk,
    input logic rstN, // active low reset
    input logic writeEn, // enable writing to reg file
    input logic [INST_ADDR_LENGTH-1:0] writeAddress, // address of reg to write to
    input logic [OPERAND_WIDTH-1:0] inst,        // input b

    output logic [OPERAND_WIDTH-1:0] result,
  	output logic error,	 
    output logic zero,     
    output logic carry,    
    output logic overflow );

// internal signals and registers
    logic [FULL_RESULT_WIDTH-1:0] fullResult; // Extra bit for carry
    logic [OPERAND_WIDTH-1:0] hiReg; // internal registers for multiplication results
    logic [OPERAND_WIDTH-1:0] lowReg; 

    logic [OPERAND_WIDTH-1:0] instructionReg [0:INST_REG_FILE_SIZE-1]; // instruction register file

    always_ff @( posedge clk or negedge rstN ) begin // loading into instruction reg file
        if (!rstN) begin
            hiReg <= 0; // clear hi and lo reg at reset
            lowReg <= 0;
            for (integer i=0; i<INST_ADDR_LENGTH; i++) begin
                instructionReg[i]<=0; // init all regs to zero
            end
        end else if (writeEn) begin
            instructionReg[writeAddress] <= inst;
        end else if (instructionReg[0] == OP_MULT) begin // handle multiplication in seq block
            {hiReg, lowReg} <= instructionReg[1] * instructionReg[2]; // Store multiplication result in hiReg and lowReg
        end
    end

    always_comb begin // combinational logic
        // Default assignments to avoid latches
        fullResult=0;  
        error=0;
        
        case (instructionReg[0])
            OP_ADD: begin
                fullResult = instructionReg[1] + instructionReg[2];
                result = fullResult[OPERAND_WIDTH-1:0];
                error=0;
            end
            OP_SUB: begin 
                fullResult = instructionReg[1] - instructionReg[2];
                result = fullResult[OPERAND_WIDTH-1:0];        
                error=0;        
            end 
            OP_AND: begin
                result = instructionReg[1] & instructionReg[2];
                fullResult = {1'b0, result}; // No carry for logical ops    
                error=0;          
            end
            OP_OR: begin
                result = instructionReg[1] | instructionReg[2];
                fullResult = {1'b0, result};
                error=0;
            end
            OP_XOR: begin 
                result = instructionReg[1] ^ instructionReg[2];
                fullResult = {1'b0, result};
                error=0;
            end
            OP_NOR: begin 
                result = ~(instructionReg[1] | instructionReg[2]);
                fullResult = {1'b0, result};
                error=0;
            end
            OP_NAND:begin 
                result = ~(instructionReg[1] & instructionReg[2]);
                fullResult = {1'b0, result};
                error=0;
            end
            OP_XNOR: begin 
                result = ~(instructionReg[1] ^ instructionReg[2]);
                fullResult = {1'b0, result};
                error=0;
            end 
            OP_EQU: begin 
                result = instructionReg[1] == instructionReg[2];
                fullResult = {1'b0, result};
                error=0;
            end
            OP_GREATER_THAN: begin 
                result = instructionReg[1] > instructionReg[2];
                fullResult = {1'b0, result};  
                error=0;              
            end
            OP_LESS_THAN: begin 
                result = instructionReg[1] < instructionReg[2];
                fullResult = {1'b0, result};   
                error=0;             
            end
          /*OP_ROTATE_RIGHT: begin 
            end
            OP_ROTATE_LEFT: begin 
            end*/
            OP_MULT: begin
                result = lowReg; // output lowest bits of multiplication result calculated in seq block
                error=0;
            end
            OP_DIVIDE: begin 
                if (instructionReg[2] == 0) begin
                    result=0;
                    error=1;
                end else begin
                    fullResult=instructionReg[1]/instructionReg[2];
                    result=fullResult[OPERAND_WIDTH-1:0];
                    error=0;
                end
            end
            OP_MFLO: begin result = lowReg; error=0; end
            OP_MFHI: begin result = hiReg; error=0; end
            default: begin // invalid opcode
                result=0;
                fullResult=0;
                error=1;
            end
        endcase
    end

    assign zero = (result == 0);
    assign carry = fullResult[OPERAND_WIDTH];
    assign overflow = (instructionReg[1][OPERAND_WIDTH-1] == instructionReg[2][OPERAND_WIDTH-1]) && 
                      (result[OPERAND_WIDTH-1] != instructionReg[2][OPERAND_WIDTH-1]) && 
                      ((instructionReg[0] == OP_ADD) || (instructionReg[0] == OP_SUB));
    // assign led_array = ~instructionReg[0]; // display opcode on onboard led array, size down to 6 bits
endmodule 
