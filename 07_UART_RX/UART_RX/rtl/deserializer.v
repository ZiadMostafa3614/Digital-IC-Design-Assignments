module deserializer (
    input  wire       CLK,
    input  wire       RST,
    input  wire       deser_en,
    input  wire [5:0] Prescale,
    input  wire [5:0] edge_cnt,
    input  wire       sampled_bit,
    output reg  [7:0] P_DATA
);
    // UART sends LSB first (b0 → b7)
    // Shift sampled_bit in from the RIGHT (LSB) on each bit-done edge
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            P_DATA <= 8'd0;
        end else if (deser_en && (edge_cnt == (Prescale - 6'd1))) begin
            P_DATA <= {sampled_bit, P_DATA[7:1]};  // MSB shift-in, fills b0 first -> LSB-first
        end
    end
endmodule
