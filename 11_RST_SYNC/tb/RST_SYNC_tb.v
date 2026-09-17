`timescale 1ns/1ps

// ============================================================================
// Module Name  : RST_SYNC_tb
// Description  : Self-checking Testbench for RST_SYNC (Reset Synchronizer)
//                Validates immediate asynchronous reset assertion and
//                clock-synchronous reset de-assertion.
// ============================================================================

module RST_SYNC_tb;

    // Clock Parameters
    parameter CLK_PERIOD = 10.0; // 100 MHz (Period = 10 ns)

    // Testbench Signals for Default DUT (NUM_STAGES = 2)
    reg  CLK;
    reg  RST;
    wire SYNC_RST_2stage;

    // Testbench Signals for 4-Stage DUT (NUM_STAGES = 4)
    wire SYNC_RST_4stage;

    // Verification Variables
    integer err_count;

    // Instantiate Default DUT (2 Stages)
    RST_SYNC #(
        .NUM_STAGES(2)
    ) uut_2stage (
        .RST     (RST),
        .CLK     (CLK),
        .SYNC_RST(SYNC_RST_2stage)
    );

    // Instantiate 4-Stage DUT (NUM_STAGES = 4)
    RST_SYNC #(
        .NUM_STAGES(4)
    ) uut_4stage (
        .RST     (RST),
        .CLK     (CLK),
        .SYNC_RST(SYNC_RST_4stage)
    );

    // ------------------------------------------------------------------------
    // Clock Generation
    // ------------------------------------------------------------------------
    always #(CLK_PERIOD / 2.0) CLK = ~CLK;

    // ------------------------------------------------------------------------
    // Main Test Execution Procedure
    // ------------------------------------------------------------------------
    initial begin
        // Initialize Signals
        CLK       = 1'b0;
        RST       = 1'b0; // Start in Reset
        err_count = 0;

        $display("=========================================================");
        $display("  RESET SYNCHRONIZER (RST_SYNC) SIMULATION TESTBENCH     ");
        $display("  Clock Frequency: 100 MHz (Period = 10 ns)              ");
        $display("=========================================================");

        // --------------------------------------------------------------------
        // TEST CASE 1: Initial Reset Status Check
        // --------------------------------------------------------------------
        #5;
        $display("\n--- TC1: Initial Reset Status Check ---");
        if (SYNC_RST_2stage !== 1'b0 || SYNC_RST_4stage !== 1'b0) begin
            $display("  -> ERROR: SYNC_RST not zero during active reset!");
            err_count = err_count + 1;
        end else begin
            $display("  -> SUCCESS: SYNC_RST is zero during active reset.");
        end

        // --------------------------------------------------------------------
        // TEST CASE 2: Synchronous De-assertion Test (2 Stages)
        // --------------------------------------------------------------------
        $display("\n--- TC2: Synchronous De-assertion Test (NUM_STAGES = 2) ---");
        test_deassertion_2stage();

        // --------------------------------------------------------------------
        // TEST CASE 3: Immediate Asynchronous Assertion Test
        // --------------------------------------------------------------------
        $display("\n--- TC3: Immediate Asynchronous Reset Assertion Test ---");
        test_async_assertion();

        // --------------------------------------------------------------------
        // TEST CASE 4: Parameter Overriding Test (NUM_STAGES = 4)
        // --------------------------------------------------------------------
        $display("\n--- TC4: Synchronous De-assertion Test (NUM_STAGES = 4) ---");
        test_deassertion_4stage();

        // --------------------------------------------------------------------
        // FINAL SUMMARY
        // --------------------------------------------------------------------
        $display("\n=========================================================");
        if (err_count == 0)
            $display("  ALL TEST CASES PASSED SUCCESSFULLY! (0 Errors)");
        else
            $display("  SIMULATION FAILED WITH %0d ERRORS!", err_count);
        $display("=========================================================");
        #50;
        $stop;
    end

    // ------------------------------------------------------------------------
    // Verification Tasks
    // ------------------------------------------------------------------------

    // TC2 Task: Test De-assertion for 2-stage synchronizer
    task test_deassertion_2stage;
    begin
        // Release RST asynchronously mid-clock-cycle (at offset +3.5 ns after negedge)
        @(negedge CLK);
        #3.5;
        RST = 1'b1; // Asynchronous de-assertion
        $display("  -> RST de-asserted asynchronously to 1 mid-cycle");

        // Verify SYNC_RST remains 0 before clock edge
        if (SYNC_RST_2stage !== 1'b0) begin
            $display("  -> ERROR: SYNC_RST de-asserted before clock edge!");
            err_count = err_count + 1;
        end

        // 1st posedge CLK: sync_reg becomes 2'b01 (SYNC_RST = 0)
        @(posedge CLK);
        #1;
        if (SYNC_RST_2stage !== 1'b0) begin
            $display("  -> ERROR: SYNC_RST de-asserted after only 1 cycle (exp 2)!");
            err_count = err_count + 1;
        end else begin
            $display("  -> Verified 1st clock edge: SYNC_RST stays 0 (1st stage captured)");
        end

        // 2nd posedge CLK: sync_reg becomes 2'b11 (SYNC_RST = 1)
        @(posedge CLK);
        #1;
        if (SYNC_RST_2stage !== 1'b1) begin
            $display("  -> ERROR: SYNC_RST failed to de-assert on 2nd clock edge!");
            err_count = err_count + 1;
        end else begin
            $display("  -> SUCCESS: SYNC_RST de-asserted to 1 synchronously on 2nd clock edge!");
        end

        repeat(2) @(posedge CLK);
    end
    endtask

    // TC3 Task: Test Immediate Asynchronous Assertion
    task test_async_assertion;
    begin
        // Assert RST asynchronously mid-cycle
        @(posedge CLK);
        #2.5; // Mid-cycle offset
        RST = 1'b0; // Asynchronous assertion
        #0.5; // Less than 1 ns check

        if (SYNC_RST_2stage !== 1'b0) begin
            $display("  -> ERROR: Asynchronous reset assertion failed to drop SYNC_RST immediately!");
            err_count = err_count + 1;
        end else begin
            $display("  -> SUCCESS: SYNC_RST dropped to 0 immediately (<1 ns) upon async RST assertion.");
        end

        repeat(2) @(posedge CLK);
    end
    endtask

    // TC4 Task: Test De-assertion for 4-stage synchronizer
    task test_deassertion_4stage;
        integer cycle;
    begin
        @(negedge CLK);
        #3.5;
        RST = 1'b1;

        for (cycle = 1; cycle <= 3; cycle = cycle + 1) begin
            @(posedge CLK);
            #1;
            if (SYNC_RST_4stage !== 1'b0) begin
                $display("  -> ERROR: 4-stage SYNC_RST de-asserted prematurely at cycle %0d!", cycle);
                err_count = err_count + 1;
            end
        end

        // 4th posedge CLK: SYNC_RST_4stage should de-assert
        @(posedge CLK);
        #1;
        if (SYNC_RST_4stage !== 1'b1) begin
            $display("  -> ERROR: 4-stage SYNC_RST failed to de-assert on 4th clock edge!");
            err_count = err_count + 1;
        end else begin
            $display("  -> SUCCESS: 4-stage SYNC_RST de-asserted to 1 synchronously on 4th clock edge!");
        end

        repeat(2) @(posedge CLK);
    end
    endtask

endmodule
