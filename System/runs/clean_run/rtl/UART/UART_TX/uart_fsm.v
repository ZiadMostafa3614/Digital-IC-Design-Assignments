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

    localparam IDLE  = 3'b000;
    localparam START = 3'b001;
    localparam DATA  = 3'b010;
    localparam PAR   = 3'b011;
    localparam STOP  = 3'b100;

    reg [2:0] current_state, next_state;

    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;
        ser_en     = 1'b0;
        mux_sel    = 2'b01; // Default: Stop/Idle line HIGH
        Busy       = 1'b0;

        case (current_state)
            IDLE: begin
                ser_en  = 1'b0;
                mux_sel = 2'b01;
                Busy    = 1'b0;

                if (Data_Valid)
                    next_state = START;
                else
                    next_state = IDLE;
            end

            START: begin
                ser_en  = 1'b0;
                mux_sel = 2'b00; // Start bit LOW
                Busy    = 1'b1;

                next_state = DATA;
            end

            DATA: begin
                ser_en  = 1'b1;
                mux_sel = 2'b10; // Data bits
                Busy    = 1'b1;

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
                ser_en  = 1'b0;
                mux_sel = 2'b11; // Parity bit
                Busy    = 1'b1;

                next_state = STOP;
            end

            STOP: begin
                ser_en  = 1'b0;
                mux_sel = 2'b01; // Stop bit HIGH
                Busy    = 1'b1;

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
