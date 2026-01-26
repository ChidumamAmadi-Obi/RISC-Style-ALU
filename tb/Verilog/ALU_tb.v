// _______________________________________________________________________
// automatic self checking testbench for ALU.v with error report
// uses bitmask (errors register) to track when specific tasks have faild
// _______________________________________________________________________

`include "ALU_constants.vh"

`timescale 1ns/1ps // specifies the time units and precision for sim

module test;
  // first, testbench signals are declared
  // these will be connected to the ALU module
  reg [`OPERAND_WIDTH-1:0] a, b;  // operands  
  reg [`SEL_WIDTH-1:0] sel;

  wire [`OPERAND_WIDTH-1:0] out;  // outputs
  wire zero, carry, overflow, error;

  // Internal register access 
  wire [`OPERAND_WIDTH-1:0] hi_reg = dut.hi_reg;
  wire [`OPERAND_WIDTH-1:0] low_reg = dut.low_reg;

  // expected outputs are declared here
  reg [`OPERAND_WIDTH-1:0] expected_out, expected_hi_reg, expected_low_reg; 
  reg expected_zero, expected_carry, expected_overflow, expected_error;

  // errror handling & reporting
  reg [`TESTS-1:0] errors;
  reg is_there_an_error;
  integer i, no_of_errors, test_num = 0; // for calculating no of errors in for loop
    
  top dut ( // instantiating the top module 1.
    .a(a), 
    .b(b), 
    .sel(sel),
    .out(out), 
    .zero(zero), 
    .carry(carry), 
    .overflow(overflow), 
    .error(error)
  );

  initial begin
    errors = 0; // begin with no errors
    no_of_errors = 0; // initialize error counter
    #1; // Small delay to allow initial propagation
    $display("//==============================================================================================//");
    $display("//                                     ALU TESTBENCH                                            //");
    $display("//==============================================================================================//");
    $display("//Test |  Time   |    A        B       Sel   |    Out    Z C O E |           Operation          //");
    $display("//_____|_________|___________________________|___________________|______________________________//");
        
    // Test 0: ADD _____________________________________________________________________________________________________________
    sel = `OP_ADD; a = `OPERAND_WIDTH'b00000001; b = `OPERAND_WIDTH'b00000001; #10; // 1 + 1 = 2
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b00000010;
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;  
    expected_error    = 1'b0;

    $display("//%4d |  %4t  | %b %b  %b  | %b  %b %b %b %b | ADD                          //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;
        
    // Test 1: ADD with carry __________________________________________________________________________________________________
    sel = `OP_ADD; a = `OPERAND_WIDTH'b11111111; b = `OPERAND_WIDTH'b00000001; #10; // 255 + 1 = 0 with carry
    expected_carry    = 1'b1;
    expected_out      = `OPERAND_WIDTH'b00000000;
    expected_overflow = 1'b0;
    expected_zero     = 1'b1;
    expected_error    = 1'b0;

    $display("//%4d |  %4t  | %b %b  %b  | %b  %b %b %b %b | ADD                          //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 2: ADD with overflow _______________________________________________________________________________________________
    sel = `OP_ADD; a = `OPERAND_WIDTH'b01111111; b = `OPERAND_WIDTH'b00000001; #10; // 127 + 1 = -128 (overflow in signed)
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b10000000;
    expected_overflow = 1'b1;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("//%4d |  %4t  | %b %b  %b  | %b  %b %b %b %b | ADD                          //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 3: SUB _____________________________________________________________________________________________________________
    sel = `OP_SUB; a = `OPERAND_WIDTH'b00000111; b = `OPERAND_WIDTH'b00000011; #10; // 7 - 3 = 4
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b00000100;
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("//%4d |  %4t  | %b %b  %b  | %b  %b %b %b %b | SUB                          //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 4: AND _____________________________________________________________________________________________________________
    sel = `OP_AND; a = `OPERAND_WIDTH'b10101010; b = `OPERAND_WIDTH'b11001100; #10;
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b10001000;
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("//%4d |  %4t  | %b %b  %b  | %b  %b %b %b %b | AND                          //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 5: OR _____________________________________________________________________________________________________________
    sel = `OP_OR; a = `OPERAND_WIDTH'b10101010; b = `OPERAND_WIDTH'b01010101; #10;
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b11111111;
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("//%4d |  %4t  | %b %b  %b  | %b  %b %b %b %b | OR                           //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 6: valid opcode ______________________________________________________________________________________________________
    sel = `OP_AND; a = `OPERAND_WIDTH'b10101010; b = `OPERAND_WIDTH'b01010101; #10; // Valid AND operation
    expected_error = 1'b0;

    $display("//%4d |  %4t  | %b %b  %b  | %b  %b %b %b %b | Valid op                     //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if (error !== expected_error) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 7: invalid opcode ________________________________________________________________________________________________________
    sel = 5'b11111; a = `OPERAND_WIDTH'b10101010; b = `OPERAND_WIDTH'b01010101; #10; // Invalid operation
    expected_error = 1'b1;

    $display("//%4d |  %4t  | %b %b  %b  | %b  %b %b %b %b | Invalid op                   //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);  
    if (error !== expected_error) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 8: XOR ________________________________________________________________________________________________________
    sel = `OP_XOR; a = `OPERAND_WIDTH'b11110000; b = `OPERAND_WIDTH'b11001100; #10;
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b00111100;
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("//%4d |  %4t  | %b %b  %b  | %b  %b %b %b %b | XOR                          //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 9: NOR ________________________________________________________________________________________________________
    sel = `OP_NOR; a = `OPERAND_WIDTH'b00000000; b = `OPERAND_WIDTH'b00000000; #10;
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b11111111;
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("//%4d |  %4t | %b %b  %b  | %b  %b %b %b %b | NOR                          //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 10: NAND _____________________________________________________________________________________________________
    sel = `OP_NAND; a = `OPERAND_WIDTH'b11111111; b = `OPERAND_WIDTH'b11111111; #10;
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b00000000;
    expected_overflow = 1'b0;
    expected_zero     = 1'b1;
    expected_error    = 1'b0;

    $display("//%4d |  %4t | %b %b  %b  | %b  %b %b %b %b | NAND                         //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 11: XNOR ______________________________________________________________________________________________________
    sel = `OP_XNOR; a = `OPERAND_WIDTH'b10101010; b = `OPERAND_WIDTH'b01010101; #10;
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b00000000;
    expected_overflow = 1'b0;
    expected_zero     = 1'b1;
    expected_error    = 1'b0;

    $display("//%4d |  %4t | %b %b  %b  | %b  %b %b %b %b | XNOR                         //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 12: Equal to part 1 ______________________________________________________________________________________________________
    sel = `OP_EQU; a = `OPERAND_WIDTH'b11111111; b = `OPERAND_WIDTH'b11111110; #10;
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b00000000; // should be false
    expected_overflow = 1'b0;
    expected_zero     = 1'b1;
    expected_error    = 1'b0;

    $display("//%4d |  %4t | %b %b  %b  | %b  %b %b %b %b | EQU                          //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 13: Equal to part 2 ______________________________________________________________________________________________________
    sel = `OP_EQU; a = `OPERAND_WIDTH'b01010101; b = `OPERAND_WIDTH'b01010101; #10;
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b00000001; // should be true
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("//%4d |  %4t | %b %b  %b  | %b  %b %b %b %b | EQU                          //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 14: Greater than part 1 ______________________________________________________________________________________________________
    sel = `OP_GREATER_THAN; a = `OPERAND_WIDTH'b00000111; b = `OPERAND_WIDTH'b00000011; #10; // 7 > 3
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b00000001; // should be true
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("//%4d |  %4t | %b %b  %b  | %b  %b %b %b %b | GREATER                      //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 15: Greater than part 2 ______________________________________________________________________________________________________
    sel = `OP_GREATER_THAN; a = `OPERAND_WIDTH'b00000001; b = `OPERAND_WIDTH'b00000011; #10; // 1 > 3
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b00000000; // should be false
    expected_overflow = 1'b0;
    expected_zero     = 1'b1;
    expected_error    = 1'b0;

    $display("//%4d |  %4t | %b %b  %b  | %b  %b %b %b %b | GREATER                      //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 16: Less than part 1 ______________________________________________________________________________________________________
    sel = `OP_LESS_THAN; a = `OPERAND_WIDTH'b00000001; b = `OPERAND_WIDTH'b00000011; #10; // 1 < 3
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b00000001; // should be true
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("//%4d |  %4t | %b %b  %b  | %b  %b %b %b %b | LESS                         //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 17: Less than part 2 ______________________________________________________________________________________________________
    sel = `OP_LESS_THAN; a = `OPERAND_WIDTH'b00000111; b = `OPERAND_WIDTH'b00000011; #10; // 7 < 3
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b00000000; // should be false
    expected_overflow = 1'b0;
    expected_zero     = 1'b1;
    expected_error    = 1'b0;

    $display("//%4d |  %4t | %b %b  %b  | %b  %b %b %b %b | LESS                         //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 18: Barrel shift right ______________________________________________________________________________________________________
    sel = `OP_ROTATE_RIGHT; a = `OPERAND_WIDTH'b11000000; b = `OPERAND_WIDTH'b00000011; #10; // Rotate right by 1
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b00011000; 
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("//%4d |  %4t | %b %b  %b  | %b  %b %b %b %b | ROTATE RIGHT                 //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;
    
    // Test 19: Barrel shift left ______________________________________________________________________________________________________
    sel = `OP_ROTATE_LEFT; a = `OPERAND_WIDTH'b00000001; b = `OPERAND_WIDTH'b00000001; #10; // Rotate left by 1
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b00000010; 
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("//%4d |  %4t | %b %b  %b  | %b  %b %b %b %b | ROTATE LEFT                  //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 20: Division ______________________________________________________________________________________________________
    sel = `OP_DIVIDE; a = `OPERAND_WIDTH'b00001100; b = `OPERAND_WIDTH'b00000100; #10; // 12 / 4 = 3
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b00000011; 
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("//%4d |  %4t | %b %b  %b  | %b  %b %b %b %b | DIVIDE                       //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 21: Division by zero ______________________________________________________________________________________________________
    sel = `OP_DIVIDE; a = `OPERAND_WIDTH'b00001100; b = `OPERAND_WIDTH'b00000000; #10; // Division by zero
    expected_error    = 1'b1;

    $display("//%4d |  %4t | %b %b  %b  | %b  %b %b %b %b | DIVIDE 0                     //", test_num, $time, a, b, sel, out, zero, carry, overflow, error);
    if (error !== expected_error) begin
      errors = errors | (1 << test_num);
    end 
    test_num++;

    // Test 22: Multiplication ______________________________________________________________________________________________________
    $display("//==============================================================================================//");
    $display("//===============================================================| High Reg  Low Reg |==========//");
    
    sel = `OP_MULT; a = `OPERAND_WIDTH'b00110101; b = `OPERAND_WIDTH'b00011100; #10; // 53 * 28  = 1484
    expected_carry    = 1'b0;
    expected_out      = `OPERAND_WIDTH'b11001100;
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;
    expected_hi_reg   = `OPERAND_WIDTH'b00000101; // For 8-bit multiplication, result fits in low_reg
    expected_low_reg  = `OPERAND_WIDTH'b11001100;

    $display("//%4d |  %4t | %b %b  %b  | %b  %b %b %b %b | %b %b | MULTIPLY //", test_num, $time, a, b, sel, out, zero, carry, overflow, error, hi_reg, low_reg);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow) || (hi_reg !== expected_hi_reg) || (low_reg !== expected_low_reg)) begin
      errors = errors | (1 << test_num);
    end;

//____________________________________________________________________________________________________________________________________

    $display("//==============================================================================================//\n");
    $display("//______________________________________________________________________________________________//");
    
    // error reporting 
    $display("//  DETAILS OF ERROR REPORT                                                                     //");
    for(i = 0; i < test_num ; i = i + 1) begin // loops through all tests
      is_there_an_error = (errors >> i) & 1;     // Check errors in each test by checking if bit is set
      if (is_there_an_error) begin
        $display("//  FAILED TEST NUMBER %0d                                                                      //", i);
        no_of_errors = no_of_errors+1;           // adds up errors
      end
    end
      
    if (errors > 0) begin
      $display("//  TEST FAILED, TOTAL NUMBER OF ERRORS IS %0d                                                  //", no_of_errors);
    end else begin
      $display("//  TEST SUCCESSFUL, NO ERRORS FOUND                                                            //");
    end
    $display("//______________________________________________________________________________________________//\n\n");
    $finish; // end of things being printed
  end   
endmodule

/* NOTES

1. creates an instance or a copy of the top module and connects it to the test bench signals
syntax => module_port_name(testbench_singal_name), dut = device under test

#10 = wait 10 nano seconds

*/
