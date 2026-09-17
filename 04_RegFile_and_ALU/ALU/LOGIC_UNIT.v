// LOGIC_UNIT: AND / OR / NAND / NOR, registered outputs, async active-low reset
module LOGIC_UNIT #(
    parameter DATA_WIDTH = 16
)(
    input  wire                          CLK,
    input  wire                          RST,          // active low
    input  wire                          Logic_Enable,
    input  wire [DATA_WIDTH-1:0]          A,
    input  wire [DATA_WIDTH-1:0]          B,
    input  wire [1:0]                    ALU_FUN,      // ALU_FUNC[1:0]
    output reg  [DATA_WIDTH-1:0]          Logic_OUT,
    output reg                            Logic_Flag
);

    reg [DATA_WIDTH-1:0] Logic_next;
    reg                  Flag_next;

    always @(*) begin
        if (Logic_Enable) begin
            case (ALU_FUN)
                2'b00:   Logic_next = A & B;         // AND
                2'b01:   Logic_next = A | B;         // OR
                2'b10:   Logic_next = ~(A & B);      // NAND
                2'b11:   Logic_next = ~(A | B);      // NOR
                default: Logic_next = {DATA_WIDTH{1'b0}};
            endcase
            Flag_next = 1'b1;
        end else begin
            Logic_next = {DATA_WIDTH{1'b0}};
            Flag_next  = 1'b0;
        end
    end

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            Logic_OUT  <= {DATA_WIDTH{1'b0}};
            Logic_Flag <= 1'b0;
        end else begin
            Logic_OUT  <= Logic_next;
            Logic_Flag <= Flag_next;
        end
    end

endmodule
