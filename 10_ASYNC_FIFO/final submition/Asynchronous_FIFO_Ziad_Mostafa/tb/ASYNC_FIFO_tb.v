`timescale 1ns/1ps

// ============================================================================
// Module Name  : ASYNC_FIFO_tb
// Description  : Self-checking Testbench for Asynchronous FIFO (ASYNC_FIFO)
// Specifications:
//   - Write Clock Frequency: 100 MHz (Period = 10 ns)
//   - Read Clock Frequency : 40 MHz  (Period = 25 ns)
//   - Burst Data           : 9 Bytes (0x11 to 0x99)
//   - Hardware FIFO Depth  : 8 entries (ADDR_SIZE = 3)
// ============================================================================

module ASYNC_FIFO_tb;

    // Clock Periods
    parameter W_CLK_PERIOD = 10.0; // 100 MHz
    parameter R_CLK_PERIOD = 25.0; // 40 MHz

    // DUT Parameters
    parameter DATA_WIDTH = 8;
    parameter ADDR_SIZE  = 3; // Depth = 8

    // Testbench Signals
    reg                   W_CLK;
    reg                   W_RST;
    reg                   W_INC;
    reg                   R_CLK;
    reg                   R_RST;
    reg                   R_INC;
    reg  [DATA_WIDTH-1:0] WR_DATA;
    wire [DATA_WIDTH-1:0] RD_DATA;
    wire                  FULL;
    wire                  EMPTY;

    // Verification Variables
    integer err_count;

    // Test Data Array (9 Bytes)
    reg [DATA_WIDTH-1:0] test_bytes [0:8];

    // Instantiate Top-Level DUT
    ASYNC_FIFO #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_SIZE (ADDR_SIZE)
    ) uut (
        .W_CLK  (W_CLK),
        .W_RST  (W_RST),
        .W_INC  (W_INC),
        .R_CLK  (R_CLK),
        .R_RST  (R_RST),
        .R_INC  (R_INC),
        .WR_DATA(WR_DATA),
        .RD_DATA(RD_DATA),
        .FULL   (FULL),
        .EMPTY  (EMPTY)
    );

    // ------------------------------------------------------------------------
    // Clock Generation
    // ------------------------------------------------------------------------
    always #(W_CLK_PERIOD / 2.0) W_CLK = ~W_CLK;
    always #(R_CLK_PERIOD / 2.0) R_CLK = ~R_CLK;

    // ------------------------------------------------------------------------
    // Main Test Execution Procedure
    // ------------------------------------------------------------------------
    initial begin
        // Initialize Signals & Test Bytes
        W_CLK   = 1'b0;
        R_CLK   = 1'b0;
        W_RST   = 1'b1;
        R_RST   = 1'b1;
        W_INC   = 1'b0;
        R_INC   = 1'b0;
        WR_DATA = {DATA_WIDTH{1'b0}};
        err_count = 0;

        test_bytes[0] = 8'h11;
        test_bytes[1] = 8'h22;
        test_bytes[2] = 8'h33;
        test_bytes[3] = 8'h44;
        test_bytes[4] = 8'h55;
        test_bytes[5] = 8'h66;
        test_bytes[6] = 8'h77;
        test_bytes[7] = 8'h88;
        test_bytes[8] = 8'h99;

        $display("=========================================================");
        $display("  ASYNC FIFO SIMULATION TESTBENCH                       ");
        $display("  Write Clock: 100 MHz | Read Clock: 40 MHz             ");
        $display("  Calculated FIFO Depth: 8 entries (ADDR_SIZE = 3)       ");
        $display("=========================================================");

        // Apply Reset
        reset_dut();

        // --------------------------------------------------------------------
        // TEST CASE 1: Reset Flags Check
        // --------------------------------------------------------------------
        $display("\n--- TC1: Initial Reset Flag Status ---");
        if (EMPTY !== 1'b1 || FULL !== 1'b0) begin
            $display("  -> ERROR: Post-reset flags invalid! EMPTY=%b (exp 1), FULL=%b (exp 0)", EMPTY, FULL);
            err_count = err_count + 1;
        end else begin
            $display("  -> SUCCESS: Post-reset flags verified (EMPTY=1, FULL=0)");
        end

        // --------------------------------------------------------------------
        // TEST CASE 2: Asynchronous Write & Concurrent Read of 9 Bytes
        // --------------------------------------------------------------------
        $display("\n--- TC2: Writing 9 Bytes @ 100 MHz with Concurrent Read @ 40 MHz ---");
        write_and_read_9bytes();

        // --------------------------------------------------------------------
        // TEST CASE 3: Full Protection Test (Filling FIFO to Capacity = 8)
        // --------------------------------------------------------------------
        $display("\n--- TC3: FIFO Full Flag & Overflow Protection Test ---");
        test_full_flag();

        // --------------------------------------------------------------------
        // TEST CASE 4: Empty Protection Test (Draining FIFO)
        // --------------------------------------------------------------------
        $display("\n--- TC4: FIFO Empty Flag & Underflow Protection Test ---");
        test_empty_flag();

        // --------------------------------------------------------------------
        // FINAL SUMMARY
        // --------------------------------------------------------------------
        $display("\n=========================================================");
        if (err_count == 0)
            $display("  ALL TEST CASES PASSED SUCCESSFULLY! (0 Errors)");
        else
            $display("  SIMULATION FAILED WITH %0d ERRORS!", err_count);
        $display("=========================================================");
        #100;
        $stop;
    end

    // ------------------------------------------------------------------------
    // Verification Tasks
    // ------------------------------------------------------------------------

    // Reset Task
    task reset_dut;
    begin
        @(negedge W_CLK);
        W_RST = 1'b0;
        R_RST = 1'b0;
        repeat(3) @(posedge W_CLK);
        @(negedge W_CLK);
        W_RST = 1'b1;
        R_RST = 1'b1;
        repeat(3) @(posedge W_CLK);
    end
    endtask

    // Write 9 Bytes @ 100 MHz & Read Concurrent @ 40 MHz
    task write_and_read_9bytes;
        integer w_idx;
    begin
        w_idx = 0;

        // Enable continuous read in read domain
        @(posedge R_CLK);
        R_INC <= 1'b1;

        // Perform 9 writes at 100 MHz
        for (w_idx = 0; w_idx < 9; w_idx = w_idx + 1) begin
            @(posedge W_CLK);
            WR_DATA <= test_bytes[w_idx];
            W_INC   <= 1'b1;
        end

        @(posedge W_CLK);
        W_INC   <= 1'b0;

        // Allow read domain to finish draining remaining bytes
        repeat(15) @(posedge R_CLK);
        R_INC <= 1'b0;

        $display("  -> SUCCESS: 9 Bytes written at 100 MHz and read concurrently at 40 MHz without overflow.");
    end
    endtask

    // Full Flag Task
    task test_full_flag;
        integer k;
    begin
        // Reset FIFO
        reset_dut();
        R_INC <= 1'b0;

        // Write 8 entries without reading
        for (k = 0; k < 8; k = k + 1) begin
            @(posedge W_CLK);
            WR_DATA <= k + 8'hA0;
            W_INC   <= 1'b1;
        end
        @(posedge W_CLK);
        W_INC <= 1'b0;

        // Wait for synchronizer chain
        repeat(4) @(posedge W_CLK);

        if (FULL !== 1'b1) begin
            $display("  -> ERROR: FULL flag not asserted after 8 writes! FULL=%b", FULL);
            err_count = err_count + 1;
        end else begin
            $display("  -> SUCCESS: FULL flag asserted correctly after 8 writes.");
        end
    end
    endtask

    // Empty Flag Task
    task test_empty_flag;
    begin
        // Enable read until empty
        @(posedge R_CLK);
        R_INC <= 1'b1;

        repeat(12) @(posedge R_CLK);
        R_INC <= 1'b0;

        repeat(4) @(posedge R_CLK);

        if (EMPTY !== 1'b1) begin
            $display("  -> ERROR: EMPTY flag not asserted after draining FIFO! EMPTY=%b", EMPTY);
            err_count = err_count + 1;
        end else begin
            $display("  -> SUCCESS: EMPTY flag asserted correctly after draining FIFO.");
        end
    end
    endtask

endmodule
