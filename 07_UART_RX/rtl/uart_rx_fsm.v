module uart_rx_fsm (
    input  wire       CLK,
    input  wire       RST,
    input  wire       RX_IN,
    input  wire       PAR_EN,
    input  wire [5:0] Prescale,
    input  wire [5:0] edge_cnt,
    input  wire [3:0] bit_cnt,
    input  wire       par_err,
    input  wire       strt_glitch,
    input  wire       stp_err,
    output reg        dat_samp_en,
    output reg        enable,
    output reg        bit_cnt_en,
    output reg        par_chk_en,
    output reg        strt_chk_en,
    output reg        stp_chk_en,
    output reg        deser_en,
    output reg        data_valid,
    output reg        clear_err      // Clears par_err/stp_err after CHK_ERR
);
    // Gray State Encoding
    localparam IDLE    = 3'b000;
    localparam START   = 3'b001;
    localparam DATA    = 3'b011;
    localparam PARITY  = 3'b010;
    localparam STOP    = 3'b110;
    localparam CHK_ERR = 3'b111;

    reg [2:0] current_state, next_state;

    wire edge_done;
    wire bit_done;

    assign edge_done = enable && (edge_cnt == (Prescale - 6'd1));
    assign bit_done  = (bit_cnt == 4'd7) && edge_done;

    // State Registering
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State & Output Logic
    always @(*) begin
        // Default Assignments (Prevents Latches)
        next_state  = current_state;
        enable      = 1'b0;
        dat_samp_en = 1'b0;
        deser_en    = 1'b0;
        bit_cnt_en  = 1'b0;
        strt_chk_en = 1'b0;
        par_chk_en  = 1'b0;
        stp_chk_en  = 1'b0;
        data_valid  = 1'b0;
        clear_err   = 1'b0;

        case (current_state)
            IDLE: begin
                if (!RX_IN) begin
                    next_state = START;
                end
            end

            START: begin
                enable      = 1'b1;
                dat_samp_en = 1'b1;
                
                if (edge_done) begin
                    strt_chk_en = 1'b1;
                    if (!strt_glitch) begin
                        next_state = DATA;
                    end else begin
                        next_state = IDLE;
                    end
                end
            end

            DATA: begin
                enable      = 1'b1;
                dat_samp_en = 1'b1;
                deser_en    = 1'b1;
                bit_cnt_en  = 1'b1;
                if (bit_done) begin
                    if (PAR_EN) begin
                        next_state = PARITY;
                    end else begin
                        next_state = STOP;
                    end
                end
            end

            PARITY: begin
                enable      = 1'b1;
                dat_samp_en = 1'b1;
                if (edge_done) begin
                    par_chk_en = 1'b1;
                    next_state = STOP;
                end
            end

            STOP: begin
                enable      = 1'b1;
                dat_samp_en = 1'b1;
                if (edge_done) begin
                    stp_chk_en = 1'b1;
                    next_state = CHK_ERR;
                end
            end

            CHK_ERR: begin
                if (!par_err && !stp_err) begin
                    data_valid = 1'b1;
                end
                clear_err  = 1'b1;  // Always clear errors after checking
                
                // Back-to-Back: start next frame immediately if valid
                if (!RX_IN && !par_err && !stp_err) begin
                    next_state = START;
                end else begin
                    next_state = IDLE;
                end
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule
