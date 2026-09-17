// ============================================================================
// Module Name  : FIFO_MEM_CNTRL
// Description  : Dual-Port RAM Memory Control Block for Asynchronous FIFO.
// Parameters   : DATA_WIDTH - Width of data word (default = 8)
//                ADDR_SIZE  - Number of address bits (Depth = 2^ADDR_SIZE, default = 3)
// ============================================================================

module FIFO_MEM_CNTRL #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_SIZE  = 3
)(
    input  wire [DATA_WIDTH-1:0] wdata,
    input  wire [ADDR_SIZE-1:0]  waddr,
    input  wire [ADDR_SIZE-1:0]  raddr,
    input  wire                  wclken,
    input  wire                  wclk,
    input  wire                  wrst_n,
    output wire [DATA_WIDTH-1:0] rdata
);

    localparam DEPTH = 1 << ADDR_SIZE;

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    integer i;

    // Synchronous Write Operation
    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            for (i = 0; i < DEPTH; i = i + 1) begin
                mem[i] <= {DATA_WIDTH{1'b0}};
            end
        end else if (wclken) begin
            mem[waddr] <= wdata;
        end
    end

    // Asynchronous Read Out
    assign rdata = mem[raddr];

endmodule
