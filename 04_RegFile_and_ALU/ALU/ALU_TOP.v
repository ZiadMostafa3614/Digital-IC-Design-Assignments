// ALU_TOP: top-level 16-bit ALU wiring Decoder + Arithmetic/Logic/CMP/Shift units
module ALU_TOP #(
    parameter DATA_WIDTH     = 16,
    parameter OUT_DATA_WIDTH = 2 * DATA_WIDTH
)(
    input  wire                              CLK,
    input  wire                              RST,          // active low, asynchronous
    input  wire signed [DATA_WIDTH-1:0]      A,
    input  wire signed [DATA_WIDTH-1:0]      B,
    input  wire [3:0]                        ALU_FUNC,

    output wire signed [OUT_DATA_WIDTH-1:0]  Arith_OUT,
    output wire                              Arith_Flag,

    output wire [DATA_WIDTH-1:0]         Logic_OUT,
    output wire                          Logic_Flag,

    output wire signed [DATA_WIDTH-1:0]  CMP_OUT,
    output wire                          CMP_Flag,

    output wire [DATA_WIDTH-1:0]         SHIFT_OUT,
    output wire                          SHIFT_Flag
);

    wire Arith_En, Logic_En, CMP_En, Shift_En;

    DECODER u_decoder (
        .SEL      (ALU_FUNC[3:2]),
        .Arith_En (Arith_En),
        .Logic_En (Logic_En),
        .CMP_En   (CMP_En),
        .Shift_En (Shift_En)
    );

    ARITHMETIC_UNIT #(.DATA_WIDTH(DATA_WIDTH), .OUT_DATA_WIDTH(OUT_DATA_WIDTH)) u_arith (
        .CLK          (CLK),
        .RST          (RST),
        .Arith_Enable (Arith_En),
        .A            (A),
        .B            (B),
        .ALU_FUN      (ALU_FUNC[1:0]),
        .Arith_OUT    (Arith_OUT),
        .Arith_Flag   (Arith_Flag)
    );

    LOGIC_UNIT #(.DATA_WIDTH(DATA_WIDTH)) u_logic (
        .CLK          (CLK),
        .RST          (RST),
        .Logic_Enable (Logic_En),
        .A            (A),
        .B            (B),
        .ALU_FUN      (ALU_FUNC[1:0]),
        .Logic_OUT    (Logic_OUT),
        .Logic_Flag   (Logic_Flag)
    );

    CMP_UNIT #(.DATA_WIDTH(DATA_WIDTH)) u_cmp (
        .CLK        (CLK),
        .RST        (RST),
        .CMP_Enable (CMP_En),
        .A          (A),
        .B          (B),
        .ALU_FUN    (ALU_FUNC[1:0]),
        .CMP_OUT    (CMP_OUT),
        .CMP_Flag   (CMP_Flag)
    );

    SHIFT_UNIT #(.DATA_WIDTH(DATA_WIDTH)) u_shift (
        .CLK          (CLK),
        .RST          (RST),
        .Shift_Enable (Shift_En),
        .A            (A),
        .B            (B),
        .ALU_FUN      (ALU_FUNC[1:0]),
        .SHIFT_OUT    (SHIFT_OUT),
        .SHIFT_Flag   (SHIFT_Flag)
    );

endmodule
