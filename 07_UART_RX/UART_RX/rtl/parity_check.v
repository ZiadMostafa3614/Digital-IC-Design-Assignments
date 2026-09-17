module parity_check (
    input  wire       CLK,
    input  wire       RST,
    input  wire       par_chk_en,
    input  wire       clear_err,     // FSM clears this after CHK_ERR
    input  wire       PAR_TYP,
    input  wire       sampled_bit,
    input  wire [7:0] P_DATA,
    output reg        par_err
);
    wire expected_parity;
    assign expected_parity = (PAR_TYP == 1'b0) ? (^P_DATA) : ~(^P_DATA);

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            par_err <= 1'b0;
        end else if (clear_err) begin
            par_err <= 1'b0;        // Clear after CHK_ERR — ready for next frame
        end else if (par_chk_en) begin
            par_err <= (sampled_bit != expected_parity);
        end
    end
endmodule
