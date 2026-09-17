`timescale 1ns/1ps

module tb;

    reg         CLK;
    reg         Load;
    reg         Up;
    reg         Down;
    reg  [4:0]  IN;
    wire [4:0]  Counter;
    wire        High;
    wire        Low;

    integer errors = 0;
    integer test_num = 0;

    // Instantiate DUT
    Up_Dn_Counter DUT (
        .CLK     (CLK),
        .Load    (Load),
        .Up      (Up),
        .Down    (Down),
        .IN      (IN),
        .Counter (Counter),
        .High    (High),
        .Low     (Low)
    );

    // Clock generation: 10 ns period
    initial CLK = 0;
    always #5 CLK = ~CLK;

    // Waveform dump
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb);
    end

    // Checker task: run after each posedge settles, compares expected value
    task check_counter(input [4:0] expected, input [399:0] msg);
        begin
            test_num = test_num + 1;
            if (Counter !== expected) begin
                $display("[%0t ns] TEST %0d FAILED : %0s | Expected Counter=%0d, Got Counter=%0d",
                           $time, test_num, msg, expected, Counter);
                errors = errors + 1;
            end
            else begin
                $display("[%0t ns] TEST %0d PASSED : %0s | Counter=%0d (High=%b, Low=%b)",
                           $time, test_num, msg, Counter, High, Low);
            end
        end
    endtask

    initial begin
        $display("=====================================================");
        $display(" Up_Dn_Counter Testbench - Simulation Log");
        $display("=====================================================");

        // Initialize all inputs
        Load = 0; Up = 0; Down = 0; IN = 5'd0;

        // ---------------------------------------------------------
        // Test 1: Synchronous Load
        // ---------------------------------------------------------
        @(negedge CLK);
        Load = 1; IN = 5'd10; Up = 0; Down = 0;
        @(posedge CLK); #1;
        check_counter(5'd10, "Load IN=10");
        @(negedge CLK);
        Load = 0;

        // ---------------------------------------------------------
        // Test 2: Up and Down Counting (Normal Increment / Decrement)
        // ---------------------------------------------------------
        Up = 1; Down = 0;
        @(posedge CLK); #1;
        check_counter(5'd11, "Up increment from 10");
        @(negedge CLK);
        Up = 0; Down = 1;
        @(posedge CLK); #1;
        check_counter(5'd10, "Down decrement from 11");
        @(negedge CLK);
        Down = 0;

        // ---------------------------------------------------------
        // Test 3: Load has highest priority (Load asserted with Up & Down)
        // ---------------------------------------------------------
        Load = 1; Up = 1; Down = 1; IN = 5'd5;
        @(posedge CLK); #1;
        check_counter(5'd5, "Load priority over Up & Down (IN=5)");
        @(negedge CLK);
        Load = 0; Up = 0; Down = 0;

        // ---------------------------------------------------------
        // Test 4: Down has priority over Up (Load=0, Up=1, Down=1)
        // ---------------------------------------------------------
        Up = 1; Down = 1;
        @(posedge CLK); #1;
        check_counter(5'd4, "Down priority over Up (from 5)");
        @(negedge CLK);
        Up = 0; Down = 0;

        // ---------------------------------------------------------
        // Test 5: Up saturation at 31 (High flag check)
        // ---------------------------------------------------------
        Load = 1; IN = 5'd31; Up = 0; Down = 0;
        @(posedge CLK); #1;
        check_counter(5'd31, "Load IN=31 (boundary)");
        @(negedge CLK);
        Load = 0; Up = 1;
        @(posedge CLK); #1;
        check_counter(5'd31, "Up saturates at 31");
        if (High !== 1'b1) begin
            $display("[%0t ns] TEST FAILED : High flag not asserted at Counter=31", $time);
            errors = errors + 1;
        end
        else
            $display("[%0t ns] High flag correctly asserted at Counter=31", $time);
        @(negedge CLK);
        Up = 0;

        // ---------------------------------------------------------
        // Test 6: Down saturation at 0 (Low flag check)
        // ---------------------------------------------------------
        Load = 1; IN = 5'd0; Down = 0; Up = 0;
        @(posedge CLK); #1;
        check_counter(5'd0, "Load IN=0 (boundary)");
        @(negedge CLK);
        Load = 0; Down = 1;
        @(posedge CLK); #1;
        check_counter(5'd0, "Down saturates at 0");
        if (Low !== 1'b1) begin
            $display("[%0t ns] TEST FAILED : Low flag not asserted at Counter=0", $time);
            errors = errors + 1;
        end
        else
            $display("[%0t ns] Low flag correctly asserted at Counter=0", $time);
        @(negedge CLK);
        Down = 0;

        // ---------------------------------------------------------
        // Test 7: Hold value when Load=Up=Down=0
        // ---------------------------------------------------------
        Load = 1; IN = 5'd15;
        @(posedge CLK); #1;
        check_counter(5'd15, "Load IN=15 for hold test");
        @(negedge CLK);
        Load = 0; Up = 0; Down = 0;
        @(posedge CLK); #1;
        check_counter(5'd15, "Hold value (no control signal)");

        // ---------------------------------------------------------
        // Summary
        // ---------------------------------------------------------
        $display("=====================================================");
        if (errors == 0)
            $display(" ALL %0d TESTS PASSED SUCCESSFULLY", test_num);
        else
            $display(" %0d OUT OF %0d TESTS FAILED", errors, test_num);
        $display("=====================================================");

        #20;
        $finish;
    end

endmodule
