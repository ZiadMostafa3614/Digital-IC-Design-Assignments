// CMP_UNIT: NOP / Equal / Greater / Less, registered outputs, async active-low reset
// Output encoding: NOP -> 0, A==B -> 1, A>B -> 2, A<B -> 3, condition false -> 0
module CMP_UNIT #(
    parameter DATA_WIDTH = 16
)(
    input  wire                          CLK,
    input  wire                          RST,          // active low
    input  wire                          CMP_Enable,
    input  wire signed [DATA_WIDTH-1:0]  A,
    input  wire signed [DATA_WIDTH-1:0]  B,
    input  wire [1:0]                    ALU_FUN,      // ALU_FUNC[1:0]
    output reg  signed [DATA_WIDTH-1:0]  CMP_OUT,
    output reg                           CMP_Flag
);

    reg signed [DATA_WIDTH-1:0] CMP_next;
    reg                         Flag_next;

    always @(*) begin
        if (CMP_Enable) begin
            case (ALU_FUN)
                2'b00:   CMP_next = {DATA_WIDTH{1'b0}};          // NOP
                2'b01:   CMP_next = (A == B) ? {{(DATA_WIDTH-1){1'b0}},1'b1} : {DATA_WIDTH{1'b0}}; // Equal
                2'b10:   CMP_next = (A >  B) ? {{(DATA_WIDTH-2){1'b0}},2'b10} : {DATA_WIDTH{1'b0}}; // Greater
                2'b11:   CMP_next = (A <  B) ? {{(DATA_WIDTH-2){1'b0}},2'b11} : {DATA_WIDTH{1'b0}}; // Less
                default: CMP_next = {DATA_WIDTH{1'b0}};
            endcase
            Flag_next = 1'b1;   // High for NOP and all comparison ops per spec
        end else begin
            CMP_next  = {DATA_WIDTH{1'b0}};
            Flag_next = 1'b0;
        end
    end

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            CMP_OUT  <= {DATA_WIDTH{1'b0}};
            CMP_Flag <= 1'b0;
        end else begin
            CMP_OUT  <= CMP_next;
            CMP_Flag <= Flag_next;
        end
    end

endmodule
