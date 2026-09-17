module clk_div #(
    parameter RATIO_WIDTH = 8
) (
    input  wire                   i_ref_clk,
    input  wire                   i_rst_n,
    input  wire                   i_clk_en,
    input  wire [RATIO_WIDTH-1:0] i_div_ratio,
    output reg                    o_div_clk
);

    reg [RATIO_WIDTH-1:0] counter;
    wire                  clk_div_en;

    assign clk_div_en = i_clk_en && (i_div_ratio != 0) && (i_div_ratio != 1);

    always @(posedge i_ref_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            counter   <= {RATIO_WIDTH{1'b0}};
            o_div_clk <= 1'b0;
        end
        else if (clk_div_en) begin
            if (counter == ((i_div_ratio >> 1) - 1)) begin
                o_div_clk <= ~o_div_clk;
                counter   <= counter + 1'b1;
            end
            else if (counter == (i_div_ratio - 1)) begin
                o_div_clk <= ~o_div_clk;
                counter   <= {RATIO_WIDTH{1'b0}};
            end
            else begin
                counter <= counter + 1'b1;
            end
        end
        else begin
            o_div_clk <= i_ref_clk;
            counter   <= {RATIO_WIDTH{1'b0}};
        end
    end

endmodule
