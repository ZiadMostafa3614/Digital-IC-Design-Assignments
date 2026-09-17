module data_sampling (
    input  wire       CLK,
    input  wire       RST,
    input  wire       RX_IN,
    input  wire [5:0] Prescale,
    input  wire       dat_samp_en,
    input  wire [5:0] edge_cnt,
    output reg        sampled_bit
);
    // 3-sample majority voting at the middle of the bit period
    // Samples taken at: (Prescale/2 - 1), (Prescale/2), (Prescale/2 + 1)
    // Supported Prescale values: 8, 16, 32
    // For Prescale=8:  sample ticks = 3, 4, 5
    // For Prescale=16: sample ticks = 7, 8, 9
    // For Prescale=32: sample ticks = 15, 16, 17

    reg  [2:0] samples;
    wire [5:0] half_ticks;
    
    assign half_ticks = Prescale >> 1;

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            samples     <= 3'b111;
            sampled_bit <= 1'b1;
        end else if (dat_samp_en) begin
            // Sample 0 at (Prescale/2 - 1)
            if (edge_cnt == (half_ticks - 6'd1))
                samples[0] <= RX_IN;

            // Sample 1 at (Prescale/2)
            if (edge_cnt == half_ticks)
                samples[1] <= RX_IN;

            // Sample 2 at (Prescale/2 + 1) → majority vote registered here
            if (edge_cnt == (half_ticks + 6'd1)) begin
                samples[2]  <= RX_IN;
                sampled_bit <= (samples[0] & samples[1]) |
                               (samples[0] & RX_IN)      |
                               (samples[1] & RX_IN);
            end
        end else begin
            samples     <= 3'b111;
            sampled_bit <= 1'b1;
        end
    end
endmodule
