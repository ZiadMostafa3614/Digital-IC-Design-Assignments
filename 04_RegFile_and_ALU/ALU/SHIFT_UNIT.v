// SHIFT_UNIT: A>>1 / A<<1 / B>>1 / B<<1, registered outputs, async active-low reset
module SHIFT_UNIT #(
    parameter DATA_WIDTH = 16
)(
    input  wire                          CLK,
    input  wire                          RST,          // active low
    input  wire                          Shift_Enable,
    input  wire [DATA_WIDTH-1:0]          A,
    input  wire [DATA_WIDTH-1:0]          B,
    input  wire [1:0]                    ALU_FUN,      // ALU_FUNC[1:0]
    output reg  [DATA_WIDTH-1:0]          SHIFT_OUT,
    output reg                            SHIFT_Flag
);

    reg [DATA_WIDTH-1:0] Shift_next;
    reg                  Flag_next;

    always @(*) begin
        if (Shift_Enable) begin
            case (ALU_FUN)
                2'b00:   Shift_next = A >> 1;   // A shift right
                2'b01:   Shift_next = A << 1;   // A shift left
                2'b10:   Shift_next = B >> 1;   // B shift right
                2'b11:   Shift_next = B << 1;   // B shift left
                default: Shift_next = {DATA_WIDTH{1'b0}};
            endcase
            Flag_next = 1'b1;
        end else begin
            Shift_next = {DATA_WIDTH{1'b0}};
            Flag_next  = 1'b0;
        end
    end

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            SHIFT_OUT  <= {DATA_WIDTH{1'b0}};
            SHIFT_Flag <= 1'b0;
        end else begin
            SHIFT_OUT  <= Shift_next;
            SHIFT_Flag <= Flag_next;
        end
    end

endmodule
