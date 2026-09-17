/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06-SP1
// Date      : Tue Sep  1 05:39:25 2026
/////////////////////////////////////////////////////////////


module mult_unit_DW01_add_0 ( A, B, CI, SUM, CO );
  input [15:0] A;
  input [15:0] B;
  output [15:0] SUM;
  input CI;
  output CO;
  wire   n1, n2, n3, n4, n5;
  wire   [15:1] carry;
  assign SUM[1] = B[1];
  assign SUM[0] = B[0];

  ADDFX2M U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  ADDFX2M U1_3 ( .A(A[3]), .B(B[3]), .CI(n1), .CO(carry[4]), .S(SUM[3]) );
  ADDFX2M U1_9 ( .A(A[9]), .B(B[9]), .CI(carry[9]), .CO(carry[10]), .S(SUM[9])
         );
  ADDFX2M U1_8 ( .A(A[8]), .B(B[8]), .CI(carry[8]), .CO(carry[9]), .S(SUM[8])
         );
  ADDFX2M U1_7 ( .A(A[7]), .B(B[7]), .CI(carry[7]), .CO(carry[8]), .S(SUM[7])
         );
  ADDFX2M U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5])
         );
  ADDFX2M U1_10 ( .A(A[10]), .B(B[10]), .CI(carry[10]), .CO(carry[11]), .S(
        SUM[10]) );
  ADDFX2M U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  ADDFX4M U1_14 ( .A(A[14]), .B(B[14]), .CI(carry[14]), .CO(carry[15]), .S(
        SUM[14]) );
  ADDFHX2M U1_11 ( .A(A[11]), .B(B[11]), .CI(carry[11]), .CO(carry[12]), .S(
        SUM[11]) );
  ADDFHX2M U1_12 ( .A(A[12]), .B(B[12]), .CI(carry[12]), .CO(carry[13]), .S(
        SUM[12]) );
  ADDFHX2M U1_13 ( .A(A[13]), .B(B[13]), .CI(carry[13]), .CO(carry[14]), .S(
        SUM[13]) );
  CLKINVX4M U1 ( .A(B[15]), .Y(n3) );
  CLKINVX6M U2 ( .A(B[15]), .Y(n2) );
  AND2X2M U3 ( .A(B[2]), .B(A[2]), .Y(n1) );
  OR2X4M U4 ( .A(n2), .B(carry[15]), .Y(n4) );
  CLKNAND2X8M U5 ( .A(n3), .B(carry[15]), .Y(n5) );
  NAND2X6M U6 ( .A(n4), .B(n5), .Y(SUM[15]) );
  XOR2X1M U7 ( .A(B[2]), .B(A[2]), .Y(SUM[2]) );
endmodule


module mult_unit ( clk, rst_n, en, a, b, product, valid );
  input [7:0] a;
  input [7:0] b;
  output [15:0] product;
  input clk, rst_n, en;
  output valid;
  wire   \pp[0][7] , \pp[0][6] , \pp[0][5] , \pp[0][4] , \pp[0][3] ,
         \pp[0][2] , \pp[0][1] , \pp[1][7] , \pp[1][6] , \pp[1][5] ,
         \pp[1][4] , \pp[1][3] , \pp[1][2] , \pp[1][1] , \pp[1][0] ,
         \pp[2][7] , \pp[2][6] , \pp[2][5] , \pp[2][4] , \pp[2][3] ,
         \pp[2][2] , \pp[2][1] , \pp[3][7] , \pp[3][6] , \pp[3][5] ,
         \pp[3][4] , \pp[3][3] , \pp[3][2] , \pp[3][1] , \pp[3][0] ,
         \pp[4][7] , \pp[4][6] , \pp[4][5] , \pp[4][4] , \pp[4][3] ,
         \pp[4][2] , \pp[4][1] , \pp[5][7] , \pp[5][6] , \pp[5][5] ,
         \pp[5][4] , \pp[5][3] , \pp[5][2] , \pp[5][1] , \pp[5][0] ,
         \pp[6][7] , \pp[6][6] , \pp[6][5] , \pp[6][4] , \pp[6][3] ,
         \pp[6][2] , \pp[6][1] , \pp[6][0] , \pp[7][7] , \pp[7][6] ,
         \pp[7][5] , \pp[7][4] , \pp[7][3] , \pp[7][2] , \pp[7][1] ,
         \pp[7][0] , n18, n19, n20, n21, n22, n24, n25, n26, n27, n28, n29,
         n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43,
         n44, n45, n46, n47, n48, n49,
         \add_1_root_add_0_root_add_135/carry[15] ,
         \add_1_root_add_0_root_add_135/carry[14] ,
         \add_1_root_add_0_root_add_135/carry[13] ,
         \add_1_root_add_0_root_add_135/carry[12] ,
         \add_1_root_add_0_root_add_135/carry[11] ,
         \add_1_root_add_0_root_add_135/carry[10] ,
         \add_1_root_add_0_root_add_135/carry[9] ,
         \add_1_root_add_0_root_add_135/carry[8] ,
         \add_1_root_add_0_root_add_135/carry[7] ,
         \add_1_root_add_0_root_add_135/carry[6] ,
         \add_1_root_add_0_root_add_135/carry[5] ,
         \add_1_root_add_0_root_add_135/SUM[4] ,
         \add_1_root_add_0_root_add_135/SUM[5] ,
         \add_1_root_add_0_root_add_135/SUM[6] ,
         \add_1_root_add_0_root_add_135/SUM[7] ,
         \add_1_root_add_0_root_add_135/SUM[8] ,
         \add_1_root_add_0_root_add_135/SUM[9] ,
         \add_1_root_add_0_root_add_135/SUM[10] ,
         \add_1_root_add_0_root_add_135/SUM[11] ,
         \add_1_root_add_0_root_add_135/SUM[12] ,
         \add_1_root_add_0_root_add_135/SUM[13] ,
         \add_1_root_add_0_root_add_135/SUM[14] ,
         \add_1_root_add_0_root_add_135/SUM[15] ,
         \add_1_root_add_0_root_add_135/B[4] ,
         \add_1_root_add_0_root_add_135/B[5] ,
         \add_1_root_add_0_root_add_135/B[6] ,
         \add_1_root_add_0_root_add_135/B[7] ,
         \add_1_root_add_0_root_add_135/B[8] ,
         \add_1_root_add_0_root_add_135/B[9] ,
         \add_1_root_add_0_root_add_135/B[10] ,
         \add_1_root_add_0_root_add_135/B[11] ,
         \add_1_root_add_0_root_add_135/B[12] ,
         \add_1_root_add_0_root_add_135/B[13] ,
         \add_1_root_add_0_root_add_135/B[14] ,
         \add_1_root_add_0_root_add_135/B[15] ,
         \add_1_root_add_0_root_add_135/A[0] ,
         \add_1_root_add_0_root_add_135/A[1] ,
         \add_1_root_add_0_root_add_135/A[2] ,
         \add_1_root_add_0_root_add_135/A[3] ,
         \add_1_root_add_0_root_add_135/A[4] ,
         \add_1_root_add_0_root_add_135/A[5] ,
         \add_1_root_add_0_root_add_135/A[6] ,
         \add_1_root_add_0_root_add_135/A[7] ,
         \add_1_root_add_0_root_add_135/A[8] ,
         \add_1_root_add_0_root_add_135/A[9] ,
         \add_2_root_add_0_root_add_135/carry[8] ,
         \add_2_root_add_0_root_add_135/carry[9] ,
         \add_2_root_add_0_root_add_135/carry[10] ,
         \add_2_root_add_0_root_add_135/carry[11] ,
         \add_2_root_add_0_root_add_135/carry[12] ,
         \add_2_root_add_0_root_add_135/carry[13] ,
         \add_2_root_add_0_root_add_135/carry[14] ,
         \add_2_root_add_0_root_add_135/B[7] ,
         \add_2_root_add_0_root_add_135/B[8] ,
         \add_2_root_add_0_root_add_135/B[9] ,
         \add_2_root_add_0_root_add_135/B[10] ,
         \add_2_root_add_0_root_add_135/B[11] ,
         \add_2_root_add_0_root_add_135/B[12] ,
         \add_2_root_add_0_root_add_135/B[13] ,
         \add_4_root_add_0_root_add_135/carry[12] ,
         \add_4_root_add_0_root_add_135/carry[11] ,
         \add_4_root_add_0_root_add_135/carry[10] ,
         \add_4_root_add_0_root_add_135/carry[9] ,
         \add_4_root_add_0_root_add_135/carry[8] ,
         \add_4_root_add_0_root_add_135/carry[7] ,
         \add_4_root_add_0_root_add_135/carry[6] ,
         \add_3_root_add_0_root_add_135/carry[13] ,
         \add_3_root_add_0_root_add_135/carry[12] ,
         \add_3_root_add_0_root_add_135/carry[11] ,
         \add_3_root_add_0_root_add_135/carry[10] ,
         \add_3_root_add_0_root_add_135/carry[9] ,
         \add_3_root_add_0_root_add_135/carry[8] ,
         \add_3_root_add_0_root_add_135/carry[7] ,
         \add_3_root_add_0_root_add_135/SUM[6] ,
         \add_3_root_add_0_root_add_135/SUM[7] ,
         \add_3_root_add_0_root_add_135/SUM[8] ,
         \add_3_root_add_0_root_add_135/SUM[9] ,
         \add_3_root_add_0_root_add_135/SUM[10] ,
         \add_3_root_add_0_root_add_135/SUM[11] ,
         \add_3_root_add_0_root_add_135/SUM[12] ,
         \add_3_root_add_0_root_add_135/SUM[13] ,
         \add_3_root_add_0_root_add_135/SUM[14] ,
         \add_3_root_add_0_root_add_135/B[2] ,
         \add_3_root_add_0_root_add_135/B[3] ,
         \add_3_root_add_0_root_add_135/B[4] ,
         \add_3_root_add_0_root_add_135/B[5] ,
         \add_3_root_add_0_root_add_135/B[6] ,
         \add_3_root_add_0_root_add_135/B[7] ,
         \add_3_root_add_0_root_add_135/B[8] ,
         \add_3_root_add_0_root_add_135/B[9] ,
         \add_3_root_add_0_root_add_135/B[10] ,
         \add_3_root_add_0_root_add_135/B[11] ,
         \add_5_root_add_0_root_add_135/carry[10] ,
         \add_5_root_add_0_root_add_135/carry[9] ,
         \add_5_root_add_0_root_add_135/carry[8] ,
         \add_5_root_add_0_root_add_135/carry[7] ,
         \add_5_root_add_0_root_add_135/carry[6] ,
         \add_5_root_add_0_root_add_135/carry[5] ,
         \add_5_root_add_0_root_add_135/carry[4] ,
         \add_6_root_add_0_root_add_135/carry[8] ,
         \add_6_root_add_0_root_add_135/carry[7] ,
         \add_6_root_add_0_root_add_135/carry[6] ,
         \add_6_root_add_0_root_add_135/carry[5] ,
         \add_6_root_add_0_root_add_135/carry[4] ,
         \add_6_root_add_0_root_add_135/carry[3] ,
         \add_6_root_add_0_root_add_135/carry[2] , n1, n2, n3, n4, n5, n6, n7,
         n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n23, n50, n51, n52,
         n53, n54;
  wire   [15:0] level7;

  DFFRHQX8M \product_reg[15]  ( .D(n49), .CK(clk), .RN(rst_n), .Q(product[15])
         );
  DFFRHQX8M \product_reg[14]  ( .D(n48), .CK(clk), .RN(rst_n), .Q(product[14])
         );
  DFFRHQX8M \product_reg[13]  ( .D(n47), .CK(clk), .RN(rst_n), .Q(product[13])
         );
  DFFRHQX8M \product_reg[12]  ( .D(n46), .CK(clk), .RN(rst_n), .Q(product[12])
         );
  DFFRHQX8M \product_reg[11]  ( .D(n45), .CK(clk), .RN(rst_n), .Q(product[11])
         );
  DFFRHQX8M \product_reg[10]  ( .D(n44), .CK(clk), .RN(rst_n), .Q(product[10])
         );
  DFFRHQX8M \product_reg[9]  ( .D(n43), .CK(clk), .RN(rst_n), .Q(product[9])
         );
  DFFRHQX8M \product_reg[8]  ( .D(n42), .CK(clk), .RN(rst_n), .Q(product[8])
         );
  DFFRHQX8M \product_reg[7]  ( .D(n41), .CK(clk), .RN(rst_n), .Q(product[7])
         );
  DFFRHQX8M \product_reg[6]  ( .D(n40), .CK(clk), .RN(rst_n), .Q(product[6])
         );
  DFFRHQX8M \product_reg[5]  ( .D(n39), .CK(clk), .RN(rst_n), .Q(product[5])
         );
  DFFRHQX8M \product_reg[4]  ( .D(n38), .CK(clk), .RN(rst_n), .Q(product[4])
         );
  DFFRHQX8M \product_reg[3]  ( .D(n37), .CK(clk), .RN(rst_n), .Q(product[3])
         );
  DFFRHQX8M \product_reg[2]  ( .D(n36), .CK(clk), .RN(rst_n), .Q(product[2])
         );
  DFFRHQX8M \product_reg[1]  ( .D(n35), .CK(clk), .RN(rst_n), .Q(product[1])
         );
  DFFRHQX8M \product_reg[0]  ( .D(n34), .CK(clk), .RN(rst_n), .Q(product[0])
         );
  mult_unit_DW01_add_0 add_0_root_add_0_root_add_135 ( .A({1'b0, 
        \add_3_root_add_0_root_add_135/SUM[14] , 
        \add_3_root_add_0_root_add_135/SUM[13] , 
        \add_3_root_add_0_root_add_135/SUM[12] , 
        \add_3_root_add_0_root_add_135/SUM[11] , 
        \add_3_root_add_0_root_add_135/SUM[10] , 
        \add_3_root_add_0_root_add_135/SUM[9] , 
        \add_3_root_add_0_root_add_135/SUM[8] , 
        \add_3_root_add_0_root_add_135/SUM[7] , 
        \add_3_root_add_0_root_add_135/SUM[6] , 
        \add_3_root_add_0_root_add_135/B[5] , 
        \add_3_root_add_0_root_add_135/B[4] , 
        \add_3_root_add_0_root_add_135/B[3] , 
        \add_3_root_add_0_root_add_135/B[2] , 1'b0, 1'b0}), .B({
        \add_1_root_add_0_root_add_135/SUM[15] , 
        \add_1_root_add_0_root_add_135/SUM[14] , 
        \add_1_root_add_0_root_add_135/SUM[13] , 
        \add_1_root_add_0_root_add_135/SUM[12] , 
        \add_1_root_add_0_root_add_135/SUM[11] , 
        \add_1_root_add_0_root_add_135/SUM[10] , 
        \add_1_root_add_0_root_add_135/SUM[9] , 
        \add_1_root_add_0_root_add_135/SUM[8] , 
        \add_1_root_add_0_root_add_135/SUM[7] , 
        \add_1_root_add_0_root_add_135/SUM[6] , 
        \add_1_root_add_0_root_add_135/SUM[5] , 
        \add_1_root_add_0_root_add_135/SUM[4] , 
        \add_1_root_add_0_root_add_135/A[3] , 
        \add_1_root_add_0_root_add_135/A[2] , 
        \add_1_root_add_0_root_add_135/A[1] , 
        \add_1_root_add_0_root_add_135/A[0] }), .CI(1'b0), .SUM(level7) );
  DFFRX1M \b_reg_reg[6]  ( .D(b[6]), .CK(clk), .RN(rst_n), .Q(n24) );
  DFFRX1M \b_reg_reg[7]  ( .D(b[7]), .CK(clk), .RN(rst_n), .Q(n32) );
  DFFRX1M \a_reg_reg[7]  ( .D(a[7]), .CK(clk), .RN(rst_n), .Q(n33) );
  DFFRX2M \b_reg_reg[4]  ( .D(b[4]), .CK(clk), .RN(rst_n), .Q(n22) );
  DFFRX2M \a_reg_reg[3]  ( .D(a[3]), .CK(clk), .RN(rst_n), .Q(n28) );
  DFFRX2M \a_reg_reg[2]  ( .D(a[2]), .CK(clk), .RN(rst_n), .Q(n27) );
  DFFRX2M \a_reg_reg[1]  ( .D(a[1]), .CK(clk), .RN(rst_n), .Q(n26) );
  DFFRX2M \b_reg_reg[0]  ( .D(b[0]), .CK(clk), .RN(rst_n), .Q(n18) );
  DFFRX1M \a_reg_reg[6]  ( .D(a[6]), .CK(clk), .RN(rst_n), .Q(n31) );
  DFFRX1M \a_reg_reg[5]  ( .D(a[5]), .CK(clk), .RN(rst_n), .Q(n30) );
  DFFRX4M \a_reg_reg[0]  ( .D(a[0]), .CK(clk), .RN(rst_n), .Q(n25), .QN(n54)
         );
  DFFRX4M \b_reg_reg[5]  ( .D(b[5]), .CK(clk), .RN(rst_n), .QN(n9) );
  DFFRX1M en_reg_reg ( .D(en), .CK(clk), .RN(rst_n), .Q(n1), .QN(n2) );
  DFFRHQX8M valid_reg ( .D(n1), .CK(clk), .RN(rst_n), .Q(valid) );
  DFFRX1M \b_reg_reg[2]  ( .D(b[2]), .CK(clk), .RN(rst_n), .Q(n20) );
  DFFRX1M \b_reg_reg[3]  ( .D(b[3]), .CK(clk), .RN(rst_n), .Q(n21) );
  DFFRX1M \a_reg_reg[4]  ( .D(a[4]), .CK(clk), .RN(rst_n), .Q(n29) );
  DFFRX2M \b_reg_reg[1]  ( .D(b[1]), .CK(clk), .RN(rst_n), .Q(n19) );
  NOR2X2M U3 ( .A(n52), .B(n12), .Y(\pp[2][2] ) );
  INVX6M U4 ( .A(n20), .Y(n12) );
  ADDFHX1M U5 ( .A(\pp[2][2] ), .B(\pp[3][1] ), .CI(
        \add_5_root_add_0_root_add_135/carry[4] ), .CO(
        \add_5_root_add_0_root_add_135/carry[5] ), .S(
        \add_3_root_add_0_root_add_135/B[4] ) );
  NOR2BX4M U6 ( .AN(n25), .B(n9), .Y(\pp[5][0] ) );
  INVX10M U7 ( .A(n28), .Y(n51) );
  NOR2X4M U8 ( .A(n52), .B(n14), .Y(\pp[0][2] ) );
  INVX10M U9 ( .A(n27), .Y(n52) );
  CLKXOR2X2M U10 ( .A(\pp[1][0] ), .B(\pp[0][1] ), .Y(
        \add_1_root_add_0_root_add_135/A[1] ) );
  CLKAND2X16M U11 ( .A(\pp[0][1] ), .B(\pp[1][0] ), .Y(
        \add_6_root_add_0_root_add_135/carry[2] ) );
  NOR2X5M U12 ( .A(n53), .B(n14), .Y(\pp[0][1] ) );
  NOR2X1M U13 ( .A(n50), .B(n10), .Y(\pp[4][4] ) );
  NOR2X1M U14 ( .A(n50), .B(n9), .Y(\pp[5][4] ) );
  NOR2X1M U15 ( .A(n50), .B(n11), .Y(\pp[3][4] ) );
  INVX10M U16 ( .A(n29), .Y(n50) );
  INVX18M U17 ( .A(n19), .Y(n13) );
  ADDFHX8M U18 ( .A(\pp[0][4] ), .B(\pp[1][3] ), .CI(
        \add_6_root_add_0_root_add_135/carry[4] ), .CO(
        \add_6_root_add_0_root_add_135/carry[5] ), .S(
        \add_1_root_add_0_root_add_135/A[4] ) );
  XOR2X1M U19 ( .A(\pp[5][0] ), .B(\pp[4][1] ), .Y(
        \add_1_root_add_0_root_add_135/B[5] ) );
  AND2X4M U20 ( .A(\pp[4][1] ), .B(\pp[5][0] ), .Y(
        \add_4_root_add_0_root_add_135/carry[6] ) );
  NOR2X3M U21 ( .A(n53), .B(n10), .Y(\pp[4][1] ) );
  XOR2X2M U22 ( .A(\pp[3][0] ), .B(\pp[2][1] ), .Y(
        \add_3_root_add_0_root_add_135/B[3] ) );
  AND2X6M U23 ( .A(\pp[2][1] ), .B(\pp[3][0] ), .Y(
        \add_5_root_add_0_root_add_135/carry[4] ) );
  NOR2X3M U24 ( .A(n54), .B(n11), .Y(\pp[3][0] ) );
  ADDFHX8M U25 ( .A(\pp[0][3] ), .B(\pp[1][2] ), .CI(
        \add_6_root_add_0_root_add_135/carry[3] ), .CO(
        \add_6_root_add_0_root_add_135/carry[4] ), .S(
        \add_1_root_add_0_root_add_135/A[3] ) );
  NOR2X2M U26 ( .A(n51), .B(n14), .Y(\pp[0][3] ) );
  ADDFHX8M U27 ( .A(\pp[0][2] ), .B(\pp[1][1] ), .CI(
        \add_6_root_add_0_root_add_135/carry[2] ), .CO(
        \add_6_root_add_0_root_add_135/carry[3] ), .S(
        \add_1_root_add_0_root_add_135/A[2] ) );
  NOR2X5M U28 ( .A(n53), .B(n12), .Y(\pp[2][1] ) );
  NOR2X1M U29 ( .A(n51), .B(n12), .Y(\pp[2][3] ) );
  NOR2X1M U30 ( .A(n50), .B(n12), .Y(\pp[2][4] ) );
  NOR2X1M U31 ( .A(n23), .B(n12), .Y(\pp[2][5] ) );
  NOR2X3M U32 ( .A(n53), .B(n13), .Y(\pp[1][1] ) );
  ADDFHX4M U33 ( .A(\pp[7][2] ), .B(\add_2_root_add_0_root_add_135/B[9] ), 
        .CI(\add_2_root_add_0_root_add_135/carry[9] ), .CO(
        \add_2_root_add_0_root_add_135/carry[10] ), .S(
        \add_1_root_add_0_root_add_135/B[9] ) );
  INVX4M U34 ( .A(n31), .Y(n17) );
  ADDFX2M U35 ( .A(\add_1_root_add_0_root_add_135/A[9] ), .B(
        \add_1_root_add_0_root_add_135/B[9] ), .CI(
        \add_1_root_add_0_root_add_135/carry[9] ), .CO(
        \add_1_root_add_0_root_add_135/carry[10] ), .S(
        \add_1_root_add_0_root_add_135/SUM[9] ) );
  ADDFX2M U36 ( .A(\pp[7][3] ), .B(\add_2_root_add_0_root_add_135/B[10] ), 
        .CI(\add_2_root_add_0_root_add_135/carry[10] ), .CO(
        \add_2_root_add_0_root_add_135/carry[11] ), .S(
        \add_1_root_add_0_root_add_135/B[10] ) );
  ADDFX2M U37 ( .A(\pp[6][4] ), .B(\add_3_root_add_0_root_add_135/B[10] ), 
        .CI(\add_3_root_add_0_root_add_135/carry[10] ), .CO(
        \add_3_root_add_0_root_add_135/carry[11] ), .S(
        \add_3_root_add_0_root_add_135/SUM[10] ) );
  CLKAND2X4M U38 ( .A(\add_1_root_add_0_root_add_135/carry[10] ), .B(
        \add_1_root_add_0_root_add_135/B[10] ), .Y(
        \add_1_root_add_0_root_add_135/carry[11] ) );
  CLKXOR2X2M U39 ( .A(\add_1_root_add_0_root_add_135/B[15] ), .B(
        \add_1_root_add_0_root_add_135/carry[15] ), .Y(
        \add_1_root_add_0_root_add_135/SUM[15] ) );
  CLKXOR2X2M U40 ( .A(\add_1_root_add_0_root_add_135/B[4] ), .B(
        \add_1_root_add_0_root_add_135/A[4] ), .Y(
        \add_1_root_add_0_root_add_135/SUM[4] ) );
  INVX4M U41 ( .A(n2), .Y(n4) );
  INVX10M U42 ( .A(n18), .Y(n14) );
  ADDFX4M U43 ( .A(\pp[7][6] ), .B(\add_2_root_add_0_root_add_135/B[13] ), 
        .CI(\add_2_root_add_0_root_add_135/carry[13] ), .CO(
        \add_2_root_add_0_root_add_135/carry[14] ), .S(
        \add_1_root_add_0_root_add_135/B[13] ) );
  ADDFHX4M U44 ( .A(\pp[7][5] ), .B(\add_2_root_add_0_root_add_135/B[12] ), 
        .CI(\add_2_root_add_0_root_add_135/carry[12] ), .CO(
        \add_2_root_add_0_root_add_135/carry[13] ), .S(
        \add_1_root_add_0_root_add_135/B[12] ) );
  ADDFHX4M U45 ( .A(\pp[6][5] ), .B(\add_3_root_add_0_root_add_135/B[11] ), 
        .CI(\add_3_root_add_0_root_add_135/carry[11] ), .CO(
        \add_3_root_add_0_root_add_135/carry[12] ), .S(
        \add_3_root_add_0_root_add_135/SUM[11] ) );
  INVX10M U46 ( .A(n21), .Y(n11) );
  ADDFHX4M U47 ( .A(\pp[4][6] ), .B(\pp[5][5] ), .CI(
        \add_4_root_add_0_root_add_135/carry[10] ), .CO(
        \add_4_root_add_0_root_add_135/carry[11] ), .S(
        \add_2_root_add_0_root_add_135/B[10] ) );
  AO22X1M U48 ( .A0(level7[13]), .A1(n4), .B0(product[13]), .B1(n6), .Y(n47)
         );
  NOR2X8M U49 ( .A(n54), .B(n13), .Y(\pp[1][0] ) );
  NOR2X6M U50 ( .A(n52), .B(n13), .Y(\pp[1][2] ) );
  NOR2X1M U51 ( .A(n51), .B(n13), .Y(\pp[1][3] ) );
  CLKAND2X3M U52 ( .A(\add_1_root_add_0_root_add_135/carry[12] ), .B(
        \add_1_root_add_0_root_add_135/B[12] ), .Y(
        \add_1_root_add_0_root_add_135/carry[13] ) );
  ADDFHX4M U53 ( .A(\add_1_root_add_0_root_add_135/A[8] ), .B(
        \add_1_root_add_0_root_add_135/B[8] ), .CI(
        \add_1_root_add_0_root_add_135/carry[8] ), .CO(
        \add_1_root_add_0_root_add_135/carry[9] ), .S(
        \add_1_root_add_0_root_add_135/SUM[8] ) );
  AO22X2M U54 ( .A0(level7[15]), .A1(n4), .B0(product[15]), .B1(n6), .Y(n49)
         );
  NOR2X1M U55 ( .A(n16), .B(n14), .Y(\pp[0][7] ) );
  AND2X2M U56 ( .A(\add_1_root_add_0_root_add_135/carry[11] ), .B(
        \add_1_root_add_0_root_add_135/B[11] ), .Y(
        \add_1_root_add_0_root_add_135/carry[12] ) );
  NOR2X1M U57 ( .A(n23), .B(n14), .Y(\pp[0][5] ) );
  NOR2X2M U58 ( .A(n53), .B(n9), .Y(\pp[5][1] ) );
  NOR2X1M U59 ( .A(n52), .B(n10), .Y(\pp[4][2] ) );
  INVX12M U60 ( .A(n26), .Y(n53) );
  NOR2X1M U61 ( .A(n50), .B(n13), .Y(\pp[1][4] ) );
  NOR2X1M U62 ( .A(n53), .B(n11), .Y(\pp[3][1] ) );
  ADDFX4M U63 ( .A(\pp[2][7] ), .B(\pp[3][6] ), .CI(
        \add_5_root_add_0_root_add_135/carry[9] ), .CO(
        \add_5_root_add_0_root_add_135/carry[10] ), .S(
        \add_3_root_add_0_root_add_135/B[9] ) );
  NOR2X1M U64 ( .A(n50), .B(n8), .Y(\pp[6][4] ) );
  ADDFHX4M U65 ( .A(\pp[0][6] ), .B(\pp[1][5] ), .CI(
        \add_6_root_add_0_root_add_135/carry[6] ), .CO(
        \add_6_root_add_0_root_add_135/carry[7] ), .S(
        \add_1_root_add_0_root_add_135/A[6] ) );
  NOR2X1M U66 ( .A(n17), .B(n14), .Y(\pp[0][6] ) );
  ADDFX2M U67 ( .A(\pp[0][7] ), .B(\pp[1][6] ), .CI(
        \add_6_root_add_0_root_add_135/carry[7] ), .CO(
        \add_6_root_add_0_root_add_135/carry[8] ), .S(
        \add_1_root_add_0_root_add_135/A[7] ) );
  AND2X2M U68 ( .A(\add_1_root_add_0_root_add_135/carry[13] ), .B(
        \add_1_root_add_0_root_add_135/B[13] ), .Y(
        \add_1_root_add_0_root_add_135/carry[14] ) );
  INVX4M U69 ( .A(n30), .Y(n23) );
  INVX6M U70 ( .A(n22), .Y(n10) );
  AND2X2M U71 ( .A(\add_3_root_add_0_root_add_135/carry[12] ), .B(\pp[6][6] ), 
        .Y(\add_3_root_add_0_root_add_135/carry[13] ) );
  NOR2X1M U72 ( .A(n17), .B(n11), .Y(\pp[3][6] ) );
  NOR2X1M U73 ( .A(n17), .B(n10), .Y(\pp[4][6] ) );
  NOR2X1M U74 ( .A(n17), .B(n12), .Y(\pp[2][6] ) );
  NOR2X2M U75 ( .A(n54), .B(n12), .Y(\add_3_root_add_0_root_add_135/B[2] ) );
  INVX4M U76 ( .A(n33), .Y(n16) );
  INVX4M U77 ( .A(n32), .Y(n7) );
  INVX4M U78 ( .A(n24), .Y(n8) );
  NOR2X1M U79 ( .A(n54), .B(n14), .Y(\add_1_root_add_0_root_add_135/A[0] ) );
  BUFX4M U80 ( .A(n15), .Y(n5) );
  BUFX4M U81 ( .A(n15), .Y(n6) );
  ADDFX2M U82 ( .A(\add_1_root_add_0_root_add_135/A[5] ), .B(
        \add_1_root_add_0_root_add_135/B[5] ), .CI(
        \add_1_root_add_0_root_add_135/carry[5] ), .CO(
        \add_1_root_add_0_root_add_135/carry[6] ), .S(
        \add_1_root_add_0_root_add_135/SUM[5] ) );
  ADDFX2M U83 ( .A(\add_1_root_add_0_root_add_135/A[7] ), .B(
        \add_1_root_add_0_root_add_135/B[7] ), .CI(
        \add_1_root_add_0_root_add_135/carry[7] ), .CO(
        \add_1_root_add_0_root_add_135/carry[8] ), .S(
        \add_1_root_add_0_root_add_135/SUM[7] ) );
  ADDFX2M U84 ( .A(\add_1_root_add_0_root_add_135/A[6] ), .B(
        \add_1_root_add_0_root_add_135/B[6] ), .CI(
        \add_1_root_add_0_root_add_135/carry[6] ), .CO(
        \add_1_root_add_0_root_add_135/carry[7] ), .S(
        \add_1_root_add_0_root_add_135/SUM[6] ) );
  INVX2M U85 ( .A(n3), .Y(n15) );
  NOR2X2M U86 ( .A(n17), .B(n13), .Y(\pp[1][6] ) );
  NOR2X2M U87 ( .A(n50), .B(n14), .Y(\pp[0][4] ) );
  ADDFX2M U88 ( .A(\pp[0][5] ), .B(\pp[1][4] ), .CI(
        \add_6_root_add_0_root_add_135/carry[5] ), .CO(
        \add_6_root_add_0_root_add_135/carry[6] ), .S(
        \add_1_root_add_0_root_add_135/A[5] ) );
  NOR2X2M U89 ( .A(n23), .B(n13), .Y(\pp[1][5] ) );
  ADDFX2M U90 ( .A(\pp[7][1] ), .B(\add_2_root_add_0_root_add_135/B[8] ), .CI(
        \add_2_root_add_0_root_add_135/carry[8] ), .CO(
        \add_2_root_add_0_root_add_135/carry[9] ), .S(
        \add_1_root_add_0_root_add_135/B[8] ) );
  NOR2X2M U91 ( .A(n7), .B(n53), .Y(\pp[7][1] ) );
  NOR2X2M U92 ( .A(n54), .B(n10), .Y(\add_1_root_add_0_root_add_135/B[4] ) );
  NOR2X2M U93 ( .A(n7), .B(n23), .Y(\pp[7][5] ) );
  ADDFX2M U94 ( .A(\pp[4][3] ), .B(\pp[5][2] ), .CI(
        \add_4_root_add_0_root_add_135/carry[7] ), .CO(
        \add_4_root_add_0_root_add_135/carry[8] ), .S(
        \add_2_root_add_0_root_add_135/B[7] ) );
  NOR2X2M U95 ( .A(n52), .B(n9), .Y(\pp[5][2] ) );
  NOR2X2M U96 ( .A(n51), .B(n10), .Y(\pp[4][3] ) );
  NOR2X2M U97 ( .A(n7), .B(n51), .Y(\pp[7][3] ) );
  ADDFX2M U98 ( .A(\pp[7][4] ), .B(\add_2_root_add_0_root_add_135/B[11] ), 
        .CI(\add_2_root_add_0_root_add_135/carry[11] ), .CO(
        \add_2_root_add_0_root_add_135/carry[12] ), .S(
        \add_1_root_add_0_root_add_135/B[11] ) );
  NOR2X2M U99 ( .A(n7), .B(n50), .Y(\pp[7][4] ) );
  ADDFX2M U100 ( .A(\pp[4][4] ), .B(\pp[5][3] ), .CI(
        \add_4_root_add_0_root_add_135/carry[8] ), .CO(
        \add_4_root_add_0_root_add_135/carry[9] ), .S(
        \add_2_root_add_0_root_add_135/B[8] ) );
  NOR2X2M U101 ( .A(n51), .B(n9), .Y(\pp[5][3] ) );
  ADDFX2M U102 ( .A(\pp[4][5] ), .B(\pp[5][4] ), .CI(
        \add_4_root_add_0_root_add_135/carry[9] ), .CO(
        \add_4_root_add_0_root_add_135/carry[10] ), .S(
        \add_2_root_add_0_root_add_135/B[9] ) );
  NOR2X2M U103 ( .A(n23), .B(n10), .Y(\pp[4][5] ) );
  NOR2X2M U104 ( .A(n7), .B(n52), .Y(\pp[7][2] ) );
  NOR2X2M U105 ( .A(n23), .B(n9), .Y(\pp[5][5] ) );
  ADDFX2M U106 ( .A(\pp[4][7] ), .B(\pp[5][6] ), .CI(
        \add_4_root_add_0_root_add_135/carry[11] ), .CO(
        \add_4_root_add_0_root_add_135/carry[12] ), .S(
        \add_2_root_add_0_root_add_135/B[11] ) );
  NOR2X2M U107 ( .A(n17), .B(n9), .Y(\pp[5][6] ) );
  NOR2X2M U108 ( .A(n16), .B(n10), .Y(\pp[4][7] ) );
  ADDFX2M U109 ( .A(\pp[4][2] ), .B(\pp[5][1] ), .CI(
        \add_4_root_add_0_root_add_135/carry[6] ), .CO(
        \add_4_root_add_0_root_add_135/carry[7] ), .S(
        \add_1_root_add_0_root_add_135/B[6] ) );
  ADDFX2M U110 ( .A(\pp[6][1] ), .B(\add_3_root_add_0_root_add_135/B[7] ), 
        .CI(\add_3_root_add_0_root_add_135/carry[7] ), .CO(
        \add_3_root_add_0_root_add_135/carry[8] ), .S(
        \add_3_root_add_0_root_add_135/SUM[7] ) );
  NOR2X2M U111 ( .A(n53), .B(n8), .Y(\pp[6][1] ) );
  NOR2X2M U112 ( .A(n16), .B(n13), .Y(\pp[1][7] ) );
  NOR2X2M U113 ( .A(n7), .B(n54), .Y(\pp[7][0] ) );
  NOR2X2M U114 ( .A(n7), .B(n17), .Y(\pp[7][6] ) );
  NOR2X2M U115 ( .A(n23), .B(n8), .Y(\pp[6][5] ) );
  NOR2X2M U116 ( .A(n16), .B(n12), .Y(\pp[2][7] ) );
  ADDFX2M U117 ( .A(\pp[2][3] ), .B(\pp[3][2] ), .CI(
        \add_5_root_add_0_root_add_135/carry[5] ), .CO(
        \add_5_root_add_0_root_add_135/carry[6] ), .S(
        \add_3_root_add_0_root_add_135/B[5] ) );
  NOR2X2M U118 ( .A(n52), .B(n11), .Y(\pp[3][2] ) );
  ADDFX2M U119 ( .A(\pp[2][4] ), .B(\pp[3][3] ), .CI(
        \add_5_root_add_0_root_add_135/carry[6] ), .CO(
        \add_5_root_add_0_root_add_135/carry[7] ), .S(
        \add_3_root_add_0_root_add_135/B[6] ) );
  NOR2X2M U120 ( .A(n51), .B(n11), .Y(\pp[3][3] ) );
  ADDFX2M U121 ( .A(\pp[2][5] ), .B(\pp[3][4] ), .CI(
        \add_5_root_add_0_root_add_135/carry[7] ), .CO(
        \add_5_root_add_0_root_add_135/carry[8] ), .S(
        \add_3_root_add_0_root_add_135/B[7] ) );
  ADDFX2M U122 ( .A(\pp[2][6] ), .B(\pp[3][5] ), .CI(
        \add_5_root_add_0_root_add_135/carry[8] ), .CO(
        \add_5_root_add_0_root_add_135/carry[9] ), .S(
        \add_3_root_add_0_root_add_135/B[8] ) );
  NOR2X2M U123 ( .A(n23), .B(n11), .Y(\pp[3][5] ) );
  ADDFX2M U124 ( .A(\pp[6][2] ), .B(\add_3_root_add_0_root_add_135/B[8] ), 
        .CI(\add_3_root_add_0_root_add_135/carry[8] ), .CO(
        \add_3_root_add_0_root_add_135/carry[9] ), .S(
        \add_3_root_add_0_root_add_135/SUM[8] ) );
  NOR2X2M U125 ( .A(n52), .B(n8), .Y(\pp[6][2] ) );
  ADDFX2M U126 ( .A(\pp[6][3] ), .B(\add_3_root_add_0_root_add_135/B[9] ), 
        .CI(\add_3_root_add_0_root_add_135/carry[9] ), .CO(
        \add_3_root_add_0_root_add_135/carry[10] ), .S(
        \add_3_root_add_0_root_add_135/SUM[9] ) );
  NOR2X2M U127 ( .A(n51), .B(n8), .Y(\pp[6][3] ) );
  NOR2X2M U128 ( .A(n54), .B(n8), .Y(\pp[6][0] ) );
  NOR2X2M U129 ( .A(n16), .B(n11), .Y(\pp[3][7] ) );
  NOR2X2M U130 ( .A(n16), .B(n9), .Y(\pp[5][7] ) );
  NOR2X2M U131 ( .A(n17), .B(n8), .Y(\pp[6][6] ) );
  NOR2X2M U132 ( .A(n16), .B(n7), .Y(\pp[7][7] ) );
  NOR2X2M U133 ( .A(n16), .B(n8), .Y(\pp[6][7] ) );
  INVX4M U134 ( .A(n2), .Y(n3) );
  AO22X1M U135 ( .A0(level7[14]), .A1(n4), .B0(product[14]), .B1(n6), .Y(n48)
         );
  AO22X1M U136 ( .A0(level7[12]), .A1(n4), .B0(product[12]), .B1(n6), .Y(n46)
         );
  AO22X1M U137 ( .A0(level7[11]), .A1(n4), .B0(product[11]), .B1(n6), .Y(n45)
         );
  AO22X1M U138 ( .A0(level7[9]), .A1(n4), .B0(product[9]), .B1(n6), .Y(n43) );
  AO22X1M U139 ( .A0(level7[10]), .A1(n4), .B0(product[10]), .B1(n6), .Y(n44)
         );
  AO22X1M U140 ( .A0(level7[6]), .A1(n3), .B0(product[6]), .B1(n5), .Y(n40) );
  AO22X1M U141 ( .A0(level7[7]), .A1(n4), .B0(product[7]), .B1(n5), .Y(n41) );
  AO22X1M U142 ( .A0(level7[8]), .A1(n4), .B0(product[8]), .B1(n6), .Y(n42) );
  AO22X1M U143 ( .A0(level7[4]), .A1(n3), .B0(product[4]), .B1(n5), .Y(n38) );
  AO22X1M U144 ( .A0(level7[5]), .A1(n3), .B0(product[5]), .B1(n5), .Y(n39) );
  AO22X1M U145 ( .A0(level7[2]), .A1(n3), .B0(product[2]), .B1(n5), .Y(n36) );
  AO22X1M U146 ( .A0(level7[3]), .A1(n3), .B0(product[3]), .B1(n5), .Y(n37) );
  AO22X1M U147 ( .A0(level7[0]), .A1(n3), .B0(product[0]), .B1(n5), .Y(n34) );
  AO22X1M U148 ( .A0(level7[1]), .A1(n3), .B0(product[1]), .B1(n5), .Y(n35) );
  AND2X1M U149 ( .A(\add_3_root_add_0_root_add_135/carry[13] ), .B(\pp[6][7] ), 
        .Y(\add_3_root_add_0_root_add_135/SUM[14] ) );
  CLKXOR2X2M U150 ( .A(\pp[6][7] ), .B(
        \add_3_root_add_0_root_add_135/carry[13] ), .Y(
        \add_3_root_add_0_root_add_135/SUM[13] ) );
  CLKXOR2X2M U151 ( .A(\pp[6][6] ), .B(
        \add_3_root_add_0_root_add_135/carry[12] ), .Y(
        \add_3_root_add_0_root_add_135/SUM[12] ) );
  AND2X1M U152 ( .A(\pp[6][0] ), .B(\add_3_root_add_0_root_add_135/B[6] ), .Y(
        \add_3_root_add_0_root_add_135/carry[7] ) );
  CLKXOR2X2M U153 ( .A(\add_3_root_add_0_root_add_135/B[6] ), .B(\pp[6][0] ), 
        .Y(\add_3_root_add_0_root_add_135/SUM[6] ) );
  AND2X1M U154 ( .A(\add_5_root_add_0_root_add_135/carry[10] ), .B(\pp[3][7] ), 
        .Y(\add_3_root_add_0_root_add_135/B[11] ) );
  CLKXOR2X2M U155 ( .A(\pp[3][7] ), .B(
        \add_5_root_add_0_root_add_135/carry[10] ), .Y(
        \add_3_root_add_0_root_add_135/B[10] ) );
  AND2X1M U156 ( .A(\add_1_root_add_0_root_add_135/carry[14] ), .B(
        \add_1_root_add_0_root_add_135/B[14] ), .Y(
        \add_1_root_add_0_root_add_135/carry[15] ) );
  CLKXOR2X2M U157 ( .A(\add_1_root_add_0_root_add_135/B[14] ), .B(
        \add_1_root_add_0_root_add_135/carry[14] ), .Y(
        \add_1_root_add_0_root_add_135/SUM[14] ) );
  CLKXOR2X2M U158 ( .A(\add_1_root_add_0_root_add_135/B[13] ), .B(
        \add_1_root_add_0_root_add_135/carry[13] ), .Y(
        \add_1_root_add_0_root_add_135/SUM[13] ) );
  CLKXOR2X2M U159 ( .A(\add_1_root_add_0_root_add_135/B[12] ), .B(
        \add_1_root_add_0_root_add_135/carry[12] ), .Y(
        \add_1_root_add_0_root_add_135/SUM[12] ) );
  CLKXOR2X2M U160 ( .A(\add_1_root_add_0_root_add_135/B[11] ), .B(
        \add_1_root_add_0_root_add_135/carry[11] ), .Y(
        \add_1_root_add_0_root_add_135/SUM[11] ) );
  CLKXOR2X2M U161 ( .A(\add_1_root_add_0_root_add_135/B[10] ), .B(
        \add_1_root_add_0_root_add_135/carry[10] ), .Y(
        \add_1_root_add_0_root_add_135/SUM[10] ) );
  AND2X1M U162 ( .A(\add_1_root_add_0_root_add_135/A[4] ), .B(
        \add_1_root_add_0_root_add_135/B[4] ), .Y(
        \add_1_root_add_0_root_add_135/carry[5] ) );
  AND2X1M U163 ( .A(\add_6_root_add_0_root_add_135/carry[8] ), .B(\pp[1][7] ), 
        .Y(\add_1_root_add_0_root_add_135/A[9] ) );
  CLKXOR2X2M U164 ( .A(\pp[1][7] ), .B(
        \add_6_root_add_0_root_add_135/carry[8] ), .Y(
        \add_1_root_add_0_root_add_135/A[8] ) );
  AND2X1M U165 ( .A(\add_2_root_add_0_root_add_135/carry[14] ), .B(\pp[7][7] ), 
        .Y(\add_1_root_add_0_root_add_135/B[15] ) );
  CLKXOR2X2M U166 ( .A(\pp[7][7] ), .B(
        \add_2_root_add_0_root_add_135/carry[14] ), .Y(
        \add_1_root_add_0_root_add_135/B[14] ) );
  AND2X1M U167 ( .A(\pp[7][0] ), .B(\add_2_root_add_0_root_add_135/B[7] ), .Y(
        \add_2_root_add_0_root_add_135/carry[8] ) );
  CLKXOR2X2M U168 ( .A(\add_2_root_add_0_root_add_135/B[7] ), .B(\pp[7][0] ), 
        .Y(\add_1_root_add_0_root_add_135/B[7] ) );
  AND2X1M U169 ( .A(\add_4_root_add_0_root_add_135/carry[12] ), .B(\pp[5][7] ), 
        .Y(\add_2_root_add_0_root_add_135/B[13] ) );
  CLKXOR2X2M U170 ( .A(\pp[5][7] ), .B(
        \add_4_root_add_0_root_add_135/carry[12] ), .Y(
        \add_2_root_add_0_root_add_135/B[12] ) );
endmodule


module alu8_top ( clk, rst_n, en, a, b, result, valid );
  input [7:0] a;
  input [7:0] b;
  output [15:0] result;
  input clk, rst_n, en;
  output valid;


  mult_unit \genblk1.u_mul  ( .clk(clk), .rst_n(rst_n), .en(en), .a(a), .b(b), 
        .product(result), .valid(valid) );
endmodule

