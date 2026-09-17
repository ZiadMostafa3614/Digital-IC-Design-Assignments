module uart_serializer (
    input  wire       CLK,
    input  wire       RST,
    input  wire [7:0] P_DATA,
    input  wire       ser_en,
    input  wire       Data_Valid,
    input  wire       Busy,
    output wire       ser_done,
    output wire       ser_data
);
    reg [7:0] shift_reg;
    reg [3:0] bit_cnt;

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            shift_reg <= 8'd0;
            bit_cnt   <= 4'd0;
        end else if (Data_Valid && !Busy) begin
            shift_reg <= P_DATA;
            bit_cnt   <= 4'd0;
        end else if (ser_en) begin
            shift_reg <= {1'b0, shift_reg[7:1]};
            bit_cnt   <= bit_cnt + 4'd1;
        end
    end

    assign ser_data = shift_reg[0];
    assign ser_done = (bit_cnt == 4'd7);
endmodule
