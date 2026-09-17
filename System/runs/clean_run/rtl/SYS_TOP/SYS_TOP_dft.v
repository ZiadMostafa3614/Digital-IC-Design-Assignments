module SYS_TOP_dft (
    input  wire REF_CLK,
    input  wire UART_CLK,
    input  wire RST,
    input  wire RX_IN,
    // DFT Scan Ports
    input  wire SI,
    input  wire SE,
    input  wire scan_clk,
    input  wire scan_rst,
    input  wire test_mode,
    output wire SO,
    // System Outputs
    output wire TX_OUT,
    output wire PAR_ERR,
    output wire STP_ERR
);

    // Default SO tie-off prior to DFT scan insertion
    assign SO = 1'b0;

    // Clock and Reset Muxing for DFT
    wire ref_clk_mux;
    wire uart_clk_mux;
    wire rst_mux;

    assign ref_clk_mux  = test_mode ? scan_clk : REF_CLK;
    assign uart_clk_mux = test_mode ? scan_clk : UART_CLK;
    assign rst_mux      = test_mode ? scan_rst : RST;

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

    // SYS_CTRL Signals
    wire [7:0] tx_p_data_fifo;
    wire       tx_d_vld_fifo;
    wire       clk_div_en;

    // Clock Divider Output
    wire tx_clk;
    wire tx_clk_mux;

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
        .CLK(ref_clk_mux),
        .RST(rst_mux),
        .SYNC_RST(rst_sync_1)
    );

    RST_SYNC u_rst_sync_2 (
        .CLK(uart_clk_mux),
        .RST(rst_mux),
        .SYNC_RST(rst_sync_2)
    );

    // ------------------------------------------------------------------------
    // 2. Clock Gating Cell
    // ------------------------------------------------------------------------
    CLK_GATE u_clk_gate (
        .CLK(ref_clk_mux),
        .CLK_EN(clk_gate_en),
        .GATED_CLK(gated_clk)
    );

    // ------------------------------------------------------------------------
    // 3. Register File
    // ------------------------------------------------------------------------
    RegFile #(
        .ADDR_WIDTH(4),
        .DATA_WIDTH(8)
    ) u_reg_file (
        .CLK(ref_clk_mux),
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
    // 4. ALU Module
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
    // 5. UART RX Module
    // ------------------------------------------------------------------------
    UART_RX u_uart_rx (
        .CLK(uart_clk_mux),
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
    // 6. Data Synchronizer
    // ------------------------------------------------------------------------
    DATA_SYNC #(
        .BUS_WIDTH(8)
    ) u_data_sync (
        .dest_clk(ref_clk_mux),
        .dest_rst(rst_sync_1),
        .unsync_bus(rx_p_data_unsync),
        .bus_enable(rx_d_vld_unsync),
        .sync_bus(rx_p_data_sync),
        .enable_pulse_d(rx_d_vld_sync)
    );

    // ------------------------------------------------------------------------
    // 7. System Controller
    // ------------------------------------------------------------------------
    SYS_CTRL u_sys_ctrl (
        .CLK(ref_clk_mux),
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
    // 8. Clock Divider
    // ------------------------------------------------------------------------
    clk_div u_clk_div (
        .i_ref_clk(uart_clk_mux),
        .i_rst_n(rst_sync_2),
        .i_clk_en(clk_div_en),
        .i_div_ratio(reg3_div_ratio),
        .o_div_clk(tx_clk)
    );

    assign tx_clk_mux = test_mode ? scan_clk : tx_clk;

    // ------------------------------------------------------------------------
    // 9. Asynchronous FIFO
    // ------------------------------------------------------------------------
    ASYNC_FIFO #(
        .DATA_WIDTH(8),
        .ADDR_WIDTH(3)
    ) u_async_fifo (
        .W_CLK(ref_clk_mux),
        .W_RST(rst_sync_1),
        .W_INC(tx_d_vld_fifo),
        .R_CLK(tx_clk_mux),
        .R_RST(rst_sync_2),
        .R_INC(fifo_r_inc),
        .WR_DATA(tx_p_data_fifo),
        .RD_DATA(tx_p_data_uart),
        .FULL(fifo_full),
        .EMPTY(fifo_empty)
    );

    // ------------------------------------------------------------------------
    // 10. Pulse Generator
    // ------------------------------------------------------------------------
    PULSE_GEN u_pulse_gen (
        .CLK(tx_clk_mux),
        .RST(rst_sync_2),
        .LVL_SIG(uart_tx_busy),
        .PULSE_SIG(fifo_r_inc)
    );

    // ------------------------------------------------------------------------
    // 11. UART TX Module
    // ------------------------------------------------------------------------
    assign uart_tx_data_valid = ~fifo_empty;

    UART_TX u_uart_tx (
        .CLK(tx_clk_mux),
        .RST(rst_sync_2),
        .PAR_TYP(reg2_uart_config[1]),
        .PAR_EN(reg2_uart_config[0]),
        .P_DATA(tx_p_data_uart),
        .DATA_VALID(uart_tx_data_valid),
        .TX_OUT(TX_OUT),
        .Busy(uart_tx_busy)
    );

endmodule
