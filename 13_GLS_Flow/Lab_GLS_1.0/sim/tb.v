`timescale 1ns/1ps
module tb;

//--------------------------------------------------------------------------
// DUT interface signals
//--------------------------------------------------------------------------
reg         clk;
reg         rst_n;
reg         en;
reg  [7:0]  a, b;

wire [15:0] result;
wire        valid;

//--------------------------------------------------------------------------
// Scoreboard counters
//--------------------------------------------------------------------------
integer tests  = 0;
integer errors = 0;

//==========================================================================
// DUT instantiation
// ----------------------------------------------------------------------
// Only ONE alu8_top exists per build (generate picks add_unit or mult_unit
// internally). Set OP(0) for the adder, OP(1) for the multiplier - no
// mode/add_en/mul_en needed anymore, just the single "en".
//==========================================================================
alu8_top dut (
    .clk    (clk),
    .rst_n  (rst_n),
    .en     (en),
    .a      (a),
    .b      (b),
    .result (result),
    .valid  (valid)
);

//==========================================================================
// Clock generation
//==========================================================================
initial clk = 0;
always #5 clk = ~clk;

//==========================================================================
// Stimulus driver task
//==========================================================================
task drive;
    input [7:0] ta;
    input [7:0] tb;
begin
    @(negedge clk);

    en = 1;
    a  = ta;
    b  = tb;

    @(negedge clk);
    en = 0;
end
endtask

//==========================================================================
// Result checking tasks
//==========================================================================
task check_result;
    input [127:0] op_name;
    input [7:0]   ta, tb;
    input [15:0]  expected;
begin
    tests = tests + 1;

    if (valid && (result === expected)) begin
        $display("  [%6t] PASS | %-4s | a=%-3d b=%-3d | result=%-6d",
                  $time, op_name, ta, tb, result);
    end
    else begin
        errors = errors + 1;
        $display("  [%6t] FAIL | %-4s | a=%-3d b=%-3d | got=%-6d (0x%04h) exp=%-6d | valid=%b",
                  $time, op_name, ta, tb, result, result, expected, valid);
    end
end
endtask

// check_add
task check_add;
    input [7:0]  ta, tb;
    input [15:0] expected;
begin
    @(posedge valid);
    #3;
    check_result("ADD", ta, tb, expected);
end
endtask

// check_mul:
task check_mul;
    input [7:0]  ta, tb;
    input [15:0] expected;
begin
    @(posedge valid);
    #3;
    check_result("MUL", ta, tb, expected);
end
endtask

//==========================================================================
// Main test sequence
//==========================================================================
initial begin

    $display("\n==================================================");
    $display("  ALU8_TOP TESTBENCH");
    $display("==================================================\n");


    rst_n = 0;
    en    = 0;
    a     = 0;
    b     = 0;

    // Hold reset for 5 clock cycles
    repeat (50) @(posedge clk);
    rst_n = 1;


    /*$dumpfile("VCD/Adder.vcd");
    $dumpvars(0, tb);
    //------------------------------------------------------------------
    // ADD Tests
    //------------------------------------------------------------------
    $display("---------------- ADD TESTS ----------------------");
    repeat (2) @(posedge clk);
    drive(8'd255, 8'd255); check_add(8'd255, 8'd255, 16'd510);
    drive(8'd254, 8'd253); check_add(8'd254, 8'd253, 16'd507);
    drive(8'd250, 8'd249); check_add(8'd250, 8'd249, 16'd499);
    drive(8'd240, 8'd230); check_add(8'd240, 8'd230, 16'd470);
    drive(8'd200, 8'd199); check_add(8'd200, 8'd199, 16'd399);
    drive(8'd180, 8'd175); check_add(8'd180, 8'd175, 16'd355);
    drive(8'd220, 8'd150); check_add(8'd220, 8'd150, 16'd370);
    drive(8'd128, 8'd127); check_add(8'd128, 8'd127, 16'd255);
    drive(8'd201, 8'd211); check_add(8'd201, 8'd211, 16'd412);
    drive(8'd245, 8'd190); check_add(8'd245, 8'd190, 16'd435);*/


    $dumpfile("VCD/Mult.vcd");
    $dumpvars(0, tb);
    //------------------------------------------------------------------
    // MUL Tests
    //------------------------------------------------------------------
    $display("\n---------------- MUL TESTS ----------------------");
    repeat (2) @(posedge clk);
    drive(8'd255, 8'd255); check_mul(8'd255, 8'd255, 16'd65025);
    drive(8'd254, 8'd253); check_mul(8'd254, 8'd253, 16'd64262);
    drive(8'd250, 8'd249); check_mul(8'd250, 8'd249, 16'd62250);
    drive(8'd240, 8'd230); check_mul(8'd240, 8'd230, 16'd55200);
    drive(8'd200, 8'd199); check_mul(8'd200, 8'd199, 16'd39800);
    drive(8'd180, 8'd175); check_mul(8'd180, 8'd175, 16'd31500);
    drive(8'd220, 8'd150); check_mul(8'd220, 8'd150, 16'd33000);
    drive(8'd128, 8'd127); check_mul(8'd128, 8'd127, 16'd16256);
    drive(8'd201, 8'd211); check_mul(8'd201, 8'd211, 16'd42411);
    drive(8'd245, 8'd190); check_mul(8'd245, 8'd190, 16'd46550);

    //------------------------------------------------------------------
    // Final summary report
    //------------------------------------------------------------------
    $display("\n==================================================");
    $display("  SUMMARY");
    $display("--------------------------------------------------");
    $display("  Total tests : %0d", tests);
    $display("  Passed      : %0d", tests - errors);
    $display("  Failed      : %0d", errors);
    if (errors == 0)
        $display("  RESULT: ALL TESTS PASSED\n");
    else
        $display("  RESULT: %0d TEST(S) FAILED\n", errors);

    $display("==================================================\n");

    #200;
    $stop;

end

endmodule
