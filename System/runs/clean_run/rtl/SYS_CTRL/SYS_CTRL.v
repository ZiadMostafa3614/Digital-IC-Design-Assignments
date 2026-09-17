module SYS_CTRL (
    input  wire        CLK,
    input  wire        RST,
    input  wire [15:0] ALU_OUT,
    input  wire        OUT_Valid,
    input  wire [7:0]  RdData,
    input  wire        RdData_Valid,
    input  wire [7:0]  RX_P_DATA,
    input  wire        RX_D_VLD,
    output reg  [3:0]  ALU_FUN,
    output reg         EN,
    output reg         CLK_EN,
    output reg  [3:0]  Address,
    output reg         WrEn,
    output reg         RdEn,
    output reg  [7:0]  WrData,
    output reg  [7:0]  TX_P_DATA,
    output reg         TX_D_VLD,
    output wire        clk_div_en
);

    // Clock divider enable is always high per system spec
    assign clk_div_en = 1'b1;

    // FSM States
    localparam IDLE         = 4'd0;
    localparam WRITE_ADDR   = 4'd1;
    localparam WRITE_DATA   = 4'd2;
    localparam DO_WRITE     = 4'd3;
    localparam READ_ADDR    = 4'd4;
    localparam DO_READ      = 4'd5;
    localparam WAIT_RD_VAL  = 4'd6;
    localparam OP_A         = 4'd7;
    localparam WRITE_OP_A   = 4'd8;
    localparam OP_B         = 4'd9;
    localparam WRITE_OP_B   = 4'd10;
    localparam OP_FUN       = 4'd11;
    localparam NOP_FUN      = 4'd12;
    localparam ALU_EXEC     = 4'd13;
    localparam TX_BYTE1     = 4'd14;
    localparam TX_BYTE2     = 4'd15;

    reg [3:0] current_state, next_state;
    reg       rx_handled;

    // Internal Registers
    reg [3:0]  addr_reg;
    reg [7:0]  wrdata_reg;
    reg [3:0]  alu_fun_reg;
    reg [15:0] alu_result_reg;
    reg [7:0]  rd_data_reg;
    reg        is_alu_op;

    // Pulse filter to ensure exactly one clock cycle trigger per RX_D_VLD pulse
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            rx_handled <= 1'b0;
        end else if (RX_D_VLD) begin
            rx_handled <= 1'b1;
        end else begin
            rx_handled <= 1'b0;
        end
    end

    wire rx_pulse = RX_D_VLD && !rx_handled;

    // State Register
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Sequential Register Updates & Data Storage
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            addr_reg       <= 4'd0;
            wrdata_reg     <= 8'd0;
            alu_fun_reg    <= 4'd0;
            alu_result_reg <= 16'd0;
            rd_data_reg    <= 8'd0;
            is_alu_op      <= 1'b0;
        end else begin
            case (current_state)
                WRITE_ADDR: begin
                    if (rx_pulse)
                        addr_reg <= RX_P_DATA[3:0];
                end

                WRITE_DATA: begin
                    if (rx_pulse)
                        wrdata_reg <= RX_P_DATA;
                end

                READ_ADDR: begin
                    if (rx_pulse) begin
                        addr_reg  <= RX_P_DATA[3:0];
                        is_alu_op <= 1'b0;
                    end
                end

                WAIT_RD_VAL: begin
                    if (RdData_Valid)
                        rd_data_reg <= RdData;
                end

                OP_A: begin
                    if (rx_pulse)
                        wrdata_reg <= RX_P_DATA;
                end

                OP_B: begin
                    if (rx_pulse)
                        wrdata_reg <= RX_P_DATA;
                end

                OP_FUN: begin
                    if (rx_pulse) begin
                        alu_fun_reg <= RX_P_DATA[3:0];
                        is_alu_op   <= 1'b1;
                    end
                end

                NOP_FUN: begin
                    if (rx_pulse) begin
                        alu_fun_reg <= RX_P_DATA[3:0];
                        is_alu_op   <= 1'b1;
                    end
                end

                ALU_EXEC: begin
                    if (OUT_Valid) begin
                        alu_result_reg <= ALU_OUT;
                        $display("[DEBUG_SYS_CTRL] Captured ALU_OUT = 0x%04h (%0d) at time %0t", ALU_OUT, ALU_OUT, $time);
                    end
                end
            endcase
        end
    end

    // Next State & Output Logic (Combinational)
    always @(*) begin
        next_state = current_state;
        ALU_FUN   = alu_fun_reg;
        EN        = 1'b0;
        CLK_EN    = 1'b0;
        Address   = addr_reg;
        WrEn      = 1'b0;
        RdEn      = 1'b0;
        WrData    = wrdata_reg;
        TX_P_DATA = 8'd0;
        TX_D_VLD  = 1'b0;

        case (current_state)
            IDLE: begin
                if (rx_pulse) begin
                    case (RX_P_DATA)
                        8'hAA: next_state = WRITE_ADDR;
                        8'hBB: next_state = READ_ADDR;
                        8'hCC: next_state = OP_A;
                        8'hDD: next_state = NOP_FUN;
                        default: next_state = IDLE;
                    endcase
                end
            end

            WRITE_ADDR: begin
                if (rx_pulse)
                    next_state = WRITE_DATA;
            end

            WRITE_DATA: begin
                if (rx_pulse)
                    next_state = DO_WRITE;
            end

            DO_WRITE: begin
                WrEn      = 1'b1;
                Address   = addr_reg;
                WrData    = wrdata_reg;
                next_state = IDLE;
            end

            READ_ADDR: begin
                if (rx_pulse)
                    next_state = DO_READ;
            end

            DO_READ: begin
                RdEn      = 1'b1;
                Address   = addr_reg;
                next_state = WAIT_RD_VAL;
            end

            WAIT_RD_VAL: begin
                RdEn    = 1'b1;
                Address = addr_reg;
                if (RdData_Valid)
                    next_state = TX_BYTE1;
            end

            OP_A: begin
                if (rx_pulse)
                    next_state = WRITE_OP_A;
            end

            WRITE_OP_A: begin
                WrEn      = 1'b1;
                Address   = 4'h0; // REG0
                WrData    = wrdata_reg;
                next_state = OP_B;
            end

            OP_B: begin
                if (rx_pulse)
                    next_state = WRITE_OP_B;
            end

            WRITE_OP_B: begin
                WrEn      = 1'b1;
                Address   = 4'h1; // REG1
                WrData    = wrdata_reg;
                next_state = OP_FUN;
            end

            OP_FUN: begin
                if (rx_pulse)
                    next_state = ALU_EXEC;
            end

            NOP_FUN: begin
                if (rx_pulse)
                    next_state = ALU_EXEC;
            end

            ALU_EXEC: begin
                CLK_EN  = 1'b1;
                EN      = 1'b1;
                ALU_FUN = alu_fun_reg;
                if (OUT_Valid)
                    next_state = TX_BYTE1;
            end

            TX_BYTE1: begin
                TX_D_VLD  = 1'b1;
                if (is_alu_op) begin
                    TX_P_DATA  = alu_result_reg[7:0];
                    next_state = TX_BYTE2;
                end else begin
                    TX_P_DATA  = rd_data_reg;
                    next_state = IDLE;
                end
            end

            TX_BYTE2: begin
                TX_D_VLD   = 1'b1;
                TX_P_DATA  = alu_result_reg[15:8];
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule
