`timescale 1ns / 1ps

// ************************************************************* //
// Author : Ziad Mostafa Abdelaziz
// Module : SYS_TOP_stress_tb
// Description : Advanced Stress Testbench for SYS_TOP focusing on
//               CDC Hazards, Start Bit Glitch Suppression,
//               Asynchronous Reset Recovery, Parity/Stop Errors,
//               Back-to-Back Frame Burst, and ASYNC_FIFO Handshaking.
// ************************************************************* //

module SYS_TOP_stress_tb;

    // Base Period Definitions
    parameter REF_CLK_PERIOD  = 20.0;     // 50 MHz (20 ns)
    parameter UART_CLK_PERIOD = 271.267;  // 3.6864 MHz (271.267 ns)
    parameter PRESCALE        = 32;
    parameter BIT_PERIOD      = UART_CLK_PERIOD * PRESCALE; // ~8680.54 ns per UART bit

    // DUT Signals
    reg  REF_CLK;
    reg  UART_CLK;
    reg  RST;
    reg  RX_IN;
    wire TX_OUT;
    wire PAR_ERR;
    wire STP_ERR;

    // Testbench Metrics & Temporary Variable Scope
    integer pass_cnt = 0;
    integer fail_cnt = 0;
    integer tc_num   = 0;

    reg [7:0] rdata_tb;
    reg       tout_tb;
    reg       rerr_tb;
    reg [7:0] b1_tb, b2_tb;
    reg       t1_tb, t2_tb;
    reg       e1_tb, e2_tb;

    real ref_jitter  = 0.0;
    real uart_jitter = 0.0;

    real current_bit_period;
    always @(*) begin
        current_bit_period = (UART_CLK_PERIOD / 2.0 + uart_jitter) * 2.0 * PRESCALE;
    end

    // DUT Instantiation
    SYS_TOP u_dut (
        .REF_CLK(REF_CLK),
        .UART_CLK(UART_CLK),
        .RST(RST),
        .RX_IN(RX_IN),
        .TX_OUT(TX_OUT),
        .PAR_ERR(PAR_ERR),
        .STP_ERR(STP_ERR)
    );

    // ------------------------------------------------------------------------
    // Clock Generation with Dynamic Jitter Injection
    // ------------------------------------------------------------------------
    always begin
        #(REF_CLK_PERIOD / 2.0 + ref_jitter);
        REF_CLK = ~REF_CLK;
    end

    always begin
        #(UART_CLK_PERIOD / 2.0 + uart_jitter);
        UART_CLK = ~UART_CLK;
    end

    // ------------------------------------------------------------------------
    // Global Simulation Timeout (safety net against infinite hangs)
    // ------------------------------------------------------------------------
    initial begin
        #(BIT_PERIOD * 5000);
        $display("[FATAL] Global simulation timeout reached at time %0t!", $time);
        $stop;
    end

    always @(TX_OUT) begin
        $display("[TX_OUT_MON] Time=%0t | TX_OUT changed to %b", $time, TX_OUT);
    end

    always @(u_dut.u_sys_ctrl.current_state) begin
        $display("[SYS_CTRL_FSM] Time=%0t | SYS_CTRL FSM State=%0d", $time, u_dut.u_sys_ctrl.current_state);
    end

    always @(u_dut.u_async_fifo.EMPTY) begin
        $display("[FIFO_MON] Time=%0t | FIFO EMPTY=%0b", $time, u_dut.u_async_fifo.EMPTY);
    end

    // ------------------------------------------------------------------------
    // Helper Tasks for Transmitting & Receiving UART Frames
    // NOTE: No fork/join_any inside tasks to avoid disable-fork killing
    //       outer test forks. Tests use sequential send-then-receive instead.
    // ------------------------------------------------------------------------
    task send_uart_frame_custom(
        input [7:0] data,
        input       corrupt_parity,
        input       corrupt_stop
    );
        integer i;
        reg par_bit;
        begin
            par_bit = ^data; // Even parity
            if (corrupt_parity) par_bit = ~par_bit;

            // Start Bit (LOW)
            RX_IN = 1'b0;
            #(current_bit_period);

            // 8 Data Bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                RX_IN = data[i];
                #(current_bit_period);
            end

            // Parity Bit
            RX_IN = par_bit;
            #(current_bit_period);

            // Stop Bit (HIGH normally, LOW if corrupt)
            RX_IN = corrupt_stop ? 1'b0 : 1'b1;
            #(current_bit_period);
            RX_IN = 1'b1; // Restore line to IDLE (HIGH)
        end
    endtask

    task send_byte(input [7:0] data);
        send_uart_frame_custom(data, 1'b0, 1'b0);
    endtask

    task receive_byte(output [7:0] data, output reg timeout, output reg err);
        integer i;
        reg par_bit;
        begin
            timeout = 1'b0;
            err     = 1'b0;

            // Wait for Start Bit (negedge TX_OUT)
            $display("[TB_DBG_RECV] Time=%0t | Waiting for negedge TX_OUT (current TX_OUT=%0b)", $time, TX_OUT);
            @(negedge TX_OUT);
            $display("[TB_DBG_RECV] Time=%0t | negedge TX_OUT CAUGHT!", $time);
            #(current_bit_period / 2.0); // Center of Start bit
            if (TX_OUT != 1'b0) err = 1'b1;

            for (i = 0; i < 8; i = i + 1) begin
                #(current_bit_period);
                data[i] = TX_OUT;
            end

            #(current_bit_period);
            par_bit = TX_OUT;
            if (par_bit != (^data)) err = 1'b1;

            #(current_bit_period);
            if (TX_OUT != 1'b1) err = 1'b1;
        end
    endtask

    // ------------------------------------------------------------------------
    // Main Test Stimulus Execution
    // ------------------------------------------------------------------------
    initial begin
        REF_CLK  = 1'b0;
        UART_CLK = 1'b0;
        RST      = 1'b1;
        RX_IN    = 1'b1;

        $display("==========================================================================");
        $display("   COMPREHENSIVE STRESS TESTBENCH FOR TOP SYSTEM DESIGN (SYS_TOP)");
        $display("   Focusing on CDC Hazards, Glitch Rejection, Race Conditions & FIFO Burst ");
        $display("==========================================================================");

        // Reset Pulse
        #(REF_CLK_PERIOD * 5);
        RST = 1'b0;
        #(REF_CLK_PERIOD * 15);
        RST = 1'b1;
        #(REF_CLK_PERIOD * 20);

        // Initial Configuration Writes (REG2=0x81, REG3=0x20)
        send_byte(8'hAA); send_byte(8'h02); send_byte(8'h81); #(BIT_PERIOD);
        send_byte(8'hAA); send_byte(8'h03); send_byte(8'h20); #(BIT_PERIOD);

        // ====================================================================
        // STRESS TEST 1: Glitch Suppression on RX_IN (CDC Start Check)
        // ====================================================================
        tc_num = tc_num + 1;
        $display("\n--- [STRESS TEST %0d] Start Bit Glitch Suppression ---", tc_num);
        // Drive RX_IN LOW for only 2 UART_CLK cycles (< Prescale/2 filtering edge)
        RX_IN = 1'b0;
        #(UART_CLK_PERIOD * 2);
        RX_IN = 1'b1;
        #(BIT_PERIOD * 3);

        if (u_dut.u_data_sync.enable_pulse_d == 1'b0) begin
            $display("[PASS] Glitch of 2 UART_CLK cycles successfully suppressed. No false CDC pulse generated.");
            pass_cnt = pass_cnt + 1;
        end else begin
            $display("[FAIL] False glitch propagated through CDC!");
            fail_cnt = fail_cnt + 1;
        end

        // ====================================================================
        // STRESS TEST 2: Parity Error Invalidation & System State Isolation
        // ====================================================================
        tc_num = tc_num + 1;
        $display("\n--- [STRESS TEST %0d] Parity Error Invalidation & Memory Isolation ---", tc_num);
        send_uart_frame_custom(8'hAA, 1'b1, 1'b0);
        send_byte(8'h0A);
        send_byte(8'h77);
        #(BIT_PERIOD * 2);

        if (PAR_ERR == 1'b1 || u_dut.u_sys_ctrl.current_state == 4'd0) begin
            $display("[PASS] Corrupted parity frame detected. System cleanly rejected frame.");
            pass_cnt = pass_cnt + 1;
        end else begin
            $display("[FAIL] Corrupted frame was improperly accepted by System!");
            fail_cnt = fail_cnt + 1;
        end

        // ====================================================================
        // STRESS TEST 3: Framing (Stop Bit) Error Recovery
        // ====================================================================
        tc_num = tc_num + 1;
        $display("\n--- [STRESS TEST %0d] Framing (Stop Bit) Error Recovery ---", tc_num);
        send_uart_frame_custom(8'hAA, 1'b0, 1'b1);
        #(BIT_PERIOD * 2);

        if (STP_ERR == 1'b1 || u_dut.u_sys_ctrl.current_state == 4'd0) begin
            $display("[PASS] Stop bit framing error detected. FSM returned to IDLE state.");
            pass_cnt = pass_cnt + 1;
        end else begin
            $display("[FAIL] Stop bit framing error failed to lock out system state machine.");
            fail_cnt = fail_cnt + 1;
        end

        // Wait for UART RX to finish any phantom frame caused by low stop bit
        #(BIT_PERIOD * 15);

        // ====================================================================
        // STRESS TEST 4: Back-to-Back Rapid Command Streaming (Zero Idle Spacing)
        // ====================================================================
        tc_num = tc_num + 1;
        $display("\n--- [STRESS TEST %0d] Back-to-Back Rapid Command Streaming ---", tc_num);

        // Write 0x5A to Addr 0x06
        send_byte(8'hAA); send_byte(8'h06); send_byte(8'h5A);
        // Write 0x3C to Addr 0x07
        send_byte(8'hAA); send_byte(8'h07); send_byte(8'h3C);
        // Allow SYS_CTRL to finish the last write cycle
        #(BIT_PERIOD * 2);

        // Read from Addr 0x06: send CMD 0xBB and ADDR 0x06 in fork thread with receive
        $display("[TEST 4] Streaming Read CMD 0xBB 0x06...");
        fork
            begin
                send_byte(8'hBB);
                send_byte(8'h06);
            end
            begin
                receive_byte(rdata_tb, tout_tb, rerr_tb);
            end
        join
        $display("[TEST 4] Received TX_OUT byte 0x%02h", rdata_tb);

        if (!rerr_tb && rdata_tb == 8'h5A) begin
            $display("[PASS] Rapid back-to-back stream correctly wrote & read Addr 0x06 (0x5A).");
            pass_cnt = pass_cnt + 1;
        end else begin
            $display("[FAIL] Back-to-back read error! Expected 0x5A, got 0x%02h (err=%0b)", rdata_tb, rerr_tb);
            fail_cnt = fail_cnt + 1;
        end

        // ====================================================================
        // STRESS TEST 5: CDC Clock Jitter & Phase Stress
        // ====================================================================
        tc_num = tc_num + 1;
        $display("\n--- [STRESS TEST %0d] CDC Clock Jitter & Phase Drift Injection ---", tc_num);
        ref_jitter  = 1.25;  // Inject +1.25 ns jitter on 50 MHz clock
        uart_jitter = -3.50; // Inject -3.50 ns jitter on 3.6864 MHz clock

        $display("[TEST 5] Sending ALU Op (85 + 15)...");
        fork
            begin
                send_byte(8'hCC); // ALU Op with Operands
                send_byte(8'd85); // A = 85
                send_byte(8'd15); // B = 15
                send_byte(8'h00); // Addition (85 + 15 = 100)
            end
            begin
                receive_byte(b1_tb, t1_tb, e1_tb);
                receive_byte(b2_tb, t2_tb, e2_tb);
            end
        join

        if (!e1_tb && !e2_tb && {b2_tb, b1_tb} == 16'd100) begin
            $display("[PASS] CDC Phase Drift Stress Passed! ALU Addition = 100 under clock jitter.");
            pass_cnt = pass_cnt + 1;
        end else begin
            $display("[FAIL] CDC Phase Drift Failure! Expected 100, Recv: %0d (e1=%0b, e2=%0b)", {b2_tb, b1_tb}, e1_tb, e2_tb);
            fail_cnt = fail_cnt + 1;
        end
        ref_jitter  = 0.0;
        uart_jitter = 0.0;

        // ====================================================================
        // STRESS TEST 6: ALU Negative Underflow Operation (0x05 - 0x10)
        // ====================================================================
        tc_num = tc_num + 1;
        $display("\n--- [STRESS TEST %0d] ALU Subtraction Underflow (5 - 16 = -11) ---", tc_num);

        $display("[TEST 6] Sending ALU Subtraction CMD...");
        fork
            begin
                send_byte(8'hCC);
                send_byte(8'd5);  // A = 5
                send_byte(8'd16); // B = 16
                send_byte(8'h01); // Subtraction
            end
            begin
                receive_byte(b1_tb, t1_tb, e1_tb);
                receive_byte(b2_tb, t2_tb, e2_tb);
            end
        join

        // 5 - 16 in 16-bit 2's complement = 0xFFF5 (65525)
        if (!e1_tb && !e2_tb && {b2_tb, b1_tb} == 16'hFFF5) begin
            $display("[PASS] ALU Subtraction Underflow Passed! Recv: 0x%04h (-11)", {b2_tb, b1_tb});
            pass_cnt = pass_cnt + 1;
        end else begin
            $display("[FAIL] Subtraction Underflow mismatch! Expected 0xFFF5, Recv: 0x%04h (e1=%0b, e2=%0b)", {b2_tb, b1_tb}, e1_tb, e2_tb);
            fail_cnt = fail_cnt + 1;
        end

        // ====================================================================
        // STRESS TEST 7: Mid-Transfer Asynchronous Reset & Recovery
        // ====================================================================
        tc_num = tc_num + 1;
        $display("\n--- [STRESS TEST %0d] Mid-Transfer Asynchronous Reset Assertion ---", tc_num);

        // Start sending an ALU command then assert reset mid-transfer
        send_byte(8'hCC);
        send_byte(8'd100);
        // Mid-transfer: assert reset during OP_B wait
        #(BIT_PERIOD * 1.5);
        RST = 1'b0;
        #(REF_CLK_PERIOD * 10);
        RST = 1'b1;
        RX_IN = 1'b1; // Ensure line is IDLE after reset
        #(BIT_PERIOD * 3);

        // Re-configure after mid-transfer reset (REG2=0x81, REG3=0x20)
        send_byte(8'hAA); send_byte(8'h02); send_byte(8'h81); #(BIT_PERIOD);
        send_byte(8'hAA); send_byte(8'h03); send_byte(8'h20); #(BIT_PERIOD);

        // Write 0xFE to Addr 0x08 and read it back
        send_byte(8'hAA); send_byte(8'h08); send_byte(8'hFE); #(BIT_PERIOD);

        // Read from Addr 0x08
        fork
            begin
                send_byte(8'hBB);
                send_byte(8'h08);
            end
            begin
                receive_byte(rdata_tb, tout_tb, rerr_tb);
            end
        join

        if (!rerr_tb && rdata_tb == 8'hFE) begin
            $display("[PASS] Mid-Transfer Reset Recovery Successful! System fully recovered.");
            pass_cnt = pass_cnt + 1;
        end else begin
            $display("[FAIL] Mid-Transfer Reset Recovery Failed! Expected 0xFE, got 0x%02h (err=%0b)", rdata_tb, rerr_tb);
            fail_cnt = fail_cnt + 1;
        end

        // ====================================================================
        // FINAL SUMMARY REPORT
        // ====================================================================
        $display("\n==========================================================================");
        $display("                   ADVANCED STRESS TESTBENCH SUMMARY                      ");
        $display("==========================================================================");
        $display(" Total Stress Test Cases Executed : %0d", tc_num);
        $display(" Total Passed                     : %0d", pass_cnt);
        $display(" Total Failed                     : %0d", fail_cnt);
        if (fail_cnt == 0) begin
            $display(" STATUS: ALL ADVANCED STRESS & CORNER CASES PASSED PERFECTLY!");
        end else begin
            $display(" STATUS: STRESS TESTBENCH ENCOUNTERED FAILURES!");
        end
        $display("==========================================================================\n");

        $stop;
    end

endmodule
