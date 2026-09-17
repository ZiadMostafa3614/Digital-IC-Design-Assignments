// ============================================================
//  Module  : ALU_16B
//  Project : Assignment 3 – 16-bit ALU
//  Date    : 2026-07-08
// ============================================================
module ALU_16B (
    input  wire        CLK,
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire [ 3:0] ALU_FUN,
    output reg  [15:0] ALU_OUT,
    output wire        Carry_Flag,
    output wire        Arith_Flag,
    output wire        Logic_Flag,
    output wire        CMP_Flag,
    output wire        Shift_Flag
);

    // Internal registers to hold combinational results
    reg  [15:0] alu_result;
    reg         carry_out;
    reg         arith_flag;
    reg         logic_flag;
    reg         cmp_flag;
    reg         shift_flag;

    // Flags are combinational (not registered)
    assign Carry_Flag = carry_out;
    assign Arith_Flag = arith_flag;
    assign Logic_Flag = logic_flag;
    assign CMP_Flag   = cmp_flag;
    assign Shift_Flag = shift_flag;

    // ── Combinational block ────────────────────────────────
    always @(*) begin
        // Defaults
        alu_result = 16'b0;
        carry_out  = 1'b0;
        arith_flag = 1'b0;
        logic_flag = 1'b0;
        cmp_flag   = 1'b0;
        shift_flag = 1'b0;

        case (ALU_FUN)
            // ── Arithmetic ─────────────────────────────────
            4'b0000: begin   // Unsigned Addition
                {carry_out, alu_result} = A + B;
                arith_flag = 1'b1;
            end
            4'b0001: begin   // Unsigned Subtraction
                {carry_out, alu_result} = A - B;  // carry_out = borrow
                arith_flag = 1'b1;
            end
            4'b0010: begin   // Unsigned Multiplication (lower 16 bits)
                alu_result = A * B;
                arith_flag = 1'b1;
            end
            4'b0011: begin   // Unsigned Division
                alu_result = (B != 0) ? (A / B) : 16'b0;
                arith_flag = 1'b1;
            end

            // ── Logic ──────────────────────────────────────
            4'b0100: begin   // AND
                alu_result = A & B;
                logic_flag = 1'b1;
            end
            4'b0101: begin   // OR
                alu_result = A | B;
                logic_flag = 1'b1;
            end
            4'b0110: begin   // NAND
                alu_result = ~(A & B);
                logic_flag = 1'b1;
            end
            4'b0111: begin   // NOR
                alu_result = ~(A | B);
                logic_flag = 1'b1;
            end
            4'b1000: begin   // XOR
                alu_result = A ^ B;
                logic_flag = 1'b1;
            end
            4'b1001: begin   // XNOR
                alu_result = ~(A ^ B);
                logic_flag = 1'b1;
            end

            // ── Compare ────────────────────────────────────
            4'b1010: begin   // CMP: A == B
                alu_result = (A == B) ? 16'd1 : 16'd0;
                cmp_flag   = 1'b1;
            end
            4'b1011: begin   // CMP: A > B
                alu_result = (A > B) ? 16'd2 : 16'd0;
                cmp_flag   = 1'b1;
            end
            4'b1100: begin   // CMP: A < B
                alu_result = (A < B) ? 16'd3 : 16'd0;
                cmp_flag   = 1'b1;
            end

            // ── Shift ──────────────────────────────────────
            4'b1101: begin   // Shift Right A >> 1
                alu_result = A >> 1;
                shift_flag = 1'b1;
            end
            4'b1110: begin   // Shift Left  A << 1
                alu_result = A << 1;
                shift_flag = 1'b1;
            end

            // ── Default / NOP ──────────────────────────────
            default: begin
                alu_result = 16'b0;
            end
        endcase
    end

    // ── Registered output (ALU_OUT only) ──────────────────
    always @(posedge CLK) begin
        ALU_OUT <= alu_result;
    end

endmodule
