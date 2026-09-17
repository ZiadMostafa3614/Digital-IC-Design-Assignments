// ============================================================================
// Module Name  : uart_fsm
// Description  : FSM controller for UART Transmitter (UART_TX)
// Outputs      : ser_en  - Serializer shift enable
//                mux_sel - MUX select (00: Start, 01: Stop/Idle, 10: Data, 11: Parity)
//                Busy    - High from START bit until STOP bit, low in IDLE state.
// ============================================================================

module uart_fsm (
    input  wire       CLK,
    input  wire       RST,
    input  wire       Data_Valid,
    input  wire       ser_done,
    input  wire       PAR_EN,
    output reg        ser_en,
    output reg  [1:0] mux_sel,
    output reg        Busy
);

    // State Encoding
    localparam IDLE  = 3'b000;
    localparam START = 3'b001;
    localparam DATA  = 3'b010;
    localparam PAR   = 3'b011;
    localparam STOP  = 3'b100;

    reg [2:0] current_state, next_state;

    // ------------------------------------------------------------------------
    // 1. State Register (Sequential)
    // ------------------------------------------------------------------------
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // ------------------------------------------------------------------------
    // 2. Next State & Output Logic (Combinational)
    //    All outputs are assigned directly inside each state block.
    // ------------------------------------------------------------------------
    always @(*) begin
        // Default Assignments to prevent latch inference
        next_state = current_state;
        ser_en     = 1'b0;
        mux_sel    = 2'b01; // Default: Stop/Idle line HIGH
        Busy       = 1'b0;  // Default: Not Busy

        case (current_state)
            IDLE: begin
                ser_en  = 1'b0;
                mux_sel = 2'b01; // Idle line is HIGH
                Busy    = 1'b0;  // Busy is LOW in IDLE state

                if (Data_Valid)
                    next_state = START;
                else
                    next_state = IDLE;
            end

            START: begin
                ser_en  = 1'b0;  // Hold data in serializer during start bit
                mux_sel = 2'b00; // Drive Start bit (LOW)
                Busy    = 1'b1;  // Busy HIGH starting from START bit

                next_state = DATA;
            end

            DATA: begin
                ser_en  = 1'b1;  // Enable serializer shifting
                mux_sel = 2'b10; // Drive serial data bits
                Busy    = 1'b1;  // Busy HIGH

                if (ser_done) begin
                    if (PAR_EN)
                        next_state = PAR;
                    else
                        next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end

            PAR: begin
                ser_en  = 1'b0;  // Disable shifting
                mux_sel = 2'b11; // Drive Parity bit
                Busy    = 1'b1;  // Busy HIGH

                next_state = STOP;
            end

            STOP: begin
                ser_en  = 1'b0;  // Disable shifting
                mux_sel = 2'b01; // Drive Stop bit (HIGH)
                Busy    = 1'b1;  // Busy stays HIGH throughout STOP bit

                if (Data_Valid)
                    next_state = START;
                else
                    next_state = IDLE;
            end

            default: begin
                ser_en     = 1'b0;
                mux_sel    = 2'b01;
                Busy       = 1'b0;
                next_state = IDLE;
            end
        endcase
    end

endmodule
