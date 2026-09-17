`timescale 1ns / 1ps

module LFSR (
    input  wire clk,
    input  wire rst_n,
    input  wire DATA,
    input  wire ACTIVE,
    output reg  CRC,
    output reg  Valid
);

    reg [7:0] lfsr_reg;
    reg [3:0] count;
    reg [1:0] state;

    localparam IDLE       = 2'b00;
    localparam SHIFT_DATA = 2'b01;
    localparam OUT_CRC    = 2'b10;

    wire feedback = lfsr_reg[0] ^ DATA;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr_reg <= 8'hD8;
            count    <= 4'd0;
            state    <= IDLE;
            CRC      <= 1'b0;
            Valid    <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    CRC   <= 1'b0;
                    Valid <= 1'b0;
                    count <= 4'd0;
                    if (ACTIVE) begin
                        state <= SHIFT_DATA;
                        lfsr_reg[7] <= feedback;
                        lfsr_reg[6] <= lfsr_reg[7] ^ feedback;
                        lfsr_reg[5] <= lfsr_reg[6];
                        lfsr_reg[4] <= lfsr_reg[5];
                        lfsr_reg[3] <= lfsr_reg[4];
                        lfsr_reg[2] <= lfsr_reg[3] ^ feedback;
                        lfsr_reg[1] <= lfsr_reg[2];
                        lfsr_reg[0] <= lfsr_reg[1];
                    end
                end

                SHIFT_DATA: begin
                    if (ACTIVE) begin
                        lfsr_reg[7] <= feedback;
                        lfsr_reg[6] <= lfsr_reg[7] ^ feedback;
                        lfsr_reg[5] <= lfsr_reg[6];
                        lfsr_reg[4] <= lfsr_reg[5];
                        lfsr_reg[3] <= lfsr_reg[4];
                        lfsr_reg[2] <= lfsr_reg[3] ^ feedback;
                        lfsr_reg[1] <= lfsr_reg[2];
                        lfsr_reg[0] <= lfsr_reg[1];
                    end else begin
                        state    <= OUT_CRC;
                        count    <= 4'd7;
                        Valid    <= 1'b1;
                        CRC      <= lfsr_reg[0];
                        lfsr_reg <= {1'b0, lfsr_reg[7:1]};
                    end
                end

                OUT_CRC: begin
                    if (count > 0) begin
                        Valid    <= 1'b1;
                        CRC      <= lfsr_reg[0];
                        lfsr_reg <= {1'b0, lfsr_reg[7:1]};
                        count    <= count - 1;
                    end else begin
                        Valid    <= 1'b0;
                        CRC      <= 1'b0;
                        state    <= IDLE;
                        lfsr_reg <= 8'hD8; // Re-initialize to SEED for next transaction
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
