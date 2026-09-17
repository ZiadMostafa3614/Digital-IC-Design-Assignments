module uart_mux (
    input  wire       CLK,
    input  wire       RST,
    input  wire [1:0] mux_sel,
    input  wire       ser_data,
    input  wire       par_bit,
    output reg        TX_OUT
);
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            TX_OUT <= 1'b1;
        end else begin
            case (mux_sel)
                2'b00: TX_OUT <= 1'b0;       // start bit
                2'b01: TX_OUT <= 1'b1;       // stop/idle bit
                2'b10: TX_OUT <= ser_data;   // serial data
                2'b11: TX_OUT <= par_bit;    // parity bit
                default: TX_OUT <= 1'b1;
            endcase
        end
    end
endmodule
