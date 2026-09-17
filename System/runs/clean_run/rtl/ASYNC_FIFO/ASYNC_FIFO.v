module ASYNC_FIFO #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 3
) (
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

    wire [ADDR_WIDTH-1:0] waddr, raddr;
    wire [ADDR_WIDTH:0]   wptr, rptr;
    wire [ADDR_WIDTH:0]   wq2_rptr, rq2_wptr;

    // Synchronize read pointer to write clock domain
    sync_r2w #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_sync_r2w (
        .wclk(W_CLK),
        .wrst_n(W_RST),
        .rptr(rptr),
        .wq2_rptr(wq2_rptr)
    );

    // Synchronize write pointer to read clock domain
    sync_w2r #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_sync_w2r (
        .rclk(R_CLK),
        .rrst_n(R_RST),
        .wptr(wptr),
        .rq2_wptr(rq2_wptr)
    );

    // Read pointer & empty logic
    rptr_empty #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_rptr_empty (
        .rclk(R_CLK),
        .rrst_n(R_RST),
        .rinc(R_INC),
        .rq2_wptr(rq2_wptr),
        .rempty(EMPTY),
        .raddr(raddr),
        .rptr(rptr)
    );

    // Write pointer & full logic
    wptr_full #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_wptr_full (
        .wclk(W_CLK),
        .wrst_n(W_RST),
        .winc(W_INC),
        .wq2_rptr(wq2_rptr),
        .wfull(FULL),
        .waddr(waddr),
        .wptr(wptr)
    );

    // FIFO Memory
    fifo_mem #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) u_fifo_mem (
        .wclk(W_CLK),
        .wclken(W_INC & ~FULL),
        .waddr(waddr),
        .raddr(raddr),
        .wdata(WR_DATA),
        .rdata(RD_DATA)
    );

endmodule
