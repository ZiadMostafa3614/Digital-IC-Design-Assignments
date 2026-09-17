`timescale 1ns/1ps

module TB_ALU_TOP;

    parameter DATA_WIDTH     = 16;
    parameter OUT_DATA_WIDTH = 2 * DATA_WIDTH;

    reg                          CLK;
    reg                          RST;
    reg  signed [DATA_WIDTH-1:0] A_TB;
    reg  signed [DATA_WIDTH-1:0] B_TB;
    reg  [3:0]                   ALU_FUNC_TB;

    wire signed [OUT_DATA_WIDTH-1:0] Arith_OUT;
    wire                         Arith_Flag;
    wire [DATA_WIDTH-1:0]        Logic_OUT;
    wire                         Logic_Flag;
    wire signed [DATA_WIDTH-1:0] CMP_OUT;
    wire                         CMP_Flag;
    wire [DATA_WIDTH-1:0]        SHIFT_OUT;
    wire                         SHIFT_Flag;

    integer pass_count = 0;
    integer fail_count = 0;

    ALU_TOP #(.DATA_WIDTH(DATA_WIDTH), .OUT_DATA_WIDTH(OUT_DATA_WIDTH)) DUT (
        .CLK        (CLK),
        .RST        (RST),
        .A          (A_TB),
        .B          (B_TB),
        .ALU_FUNC   (ALU_FUNC_TB),
        .Arith_OUT  (Arith_OUT),
        .Arith_Flag (Arith_Flag),
        .Logic_OUT  (Logic_OUT),
        .Logic_Flag (Logic_Flag),
        .CMP_OUT    (CMP_OUT),
        .CMP_Flag   (CMP_Flag),
        .SHIFT_OUT  (SHIFT_OUT),
        .SHIFT_Flag (SHIFT_Flag)
    );

    //*******************************************************
    // Clock: 100 KHz  -> period = 10000 ns
    // 40% low (4000 ns) / 60% high (6000 ns)
    //*******************************************************
    initial CLK = 1'b0;
    always begin
        #4000 CLK = 1'b1;   // 40% low completed, go high
        #6000 CLK = 1'b0;   // 60% high completed, go low
    end

    //*******************************************************
    // Test task: drives inputs, waits one clock edge for the
    // registered output to update, then checks result + flag
    //*******************************************************
    task run_test;
        input [8*40:1]                  test_name;
        input signed [DATA_WIDTH-1:0]   a_val;
        input signed [DATA_WIDTH-1:0]   b_val;
        input [3:0]                     func;
        input signed [OUT_DATA_WIDTH-1:0] exp_out;
        input                           exp_flag;
        reg signed [OUT_DATA_WIDTH-1:0] actual_out;
        reg                             actual_flag;
        begin
            A_TB        = a_val;
            B_TB        = b_val;
            ALU_FUNC_TB = func;

            @(posedge CLK);
            #1; // allow registered outputs to settle

            case (func[3:2])
                2'b00: begin actual_out = Arith_OUT;           actual_flag = Arith_Flag; end
                2'b01: begin actual_out = $signed(Logic_OUT);  actual_flag = Logic_Flag; end
                2'b10: begin actual_out = $signed(CMP_OUT);    actual_flag = CMP_Flag;  end
                2'b11: begin actual_out = $signed(SHIFT_OUT);  actual_flag = SHIFT_Flag; end
                default: begin actual_out = {OUT_DATA_WIDTH{1'b0}}; actual_flag = 1'b0; end
            endcase

            if (actual_out === exp_out && actual_flag === exp_flag) begin
                $display("PASS | %0s | A=%0d B=%0d FUNC=%b -> OUT=%0d FLAG=%b",
                          test_name, a_val, b_val, func, actual_out, actual_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL | %0s | A=%0d B=%0d FUNC=%b -> OUT=%0d (exp %0d) FLAG=%b (exp %b)",
                          test_name, a_val, b_val, func, actual_out, exp_out, actual_flag, exp_flag);
                fail_count = fail_count + 1;
            end
        end
    endtask

    initial begin
        $display("=========================================================");
        $display(" ALU_TOP Testbench - 28 Test Cases");
        $display("=========================================================");

        RST         = 1'b0;   // assert active-low reset
        A_TB        = 0;
        B_TB        = 0;
        ALU_FUNC_TB = 4'b0000;
        #100;
        RST = 1'b1;           // release reset
        @(posedge CLK);

        //---------------------------------------------------
        // Signed Arithmetic Addition (ALU_FUNC = 0000)
        //---------------------------------------------------
        run_test("ADD_NEG_NEG",  -16'sd4, -16'sd10, 4'b0000, -32'sd14, 1'b1);
        run_test("ADD_POS_NEG",   16'sd10, -16'sd4, 4'b0000,  32'sd6,  1'b1);
        run_test("ADD_NEG_POS",  -16'sd10,  16'sd4, 4'b0000, -32'sd6,  1'b1);
        run_test("ADD_POS_POS",   16'sd10,  16'sd4, 4'b0000,  32'sd14, 1'b1);

        //---------------------------------------------------
        // Signed Arithmetic Subtraction (ALU_FUNC = 0001)
        //---------------------------------------------------
        run_test("SUB_NEG_NEG",  -16'sd4, -16'sd10, 4'b0001,  32'sd6,  1'b1);
        run_test("SUB_POS_NEG",   16'sd10, -16'sd4, 4'b0001,  32'sd14, 1'b1);
        run_test("SUB_NEG_POS",  -16'sd10,  16'sd4, 4'b0001, -32'sd14, 1'b1);
        run_test("SUB_POS_POS",   16'sd10,  16'sd4, 4'b0001,  32'sd6,  1'b1);

        //---------------------------------------------------
        // Signed Arithmetic Multiplication (ALU_FUNC = 0010)
        //---------------------------------------------------
        run_test("MUL_NEG_NEG",  -16'sd4, -16'sd3, 4'b0010,  32'sd12, 1'b1);
        run_test("MUL_POS_NEG",   16'sd4, -16'sd3, 4'b0010, -32'sd12, 1'b1);
        run_test("MUL_NEG_POS",  -16'sd4,  16'sd3, 4'b0010, -32'sd12, 1'b1);
        run_test("MUL_POS_POS",   16'sd4,  16'sd3, 4'b0010,  32'sd12, 1'b1);

        //---------------------------------------------------
        // Signed Arithmetic Division (ALU_FUNC = 0011)
        //---------------------------------------------------
        run_test("DIV_NEG_NEG", -16'sd12, -16'sd3, 4'b0011,  32'sd4,  1'b1);
        run_test("DIV_POS_NEG",  16'sd12, -16'sd3, 4'b0011, -32'sd4,  1'b1);
        run_test("DIV_NEG_POS", -16'sd12,  16'sd3, 4'b0011, -32'sd4,  1'b1);
        run_test("DIV_POS_POS",  16'sd12,  16'sd3, 4'b0011,  32'sd4,  1'b1);

        //---------------------------------------------------
        // Logical Operations: A = 12 (1100), B = 10 (1010)
        //---------------------------------------------------
        run_test("LOGIC_AND",  16'sd12, 16'sd10, 4'b0100,  32'sd8,  1'b1); // 1100 & 1010 = 1000 = 8
        run_test("LOGIC_OR",   16'sd12, 16'sd10, 4'b0101,  32'sd14, 1'b1); // 1100 | 1010 = 1110 = 14
        run_test("LOGIC_NAND", 16'sd12, 16'sd10, 4'b0110, -32'sd9,  1'b1); // ~1000 -> 0xFFF7 = -9
        run_test("LOGIC_NOR",  16'sd12, 16'sd10, 4'b0111, -32'sd15, 1'b1); // ~1110 -> 0xFFF1 = -15

        //---------------------------------------------------
        // NOP (ALU_FUNC = 1000)
        //---------------------------------------------------
        run_test("NOP", 16'sd0, 16'sd0, 4'b1000, 32'sd0, 1'b1);

        //---------------------------------------------------
        // Compare Operations
        //---------------------------------------------------
        run_test("CMP_EQUAL",   16'sd5, 16'sd5, 4'b1001, 32'sd1, 1'b1); // A=B
        run_test("CMP_GREATER", 16'sd8, 16'sd3, 4'b1010, 32'sd2, 1'b1); // A>B
        run_test("CMP_LESS",    16'sd3, 16'sd8, 4'b1011, 32'sd3, 1'b1); // A<B

        //---------------------------------------------------
        // Shift Operations
        //---------------------------------------------------
        run_test("SHIFT_A_RIGHT", 16'sd16, 16'sd0,  4'b1100, 32'sd8,  1'b1);
        run_test("SHIFT_A_LEFT",  16'sd16, 16'sd0,  4'b1101, 32'sd32, 1'b1);
        run_test("SHIFT_B_RIGHT", 16'sd0,  16'sd16, 4'b1110, 32'sd8,  1'b1);
        run_test("SHIFT_B_LEFT",  16'sd0,  16'sd16, 4'b1111, 32'sd32, 1'b1);

        $display("=========================================================");
        $display(" RESULTS: %0d PASSED, %0d FAILED (out of 28)", pass_count, fail_count);
        $display("=========================================================");

        #100;
        $finish;
    end

endmodule
