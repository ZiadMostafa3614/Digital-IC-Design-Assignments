// ============================================================================
// Module Name  : UART_TX (Top Module with DFT Scan Ports & Clock/Reset Muxing)
// Description  : Top-level UART Transmitter prepared for DFT scan insertion.
// Inputs       : CLK, RST, PAR_TYP, PAR_EN, P_DATA, DATA_VALID
//                SI, SE, scan_clk, scan_rst, test_mode (DFT Ports)
// Outputs      : TX_OUT, Busy, SO
// ============================================================================

module UART_TX (
    input  wire       CLK,
    input  wire       RST,
    input  wire       PAR_TYP,
    input  wire       PAR_EN,
    input  wire [7:0] P_DATA,
    input  wire       DATA_VALID,
    // DFT Scan Ports
    input  wire       SI,
    input  wire       SE,
    input  wire       scan_clk,
    input  wire       scan_rst,
    input  wire       test_mode,
    output wire       SO,
    // Functional Outputs
    output wire       TX_OUT,
    output wire       Busy
);
    wire       ser_done;
    wire       ser_en;
    wire [1:0] mux_sel;
    wire       ser_data;
    wire       par_bit;

    // Clock and Reset Muxing for DFT Scan Testing
    wire clk_mux;
    wire rst_mux;

    assign clk_mux = test_mode ? scan_clk : CLK;
    assign rst_mux = test_mode ? scan_rst : RST;

    // Default connection for SO before DFT scan chain insertion
    assign SO = 1'b0;

    uart_fsm u_fsm (
        .CLK(clk_mux),
        .RST(rst_mux),
        .Data_Valid(DATA_VALID),
        .ser_done(ser_done),
        .PAR_EN(PAR_EN),
        .ser_en(ser_en),
        .mux_sel(mux_sel),
        .Busy(Busy)
    );

    uart_serializer u_serializer (
        .CLK(clk_mux),
        .RST(rst_mux),
        .P_DATA(P_DATA),
        .ser_en(ser_en),
        .Data_Valid(DATA_VALID),
        .Busy(Busy),
        .ser_done(ser_done),
        .ser_data(ser_data)
    );

    uart_parity_calc u_parity_calc (
        .CLK(clk_mux),
        .RST(rst_mux),
        .P_DATA(P_DATA),
        .Data_Valid(DATA_VALID),
        .PAR_TYP(PAR_TYP),
        .PAR_EN(PAR_EN),
        .Busy(Busy),
        .par_bit(par_bit)
    );

    uart_mux u_mux (
        .CLK(clk_mux),
        .RST(rst_mux),
        .mux_sel(mux_sel),
        .ser_data(ser_data),
        .par_bit(par_bit),
        .TX_OUT(TX_OUT)
    );

endmodule
