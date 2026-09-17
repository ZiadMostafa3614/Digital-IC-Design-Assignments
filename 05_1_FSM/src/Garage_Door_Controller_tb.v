`timescale 1ns / 1ps
// ============================================================
//  Testbench : Garage_Door_Controller_tb
//  Project   : Assignment 5.1 – Automatic Garage Door Controller
//  Clock     : 50 MHz  →  period = 20 ns
//  Date      : 2026-07-22
// ============================================================
module Garage_Door_Controller_tb;

    // Inputs
    reg CLK;
    reg RST;
    reg Activate;
    reg UP_Max;
    reg DN_Max;

    // Outputs
    wire UP_M;
    wire DN_M;

    // Internal trackers
    integer pass_count = 0;
    integer fail_count = 0;
    integer test_num = 0;

    // Instantiate DUT
    Garage_Door_Controller DUT (
        .CLK(CLK),
        .RST(RST),
        .Activate(Activate),
        .UP_Max(UP_Max),
        .DN_Max(DN_Max),
        .UP_M(UP_M),
        .DN_M(DN_M)
    );

    // Clock Generation: 50 MHz = 20 ns period
    initial CLK = 0;
    always #10 CLK = ~CLK;

    // Waveform Dump
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, Garage_Door_Controller_tb);
    end

    // Assertion task to check motor outputs
    task check_outputs(input exp_up, input exp_dn, input [399:0] msg);
        begin
            test_num = test_num + 1;
            if (UP_M !== exp_up || DN_M !== exp_dn) begin
                $display("[%0t ns] TEST %0d FAILED : %0s | Expected UP_M=%b, DN_M=%b | Got UP_M=%b, DN_M=%b",
                         $time, test_num, msg, exp_up, exp_dn, UP_M, DN_M);
                fail_count = fail_count + 1;
            end else begin
                $display("[%0t ns] TEST %0d PASSED : %0s | UP_M=%b, DN_M=%b",
                         $time, test_num, msg, UP_M, DN_M);
                pass_count = pass_count + 1;
            end
        end
    endtask

    initial begin
        $display("=========================================================");
        $display(" Garage Door Controller Testbench - 50 MHz Simulation");
        $display("=========================================================");

        // 1. Initialize Inputs
        RST = 0;
        Activate = 0;
        UP_Max = 0;
        DN_Max = 0;

        // Wait 40 ns and release Reset
        #40;
        RST = 1;
        #1;
        check_outputs(1'b0, 1'b0, "Initialization (Reset State)");

        // ---------------------------------------------------------
        // Test 2: Activate with no limit sensor active (Door in intermediate state)
        // ---------------------------------------------------------
        @(negedge CLK);
        Activate = 1; UP_Max = 0; DN_Max = 0;
        @(posedge CLK); #1;
        check_outputs(1'b0, 1'b0, "Activate ignored if door not fully open or closed");
        @(negedge CLK);
        Activate = 0;

        // ---------------------------------------------------------
        // Test 3: Door Fully Closed -> Trigger Opening sequence
        // ---------------------------------------------------------
        @(negedge CLK);
        DN_Max = 1; UP_Max = 0;
        @(negedge CLK);
        Activate = 1;
        @(posedge CLK); #1;
        check_outputs(1'b1, 1'b0, "Start Moving Up (UP_M=1) when activated and closed");
        
        // Deassert Activate, clear DN_Max (door starts rising and leaves the bottom sensor)
        @(negedge CLK);
        Activate = 0; DN_Max = 0;
        @(posedge CLK); #1;
        check_outputs(1'b1, 1'b0, "UP_M stays active when rising (DN_Max leaves)");

        #100; // Let door rise for a while

        // Reach Top limit sensor
        @(negedge CLK);
        UP_Max = 1;
        @(posedge CLK); #1;
        check_outputs(1'b0, 1'b0, "Reaching UP_Max clears UP_M (back to IDLE)");

        // ---------------------------------------------------------
        // Test 4: Door Fully Open -> Trigger Closing sequence
        // ---------------------------------------------------------
        @(negedge CLK);
        // Door remains at the top
        UP_Max = 1; DN_Max = 0;
        @(negedge CLK);
        Activate = 1;
        @(posedge CLK); #1;
        check_outputs(1'b0, 1'b1, "Start Moving Down (DN_M=1) when activated and open");

        // Deassert Activate, clear UP_Max (door starts descending and leaves the top sensor)
        @(negedge CLK);
        Activate = 0; UP_Max = 0;
        @(posedge CLK); #1;
        check_outputs(1'b0, 1'b1, "DN_M stays active when falling (UP_Max leaves)");

        #100; // Let door descend for a while

        // Reach Bottom limit sensor
        @(negedge CLK);
        DN_Max = 1;
        @(posedge CLK); #1;
        check_outputs(1'b0, 1'b0, "Reaching DN_Max clears DN_M (back to IDLE)");

        // ---------------------------------------------------------
        // Test 5: Verify Asynchronous Reset interrupts operation
        // ---------------------------------------------------------
        @(negedge CLK);
        DN_Max = 1; UP_Max = 0;
        @(negedge CLK);
        Activate = 1;
        @(posedge CLK); #1;
        check_outputs(1'b1, 1'b0, "Moving Up (Verification before reset check)");
        
        // Assert Reset asynchronously
        #5;
        RST = 0;
        #1;
        check_outputs(1'b0, 1'b0, "Asynchronous reset stops motor immediately");

        #20;
        RST = 1;
        #20;

        $display("=========================================================");
        $display(" RESULTS: %0d PASSED, %0d FAILED (out of %0d assertions)", pass_count, fail_count, test_num);
        $display("=========================================================");
        
        #100;
        $finish;
    end

endmodule
