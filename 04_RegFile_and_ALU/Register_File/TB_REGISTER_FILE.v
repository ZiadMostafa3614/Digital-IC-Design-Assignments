`timescale 1ns/1ps

module TB_REGISTER_FILE;

    parameter DATA_WIDTH = 16;
    parameter ADDR_WIDTH = 3;
    parameter CLK_PERIOD = 10;

    reg                   CLK;
    reg                   RST;
    reg                   WrEn;
    reg                   RdEn;
    reg  [ADDR_WIDTH-1:0] Address;
    reg  [DATA_WIDTH-1:0] WrData;
    wire [DATA_WIDTH-1:0] RdData;

    integer pass_count = 0;
    integer fail_count = 0;

    REGISTER_FILE #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) DUT (
        .CLK     (CLK),
        .RST     (RST),
        .WrEn    (WrEn),
        .RdEn    (RdEn),
        .Address (Address),
        .WrData  (WrData),
        .RdData  (RdData)
    );

    // Simple 50/50 clock, period = 10 ns
    initial CLK = 1'b0;
    always #(CLK_PERIOD/2) CLK = ~CLK;

    task do_write;
        input [ADDR_WIDTH-1:0] addr;
        input [DATA_WIDTH-1:0] data;
        begin
            WrEn    = 1'b1;
            RdEn    = 1'b0;
            Address = addr;
            WrData  = data;
            @(posedge CLK);
            #1;
            WrEn = 1'b0;
        end
    endtask

    task do_read;
        input  [ADDR_WIDTH-1:0] addr;
        input  [DATA_WIDTH-1:0] exp_data;
        input  [8*32:1]         test_name;
        begin
            RdEn    = 1'b1;
            WrEn    = 1'b0;
            Address = addr;
            @(posedge CLK);
            #1;
            if (RdData === exp_data) begin
                $display("PASS | %0s | Address=%0d -> RdData=%0d", test_name, addr, RdData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | %0s | Address=%0d -> RdData=%0d (exp %0d)", test_name, addr, RdData, exp_data);
                fail_count = fail_count + 1;
            end
            RdEn = 1'b0;
        end
    endtask

    initial begin
        $display("=========================================================");
        $display(" REGISTER_FILE Testbench");
        $display("=========================================================");

        RST     = 1'b0;   // assert active-low reset
        WrEn    = 1'b0;
        RdEn    = 1'b0;
        Address = 0;
        WrData  = 0;
        #(CLK_PERIOD*2);
        RST = 1'b1;        // release reset
        @(posedge CLK);

        // Scenario 1: Write to register 2
        do_write(3'd2, 16'hABCD);

        // Scenario 2: Write to register 5
        do_write(3'd5, 16'h1234);

        // Scenario 3: Read back register 2
        do_read(3'd2, 16'hABCD, "READ_REG2");

        // Scenario 4: Read back register 5
        do_read(3'd5, 16'h1234, "READ_REG5");

        // Extra scenario: overwrite register 2, then verify old value at reg5 unaffected
        do_write(3'd2, 16'h5555);
        do_read(3'd2, 16'h5555, "READ_REG2_AFTER_OVERWRITE");
        do_read(3'd5, 16'h1234, "READ_REG5_UNCHANGED");

        // Extra scenario: verify async reset clears everything
        RST = 1'b0;
        #1;
        RST = 1'b1;
        do_read(3'd2, 16'h0000, "READ_REG2_AFTER_RESET");

        $display("=========================================================");
        $display(" RESULTS: %0d PASSED, %0d FAILED", pass_count, fail_count);
        $display("=========================================================");

        #(CLK_PERIOD*2);
        $finish;
    end

endmodule
