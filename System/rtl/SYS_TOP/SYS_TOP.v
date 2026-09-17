module SYS_TOP (
    input  wire REF_CLK,
    input  wire UART_CLK,
    input  wire RST,
    input  wire RX_IN,
    output wire TX_OUT,
    output wire PAR_ERR,
    output wire STP_ERR
);

    // Internal Resets
    wire rst_sync_1;
    wire rst_sync_2;

    // Clock Gating
    wire clk_gate_en;
    wire gated_clk;

    // RegFile Signals
    wire [3:0] address;
    wire       wr_en;
    wire       rd_en;
    wire [7:0] wr_data;
    wire [7:0] rd_data;
    wire       rd_data_valid;
    wire [7:0] operand_a;
    wire [7:0] operand_b;
    wire [7:0] reg2_uart_config;
    wire [7:0] reg3_div_ratio;

    // ALU Signals
    wire [3:0]  alu_fun;
    wire        alu_en;
    wire [15:0] alu_out;
    wire        alu_out_valid;

    // UART RX Signals
    wire [7:0] rx_p_data_unsync;
    wire       rx_d_vld_unsync;
    wire [7:0] rx_p_data_sync;
    wire       rx_d_vld_sync;

    // SYS_CTRL to ASYNC_FIFO Signals
    wire [7:0] tx_p_data_fifo;
    wire       tx_d_vld_fifo;
    wire       clk_div_en;

    // Clock Divider Output
    wire tx_clk;

    // ASYNC_FIFO Signals
    wire [7:0] tx_p_data_uart;
    wire       fifo_full;
    wire       fifo_empty;
    wire       fifo_r_inc;

    // UART TX Signals
    wire uart_tx_busy;
    wire uart_tx_data_valid;

    // ------------------------------------------------------------------------
    // 1. Reset Synchronizers
    // ------------------------------------------------------------------------
    RST_SYNC u_rst_sync_1 (
        .CLK(REF_CLK),
        .RST(RST),
        .SYNC_RST(rst_sync_1)
    );

    RST_SYNC u_rst_sync_2 (
        .CLK(UART_CLK),
        .RST(RST),
        .SYNC_RST(rst_sync_2)
    );

    // ------------------------------------------------------------------------
    // 2. Clock Gating Cell (REF_CLK domain)
    // ------------------------------------------------------------------------
    CLK_GATE u_clk_gate (
        .CLK(REF_CLK),
        .CLK_EN(clk_gate_en),
        .GATED_CLK(gated_clk)
    );

    // ------------------------------------------------------------------------
    // 3. Register File (REF_CLK domain)
    // ------------------------------------------------------------------------
    RegFile #(
        .ADDR_WIDTH(4),
        .DATA_WIDTH(8)
    ) u_reg_file (
        .CLK(REF_CLK),
        .RST(rst_sync_1),
        .Address(address),
        .WrEn(wr_en),
        .RdEn(rd_en),
        .WrData(wr_data),
        .RdData(rd_data),
        .RdData_Valid(rd_data_valid),
        .REG0(operand_a),
        .REG1(operand_b),
        .REG2(reg2_uart_config),
        .REG3(reg3_div_ratio)
    );

    // ------------------------------------------------------------------------
    // 4. ALU Module (REF_CLK domain - Gated Clock)
    // ------------------------------------------------------------------------
    ALU #(
        .OPERAND_WIDTH(8),
        .RESULT_WIDTH(16),
        .FUN_WIDTH(4)
    ) u_alu (
        .CLK(gated_clk),
        .RST(rst_sync_1),
        .A(operand_a),
        .B(operand_b),
        .ALU_FUN(alu_fun),
        .Enable(alu_en),
        .ALU_OUT(alu_out),
        .OUT_VALID(alu_out_valid)
    );

    // ------------------------------------------------------------------------
    // 5. UART RX Module (UART_CLK domain)
    // ------------------------------------------------------------------------
    UART_RX u_uart_rx (
        .CLK(UART_CLK),
        .RST(rst_sync_2),
        .RX_IN(RX_IN),
        .Prescale(reg2_uart_config[7:2]),
        .PAR_EN(reg2_uart_config[0]),
        .PAR_TYP(reg2_uart_config[1]),
        .data_valid(rx_d_vld_unsync),
        .P_DATA(rx_p_data_unsync),
        .parity_error(PAR_ERR),
        .framing_error(STP_ERR)
    );

    // ------------------------------------------------------------------------
    // 6. Data Synchronizer (UART_CLK -> REF_CLK domain)
    // ------------------------------------------------------------------------
    DATA_SYNC #(
        .BUS_WIDTH(8)
    ) u_data_sync (
        .dest_clk(REF_CLK),
        .dest_rst(rst_sync_1),
        .unsync_bus(rx_p_data_unsync),
        .bus_enable(rx_d_vld_unsync),
        .sync_bus(rx_p_data_sync),
        .enable_pulse_d(rx_d_vld_sync)
    );

    // ------------------------------------------------------------------------
    // 7. System Controller (REF_CLK domain)
    // ------------------------------------------------------------------------
    SYS_CTRL u_sys_ctrl (
        .CLK(REF_CLK),
        .RST(rst_sync_1),
        .ALU_OUT(alu_out),
        .OUT_Valid(alu_out_valid),
        .RdData(rd_data),
        .RdData_Valid(rd_data_valid),
        .RX_P_DATA(rx_p_data_sync),
        .RX_D_VLD(rx_d_vld_sync),
        .ALU_FUN(alu_fun),
        .EN(alu_en),
        .CLK_EN(clk_gate_en),
        .Address(address),
        .WrEn(wr_en),
        .RdEn(rd_en),
        .WrData(wr_data),
        .TX_P_DATA(tx_p_data_fifo),
        .TX_D_VLD(tx_d_vld_fifo),
        .clk_div_en(clk_div_en)
    );

    // ------------------------------------------------------------------------
    // 8. Clock Divider (UART_CLK domain)
    // ------------------------------------------------------------------------
    clk_div u_clk_div (
        .i_ref_clk(UART_CLK),
        .i_rst_n(rst_sync_2),
        .i_clk_en(clk_div_en),
        .i_div_ratio(reg3_div_ratio),
        .o_div_clk(tx_clk)
    );

    // ------------------------------------------------------------------------
    // 9. Asynchronous FIFO (REF_CLK write domain -> TX_CLK read domain)
    // ------------------------------------------------------------------------
    ASYNC_FIFO #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(3)
    ) u_async_fifo (
        .W_CLK(REF_CLK),
        .W_RST(rst_sync_1),
        .W_INC(tx_d_vld_fifo),
        .R_CLK(tx_clk),
        .R_RST(rst_sync_2),
        .R_INC(fifo_r_inc),
        .WR_DATA(tx_p_data_fifo),
        .RD_DATA(tx_p_data_uart),
        .FULL(fifo_full),
        .EMPTY(fifo_empty)
    );

    // ------------------------------------------------------------------------
    // 10. Pulse Generator (TX_CLK domain)
    // ------------------------------------------------------------------------
    PULSE_GEN u_pulse_gen (
        .CLK(tx_clk),
        .RST(rst_sync_2),
        .LVL_SIG(uart_tx_busy),
        .PULSE_SIG(fifo_r_inc)
    );

    // ------------------------------------------------------------------------
    // 11. UART TX Module (TX_CLK domain)
    // ------------------------------------------------------------------------
    assign uart_tx_data_valid = ~fifo_empty;

    UART_TX u_uart_tx (
        .CLK(tx_clk),
        .RST(rst_sync_2),
        .PAR_TYP(reg2_uart_config[1]),
        .PAR_EN(reg2_uart_config[0]),
        .P_DATA(tx_p_data_uart),
        .DATA_VALID(uart_tx_data_valid),
        .TX_OUT(TX_OUT),
        .Busy(uart_tx_busy)
    );

endmodule
