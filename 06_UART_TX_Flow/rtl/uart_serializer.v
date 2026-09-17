module uart_serializer (
    input  wire       CLK,
    input  wire       RST,
    input  wire [7:0] P_DATA,
    input  wire       ser_en,
    input  wire       Data_Valid,
    input  wire       Busy,
    output wire       ser_done,
    output wire       ser_data
);
    reg [7:0] shift_reg;
    reg [2:0] bit_cnt;

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            shift_reg <= 8'd0;
            bit_cnt   <= 3'd0;
        end else if (Data_Valid && !Busy) begin
            // Lint Rule: Load data when idle (Data_Valid pulse, !Busy)
            shift_reg <= P_DATA;
            bit_cnt   <= 3'd0;
        end else if (ser_en) begin
            // Lint Rule: Use matching width literal (3'd1 not 1'b1)
            shift_reg <= {1'b0, shift_reg[7:1]};
            bit_cnt   <= bit_cnt + 3'd1;
        end
        // Implicit else: hold all registers (no latch risk in sequential block)
    end

    // ser_data: LSB of shift register (updated every clock)
    assign ser_data = shift_reg[0];
    // ser_done: high for exactly 1 cycle when all 8 bits have been shifted out
    assign ser_done = (bit_cnt == 3'd7);
endmodule
