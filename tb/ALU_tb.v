`timescale 1ns/1ps

module tb_top;
    // first, testbench signals (variables) are declared
    // these will be connected to the ALU module
    reg [1:0] a, b; // inputs
  	reg [2:0] sel;
  	reg error;
    wire [1:0] out;      // outputs
    wire zero, carry, overflow;
    
    top dut ( // instantiating the top module
        .a(a), .b(b), .sel(sel),
        .out(out), .zero(zero), 
        .carry(carry), .overflow(overflow), .error(error)
    );
    // creates an instance or a copy of the top module and connects it to the test bench signals
    // module_port_name(testbench_singal_name)
    // dut = device under test

    initial begin
        $display("Testing 2-bit ALU");
        $display("=================");
      $display("Time  | A   B  Sel | Out Z C O E | Operation");
      $display("------|------------|-------------|-----------");
        
        // Test ADD
        sel = 3'b000; a = 2'b01; b = 2'b01; #10;
        $display("%4t | %b %b  %b  | %b  %b %b %b %b | ADD 1+1=2", 
                 $time, a, b, sel, out, zero, carry, overflow, error);
        
        // Test ADD with carry
        sel = 3'b000; a = 2'b11; b = 2'b01; #10;
        $display("%4t | %b %b  %b  | %b  %b %b %b %b | ADD 3+1=0 (carry)", 
                 $time, a, b, sel, out, zero, carry, overflow, error);
        
        // Test SUB
        sel = 3'b001; a = 2'b11; b = 2'b01; #10;
        $display("%4t | %b %b  %b  | %b  %b %b %b %b | SUB 3-1=2", 
                 $time, a, b, sel, out, zero, carry, overflow, error);
        
        // Test AND
        sel = 3'b010; a = 2'b11; b = 2'b01; #10;
        $display("%4t | %b %b  %b  | %b  %b %b %b %b | AND 3&1=1", 
                 $time, a, b, sel, out, zero, carry, overflow, error);
        
        // Test OR
        sel = 3'b011; a = 2'b10; b = 2'b01; #10;
        $display("%4t | %b %b  %b  | %b  %b %b %b %b | OR 2|1=3", 
                 $time, a, b, sel, out, zero, carry, overflow, error);
        
        // Test invalid opcode
        sel = 3'b010; #10; // This is actually valid AND operation
        $display("%4t | %b %b  %b  | %b  %b %b %b %b | Valid op", 
                 $time, a, b, sel, out, zero, carry, overflow, error);
      
      	sel = 3'b100; #10; // Invalid operation
      $display("%4t | %b %b  %b  | %b  %b %b %b %b | Invalid op", 
                 $time, a, b, sel, out, zero, carry, overflow, error);
        
        $finish;
    end

endmodule
