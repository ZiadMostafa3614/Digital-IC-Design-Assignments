`timescale 1ns/1ps

// ============================================================================
// Module Name  : ClkDiv_tb
// Description  : Self-checking Testbench for Integer Clock Divider (ClkDiv)
//                Tests Even/Odd Division Ratios (2..8), Corner Cases (0, 1),
//                Block Disable (i_clk_en=0), Dynamic Switching, and Reset.
// ============================================================================

module ClkDiv_tb;

    // Testbench Parameters
    parameter REF_CLK_PERIOD = 10.0; // 100 MHz reference clock (Period = 10ns)

    // DUT Signals
    reg        i_ref_clk;
    reg        i_rst_n;
    reg        i_clk_en;
    reg  [7:0] i_div_ratio;
    wire       o_div_clk;

    // Verification Variables
    integer    err_count;
    realtime   t_rising_1, t_rising_2, measured_period, expected_period;
    realtime   t_falling, measured_high, measured_low;

    // Instantiate DUT
    ClkDiv uut (
        .i_ref_clk  (i_ref_clk),
        .i_rst_n    (i_rst_n),
        .i_clk_en   (i_clk_en),
        .i_div_ratio(i_div_ratio),
        .o_div_clk  (o_div_clk)
    );

    // Reference Clock Generation (100 MHz)
    always #(REF_CLK_PERIOD / 2.0) i_ref_clk = ~i_ref_clk;

    // ========================================================================
    // Main Test Execution Procedure
    // ========================================================================
    initial begin
        // Initialize Signals
        i_ref_clk   = 1'b0;
        i_rst_n     = 1'b1;
        i_clk_en    = 1'b0;
        i_div_ratio = 8'd0;
        err_count   = 0;

        $display("=========================================================");
        $display("  INTEGER CLOCK DIVIDER (ClkDiv) SIMULATION TESTBENCH  ");
        $display("  Reference Clock: f_in = 100 MHz (Period = 10.0 ns)");
        $display("=========================================================");

        // Apply Reset
        reset_dut();

        // --------------------------------------------------------------------
        // SECTION 1: EVEN DIVISION RATIOS (N = 2, 4, 6, 8)
        // --------------------------------------------------------------------
        $display("\n--- SECTION 1: EVEN DIVISION RATIOS ---");
        test_division(8'd2, 1'b1, "Even Ratio N = 2 (Divide by 2)");
        test_division(8'd4, 1'b1, "Even Ratio N = 4 (Divide by 4)");
        test_division(8'd6, 1'b1, "Even Ratio N = 6 (Divide by 6)");
        test_division(8'd8, 1'b1, "Even Ratio N = 8 (Divide by 8)");

        // --------------------------------------------------------------------
        // SECTION 2: ODD DIVISION RATIOS (N = 3, 5, 7) — 50% Duty Cycle
        // --------------------------------------------------------------------
        $display("\n--- SECTION 2: ODD DIVISION RATIOS ---");
        test_division(8'd3, 1'b1, "Odd Ratio N = 3 (Divide by 3)");
        test_division(8'd5, 1'b1, "Odd Ratio N = 5 (Divide by 5)");
        test_division(8'd7, 1'b1, "Odd Ratio N = 7 (Divide by 7)");

        // --------------------------------------------------------------------
        // SECTION 3: CORNER CASES (N = 0, N = 1, i_clk_en = 0)
        // --------------------------------------------------------------------
        $display("\n--- SECTION 3: CORNER CASES ---");
        test_corner_case(8'd0, 1'b1, "Corner Case: Ratio = 0 (Bypass / Pass Ref Clock)");
        test_corner_case(8'd1, 1'b1, "Corner Case: Ratio = 1 (Bypass / Pass Ref Clock)");
        test_corner_case(8'd4, 1'b0, "Corner Case: i_clk_en = 0 (Block Disabled / Pass Ref Clock)");

        // --------------------------------------------------------------------
        // SECTION 4: ASYNCHRONOUS RESET & DYNAMIC SWITCHING
        // --------------------------------------------------------------------
        $display("\n--- SECTION 4: RESET & DYNAMIC RATIO SWITCHING ---");
        test_async_reset();
        test_dynamic_switching();

        // --------------------------------------------------------------------
        // FINAL SUMMARY
        // --------------------------------------------------------------------
        $display("\n=========================================================");
        if (err_count == 0)
            $display("  ALL TEST CASES PASSED SUCCESSFULLY! (0 Errors)");
        else
            $display("  SIMULATION FAILED WITH %0d ERRORS!", err_count);
        $display("=========================================================");
        $stop;
    end

    // ========================================================================
    // Verification Tasks
    // ========================================================================

    // Active-Low Reset Task
    task reset_dut;
    begin
        @(negedge i_ref_clk);
        i_rst_n = 1'b0;
        repeat(2) @(posedge i_ref_clk);
        @(negedge i_ref_clk);
        i_rst_n = 1'b1;
        repeat(2) @(posedge i_ref_clk);
    end
    endtask

    // Test Division Ratio Task (Checks Period & Duty Cycle)
    task test_division(
        input [7:0]  ratio,
        input        clk_en,
        input [8*60:1] test_label
    );
    begin
        $display("Testing: %0s", test_label);
        @(negedge i_ref_clk);
        i_div_ratio = ratio;
        i_clk_en    = clk_en;

        // Wait for counter stabilization
        repeat(2 * ratio) @(posedge i_ref_clk);

        // Measure period and duty cycle
        @(posedge o_div_clk);
        t_rising_1 = $realtime;

        @(negedge o_div_clk);
        t_falling = $realtime;

        @(posedge o_div_clk);
        t_rising_2 = $realtime;

        measured_period = t_rising_2 - t_rising_1;
        measured_high   = t_falling - t_rising_1;
        measured_low    = t_rising_2 - t_falling;
        expected_period = ratio * REF_CLK_PERIOD;

        // Validate Period
        if (measured_period != expected_period) begin
            $display("  -> ERROR: Period mismatch for N=%0d! Got %0.2f ns, Expected %0.2f ns",
                     ratio, measured_period, expected_period);
            err_count = err_count + 1;
        end else begin
            $display("  -> SUCCESS: Period = %0.2f ns (f_out = %0.2f MHz)",
                     measured_period, 1000.0 / measured_period);
        end

        // Validate 50% Duty Cycle
        if (measured_high != (expected_period / 2.0)) begin
            $display("  -> ERROR: Duty cycle mismatch! High=%0.2f ns, Low=%0.2f ns (Expected 50%% = %0.2f ns)",
                     measured_high, measured_low, expected_period / 2.0);
            err_count = err_count + 1;
        end else begin
            $display("  -> SUCCESS: 50%% Duty Cycle verified (High = %0.2f ns, Low = %0.2f ns)",
                     measured_high, measured_low);
        end
    end
    endtask

    // Test Corner Cases (Bypass Verification)
    task test_corner_case(
        input [7:0]  ratio,
        input        clk_en,
        input [8*60:1] test_label
    );
    begin
        $display("Testing: %0s", test_label);
        @(negedge i_ref_clk);
        i_div_ratio = ratio;
        i_clk_en    = clk_en;

        repeat(2) @(posedge i_ref_clk);

        // Measure period of bypass clock
        @(posedge o_div_clk);
        t_rising_1 = $realtime;
        @(posedge o_div_clk);
        t_rising_2 = $realtime;

        measured_period = t_rising_2 - t_rising_1;
        expected_period = REF_CLK_PERIOD;

        if (measured_period != expected_period) begin
            $display("  -> ERROR: Corner case bypass failed! Got period %0.2f ns, Expected %0.2f ns",
                     measured_period, expected_period);
            err_count = err_count + 1;
        end else begin
            $display("  -> SUCCESS: Corner case verified! Output passes reference clock (Period = %0.2f ns)",
                     measured_period);
        end
    end
    endtask

    // Test Asynchronous Reset Mid-Operation
    task test_async_reset;
    begin
        $display("Testing: Asynchronous Reset Mid-Operation (N = 4)");
        @(negedge i_ref_clk);
        i_div_ratio = 8'd4;
        i_clk_en    = 1'b1;

        repeat(2) @(posedge i_ref_clk);
        #3.5; // Assert reset asynchronously mid-clock
        i_rst_n = 1'b0;
        #1.0;

        if (uut.pos_cnt !== 8'd0 || uut.p_clk !== 1'b0) begin
            $display("  -> ERROR: Async reset failed to clear internal registers immediately!");
            err_count = err_count + 1;
        end else begin
            $display("  -> SUCCESS: Async reset cleared all internal registers immediately.");
        end

        #5.0;
        i_rst_n = 1'b1;
        repeat(4) @(posedge i_ref_clk);
    end
    endtask

    // Test Dynamic Ratio Switching
    task test_dynamic_switching;
    begin
        $display("Testing: Dynamic Ratio Switching (N = 2 -> N = 3 -> N = 4)");
        test_division(8'd2, 1'b1, "Switch to N = 2");
        test_division(8'd3, 1'b1, "Switch to N = 3");
        test_division(8'd4, 1'b1, "Switch to N = 4");
    end
    endtask

endmodule
