module alu8_top #( parameter Adder_0_Mult_1 = 0) 
(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        en,    
    input  wire [7:0]  a,
    input  wire [7:0]  b,

    output wire [15:0] result,
    output wire        valid
);

    generate
        if (Adder_0_Mult_1 == 0) 
            begin 
                  //---------------- Adder -----------------
                  wire [7:0] add_sum;
                  wire       add_cout;
                  wire       add_valid;

                  add_unit #( .DATA_WIDTH(8)
                  ) u_add (
                   .clk   (clk),
                   .rst_n (rst_n),
                   .en    (en),
                   .a     (a),
                   .b     (b),
                   .sum   (add_sum),
                   .cout  (add_cout),
                   .valid (add_valid)
                  );

                  assign result = {7'd0, add_cout, add_sum};
                  assign valid  = add_valid;
       end
       else begin
                  //---------------- Multiplier -----------------
                  wire [15:0] mul_product;
                  wire        mul_valid;

                  mult_unit u_mul (
                  .clk     (clk),
                  .rst_n   (rst_n),
                  .en      (en),
                  .a       (a),
                  .b       (b),
                  .product (mul_product),
                  .valid   (mul_valid)
                  );

                  assign result = mul_product;
                  assign valid  = mul_valid;
       end
    endgenerate

endmodule
