module sync_r2w #(
    parameter ADDR_WIDTH = 3
) (
    input  wire                  wclk,
    input  wire                  wrst_n,
    input  wire [ADDR_WIDTH:0]   rptr,
    output reg  [ADDR_WIDTH:0]   wq2_rptr
);

    reg [ADDR_WIDTH:0] wq1_rptr;

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wq1_rptr <= {(ADDR_WIDTH+1){1'b0}};
            wq2_rptr <= {(ADDR_WIDTH+1){1'b0}};
        end
        else begin
            wq1_rptr <= rptr;
            wq2_rptr <= wq1_rptr;
        end
    end

endmodule
