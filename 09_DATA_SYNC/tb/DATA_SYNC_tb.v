`timescale 1ns/1ps

// ============================================================================
// Module Name  : DATA_SYNC_tb
// Description  : Self-checking Testbench for DATA_SYNC (Data Synchronizer)
//                Simulates an asynchronous Clock Domain Crossing (CDC) setup.
// ============================================================================

module DATA_SYNC_tb;

    // Parameters
    parameter TX_CLK_PERIOD   = 20.0; // Source Clock: 50 MHz (Period = 20 ns)
    parameter DEST_CLK_PERIOD = 10.0; // Destination Clock: 100 MHz (Period = 10 ns)

    // DUT Default Parameters
    parameter NUM_STAGES = 2;
    parameter BUS_WIDTH  = 8;

    // Testbench Signals
    reg                   tx_clk;
    reg                   CLK;
    reg                   RST;
    reg  [BUS_WIDTH-1:0]  unsync_bus;
    reg                   bus_enable;
    wire [BUS_WIDTH-1:0]  sync_bus;
    wire                  enable_pulse;

    // Verification Variables
    integer err_count;
    integer timeout_cnt;

    // Pulse capture flag (set by monitor process)
    reg pulse_captured;
    reg [BUS_WIDTH-1:0] captured_data;

    // Instantiate Default DUT
    DATA_SYNC #(
        .NUM_STAGES(NUM_STAGES),
        .BUS_WIDTH(BUS_WIDTH)
    ) uut (
        .unsync_bus  (unsync_bus),
        .bus_enable  (bus_enable),
        .CLK         (CLK),
        .RST         (RST),
        .sync_bus    (sync_bus),
        .enable_pulse(enable_pulse)
    );

    // ------------------------------------------------------------------------
    // Clock Generation
    // ------------------------------------------------------------------------
    always #(TX_CLK_PERIOD / 2.0)   tx_clk = ~tx_clk;
    always #(DEST_CLK_PERIOD / 2.0) CLK    = ~CLK;

    // ------------------------------------------------------------------------
    // Enable Pulse Monitor (captures enable_pulse events concurrently)
    // ------------------------------------------------------------------------
    always @(posedge CLK) begin
        if (enable_pulse === 1'b1) begin
            pulse_captured <= 1'b1;
            captured_data  <= sync_bus;
        end
    end

    // ------------------------------------------------------------------------
    // Main Test Execution Procedure
    // ------------------------------------------------------------------------
    initial begin
        // Initialize Signals
        tx_clk         = 1'b0;
        CLK            = 1'b0;
        RST            = 1'b1;
        unsync_bus     = {BUS_WIDTH{1'b0}};
        bus_enable     = 1'b0;
        err_count      = 0;
        pulse_captured = 1'b0;
        captured_data  = {BUS_WIDTH{1'b0}};

        $display("=========================================================");
        $display("  DATA SYNCHRONIZER (DATA_SYNC) SIMULATION TESTBENCH     ");
        $display("  Source Clock: f_tx = 50 MHz | Dest Clock: f_dest = 100 MHz");
        $display("=========================================================");

        // Apply Reset
        reset_dut();

        // --------------------------------------------------------------------
        // TEST CASE 1: Single Data Transfer (8-bit, 8'hA5)
        // --------------------------------------------------------------------
        $display("\n--- TC1: Single Data Transfer (unsync_bus = 0xA5) ---");
        send_data(8'hA5);

        // --------------------------------------------------------------------
        // TEST CASE 2: Consecutive Data Transfers (8'h5A -> 8'hF0)
        // --------------------------------------------------------------------
        $display("\n--- TC2: Consecutive Data Transfers (0x5A -> 0xF0) ---");
        send_data(8'h5A);
        send_data(8'hF0);

        // --------------------------------------------------------------------
        // TEST CASE 3: Dynamic Data Transfer (8'hC3)
        // --------------------------------------------------------------------
        $display("\n--- TC3: Dynamic Data Transfer (unsync_bus = 0xC3) ---");
        send_data(8'hC3);

        // --------------------------------------------------------------------
        // TEST CASE 4: All ones (8'hFF)
        // --------------------------------------------------------------------
        $display("\n--- TC4: All-Ones Transfer (unsync_bus = 0xFF) ---");
        send_data(8'hFF);

        // --------------------------------------------------------------------
        // TEST CASE 5: All zeros (8'h00)
        // --------------------------------------------------------------------
        $display("\n--- TC5: All-Zeros Transfer (unsync_bus = 0x00) ---");
        send_data(8'h00);

        // --------------------------------------------------------------------
        // TEST CASE 6: Asynchronous Active-Low Reset
        // --------------------------------------------------------------------
        $display("\n--- TC6: Asynchronous Active-Low Reset Mid-Operation ---");
        test_async_reset();

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
        @(negedge CLK);
        RST = 1'b0;
        repeat(3) @(posedge CLK);
        @(negedge CLK);
        RST = 1'b1;
        repeat(3) @(posedge CLK);
    end
    endtask

    // Send Data Task (Source Domain -> Destination Domain Verification)
    task send_data(input [BUS_WIDTH-1:0] data_val);
    begin
        // Clear capture flag
        pulse_captured <= 1'b0;
        @(posedge CLK);  // Let the flag clear propagate

        // Drive data and enable in source clock domain
        @(posedge tx_clk);
        unsync_bus <= data_val;
        bus_enable <= 1'b1;

        // Hold enable in source domain for 4 source cycles
        repeat(4) @(posedge tx_clk);
        bus_enable <= 1'b0;

        // Wait for enable_pulse or timeout using the concurrent monitor
        // The monitor process captures enable_pulse events in real-time
        timeout_cnt = 0;
        while (pulse_captured !== 1'b1 && timeout_cnt < 30) begin
            @(posedge CLK);
            timeout_cnt = timeout_cnt + 1;
        end

        // Verify results
        if (pulse_captured !== 1'b1) begin
            $display("  -> ERROR: Timeout waiting for enable_pulse!");
            err_count = err_count + 1;
        end else if (captured_data !== data_val) begin
            $display("  -> ERROR: Mismatch! Expected sync_bus = 0x%h, Got 0x%h", data_val, captured_data);
            err_count = err_count + 1;
        end else begin
            $display("  -> SUCCESS: Synchronized data 0x%h verified (enable_pulse asserted)", captured_data);
        end

        // Wait for idle between transfers
        repeat(5) @(posedge CLK);
    end
    endtask

    // Async Reset Task
    task test_async_reset;
    begin
        // First do a successful transfer to load data
        pulse_captured <= 1'b0;
        @(posedge CLK);
        @(posedge tx_clk);
        unsync_bus <= 8'hBB;
        bus_enable <= 1'b1;
        repeat(4) @(posedge tx_clk);
        bus_enable <= 1'b0;

        // Wait for sync to complete
        repeat(12) @(posedge CLK);

        // Now assert reset asynchronously
        #2;
        RST = 1'b0;
        #1;

        if (sync_bus !== 8'h00 || enable_pulse !== 1'b0) begin
            $display("  -> ERROR: Async reset failed to clear outputs immediately!");
            err_count = err_count + 1;
        end else begin
            $display("  -> SUCCESS: Async reset cleared sync_bus and enable_pulse immediately.");
        end

        #10;
        RST = 1'b1;
        repeat(5) @(posedge CLK);
    end
    endtask

endmodule
