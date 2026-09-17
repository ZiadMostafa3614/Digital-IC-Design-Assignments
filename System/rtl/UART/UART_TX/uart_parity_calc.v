module uart_parity_calc (
    input  wire       CLK,
    input  wire       RST,
    input  wire [7:0] P_DATA,
    input  wire       Data_Valid,
    input  wire       PAR_TYP,
    input  wire       PAR_EN,
    input  wire       Busy,
    output wire       par_bit
);
    reg parity_reg;
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            parity_reg <= 1'b0;
        end else if (Data_Valid && !Busy && PAR_EN) begin
            if (PAR_TYP == 1'b0) parity_reg <= ^P_DATA;      // Even Parity
            else                 parity_reg <= ~(^P_DATA);   // Odd Parity
        end
    end
    assign par_bit = parity_reg;
endmodule
