// ============================================================================
// Module Name  : ASYNC_FIFO
// Description  : Top-Level Asynchronous FIFO Integration Module.
// Parameters   : DATA_WIDTH - Data bus width (default = 8)
//                ADDR_SIZE  - Memory address size (default = 3, Depth = 8)
// ============================================================================

module ASYNC_FIFO #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_SIZE  = 3
)(
    input  wire                  W_CLK,
    input  wire                  W_RST,
    input  wire                  W_INC,
    input  wire                  R_CLK,
    input  wire                  R_RST,
    input  wire                  R_INC,
    input  wire [DATA_WIDTH-1:0] WR_DATA,
    output wire [DATA_WIDTH-1:0] RD_DATA,
    output wire                  FULL,
    output wire                  EMPTY
);

    // Internal Connection Wires
    wire [ADDR_SIZE-1:0] waddr, raddr;
    wire [ADDR_SIZE:0]   wptr, rptr;
    wire [ADDR_SIZE:0]   wq2_rptr, rq2_wptr;
    wire                 wclken;

    // Gated Write Enable to Memory
    assign wclken = W_INC && (!FULL);

    // 1. Dual-Port RAM Buffer Module
    FIFO_MEM_CNTRL #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_SIZE (ADDR_SIZE)
    ) u_fifo_mem (
        .wdata (WR_DATA),
        .waddr (waddr),
        .raddr (raddr),
        .wclken(wclken),
        .wclk  (W_CLK),
        .wrst_n(W_RST),
        .rdata (RD_DATA)
    );

    // 2. Read-to-Write Domain Double Flop Synchronizer
    DF_SYNC #(
        .BUS_WIDTH(ADDR_SIZE + 1)
    ) sync_r2w (
        .ptr     (rptr),
        .clk     (W_CLK),
        .rst_n   (W_RST),
        .sync_ptr(wq2_rptr)
    );

    // 3. Write-to-Read Domain Double Flop Synchronizer
    DF_SYNC #(
        .BUS_WIDTH(ADDR_SIZE + 1)
    ) sync_w2r (
        .ptr     (wptr),
        .clk     (R_CLK),
        .rst_n   (R_RST),
        .sync_ptr(rq2_wptr)
    );

    // 4. FIFO Write Address & FULL Flag Controller
    FIFO_WR #(
        .ADDR_SIZE(ADDR_SIZE)
    ) u_fifo_wr (
        .wclk    (W_CLK),
        .wrst_n  (W_RST),
        .winc    (W_INC),
        .wq2_rptr(wq2_rptr),
        .waddr   (waddr),
        .wptr    (wptr),
        .wfull   (FULL)
    );

    // 5. FIFO Read Address & EMPTY Flag Controller
    FIFO_RD #(
        .ADDR_SIZE(ADDR_SIZE)
    ) u_fifo_rd (
        .rclk    (R_CLK),
        .rrst_n  (R_RST),
        .rinc    (R_INC),
        .rq2_wptr(rq2_wptr),
        .raddr   (raddr),
        .rptr    (rptr),
        .rempty  (EMPTY)
    );

endmodule
