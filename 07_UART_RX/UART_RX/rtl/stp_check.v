module stp_check (
    input  wire CLK,
    input  wire RST,
    input  wire stp_chk_en,
    input  wire clear_err,       // FSM clears this after CHK_ERR
    input  wire sampled_bit,
    output reg  stp_err
);
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            stp_err <= 1'b0;
        end else if (clear_err) begin
            stp_err <= 1'b0;        // Clear after CHK_ERR — ready for next frame
        end else if (stp_chk_en) begin
            stp_err <= (sampled_bit != 1'b1);
        end
    end
endmodule
