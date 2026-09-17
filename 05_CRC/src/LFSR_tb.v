`timescale 1ns / 1ps

module LFSR_tb;

    reg clk;
    reg rst_n;
    reg DATA;
    reg ACTIVE;
    wire CRC;
    wire Valid;

    // Instantiate DUT
    LFSR dut (
        .clk(clk),
        .rst_n(rst_n),
        .DATA(DATA),
        .ACTIVE(ACTIVE),
        .CRC(CRC),
        .Valid(Valid)
    );

    // Clock generation: 10 MHz = 100 ns period
    always #50 clk = ~clk;

    reg [7:0] test_data [0:9];
    reg [7:0] expected_crc [0:9];
    reg [7:0] captured_crc;
    integer pass_count = 0;
    integer fail_count = 0;
    integer i, j;

    initial begin
        // Read memory
        $readmemh("src/DATA_h.txt", test_data);
        $readmemh("src/Expec_Out_h.txt", expected_crc);

        // Initialize inputs
        clk = 0;
        rst_n = 0;
        DATA = 0;
        ACTIVE = 0;

        $display("=========================================================");
        $display(" LFSR_tb Testbench - 10 Test Cases");
        $display("=========================================================");

        // Reset
        #100 rst_n = 1;

        // Run tests
        for (i = 0; i < 10; i = i + 1) begin
            // Wait a clock
            @(negedge clk);
            
            // Shift in data bits LSB first
            ACTIVE = 1;
            for (j = 0; j < 8; j = j + 1) begin
                DATA = test_data[i][j];
                @(negedge clk);
            end
            
            // End data transmission
            ACTIVE = 0;
            DATA = 0;
            
            // Capture CRC bits
            captured_crc = 8'h00;
            for (j = 0; j < 8; j = j + 1) begin
                // wait until Valid is high, sample on negedge
                while (!Valid) @(negedge clk);
                captured_crc[j] = CRC;
                if (j < 7) @(negedge clk);
            end
            
            // Wait for Valid to go low
            while (Valid) @(negedge clk);
            
            if (captured_crc === expected_crc[i]) begin
                $display("PASS | Test Case %0d | DATA=0x%02X -> CRC=0x%02X", 
                          i+1, test_data[i], captured_crc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | Test Case %0d | DATA=0x%02X -> CRC=0x%02X (exp 0x%02X)", 
                          i+1, test_data[i], captured_crc, expected_crc[i]);
                fail_count = fail_count + 1;
            end
            
            // Wait some time between tests
            #200;
        end

        $display("=========================================================");
        $display(" RESULTS: %0d PASSED, %0d FAILED (out of 10)", pass_count, fail_count);
        $display("=========================================================");

        #100;
        $stop;
    end

endmodule
