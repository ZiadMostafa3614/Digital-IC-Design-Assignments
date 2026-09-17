module UART_RX (
    input  wire       CLK,
    input  wire       RST,
    input  wire       PAR_TYP,
    input  wire       PAR_EN,
    input  wire [5:0] Prescale,
    input  wire       RX_IN,
    output wire [7:0] P_DATA,
    output wire       data_valid,
    output wire       Parity_Error,
    output wire       Stop_Error
);
    // Internal Wires matching System Block Diagram
    wire       dat_samp_en;
    wire       enable;
    wire       bit_cnt_en;
    wire       deser_en;
    wire       strt_chk_en;
    wire       strt_glitch;
    wire       par_chk_en;
    wire       par_err;
    wire       stp_chk_en;
    wire       stp_err;
    wire       sampled_bit;
    wire       clear_err;       // Clears par_err/stp_err after CHK_ERR state
    wire [5:0] edge_cnt;
    wire [3:0] bit_cnt;

    // Top-Level Error Outputs
    assign Parity_Error = par_err;
    assign Stop_Error   = stp_err;

    // 1. FSM Block
    uart_rx_fsm u_fsm (
        .CLK(CLK),
        .RST(RST),
        .RX_IN(RX_IN),
        .PAR_EN(PAR_EN),
        .Prescale(Prescale),
        .edge_cnt(edge_cnt),
        .bit_cnt(bit_cnt),
        .par_err(par_err),
        .strt_glitch(strt_glitch),
        .stp_err(stp_err),
        .dat_samp_en(dat_samp_en),
        .enable(enable),
        .bit_cnt_en(bit_cnt_en),
        .par_chk_en(par_chk_en),
        .strt_chk_en(strt_chk_en),
        .stp_chk_en(stp_chk_en),
        .deser_en(deser_en),
        .data_valid(data_valid),
        .clear_err(clear_err)
    );

    // 2. Data Sampling Block
    data_sampling u_data_sampling (
        .CLK(CLK),
        .RST(RST),
        .RX_IN(RX_IN),
        .Prescale(Prescale),
        .dat_samp_en(dat_samp_en),
        .edge_cnt(edge_cnt),
        .sampled_bit(sampled_bit)
    );

    // 3. Edge and Bit Counter Block
    edge_bit_counter u_edge_bit_counter (
        .CLK(CLK),
        .RST(RST),
        .enable(enable),
        .bit_cnt_en(bit_cnt_en),
        .Prescale(Prescale),
        .edge_cnt(edge_cnt),
        .bit_cnt(bit_cnt)
    );

    // 4. Deserializer Block
    deserializer u_deserializer (
        .CLK(CLK),
        .RST(RST),
        .deser_en(deser_en),
        .Prescale(Prescale),
        .edge_cnt(edge_cnt),
        .sampled_bit(sampled_bit),
        .P_DATA(P_DATA)
    );

    // 5. Start Check Block
    strt_check u_strt_check (
        .CLK(CLK),
        .RST(RST),
        .strt_chk_en(strt_chk_en),
        .sampled_bit(sampled_bit),
        .strt_glitch(strt_glitch)
    );

    // 6. Parity Check Block
    parity_check u_parity_check (
        .CLK(CLK),
        .RST(RST),
        .par_chk_en(par_chk_en),
        .clear_err(clear_err),
        .PAR_TYP(PAR_TYP),
        .sampled_bit(sampled_bit),
        .P_DATA(P_DATA),
        .par_err(par_err)
    );

    // 7. Stop Check Block
    stp_check u_stp_check (
        .CLK(CLK),
        .RST(RST),
        .stp_chk_en(stp_chk_en),
        .clear_err(clear_err),
        .sampled_bit(sampled_bit),
        .stp_err(stp_err)
    );

endmodule
