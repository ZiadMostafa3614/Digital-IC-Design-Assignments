module edge_bit_counter (
    input  wire       CLK,
    input  wire       RST,
    input  wire       enable,
    input  wire       bit_cnt_en,
    input  wire [5:0] Prescale,
    output reg  [5:0] edge_cnt,
    output reg  [3:0] bit_cnt
);
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            edge_cnt <= 6'd0;
            bit_cnt  <= 4'd0;
        end else if (enable) begin
            if (edge_cnt == (Prescale - 6'd1)) begin
                edge_cnt <= 6'd0;
                if (bit_cnt_en) begin
                    if (bit_cnt == 4'd7) begin
                        bit_cnt <= 4'd0;
                    end else begin
                        bit_cnt <= bit_cnt + 4'd1;
                    end
                end else begin
                    bit_cnt <= 4'd0;
                end
            end else begin
                edge_cnt <= edge_cnt + 6'd1;
            end
        end else begin
            edge_cnt <= 6'd0;
            bit_cnt  <= 4'd0;
        end
    end
endmodule
