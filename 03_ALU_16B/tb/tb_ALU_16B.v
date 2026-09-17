// ============================================================
//  Testbench : tb_ALU_16B
//  Project   : Assignment 3 – 16-bit ALU
//  Clock     : 100 KHz  →  period = 10 µs
//  Date      : 2026-07-08
// ============================================================
`timescale 1us/1ns          // time unit = 1 µs, precision = 1 ns

module tb_ALU_16B;

    // ── DUT Ports ──────────────────────────────────────────
    reg         CLK;
    reg  [15:0] A, B;
    reg  [ 3:0] ALU_FUN;

    wire [15:0] ALU_OUT;
    wire        Carry_Flag;
    wire        Arith_Flag;
    wire        Logic_Flag;
    wire        CMP_Flag;
    wire        Shift_Flag;

    // ── Instantiate DUT ────────────────────────────────────
    ALU_16B DUT (
        .CLK       (CLK),
        .A         (A),
        .B         (B),
        .ALU_FUN   (ALU_FUN),
        .ALU_OUT   (ALU_OUT),
        .Carry_Flag(Carry_Flag),
        .Arith_Flag(Arith_Flag),
        .Logic_Flag(Logic_Flag),
        .CMP_Flag  (CMP_Flag),
        .Shift_Flag(Shift_Flag)
    );

    // ── Clock Generation : 100 KHz → T = 10 µs ────────────
    initial CLK = 1'b0;
    always #5 CLK = ~CLK;   // toggle every 5 µs → 10 µs period

    // ── Helper task: apply inputs and print result ─────────
    task apply;
        input [15:0] in_A, in_B;
        input [ 3:0] fun;
        input [63:0] description_id; // unused – just for readability
        begin
            A       = in_A;
            B       = in_B;
            ALU_FUN = fun;
            @(posedge CLK);          // wait for rising edge to register
            #1;                      // small settling delay after edge
            $display("TC%0d | FUN=%b | A=%0d B=%0d | OUT=%0d | Cy=%b Ar=%b Lo=%b CM=%b Sh=%b",
                     description_id, fun, in_A, in_B,
                     ALU_OUT, Carry_Flag, Arith_Flag,
                     Logic_Flag, CMP_Flag, Shift_Flag);
        end
    endtask

    // ── Stimulus ───────────────────────────────────────────
    initial begin
        $display("====  16-bit ALU Testbench  ====");
        $display("Clock: 100 KHz  (period = 10 us)");
        $display("------------------------------------------------");

        A = 0; B = 0; ALU_FUN = 4'b1111;

        // Wait a couple of half-cycles before starting
        @(posedge CLK); #1;

        // ── TC 1: Addition (no carry) ──────────────────────
        apply(16'd100,  16'd200,  4'b0000, 1);
        // ── TC 2: Addition (with carry) ──────────────────────
        apply(16'hFFFF, 16'd1,    4'b0000, 2);
        // ── TC 3: Subtraction (no borrow) ─────────────────
        apply(16'd500,  16'd200,  4'b0001, 3);
        // ── TC 4: Subtraction (with borrow) ───────────────
        apply(16'd10,   16'd20,   4'b0001, 4);
        // ── TC 5: Multiplication ───────────────────────────
        apply(16'd15,   16'd4,    4'b0010, 5);
        // ── TC 6: Division ─────────────────────────────────
        apply(16'd100,  16'd4,    4'b0011, 6);

        // ── TC 7: AND ──────────────────────────────────────
        apply(16'hFF00, 16'h0FF0, 4'b0100, 7);
        // ── TC 8: NAND ─────────────────────────────────────
        apply(16'hFF00, 16'h0FF0, 4'b0110, 8);
        // ── TC 9: OR ───────────────────────────────────────
        apply(16'hAA55, 16'h55AA, 4'b0101, 9);
        // ── TC 10: NOR ─────────────────────────────────────
        apply(16'hAA55, 16'h55AA, 4'b0111, 10);

        // ── TC 11: CMP Equal ───────────────────────────────
        apply(16'd42,   16'd42,   4'b1010, 11);
        // ── TC 12: CMP Greater ─────────────────────────────
        apply(16'd100,  16'd50,   4'b1011, 12);
        // ── TC 13: CMP Less ────────────────────────────────
        apply(16'd5,    16'd99,   4'b1100, 13);

        // ── TC 14: Shift Right A ───────────────────────────
        apply(16'b1010_1010_1010_1010, 16'd0, 4'b1101, 14);
        // ── TC 15: Shift Left A ────────────────────────────
        apply(16'b0101_0101_0101_0101, 16'd0, 4'b1110, 15);

        // ── TC 16: NOP (undefined ALU_FUN) ─────────────────
        apply(16'd1234, 16'd5678, 4'b1111, 16);

        $display("------------------------------------------------");
        $display("Simulation complete.");
        $finish;
    end

    // ── Optional: waveform dump (uncomment for ModelSim) ──
    // initial begin
    //     $dumpfile("ALU_wave.vcd");
    //     $dumpvars(0, tb_ALU_16B);
    // end

endmodule
