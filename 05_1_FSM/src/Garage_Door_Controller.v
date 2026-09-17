`timescale 1ns / 1ps
// ============================================================
//  Module  : Garage_Door_Controller
//  Project : Assignment 5.1 – Automatic Garage Door Controller
//  Date    : 2026-07-22
// ============================================================
module Garage_Door_Controller (
    input  wire CLK,
    input  wire RST,
    input  wire Activate,
    input  wire UP_Max,
    input  wire DN_Max,
    output reg  UP_M,
    output reg  DN_M
);

    // FSM State Encoding
    reg [1:0] current_state, next_state;

    localparam IDLE  = 2'b00;
    localparam Mv_Up = 2'b01;
    localparam Mv_Dn = 2'b10;

    // ── 1. State Register (Sequential) ─────────────────────
    always @(posedge CLK or negedge RST) begin
        if (!RST) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // ── 2. Next State Logic (Combinational) ────────────────
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (Activate && DN_Max && !UP_Max) begin
                    next_state = Mv_Up;
                end else if (Activate && UP_Max && !DN_Max) begin
                    next_state = Mv_Dn;
                end else begin
                    next_state = IDLE;
                end
            end

            Mv_Up: begin
                if (UP_Max) begin
                    next_state = IDLE;
                end else begin
                    next_state = Mv_Up;
                end
            end

            Mv_Dn: begin
                if (DN_Max) begin
                    next_state = IDLE;
                end else begin
                    next_state = Mv_Dn;
                end
            end

            default: next_state = IDLE;
        endcase
    end

    // ── 3. Output Logic (Moore FSM: State Dependent Only) ──
    always @(*) begin
        case (current_state)
            IDLE: begin
                UP_M = 1'b0;
                DN_M = 1'b0;
            end
            Mv_Up: begin
                UP_M = 1'b1;
                DN_M = 1'b0;
            end
            Mv_Dn: begin
                UP_M = 1'b0;
                DN_M = 1'b1;
            end
            default: begin
                UP_M = 1'b0;
                DN_M = 1'b0;
            end
        endcase
    end

endmodule
