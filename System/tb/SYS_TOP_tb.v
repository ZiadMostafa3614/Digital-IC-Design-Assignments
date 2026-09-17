`timescale 1ns / 1ps

// ************************************************************* //
// Author : Ziad Mostafa Abdelaziz
// Module : SYS_TOP_tb
// ************************************************************* //

module SYS_TOP_tb;

    // Parameters
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

    // Testbench Variables
    reg [7:0] tx_byte;
    reg       tx_err;
    reg [7:0] b1, b2;
    reg       e1, e2;
    integer   test_pass_count = 0;
    integer   test_fail_count = 0;

    // Instantiate DUT
    SYS_TOP u_dut (
        .REF_CLK(REF_CLK),
        .UART_CLK(UART_CLK),
        .RST(RST),
        .RX_IN(RX_IN),
        .TX_OUT(TX_OUT),
        .PAR_ERR(PAR_ERR),
        .STP_ERR(STP_ERR)
    );

    // Clock Generation
    always #(REF_CLK_PERIOD / 2.0) REF_CLK = ~REF_CLK;
    always #(UART_CLK_PERIOD / 2.0) UART_CLK = ~UART_CLK;

    always @(TX_OUT) $display("[TX_OUT_MONITOR] TX_OUT changed to %b at time %0t", TX_OUT, $time);

    // ------------------------------------------------------------------------
    // Tasks: UART Transmission and Reception
    // ------------------------------------------------------------------------
    task send_uart_byte(input [7:0] data);
        integer i;
        reg par_bit;
        begin
            par_bit = ^data; // Even parity
            // Start Bit (LOW)
            RX_IN = 1'b0;
            #(BIT_PERIOD);
            // 8 Data Bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                RX_IN = data[i];
                #(BIT_PERIOD);
            end
            // Parity Bit (Even)
            RX_IN = par_bit;
            #(BIT_PERIOD);
            // Stop Bit (HIGH)
            RX_IN = 1'b1;
            #(BIT_PERIOD);
        end
    endtask

    task receive_uart_byte(output [7:0] data, output err);
        integer i;
        reg par_bit;
        begin
            err = 1'b0;
            // Wait for Start Bit (falling edge on TX_OUT)
            @(negedge TX_OUT);
            #(BIT_PERIOD / 2.0); // Center of Start Bit
            if (TX_OUT != 1'b0) err = 1'b1;

            // Sample 8 Data Bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                #(BIT_PERIOD);
                data[i] = TX_OUT;
            end

            // Parity Bit (Center)
            #(BIT_PERIOD);
            par_bit = TX_OUT;
            if (par_bit != (^data)) err = 1'b1;

            // Stop Bit (Center) - exit task during Stop bit so next call is ready for negedge
            #(BIT_PERIOD);
            if (TX_OUT != 1'b1) err = 1'b1;
            #(BIT_PERIOD / 4.0); // Advance slightly into Stop bit
        end
    endtask

    // ------------------------------------------------------------------------
    // Main Test Stimulus
    // ------------------------------------------------------------------------
    initial begin
        // Initialize Signals
        REF_CLK  = 1'b0;
        UART_CLK = 1'b0;
        RST      = 1'b1;
        RX_IN    = 1'b1; // Idle state high

        $display("=========================================================");
        $display("        SYSTEM INTEGRATION FUNCTIONAL VERIFICATION       ");
        $display("=========================================================");

        // 1. Reset Sequence
        #(REF_CLK_PERIOD * 5);
        RST = 1'b0;
        #(REF_CLK_PERIOD * 10);
        RST = 1'b1;
        #(REF_CLK_PERIOD * 10);
        $display("[INFO] System Reset Applied and Released successfully.");

        // 2. Initial Configuration Writes (Address 0x2 and 0x3)
        $display("\n--- Performing Initial System Configuration ---");
        // Config REG2: Prescale = 32, Parity_Type = 0 (Even), Parity_En = 1 -> 0x81
        send_uart_byte(8'hAA); // RegFile Write CMD
        send_uart_byte(8'h02); // REG2 Address
        send_uart_byte(8'h81); // REG2 Data (0x81)
        #(BIT_PERIOD * 2);

        // Config REG3: Division Ratio = 32 -> 0x20
        send_uart_byte(8'hAA); // RegFile Write CMD
        send_uart_byte(8'h03); // REG3 Address
        send_uart_byte(8'h20); // REG3 Data (0x20)
        #(BIT_PERIOD * 2);
        $display("[INFO] Initial Configuration Completed.");

        // --------------------------------------------------------------------
        // TEST CASE 1: Register File Write Command (0xAA)
        // --------------------------------------------------------------------
        $display("\n--- [TEST CASE 1] Register File Write (0xAA) ---");
        send_uart_byte(8'hAA); // CMD
        send_uart_byte(8'h05); // Address: 0x05
        send_uart_byte(8'hA5); // Data: 0xA5
        #(BIT_PERIOD * 2);
        $display("[PASS] Test Case 1: RF Write command sent to addr 0x05 with data 0xA5.");
        test_pass_count = test_pass_count + 1;

        // --------------------------------------------------------------------
        // TEST CASE 2: Register File Read Command (0xBB)
        // --------------------------------------------------------------------
        $display("\n--- [TEST CASE 2] Register File Read (0xBB) ---");
        fork
            begin
                send_uart_byte(8'hBB); // CMD
                send_uart_byte(8'h05); // Address: 0x05
            end
            begin
                receive_uart_byte(tx_byte, tx_err);
            end
        join

        if (!tx_err && tx_byte == 8'hA5) begin
            $display("[PASS] Test Case 2: RF Read back matched expected 0xA5. Recv: 0x%02h", tx_byte);
            test_pass_count = test_pass_count + 1;
        end else begin
            $display("[FAIL] Test Case 2: RF Read mismatch! Expected 0xA5, Recv: 0x%02h (err: %0d)", tx_byte, tx_err);
            test_fail_count = test_fail_count + 1;
        end
        #(BIT_PERIOD * 5);

        // --------------------------------------------------------------------
        // TEST CASE 3: ALU Operation with Operands Command (0xCC)
        // --------------------------------------------------------------------
        $display("\n--- [TEST CASE 3] ALU Op with Operands (0xCC): Addition (20 + 10) ---");
        fork
            begin
                send_uart_byte(8'hCC); // CMD
                send_uart_byte(8'd20); // Operand A = 20 (0x14)
                send_uart_byte(8'd10); // Operand B = 10 (0x0A)
                send_uart_byte(8'h00); // ALU_FUN = 0x0 (Addition)
            end
            begin
                receive_uart_byte(b1, e1); // Byte 1 (Low byte)
                receive_uart_byte(b2, e2); // Byte 2 (High byte)
            end
        join

        tx_byte = b1;
        tx_err = e1 | e2;
        $display("[DEBUG_TB_CHECK] b1=0x%02h, b2=0x%02h, concat=0x%04h (%0d)", b1, b2, {b2, b1}, {b2, b1});
        if ({b2, b1} == 16'd30) begin
            $display("[PASS] Test Case 3: ALU Addition result matched expected 30. Recv: %0d (0x%04h)", {b2, b1}, {b2, b1});
            test_pass_count = test_pass_count + 1;
        end else begin
            $display("[FAIL] Test Case 3: ALU Addition mismatch! Expected 30, Recv: %0d (0x%04h)", {b2, b1}, {b2, b1});
            test_fail_count = test_fail_count + 1;
        end
        #(BIT_PERIOD * 5);

        // --------------------------------------------------------------------
        // TEST CASE 4: ALU Operation with No Operands Command (0xDD)
        // --------------------------------------------------------------------
        $display("\n--- [TEST CASE 4] ALU Op NOP (0xDD): Multiplication (20 * 10) ---");
        fork
            begin
                send_uart_byte(8'hDD); // CMD
                send_uart_byte(8'h02); // ALU_FUN = 0x2 (Multiplication)
            end
            begin
                receive_uart_byte(b1, e1); // Byte 1 (Low byte)
                receive_uart_byte(b2, e2); // Byte 2 (High byte)
            end
        join

        if ({b2, b1} == 16'd200) begin
            $display("[PASS] Test Case 4: ALU Multiplication result matched expected 200. Recv: %0d (0x%04h)", {b2, b1}, {b2, b1});
            test_pass_count = test_pass_count + 1;
        end else begin
            $display("[FAIL] Test Case 4: ALU Multiplication mismatch! Expected 200, Recv: %0d (0x%04h)", {b2, b1}, {b2, b1});
            test_fail_count = test_fail_count + 1;
        end
        #(BIT_PERIOD * 5);

        // --------------------------------------------------------------------
        // Final Summary
        // --------------------------------------------------------------------
        $display("\n=========================================================");
        $display("                   VERIFICATION SUMMARY                  ");
        $display("=========================================================");
        $display(" Total Passed: %0d / 4", test_pass_count);
        $display(" Total Failed: %0d / 4", test_fail_count);
        if (test_fail_count == 0) begin
            $display(" STATUS: ALL TEST CASES PASSED SUCCESSFULLY!");
        end else begin
            $display(" STATUS: VERIFICATION FAILED WITH ERRORS!");
        end
        $display("=========================================================\n");

        $stop;
    end

endmodule
