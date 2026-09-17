// ============================================================================
// Module Name  : FIFO_WR
// Description  : Write Address Generator & FULL Flag Logic for Asynchronous FIFO.
// Parameters   : ADDR_SIZE - Address size (default = 3)
// ============================================================================

module FIFO_WR #(
    parameter ADDR_SIZE = 3
)(
    input  wire                 wclk,
    input  wire                 wrst_n,
    input  wire                 winc,
    input  wire [ADDR_SIZE:0]   wq2_rptr,
    output wire [ADDR_SIZE-1:0] waddr,
    output reg  [ADDR_SIZE:0]   wptr,
    output reg                  wfull
);

    reg  [ADDR_SIZE:0] wbin;
    wire [ADDR_SIZE:0] wbin_next;
    wire [ADDR_SIZE:0] wgray_next;
    wire               wfull_val;

    // Binary counter update
    assign wbin_next  = wbin + (winc && !wfull);

    // Binary to Gray conversion
    assign wgray_next = wbin_next ^ (wbin_next >> 1);

    // Binary write address output to memory
    assign waddr      = wbin[ADDR_SIZE-1:0];

    // Sequential update of binary counter, Gray pointer, and full flag
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wbin  <= {(ADDR_SIZE+1){1'b0}};
            wptr  <= {(ADDR_SIZE+1){1'b0}};
            wfull <= 1'b0;
        end else begin
            wbin  <= wbin_next;
            wptr  <= wgray_next;
            wfull <= wfull_val;
        end
    end

    // Clifford Cummings FULL condition comparison:
    // Full when top 2 MSBs differ and remaining LSBs match
    assign wfull_val = (wgray_next[ADDR_SIZE]   != wq2_rptr[ADDR_SIZE])   &&
                       (wgray_next[ADDR_SIZE-1] != wq2_rptr[ADDR_SIZE-1]) &&
                       (wgray_next[ADDR_SIZE-2:0] == wq2_rptr[ADDR_SIZE-2:0]);

endmodule
