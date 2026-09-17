module PULSE_GEN (
    input  wire CLK,
    input  wire RST,
    input  wire LVL_SIG,
    output wire PULSE_SIG
);

    reg q_reg;

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            q_reg <= 1'b0;
        end
        else begin
            q_reg <= LVL_SIG;
        end
    end

    // Pulse generated on falling edge of Busy signal (when TX becomes idle after sending)
    assign PULSE_SIG = q_reg & ~LVL_SIG;

endmodule
