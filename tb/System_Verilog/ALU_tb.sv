/*
*/

`include "ALU_constants.svh"

module top_tb;

    // configure number of tests done in each sector here
    localparam NUM_ADD_TESTS = 3;
    localparam NUM_SUB_TESTS = 3;
    localparam NUM_DIV_TESTS = 3;
    localparam NUM_MULT_TESTS = 3;
    localparam NUM_ROTATION_TESTS = 3;
    localparam NUM_LOGICAL_TESTS = 3;
    localparam NUM_TESTS =  NUM_ADD_TESTS + 
                            NUM_SUB_TESTS +
                            NUM_DIV_TESTS +
                            NUM_MULT_TESTS +
                            NUM_ROTATION_TESTS +
                            NUM_LOGICAL_TESTS + 
                            4; // no of edge case tests

    // localparam MAX_ROTATE_OPERAND = ;
    localparam MAX_OPERAND = 255;
    localparam MIN_OPERAND = 0;
    
    logic clkIn; // inputs
    logic rstN;
    logic writeEn;
    logic [INST_ADDR_LENGTH-1:0] writeAdd;
    logic [OPERAND_WIDTH-1:0] instructionIn;
    
    logic [OPERAND_WIDTH-1:0] result;// outputs
    logic errorFlag;
    logic zeroFlag;     
    logic carryFlag;    
    logic overflowFlag;

    real a;
    real b;
    real sel;

// error checking and reporting
    integer [NUM_TESTS-1:0] errors;
    integer isAnError;
    integer testNo;
    integer noOfErrors;
    
    top topInstance(
        .clk(clkIn),
        .rstN(rstN),
        .writeEn(writeEn),
        .writeAddress(writeAdd),
        .inst(instructionIn),
        .result(result),
        .error(errorFlag),
        .zero(zeroFlag),
        .carry(carryFlag),
        .overflow(overflowFlag) );
    
    task pulse(ref logic clkIn);
        clkIn=~clkIn; #5;
        clkIn=~clkIn; #5;
    endtask
	task loadInstruction(
        input real opcode,
		input real inputA,
		input real inputB,
		ref logic [INST_ADDR_LENGTH-1:0] writeAdd,
		ref logic writeEn,
		ref logic [OPERAND_WIDTH-1:0] instructionIn);

        writeEn=1; // enable write to instruction reg file
        instructionIn=opcode; writeAdd=0; // load opcode first
        pulse(clkIn);
        instructionIn=inputA; writeAdd=1; //write to operand A
        pulse(clkIn);
        instructionIn=inputB; writeAdd=2; // write to operand B
        pulse(clkIn);
        writeEn=0; // disable write
	endtask

    // test tasks insert ranomized operands 
    task testAddition(
        ref integer testNo,
        ref integer [NUM_TESTS-1:0] errors, 
        ref real a,
        ref real b,
        ref real sel);

        $display("TESTING ADDITION...");
        sel=OP_ADD;
        for(integer i=0; i<NUM_ADD_TESTS; i++) begin // test addition 5 times
            testNo++;
            a=$urandom_range(MIN_OPERAND,MAX_OPERAND);
            b=$urandom_range(MIN_OPERAND,MAX_OPERAND);
            loadInstruction(sel,a,b,writeAdd,writeEn,instructionIn);
        end
    endtask
    task testSubtraction( 
        ref integer testNo,
        ref integer [NUM_TESTS-1:0] errors,         
        ref real a,
        ref real b,
        ref real sel);

        $display("TESTING SUBTRACTION...");
        sel=OP_SUB;
        for(integer i=0; i<NUM_SUB_TESTS; i++) begin 
            testNo++;
            a=$urandom_range(MIN_OPERAND,MAX_OPERAND);
            b=$urandom_range(MIN_OPERAND,MAX_OPERAND);
            loadInstruction(sel,a,b,writeAdd,writeEn,instructionIn);
        end
    endtask
    task testLogic(
        ref integer testNo,
        ref integer [NUM_TESTS-1:0] errors, 
        ref real a,
        ref real b,
        ref real sel);

        $display("TESTING LOGICAL INSTRICTIONS...");
        for (integer i=0; i<NUM_LOGICAL_TESTS; i++) begin
            testNo++;
            sel=$urandom_range(OP_AND,OP_LESS_THAN); // chose random logical instruction
            a=$urandom_range(MIN_OPERAND,MAX_OPERAND);
            b=$urandom_range(MIN_OPERAND,MAX_OPERAND);
            loadInstruction(sel,a,b,writeAdd,writeEn,instructionIn);
        end  
    endtask
    task testDivision(
        ref integer testNo,
        ref integer [NUM_TESTS-1:0] errors,         
        ref real a,
        ref real b,
        ref real sel);

        $display("TESTING DIVISION...");
        sel=OP_DIVIDE;
            for (integer i=0; i<NUM_DIV_TESTS; i++) begin
                testNo++;
                a=$urandom_range(MIN_OPERAND,MAX_OPERAND);
                b=$urandom_range(MIN_OPERAND,MAX_OPERAND);
                loadInstruction(sel,a,b,writeAdd,writeEn,instructionIn);
        end
    endtask
    task testMultiplication( // to test mult, mfhi and mflow
        ref integer testNo,
        ref integer [NUM_TESTS-1:0] errors,     
        ref real a,
        ref real b,
        ref real sel);

        $display("TESTING MULTIPLICATION...");
            for (integer i=0; i<NUM_MULT_TESTS; i++) begin
                testNo++;
                a=$urandom_range(MIN_OPERAND,MAX_OPERAND);
                b=$urandom_range(MIN_OPERAND,MAX_OPERAND);
                sel=OP_MULT; loadInstruction(sel,a,b,writeAdd,writeEn,instructionIn); // defaults to outputing the contents of low reg
                sel=OP_MFHI; loadInstruction(sel,a,b,writeAdd,writeEn,instructionIn); // output contents of high reg
                sel=OP_MFLO; loadInstruction(sel,a,b,writeAdd,writeEn,instructionIn); // output contents of lo reg

        end
    endtask
    /*
    task testRotate(
        ref real a,
        ref real b,
        ref real sel);

        $display("TESTING ROTATION...");
            for (integer i=0; i<=NUM_ROTATION_TESTS; i++) begin
                a=$urandom_range(MIN_OPERAND,MAX_OPERAND);
                b=$urandom_range(MIN_OPERAND,MAX_ROTATE_OPERAND);
                sel=$urandom_range(OP_ROTATE_LEFT,OP_ROTATE_RIGHT);
                loadInstruction(sel,a,b,writeAdd,writeEn,instructionIn);
        end
    endtask*/

    task testEdgecases(        
        ref integer testNo,
        ref integer [NUM_TESTS-1:0] errors,     
        ref real a,
        ref real b,
        ref real sel);

        $display("TESTING EDGE CASES...");

        sel=255; 
        testNo++; 
        loadInstruction(sel,a,b,writeAdd,writeEn,instructionIn); // invalid opcode

        b=205; 
        sel=OP_ROTATE_LEFT;
        testNo++; 
        loadInstruction(sel,a,b,writeAdd,writeEn,instructionIn); // invalid rotate operand
        
        testNo++;
        sel=OP_ROTATE_RIGHT;
        loadInstruction(sel,a,b,writeAdd,writeEn,instructionIn); 

        b=0; 
        sel=OP_DIVIDE;
        testNo++; 
        loadInstruction(sel,a,b,writeAdd,writeEn,instructionIn); // division by zero
    endtask

    initial begin
        $display("-----");
        $monitor("|| %0d -> t: %0d | SEL: 0x%0H | A: 0x%0H | B: 0x%0H | RESULT: 0x%0H |#| EF: %b | OF: %b | ZF: %b | CF: %b ||", 
          testNo, $time, sel, a, b, result, errorFlag, overflowFlag, zeroFlag, carryFlag);

        clkIn=0;
        rstN=1;
        a=0;
        b=0;
        sel=0;
        testNo=0;

        testAddition(testNo,errors,a,b,sel);
        testSubtraction(testNo,errors,a,b,sel);
        testDivision(testNo,errors,a,b,sel);
        testLogic(testNo,errors,a,b,sel);
        testMultiplication(testNo,errors,a,b,sel);
        testEdgecases(testNo,errors,a,b,sel);

        $display("-----");
		$finish;
    end
endmodule
