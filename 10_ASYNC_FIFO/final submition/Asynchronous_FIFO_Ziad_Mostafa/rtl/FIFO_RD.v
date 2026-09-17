// ============================================================================
// Module Name  : FIFO_RD
// Description  : Read Address Generator & EMPTY Flag Logic for Asynchronous FIFO.
// Parameters   : ADDR_SIZE - Address size (default = 3)
// ============================================================================

module FIFO_RD #(
    parameter ADDR_SIZE = 3
)(
    input  wire                 rclk,
    input  wire                 rrst_n,
    input  wire                 rinc,
    input  wire [ADDR_SIZE:0]   rq2_wptr,
    output wire [ADDR_SIZE-1:0] raddr,
    output reg  [ADDR_SIZE:0]   rptr,
    output reg                  rempty
);

    reg  [ADDR_SIZE:0] rbin;
    wire [ADDR_SIZE:0] rbin_next;
    wire [ADDR_SIZE:0] rgray_next;
    wire               rempty_val;

    // Binary counter update
    assign rbin_next  = rbin + (rinc && !rempty);

    // Binary to Gray conversion
    assign rgray_next = rbin_next ^ (rbin_next >> 1);

    // Binary read address output to memory
    assign raddr      = rbin[ADDR_SIZE-1:0];

    // Sequential update of binary counter, Gray pointer, and empty flag
    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rbin   <= {(ADDR_SIZE+1){1'b0}};
            rptr   <= {(ADDR_SIZE+1){1'b0}};
            rempty <= 1'b1; // Initially EMPTY after reset
        end else begin
            rbin   <= rbin_next;
            rptr   <= rgray_next;
            rempty <= rempty_val;
        end
    end

    // EMPTY condition comparison:
    // Empty when read Gray pointer equals synchronized write Gray pointer
    assign rempty_val = (rgray_next == rq2_wptr);

endmodule
