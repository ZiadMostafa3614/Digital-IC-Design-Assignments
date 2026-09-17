// ============================================================================
// Module Name  : DF_SYNC
// Description  : Parameterized 2-Stage D Flip-Flop Synchronizer for CDC Pointers.
// Parameters   : BUS_WIDTH - Width of pointer bus to synchronize (default = 4)
// ============================================================================

module DF_SYNC #(
    parameter BUS_WIDTH = 4
)(
    input  wire [BUS_WIDTH-1:0] ptr,
    input  wire                 clk,
    input  wire                 rst_n,
    output reg  [BUS_WIDTH-1:0] sync_ptr
);

    reg [BUS_WIDTH-1:0] sync_stage_1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_stage_1 <= {BUS_WIDTH{1'b0}};
            sync_ptr     <= {BUS_WIDTH{1'b0}};
        end else begin
            sync_stage_1 <= ptr;
            sync_ptr     <= sync_stage_1;
        end
    end

endmodule
