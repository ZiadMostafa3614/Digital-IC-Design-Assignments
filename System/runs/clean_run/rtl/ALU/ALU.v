module ALU #(
    parameter OPERAND_WIDTH = 8,
    parameter RESULT_WIDTH  = 16,
    parameter FUN_WIDTH     = 4
) (
    input  wire                     CLK,
    input  wire                     RST,
    input  wire [OPERAND_WIDTH-1:0] A,
    input  wire [OPERAND_WIDTH-1:0] B,
    input  wire [FUN_WIDTH-1:0]     ALU_FUN,
    input  wire                     Enable,
    output reg  [RESULT_WIDTH-1:0]  ALU_OUT,
    output reg                      OUT_VALID
);

    reg [RESULT_WIDTH-1:0] alu_comb_result;

    always @(*) begin
        case (ALU_FUN)
            4'b0000: alu_comb_result = A + B;
            4'b0001: alu_comb_result = A - B;
            4'b0010: alu_comb_result = A * B;
            4'b0011: alu_comb_result = (B != 0) ? (A / B) : {RESULT_WIDTH{1'b0}};
            4'b0100: alu_comb_result = A & B;
            4'b0101: alu_comb_result = A | B;
            4'b0110: alu_comb_result = ~(A & B);
            4'b0111: alu_comb_result = ~(A | B);
            4'b1000: alu_comb_result = A ^ B;
            4'b1001: alu_comb_result = ~(A ^ B);
            4'b1010: alu_comb_result = (A == B) ? 16'd1 : 16'd0;
            4'b1011: alu_comb_result = (A > B)  ? 16'd2 : 16'd0;
            4'b1100: alu_comb_result = A >> 1;
            4'b1101: alu_comb_result = A << 1;
            default: alu_comb_result = {RESULT_WIDTH{1'b0}};
        endcase
    end

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            ALU_OUT   <= {RESULT_WIDTH{1'b0}};
            OUT_VALID <= 1'b0;
        end
        else if (Enable) begin
            ALU_OUT   <= alu_comb_result;
            OUT_VALID <= 1'b1;
        end
        else begin
            OUT_VALID <= 1'b0;
        end
    end

endmodule
