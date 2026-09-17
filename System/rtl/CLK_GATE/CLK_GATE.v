module CLK_GATE (
    input  wire CLK,
    input  wire CLK_EN,
    output wire GATED_CLK
);

    reg gate_latch;

    always @(*) begin
        if (!CLK) begin
            gate_latch = CLK_EN;
        end
    end

    assign GATED_CLK = CLK & gate_latch;

endmodule
