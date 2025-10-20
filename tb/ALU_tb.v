// _______________________________________________________________________
// automatic self checking testbench for ALU.v with error report
// uses bitmask (errors register) to track when specific tasks have faild
// _______________________________________________________________________

`timescale 1ns/1ps // specifies the time units and precision for sim
`include "ALU.v"
`include "ALU_constants.vh"

module tb_top;
  // first, testbench signals are declared
  // these will be connected to the ALU module
  reg [1:0] a, b;  // inputs    
  reg [3:0] sel;
  reg error;
  wire [1:0] out;  // outputs
  wire zero, carry, overflow;

  // expected outputs are declared here
  reg [1:0] expected_out; 
  reg expected_zero, expected_carry, expected_overflow, expected_error;

  // errror handling & reporting
  reg [`TESTS-1:0] errors;
  reg is_there_an_error;
  integer i, no_of_errors = 0; // for calculating no of errors in for loop
    
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
	$display("=====================================================");
    $display("                ALU TESTBENCH");
    $display("=====================================================");
    $display(" Time  | A   B   Sel  | Out Z C O E |   Operation");
    $display("_______|______________|_____________|________________");
        
    // Test 0: ADD _____________________________________________________________________________________________________________
    sel = `OP_ADD; a = 2'b01; b = 2'b01;#10;  // seting up sim inputs, ans wait for combinational logic to stabilize
    expected_carry    = 1'b0;                 // setting up expected outputs
    expected_out      = 2'b10;
    expected_overflow = 1'b1;
    expected_zero     = 1'b0;  
    expected_error    = 1'b0;

    $display("%4t  | %b %b  %b  | %b  %b %b %b %b | ADD 1 + 1 = 2", $time, a, b, sel, out, zero, carry, overflow, error); // printing results
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << 0); // if the expected outputs arent the test outputs, mark as an error
    end 
        
    // Test 1: ADD with carry __________________________________________________________________________________________________
    sel = `OP_ADD; a = 2'b11; b = 2'b01; #10;
    expected_carry    = 1'b1;
    expected_out      = 2'b00;
    expected_overflow = 1'b0;
    expected_zero     = 1'b1;
    expected_error    = 1'b0;

    $display("%4t  | %b %b  %b  | %b  %b %b %b %b | ADD 3 + 1 = 0 (w/ carry)", $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << 1);
    end 

    // Test 2: SUB _____________________________________________________________________________________________________________
    sel = `OP_SUB; a = 2'b11; b = 2'b01; #10;
    expected_carry    = 1'b0;
    expected_out      = 2'b10;
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("%4t  | %b %b  %b  | %b  %b %b %b %b | SUB 3 - 1 = 2 ", $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << 2);
    end 

    // Test 3: AND _____________________________________________________________________________________________________________
    sel = `OP_AND; a = 2'b11; b = 2'b01; #10;
    expected_carry    = 1'b0;
    expected_out      = 2'b01;
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("%4t  | %b %b  %b  | %b  %b %b %b %b | AND 3 & 1 = 1", $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << 3);
    end 

    // Test 4: OR _____________________________________________________________________________________________________________
    sel = `OP_OR; a = 2'b10; b = 2'b01; #10;
    expected_carry    = 1'b0;
    expected_out      = 2'b11;
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("%4t  | %b %b  %b  | %b  %b %b %b %b | OR 2 | 1 = 3", $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << 4);
    end 

    // Test 5: valid opcode ______________________________________________________________________________________________________
    sel = `OP_AND; a = 2'b10; b = 2'b01; #10; // Valid AND operation
    expected_error = 1'b0;

    $display("%4t  | %b %b  %b  | %b  %b %b %b %b | Valid op", $time, a, b, sel, out, zero, carry, overflow, error);
    if (error !== expected_error) begin
      errors = errors | (1 << 5);
    end 

    // Test 6: invalid opcode ___________________________________________________________________________________________________
    sel = 4'b1000; a = 2'b10; b = 2'b01; #10; // Invalid operation
    expected_error = 1'b1;

    $display("%4t  | %b %b  %b  | %b  %b %b %b %b | Invalid op", $time, a, b, sel, out, zero, carry, overflow, error);  
    if (error !== expected_error) begin
      errors = errors | (1 << 6);
    end 

    // Test 7: XOR _____________________________________________________________________________________________________________
    sel = `OP_XOR; a = 2'b10; b = 2'b01; #10;
    expected_carry    = 1'b0;
    expected_out      = 2'b11;
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("%4t  | %b %b  %b  | %b  %b %b %b %b | XOR 2 ^ 1 = 3", $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << 7);
    end 

    // Test 8: NOR _____________________________________________________________________________________________________________
    sel = `OP_NOR; a = 2'b00; b = 2'b00; #10;
    expected_carry    = 1'b0;
    expected_out      = 2'b11;
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("%4t  | %b %b  %b  | %b  %b %b %b %b | NOR ~(0 | 0) = 3", $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << 8);
    end 

    // Test 9: NAND _____________________________________________________________________________________________________________
    sel = `OP_NAND; a = 2'b11; b = 2'b01; #10;
    expected_carry    = 1'b0;
    expected_out      = 2'b10;
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("%4t | %b %b  %b  | %b  %b %b %b %b | NAND ~(3 & 1) = 2", $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << 9);
    end 

    // Test 10: XNOR _____________________________________________________________________________________________________________
    sel = `OP_XNOR; a = 2'b10; b = 2'b01; #10;
    expected_carry    = 1'b0;
    expected_out      = 2'b00;
    expected_overflow = 1'b0;
    expected_zero     = 1'b1;
    expected_error    = 1'b0;

    $display("%4t | %b %b  %b  | %b  %b %b %b %b | XNOR ~(2 ^ 1) = 0", $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << 10);
    end 

    // Test 11: Modulo part 1 _____________________________________________________________________________________________________________
    sel = `OP_MODULO; a = 2'b11; b = 2'b01; #10;
    expected_carry    = 1'b0;
    expected_out      = 2'b00; // should be zero
    expected_overflow = 1'b0;
    expected_zero     = 1'b1;
    expected_error    = 1'b0;

    $display("%4t | %b %b  %b  | %b  %b %b %b %b | Modulo of 3/1 = 0", $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << 11);
    end

    // Test 12: Modulo part 2 _____________________________________________________________________________________________________________
    sel = `OP_MODULO; a = 2'b11; b = 2'b10; #10;
    expected_carry    = 1'b0;
    expected_out      = 2'b01; // should be one
    expected_overflow = 1'b0;
    expected_zero     = 1'b0;
    expected_error    = 1'b0;

    $display("%4t | %b %b  %b  | %b  %b %b %b %b | Modulo of 3/2 = 1", $time, a, b, sel, out, zero, carry, overflow, error);
    if ((out !== expected_out) || (zero !== expected_zero) || (carry !== expected_carry) || (overflow !== expected_overflow)) begin
      errors = errors | (1 << 12);
    end 

    $display("=====================================================");
    $display("_____________________________________________________");
    
    // error reporting 
    $display("DETAILS OF ERROR REPORT\n");
    for(i = 0; i < `TESTS ; i = i + 1) begin #10 // loops through all tests
      is_there_an_error = (errors >> i) & 1;     // Check errors in each test yb checking if bit is set
      if (is_there_an_error) begin
        $display("FAILED TEST NUMBER %0d", i+1);
        no_of_errors = no_of_errors+1;           // adds up errors
      end
    end
      
    if (errors > 0) begin
      $display("TEST FAILED, TOTAL NUMBER OF ERRORS IS %0d", no_of_errors);
    end else begin
      $display("TEST SUCCESSFUL, NO ERRORS FOUND");
    end
    $display("_____________________________________________________\n\n");
    $finish; // end of things being printed
  end   
endmodule

/* NOTES
1. creates an instance or a copy of the top module and connects it to the test bench signals

module_port_name(testbench_singal_name), dut = device under test


#10 = wait 10 nano seconds
