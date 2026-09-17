// ============================================================================
// Module Name  : RST_SYNC
// Description  : Synthesizable Reset Synchronizer for active-low asynchronous reset.
//                Asynchronously asserts reset and synchronously de-asserts reset.
// Parameters   : NUM_STAGES - Number of D Flip-Flop stages (default = 2)
// Inputs       : RST      - Asynchronous active-low reset input
//                CLK      - Destination domain clock
// Outputs      : SYNC_RST - Synchronized active-low reset output
// ============================================================================

module RST_SYNC #(
    parameter NUM_STAGES = 2
)(
    input  wire RST,
    input  wire CLK,
    output wire SYNC_RST
);

    // Synchronizer Shift Register Chain
    reg [NUM_STAGES-1:0] sync_reg;

    // Asynchronous Reset Assertion & Synchronous De-assertion Logic
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            sync_reg <= {NUM_STAGES{1'b0}};
        end else begin
            sync_reg <= {sync_reg[NUM_STAGES-2:0], 1'b1};
        end
    end

    // Synchronized Reset Output
    assign SYNC_RST = sync_reg[NUM_STAGES-1];

endmodule
