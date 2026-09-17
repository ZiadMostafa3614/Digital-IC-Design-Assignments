module UART_TX (
    input  wire       CLK,
    input  wire       RST,
    input  wire       PAR_TYP,
    input  wire       PAR_EN,
    input  wire [7:0] P_DATA,
    input  wire       DATA_VALID,
    output wire       TX_OUT,
    output wire       Busy
);
    wire       ser_done;
    wire       ser_en;
    wire [1:0] mux_sel;
    wire       ser_data;
    wire       par_bit;

    uart_fsm u_fsm (
        .CLK(CLK),
        .RST(RST),
        .Data_Valid(DATA_VALID),
        .ser_done(ser_done),
        .PAR_EN(PAR_EN),
        .ser_en(ser_en),
        .mux_sel(mux_sel),
        .Busy(Busy)
    );

    uart_serializer u_serializer (
        .CLK(CLK),
        .RST(RST),
        .P_DATA(P_DATA),
        .ser_en(ser_en),
        .Data_Valid(DATA_VALID),
        .Busy(Busy),
        .ser_done(ser_done),
        .ser_data(ser_data)
    );

    uart_parity_calc u_parity_calc (
        .CLK(CLK),
        .RST(RST),
        .P_DATA(P_DATA),
        .Data_Valid(DATA_VALID),
        .PAR_TYP(PAR_TYP),
        .PAR_EN(PAR_EN),
        .Busy(Busy),
        .par_bit(par_bit)
    );

    uart_mux u_mux (
        .CLK(CLK),
        .RST(RST),
        .mux_sel(mux_sel),
        .ser_data(ser_data),
        .par_bit(par_bit),
        .TX_OUT(TX_OUT)
    );

endmodule
