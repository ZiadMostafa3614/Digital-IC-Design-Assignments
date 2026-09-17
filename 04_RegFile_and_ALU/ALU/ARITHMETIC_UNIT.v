// ARITHMETIC_UNIT: Signed Add / Sub / Mul / Div, registered outputs, async active-low reset
// OUT_DATA_WIDTH defaults to 2*DATA_WIDTH for full-precision multiplication
module ARITHMETIC_UNIT #(
    parameter DATA_WIDTH     = 16,
    parameter OUT_DATA_WIDTH = 2 * DATA_WIDTH
)(
    input  wire                              CLK,
    input  wire                              RST,          // active low
    input  wire                              Arith_Enable,
    input  wire signed [DATA_WIDTH-1:0]      A,
    input  wire signed [DATA_WIDTH-1:0]      B,
    input  wire [1:0]                        ALU_FUN,      // ALU_FUNC[1:0]
    output reg  signed [OUT_DATA_WIDTH-1:0]  Arith_OUT,
    output reg                               Arith_Flag
);

    reg signed [OUT_DATA_WIDTH-1:0] Arith_next;
    reg                             Flag_next;

    always @(*) begin
        if (Arith_Enable) begin
            case (ALU_FUN)
                2'b00:   Arith_next = A + B;                     // Signed Addition
                2'b01:   Arith_next = A - B;                     // Signed Subtraction
                2'b10:   Arith_next = A * B;                     // Signed Multiplication (full precision)
                2'b11: begin                                     // Signed Division, guarded against /0
                    if (B == 0)
                        Arith_next = {OUT_DATA_WIDTH{1'b0}};
                    else
                        Arith_next = A / B;
                end
                default: Arith_next = {OUT_DATA_WIDTH{1'b0}};
            endcase
            Flag_next = 1'b1;
        end else begin
            Arith_next = {OUT_DATA_WIDTH{1'b0}};
            Flag_next  = 1'b0;
        end
    end

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            Arith_OUT  <= {OUT_DATA_WIDTH{1'b0}};
            Arith_Flag <= 1'b0;
        end else begin
            Arith_OUT  <= Arith_next;
            Arith_Flag <= Flag_next;
        end
    end

endmodule
