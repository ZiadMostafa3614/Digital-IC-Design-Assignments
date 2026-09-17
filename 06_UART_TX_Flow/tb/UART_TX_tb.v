`timescale 1ns/1ps

module UART_TX_tb;

    // Inputs
    reg       CLK;
    reg       RST;
    reg       PAR_TYP;
    reg       PAR_EN;
    reg [7:0] P_DATA;
    reg       DATA_VALID;

    // Outputs
    wire TX_OUT;
    wire Busy;

    // Clock period (100 MHz clock)
    parameter CLK_PERIOD = 10;

    // Instantiate the Unit Under Test (UUT)
    UART_TX uut (
        .CLK(CLK),
        .RST(RST),
        .PAR_TYP(PAR_TYP),
        .PAR_EN(PAR_EN),
        .P_DATA(P_DATA),
        .DATA_VALID(DATA_VALID),
        .TX_OUT(TX_OUT),
        .Busy(Busy)
    );

    // Clock generation
    always #(CLK_PERIOD / 2) CLK = ~CLK;

    integer errors = 0;

    // Task to run a single TX test case and check the output frame
    task test_tx_frame;
        input [7:0] data_in;
        input       par_en_in;
        input       par_typ_in;
        input [127:0] test_name;
        
        reg [10:0] expected_frame; // max 11 bits: Start + 8 Data + Parity + Stop
        integer i;
        integer expected_length;
        reg expected_parity;
        begin
            $display("---------------------------------------------------------");
            $display("Running: %s | Data: 0x%h | Par_En: %b | Par_Typ: %b", test_name, data_in, par_en_in, par_typ_in);
            
            // Calculate parity
            if (par_typ_in == 0) begin
                expected_parity = ^data_in; // Even parity
            end else begin
                expected_parity = ~(^data_in); // Odd parity
            end

            // Construct expected frame (LSB first)
            // Start bit = 0, Data[0..7], Parity (optional), Stop bit = 1
            if (par_en_in) begin
                expected_frame = {1'b1, expected_parity, data_in, 1'b0};
                expected_length = 11;
            end else begin
                expected_frame = {2'b11, data_in, 1'b0}; // 10 bits used
                expected_length = 10;
            end

            // Drive inputs
            @(posedge CLK);
            P_DATA <= data_in;
            PAR_EN <= par_en_in;
            PAR_TYP <= par_typ_in;
            DATA_VALID <= 1'b1;
            
            @(posedge CLK);
            DATA_VALID <= 1'b0;

            // Wait for Busy to go high
            @(posedge Busy);
            @(posedge CLK); // Account for registered MUX output (TX_OUT)

            // Sample each bit on falling edge of clock (middle of frame)
            for (i = 0; i < expected_length; i = i + 1) begin
                @(negedge CLK);
                if (TX_OUT !== expected_frame[i]) begin
                    $display("[ERROR] %s: Bit %0d Mismatch! Got %b, Expected %b", test_name, i, TX_OUT, expected_frame[i]);
                    errors = errors + 1;
                end
                @(posedge CLK);
            end

            // Verify Busy drops to 0 after frame finishes
            @(posedge CLK);
            if (Busy !== 1'b0) begin
                $display("[ERROR] %s: Busy did not drop to 0 at end of frame!", test_name);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        // Initialize Inputs
        CLK = 0;
        RST = 1;
        PAR_TYP = 0;
        PAR_EN = 0;
        P_DATA = 0;
        DATA_VALID = 0;

        // Apply Reset
        #15;
        RST = 0;
        #20;
        RST = 1;
        #20;

        $display("=========================================================");
        $display("Starting Directed Edge-Case Verification...");
        $display("=========================================================");

        // Test 1: All Zeros, Even Parity
        test_tx_frame(8'h00, 1'b1, 1'b0, "Edge Case: All Zeros (Even)");

        // Test 2: All Zeros, Odd Parity
        test_tx_frame(8'h00, 1'b1, 1'b1, "Edge Case: All Zeros (Odd)");

        // Test 3: All Ones, Even Parity
        test_tx_frame(8'hFF, 1'b1, 1'b0, "Edge Case: All Ones (Even)");

        // Test 4: All Ones, Odd Parity
        test_tx_frame(8'hFF, 1'b1, 1'b1, "Edge Case: All Ones (Odd)");

        // Test 5: Alternating Pattern 0x55, Even Parity
        test_tx_frame(8'h55, 1'b1, 1'b0, "Edge Case: 0x55 (Even)");

        // Test 6: Alternating Pattern 0x55, No Parity
        test_tx_frame(8'h55, 1'b0, 1'b0, "Edge Case: 0x55 (No Parity)");

        // Test 7: Alternating Pattern 0xAA, Odd Parity
        test_tx_frame(8'hAA, 1'b1, 1'b1, "Edge Case: 0xAA (Odd)");

        // Test 8: Alternating Pattern 0xAA, No Parity
        test_tx_frame(8'hAA, 1'b0, 1'b0, "Edge Case: 0xAA (No Parity)");

        // Test 9: Single Bit LSB High (0x01), Even Parity
        test_tx_frame(8'h01, 1'b1, 1'b0, "Edge Case: 0x01 (Even)");

        // Test 10: Single Bit MSB High (0x80), Odd Parity
        test_tx_frame(8'h80, 1'b1, 1'b1, "Edge Case: 0x80 (Odd)");

        // Test 11: Protocol Abuse - DATA_VALID during transmission
        $display("---------------------------------------------------------");
        $display("Running: Protocol Abuse (Data_Valid during transmission)");
        @(posedge CLK);
        P_DATA <= 8'h3C;
        PAR_EN <= 1'b1;
        PAR_TYP <= 1'b0;
        DATA_VALID <= 1'b1;
        @(posedge CLK);
        DATA_VALID <= 1'b0;

        // Attempt invalid DATA_VALID injection while busy
        repeat(3) @(posedge CLK);
        P_DATA <= 8'hA5;
        DATA_VALID <= 1'b1;
        @(posedge CLK);
        DATA_VALID <= 1'b0;

        repeat(15) @(posedge CLK);

        $display("=========================================================");
        if (errors == 0) begin
            $display("ALL 11 EDGE-CASE SIMULATIONS PASSED: 0 Errors.");
        end else begin
            $display("TEST FAILED WITH %0d ERRORS.", errors);
        end
        $display("=========================================================");

        $stop;
    end

endmodule