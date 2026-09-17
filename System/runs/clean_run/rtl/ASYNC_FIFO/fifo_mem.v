module fifo_mem #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 3
) (
    input  wire                  wclk,
    input  wire                  wclken,
    input  wire [ADDR_WIDTH-1:0] waddr,
    input  wire [ADDR_WIDTH-1:0] raddr,
    input  wire [DATA_WIDTH-1:0] wdata,
    output wire [DATA_WIDTH-1:0] rdata
);

    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    always @(posedge wclk) begin
        if (wclken) begin
            mem[waddr] <= wdata;
        end
    end

    assign rdata = mem[raddr];

endmodule
