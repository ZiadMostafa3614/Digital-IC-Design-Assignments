// 2x4 Decoder: enables one of the four functional blocks based on ALU_FUNC[3:2]
module DECODER (
    input  wire [1:0] SEL,       // ALU_FUNC[3:2]
    output reg         Arith_En,
    output reg         Logic_En,
    output reg         CMP_En,
    output reg         Shift_En
);

    always @(*) begin
        {Arith_En, Logic_En, CMP_En, Shift_En} = 4'b0000;
        case (SEL)
            2'b00: Arith_En = 1'b1;
            2'b01: Logic_En = 1'b1;
            2'b10: CMP_En   = 1'b1;
            2'b11: Shift_En = 1'b1;
        endcase
    end

endmodule
