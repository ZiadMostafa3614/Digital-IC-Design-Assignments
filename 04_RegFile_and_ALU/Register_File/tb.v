`timescale 1ns/1ps

module TB_REG_FILE;

    reg        CLK;
    reg        RST;
    reg        WrEn;
    reg        RdEn;
    reg [2:0]  Address;
    reg [15:0] WrData;
    wire [15:0] RdData;

    integer pass_count = 0;
    integer fail_count = 0;

    REG_FILE DUT (
        .CLK     (CLK),
        .RST     (RST),
        .WrEn    (WrEn),
        .RdEn    (RdEn),
        .Address (Address),
        .WrData  (WrData),
        .RdData  (RdData)
    );

    initial CLK = 1'b0;
    always #5 CLK = ~CLK; // Clock period = 10 ns

    task check_read;
        input [15:0] expected_val;
        input [8*20:1] test_name;
        begin
            if (RdData === expected_val) begin
                $display("PASS | %0s | RdData = 0x%h", test_name, RdData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | %0s | RdData = 0x%h (expected 0x%h)", test_name, RdData, expected_val);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $display("=========================================================");
        $display(" REGISTER_FILE Validation Scenarios");
        $display("=========================================================");
        
        RST = 1'b0;
        WrEn = 1'b0;
        RdEn = 1'b0;
        Address = 3'b000;
        WrData = 16'h0000;
        
        // Wait and release reset
        #25 RST = 1'b1;
        
        // ----------------------------------------------------
        // Scenario 1: Write Data to Register 3
        // ----------------------------------------------------
        @(posedge CLK);
        WrEn = 1'b1;
        RdEn = 1'b0;
        Address = 3'd3;
        WrData = 16'h5A5A;
        @(posedge CLK);
        #1 WrEn = 1'b0;
        
        // ----------------------------------------------------
        // Scenario 2: Write Data to Register 6
        // ----------------------------------------------------
        @(posedge CLK);
        WrEn = 1'b1;
        RdEn = 1'b0;
        Address = 3'd6;
        WrData = 16'hC3C3;
        @(posedge CLK);
        #1 WrEn = 1'b0;

        // ----------------------------------------------------
        // Scenario 3: Read back from Register 3
        // ----------------------------------------------------
        @(posedge CLK);
        WrEn = 1'b0;
        RdEn = 1'b1;
        Address = 3'd3;
        @(posedge CLK);
        #1;
        check_read(16'h5A5A, "READ_REGISTER_3");
        RdEn = 1'b0;

        // ----------------------------------------------------
        // Scenario 4: Read back from Register 6
        // ----------------------------------------------------
        @(posedge CLK);
        WrEn = 1'b0;
        RdEn = 1'b1;
        Address = 3'd6;
        @(posedge CLK);
        #1;
        check_read(16'hC3C3, "READ_REGISTER_6");
        RdEn = 1'b0;

        $display("=========================================================");
        $display(" Results: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $display("=========================================================");
        $finish;
    end
endmodule
