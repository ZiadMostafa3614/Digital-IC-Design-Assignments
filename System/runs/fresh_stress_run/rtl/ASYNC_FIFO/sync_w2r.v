module sync_w2r #(
    parameter ADDR_WIDTH = 3
) (
    input  wire                  rclk,
    input  wire                  rrst_n,
    input  wire [ADDR_WIDTH:0]   wptr,
    output reg  [ADDR_WIDTH:0]   rq2_wptr
);

    reg [ADDR_WIDTH:0] rq1_wptr;

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rq1_wptr <= {(ADDR_WIDTH+1){1'b0}};
            rq2_wptr <= {(ADDR_WIDTH+1){1'b0}};
        end
        else begin
            rq1_wptr <= wptr;
            rq2_wptr <= rq1_wptr;
        end
    end

endmodule
