/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06-SP1
// Date      : Wed Sep  2 04:55:09 2026
/////////////////////////////////////////////////////////////


module add_unit_DW01_add_0 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   n1;
  wire   [8:1] carry;

  ADDFHX8M U1_1 ( .A(A[1]), .B(B[1]), .CI(n1), .CO(carry[2]), .S(SUM[1]) );
  ADDFX2M U1_2 ( .A(A[2]), .B(B[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2])
         );
  ADDFX2M U1_3 ( .A(A[3]), .B(B[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3])
         );
  ADDFX2M U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  ADDFX2M U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5])
         );
  ADDFX2M U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  ADDFHX4M U1_7 ( .A(A[7]), .B(B[7]), .CI(carry[7]), .CO(SUM[8]), .S(SUM[7])
         );
  AND2X12M U1 ( .A(B[0]), .B(A[0]), .Y(n1) );
  CLKXOR2X2M U2 ( .A(B[0]), .B(A[0]), .Y(SUM[0]) );
endmodule


module add_unit ( clk, rst_n, en, a, b, sum, cout, valid );
  input [7:0] a;
  input [7:0] b;
  output [7:0] sum;
  input clk, rst_n, en;
  output cout, valid;
  wire   en_reg, n2, n3, n4, n5, n6, n7, n8, n9, n10, n1, n12, n13, n14, n15,
         n16;
  wire   [8:0] add_result;

  add_unit_DW01_add_0 add_34 ( .A({1'b0, a}), .B({1'b0, b}), .CI(1'b0), .SUM(
        add_result) );
  DFFRQX2M en_reg_reg ( .D(en), .CK(clk), .RN(rst_n), .Q(en_reg) );
  DFFRQX2M valid_reg ( .D(n15), .CK(clk), .RN(rst_n), .Q(valid) );
  DFFRQX2M \sum_reg[6]  ( .D(n8), .CK(clk), .RN(rst_n), .Q(sum[6]) );
  DFFRQX2M \sum_reg[5]  ( .D(n7), .CK(clk), .RN(rst_n), .Q(sum[5]) );
  DFFRQX2M \sum_reg[4]  ( .D(n6), .CK(clk), .RN(rst_n), .Q(sum[4]) );
  DFFRQX2M \sum_reg[3]  ( .D(n5), .CK(clk), .RN(rst_n), .Q(sum[3]) );
  DFFRQX2M \sum_reg[2]  ( .D(n4), .CK(clk), .RN(rst_n), .Q(sum[2]) );
  DFFRQX2M \sum_reg[1]  ( .D(n3), .CK(clk), .RN(rst_n), .Q(sum[1]) );
  DFFRQX2M \sum_reg[0]  ( .D(n2), .CK(clk), .RN(rst_n), .Q(sum[0]) );
  DFFRQX2M \sum_reg[7]  ( .D(n9), .CK(clk), .RN(rst_n), .Q(sum[7]) );
  DFFRQX2M cout_reg ( .D(n10), .CK(clk), .RN(rst_n), .Q(cout) );
  NAND2X2M U3 ( .A(add_result[8]), .B(n15), .Y(n12) );
  NAND2X2M U4 ( .A(cout), .B(n16), .Y(n1) );
  NAND2X2M U5 ( .A(n1), .B(n12), .Y(n10) );
  INVX4M U6 ( .A(n15), .Y(n16) );
  CLKBUFX6M U7 ( .A(en_reg), .Y(n15) );
  NAND2X2M U8 ( .A(sum[7]), .B(n16), .Y(n13) );
  NAND2X2M U9 ( .A(add_result[7]), .B(n15), .Y(n14) );
  NAND2X2M U10 ( .A(n13), .B(n14), .Y(n9) );
  AO22X1M U11 ( .A0(sum[5]), .A1(n16), .B0(add_result[5]), .B1(n15), .Y(n7) );
  AO22X1M U12 ( .A0(sum[6]), .A1(n16), .B0(add_result[6]), .B1(n15), .Y(n8) );
  AO22X1M U14 ( .A0(sum[1]), .A1(n16), .B0(add_result[1]), .B1(n15), .Y(n3) );
  AO22X1M U15 ( .A0(sum[2]), .A1(n16), .B0(add_result[2]), .B1(n15), .Y(n4) );
  AO22X1M U16 ( .A0(sum[3]), .A1(n16), .B0(add_result[3]), .B1(n15), .Y(n5) );
  AO22X1M U17 ( .A0(sum[4]), .A1(n16), .B0(add_result[4]), .B1(n15), .Y(n6) );
  AO22X1M U18 ( .A0(sum[0]), .A1(n16), .B0(n15), .B1(add_result[0]), .Y(n2) );
endmodule


module mult_unit_DW01_add_4 ( A, B, CI, SUM, CO );
  input [11:0] A;
  input [11:0] B;
  output [11:0] SUM;
  input CI;
  output CO;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12;
  wire   [11:1] carry;
  assign SUM[1] = A[1];
  assign SUM[0] = A[0];

  ADDFHX8M U1_9 ( .A(A[9]), .B(B[9]), .CI(carry[9]), .CO(carry[10]), .S(SUM[9]) );
  ADDFHX8M U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  ADDFHX4M U1_8 ( .A(A[8]), .B(B[8]), .CI(carry[8]), .CO(carry[9]), .S(SUM[8])
         );
  ADDFHX8M U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  ADDFHX8M U1_3 ( .A(A[3]), .B(B[3]), .CI(n1), .CO(carry[4]), .S(SUM[3]) );
  XOR2X1M U1 ( .A(B[2]), .B(A[2]), .Y(SUM[2]) );
  AND2X4M U2 ( .A(B[2]), .B(A[2]), .Y(n1) );
  NAND2X6M U3 ( .A(carry[5]), .B(A[5]), .Y(n3) );
  NAND2X3M U4 ( .A(A[7]), .B(B[7]), .Y(n12) );
  XOR2X1M U5 ( .A(A[5]), .B(B[5]), .Y(n2) );
  XOR2X1M U6 ( .A(carry[5]), .B(n2), .Y(SUM[5]) );
  NAND2X8M U7 ( .A(carry[5]), .B(B[5]), .Y(n4) );
  CLKNAND2X8M U8 ( .A(A[5]), .B(B[5]), .Y(n5) );
  NAND3X12M U9 ( .A(n5), .B(n4), .C(n3), .Y(carry[6]) );
  NAND2X2M U10 ( .A(carry[7]), .B(B[7]), .Y(n11) );
  XOR2X8M U11 ( .A(B[11]), .B(n6), .Y(SUM[11]) );
  AND2X8M U12 ( .A(B[10]), .B(carry[10]), .Y(n6) );
  NAND2X8M U13 ( .A(n10), .B(n12), .Y(n7) );
  NAND2X3M U14 ( .A(carry[7]), .B(A[7]), .Y(n10) );
  XOR2X1M U15 ( .A(carry[7]), .B(n9), .Y(SUM[7]) );
  NAND2X12M U16 ( .A(n11), .B(n8), .Y(carry[8]) );
  CLKINVX8M U17 ( .A(n7), .Y(n8) );
  XOR2X2M U18 ( .A(A[7]), .B(B[7]), .Y(n9) );
  CLKXOR2X2M U19 ( .A(B[10]), .B(carry[10]), .Y(SUM[10]) );
endmodule


module mult_unit_DW01_add_0 ( A, B, CI, SUM, CO );
  input [15:0] A;
  input [15:0] B;
  output [15:0] SUM;
  input CI;
  output CO;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27;
  wire   [15:1] carry;
  assign SUM[3] = B[3];
  assign SUM[2] = B[2];
  assign SUM[1] = B[1];
  assign SUM[0] = B[0];

  ADDFHX8M U1_12 ( .A(A[12]), .B(B[12]), .CI(carry[12]), .CO(carry[13]), .S(
        SUM[12]) );
  ADDFHX8M U1_5 ( .A(A[5]), .B(B[5]), .CI(n3), .CO(carry[6]), .S(SUM[5]) );
  ADDFHX4M U1_11 ( .A(A[11]), .B(B[11]), .CI(carry[11]), .CO(carry[12]), .S(
        SUM[11]) );
  ADDFHX8M U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  BUFX24M U1 ( .A(A[9]), .Y(n1) );
  CLKNAND2X16M U2 ( .A(B[8]), .B(carry[8]), .Y(n16) );
  CLKNAND2X8M U3 ( .A(carry[8]), .B(A[8]), .Y(n18) );
  NAND3X12M U4 ( .A(n15), .B(n14), .C(n13), .Y(carry[8]) );
  BUFX14M U5 ( .A(B[7]), .Y(n2) );
  INVX2M U6 ( .A(B[15]), .Y(n19) );
  CLKNAND2X12M U7 ( .A(n5), .B(n6), .Y(carry[11]) );
  NAND2X6M U8 ( .A(n4), .B(B[10]), .Y(n25) );
  NAND2X2M U9 ( .A(B[13]), .B(A[13]), .Y(n12) );
  NAND2X4M U10 ( .A(carry[13]), .B(B[13]), .Y(n10) );
  NAND2X4M U11 ( .A(n2), .B(A[7]), .Y(n14) );
  NAND2X4M U12 ( .A(carry[7]), .B(A[7]), .Y(n15) );
  NAND2X4M U13 ( .A(n2), .B(carry[7]), .Y(n13) );
  CLKXOR2X2M U14 ( .A(carry[13]), .B(n9), .Y(SUM[13]) );
  XOR2X4M U15 ( .A(B[13]), .B(A[13]), .Y(n9) );
  AND2X2M U16 ( .A(B[4]), .B(A[4]), .Y(n3) );
  OR2X12M U17 ( .A(n7), .B(n8), .Y(n4) );
  CLKXOR2X4M U18 ( .A(B[14]), .B(carry[14]), .Y(SUM[14]) );
  NAND2X5M U19 ( .A(B[9]), .B(carry[9]), .Y(n23) );
  CLKAND2X12M U20 ( .A(carry[9]), .B(n1), .Y(n7) );
  NAND3X12M U21 ( .A(n18), .B(n17), .C(n16), .Y(carry[9]) );
  NAND2X3M U22 ( .A(n4), .B(A[10]), .Y(n5) );
  AND2X12M U23 ( .A(n25), .B(n26), .Y(n6) );
  NAND2X12M U24 ( .A(n24), .B(n23), .Y(n8) );
  NAND2X4M U25 ( .A(carry[13]), .B(A[13]), .Y(n11) );
  NAND3X12M U26 ( .A(n12), .B(n11), .C(n10), .Y(carry[14]) );
  NAND2X12M U27 ( .A(B[14]), .B(carry[14]), .Y(n27) );
  CLKNAND2X12M U28 ( .A(n21), .B(n22), .Y(SUM[15]) );
  NAND2X4M U29 ( .A(B[15]), .B(n27), .Y(n21) );
  CLKINVX6M U30 ( .A(n27), .Y(n20) );
  NAND2X8M U31 ( .A(n19), .B(n20), .Y(n22) );
  XOR3XLM U32 ( .A(n2), .B(carry[7]), .C(A[7]), .Y(SUM[7]) );
  NAND2X6M U33 ( .A(B[8]), .B(A[8]), .Y(n17) );
  NAND2X4M U34 ( .A(B[9]), .B(n1), .Y(n24) );
  NAND2X2M U35 ( .A(B[10]), .B(A[10]), .Y(n26) );
  XOR3XLM U36 ( .A(B[8]), .B(carry[8]), .C(A[8]), .Y(SUM[8]) );
  XOR3XLM U37 ( .A(B[9]), .B(carry[9]), .C(n1), .Y(SUM[9]) );
  XOR3XLM U38 ( .A(n4), .B(B[10]), .C(A[10]), .Y(SUM[10]) );
  XOR2X1M U39 ( .A(B[4]), .B(A[4]), .Y(SUM[4]) );
endmodule


module mult_unit ( clk, rst_n, en, a, b, product, valid );
  input [7:0] a;
  input [7:0] b;
  output [15:0] product;
  input clk, rst_n, en;
  output valid;
  wire   en_reg, \pp[0][7] , \pp[0][6] , \pp[0][5] , \pp[0][4] , \pp[0][3] ,
         \pp[0][0] , \pp[1][7] , \pp[1][6] , \pp[1][5] , \pp[1][4] ,
         \pp[1][3] , \pp[1][2] , \pp[1][1] , \pp[1][0] , \pp[2][7] ,
         \pp[2][6] , \pp[2][5] , \pp[2][4] , \pp[2][3] , \pp[2][2] ,
         \pp[2][1] , \pp[2][0] , \pp[3][7] , \pp[3][6] , \pp[3][5] ,
         \pp[3][4] , \pp[3][3] , \pp[3][2] , \pp[3][1] , \pp[3][0] ,
         \pp[4][7] , \pp[4][6] , \pp[4][5] , \pp[4][4] , \pp[4][3] ,
         \pp[4][2] , \pp[4][1] , \pp[4][0] , \pp[5][7] , \pp[5][6] ,
         \pp[5][5] , \pp[5][4] , \pp[5][3] , \pp[5][2] , \pp[5][1] ,
         \pp[5][0] , \pp[6][7] , \pp[6][6] , \pp[6][5] , \pp[6][4] ,
         \pp[6][3] , \pp[6][2] , \pp[6][1] , \pp[6][0] , \pp[7][7] ,
         \pp[7][6] , \pp[7][5] , \pp[7][4] , \pp[7][3] , \pp[7][2] ,
         \pp[7][1] , \pp[7][0] , en_pipe, n18, n20, n22, n23, n24, n25, n26,
         n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40,
         n41, n42, n43, n44, n45, n46, n47, n48, n49, \level6[9] , \level6[8] ,
         \level6[7] , \level6[14] , \level6[13] , \level6[12] , \level6[11] ,
         \level6[10] , \level5[9] , \level5[8] , \level5[7] , \level5[6] ,
         \level5[5] , \level5[4] , \level5[3] , \level5[2] , \level5[1] ,
         \level5[15] , \level5[14] , \level5[13] , \level5[12] , \level5[11] ,
         \level5[10] , \level5[0] , \level4[9] , \level4[8] , \level4[7] ,
         \level4[6] , \level4[5] , \level4[4] , \level4[13] , \level4[12] ,
         \level4[11] , \level4[10] , \add_3_root_add_0_root_add_158/carry[12] ,
         \add_3_root_add_0_root_add_158/carry[11] ,
         \add_3_root_add_0_root_add_158/carry[10] ,
         \add_3_root_add_0_root_add_158/carry[9] ,
         \add_3_root_add_0_root_add_158/carry[8] ,
         \add_3_root_add_0_root_add_158/carry[7] ,
         \add_3_root_add_0_root_add_158/carry[6] ,
         \add_1_root_add_0_root_add_158/carry[8] ,
         \add_1_root_add_0_root_add_158/carry[9] ,
         \add_1_root_add_0_root_add_158/carry[10] ,
         \add_1_root_add_0_root_add_158/carry[11] ,
         \add_1_root_add_0_root_add_158/carry[12] ,
         \add_1_root_add_0_root_add_158/carry[13] ,
         \add_1_root_add_0_root_add_158/carry[14] ,
         \add_2_root_add_0_root_add_158/carry[7] ,
         \add_2_root_add_0_root_add_158/carry[8] ,
         \add_2_root_add_0_root_add_158/carry[9] ,
         \add_2_root_add_0_root_add_158/carry[10] ,
         \add_2_root_add_0_root_add_158/carry[11] ,
         \add_2_root_add_0_root_add_158/carry[12] ,
         \add_2_root_add_0_root_add_158/carry[13] ,
         \add_1_root_add_0_root_add_119/carry[10] ,
         \add_1_root_add_0_root_add_119/carry[9] ,
         \add_1_root_add_0_root_add_119/carry[8] ,
         \add_1_root_add_0_root_add_119/carry[7] ,
         \add_1_root_add_0_root_add_119/carry[6] ,
         \add_1_root_add_0_root_add_119/carry[5] ,
         \add_1_root_add_0_root_add_119/carry[4] ,
         \add_1_root_add_0_root_add_119/SUM[3] ,
         \add_1_root_add_0_root_add_119/SUM[4] ,
         \add_1_root_add_0_root_add_119/SUM[5] ,
         \add_1_root_add_0_root_add_119/SUM[6] ,
         \add_1_root_add_0_root_add_119/SUM[7] ,
         \add_1_root_add_0_root_add_119/SUM[8] ,
         \add_1_root_add_0_root_add_119/SUM[9] ,
         \add_1_root_add_0_root_add_119/SUM[10] ,
         \add_1_root_add_0_root_add_119/SUM[11] ,
         \add_2_root_add_0_root_add_119/carry[8] ,
         \add_2_root_add_0_root_add_119/carry[7] ,
         \add_2_root_add_0_root_add_119/carry[6] ,
         \add_2_root_add_0_root_add_119/carry[5] ,
         \add_2_root_add_0_root_add_119/carry[4] ,
         \add_2_root_add_0_root_add_119/carry[3] ,
         \add_2_root_add_0_root_add_119/carry[2] ,
         \add_2_root_add_0_root_add_119/SUM[1] ,
         \add_2_root_add_0_root_add_119/SUM[2] ,
         \add_2_root_add_0_root_add_119/SUM[3] ,
         \add_2_root_add_0_root_add_119/SUM[4] ,
         \add_2_root_add_0_root_add_119/SUM[5] ,
         \add_2_root_add_0_root_add_119/SUM[6] ,
         \add_2_root_add_0_root_add_119/SUM[7] ,
         \add_2_root_add_0_root_add_119/SUM[8] ,
         \add_2_root_add_0_root_add_119/SUM[9] , n1, n2, n3, n4, n5, n6, n7,
         n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n19, n21, n50, n51,
         n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65,
         n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79,
         n80, n81, n82, n83, n84, n85, n86;
  wire   [11:0] level3;
  wire   [15:0] level3_pipe;
  wire   [7:0] pp4_pipe;
  wire   [7:0] pp5_pipe;
  wire   [7:0] pp6_pipe;
  wire   [7:0] pp7_pipe;
  wire   [15:0] level7;

  mult_unit_DW01_add_4 add_0_root_add_0_root_add_119 ( .A({1'b0, 1'b0, 
        \add_2_root_add_0_root_add_119/SUM[9] , 
        \add_2_root_add_0_root_add_119/SUM[8] , 
        \add_2_root_add_0_root_add_119/SUM[7] , 
        \add_2_root_add_0_root_add_119/SUM[6] , 
        \add_2_root_add_0_root_add_119/SUM[5] , 
        \add_2_root_add_0_root_add_119/SUM[4] , 
        \add_2_root_add_0_root_add_119/SUM[3] , 
        \add_2_root_add_0_root_add_119/SUM[2] , 
        \add_2_root_add_0_root_add_119/SUM[1] , \pp[0][0] }), .B({
        \add_1_root_add_0_root_add_119/SUM[11] , 
        \add_1_root_add_0_root_add_119/SUM[10] , 
        \add_1_root_add_0_root_add_119/SUM[9] , 
        \add_1_root_add_0_root_add_119/SUM[8] , 
        \add_1_root_add_0_root_add_119/SUM[7] , 
        \add_1_root_add_0_root_add_119/SUM[6] , 
        \add_1_root_add_0_root_add_119/SUM[5] , 
        \add_1_root_add_0_root_add_119/SUM[4] , 
        \add_1_root_add_0_root_add_119/SUM[3] , \pp[2][0] , 1'b0, 1'b0}), .CI(
        1'b0), .SUM(level3) );
  mult_unit_DW01_add_0 add_0_root_add_0_root_add_158 ( .A({1'b0, 1'b0, 
        \level4[13] , \level4[12] , \level4[11] , \level4[10] , \level4[9] , 
        \level4[8] , \level4[7] , \level4[6] , \level4[5] , \level4[4] , 1'b0, 
        1'b0, 1'b0, 1'b0}), .B({\level5[15] , \level5[14] , \level5[13] , 
        \level5[12] , \level5[11] , \level5[10] , \level5[9] , \level5[8] , 
        \level5[7] , \level5[6] , \level5[5] , \level5[4] , \level5[3] , 
        \level5[2] , \level5[1] , \level5[0] }), .CI(1'b0), .SUM(level7) );
  DFFRQX2M \level3_pipe_reg[3]  ( .D(level3[3]), .CK(clk), .RN(rst_n), .Q(
        \level5[3] ) );
  DFFRQX2M \level3_pipe_reg[2]  ( .D(level3[2]), .CK(clk), .RN(rst_n), .Q(
        \level5[2] ) );
  DFFRQX2M \level3_pipe_reg[1]  ( .D(level3[1]), .CK(clk), .RN(rst_n), .Q(
        \level5[1] ) );
  DFFRQX2M \level3_pipe_reg[0]  ( .D(level3[0]), .CK(clk), .RN(rst_n), .Q(
        \level5[0] ) );
  DFFRQX2M \pp7_pipe_reg[7]  ( .D(\pp[7][7] ), .CK(clk), .RN(rst_n), .Q(
        pp7_pipe[7]) );
  DFFRX1M \b_reg_reg[7]  ( .D(b[7]), .CK(clk), .RN(rst_n), .Q(n32) );
  DFFRX1M \b_reg_reg[6]  ( .D(b[6]), .CK(clk), .RN(rst_n), .Q(n24) );
  DFFRX1M \b_reg_reg[5]  ( .D(b[5]), .CK(clk), .RN(rst_n), .Q(n23) );
  DFFRX1M \b_reg_reg[4]  ( .D(b[4]), .CK(clk), .RN(rst_n), .Q(n22) );
  DFFRQX2M en_pipe_reg ( .D(en_reg), .CK(clk), .RN(rst_n), .Q(en_pipe) );
  DFFRQX2M valid_reg ( .D(n70), .CK(clk), .RN(rst_n), .Q(valid) );
  DFFRQX2M \pp7_pipe_reg[5]  ( .D(\pp[7][5] ), .CK(clk), .RN(rst_n), .Q(
        pp7_pipe[5]) );
  DFFRQX2M \pp7_pipe_reg[4]  ( .D(\pp[7][4] ), .CK(clk), .RN(rst_n), .Q(
        pp7_pipe[4]) );
  DFFRQX2M \pp5_pipe_reg[7]  ( .D(\pp[5][7] ), .CK(clk), .RN(rst_n), .Q(
        pp5_pipe[7]) );
  DFFRQX2M \pp6_pipe_reg[7]  ( .D(\pp[6][7] ), .CK(clk), .RN(rst_n), .Q(
        pp6_pipe[7]) );
  DFFRQX2M \product_reg[8]  ( .D(n42), .CK(clk), .RN(rst_n), .Q(product[8]) );
  DFFRQX2M \product_reg[7]  ( .D(n41), .CK(clk), .RN(rst_n), .Q(product[7]) );
  DFFRQX2M \product_reg[6]  ( .D(n40), .CK(clk), .RN(rst_n), .Q(product[6]) );
  DFFRQX2M \product_reg[5]  ( .D(n39), .CK(clk), .RN(rst_n), .Q(product[5]) );
  DFFRQX2M \product_reg[4]  ( .D(n38), .CK(clk), .RN(rst_n), .Q(product[4]) );
  DFFRQX2M \product_reg[3]  ( .D(n37), .CK(clk), .RN(rst_n), .Q(product[3]) );
  DFFRQX2M \product_reg[2]  ( .D(n36), .CK(clk), .RN(rst_n), .Q(product[2]) );
  DFFRQX2M \product_reg[1]  ( .D(n35), .CK(clk), .RN(rst_n), .Q(product[1]) );
  DFFRQX2M \product_reg[0]  ( .D(n34), .CK(clk), .RN(rst_n), .Q(product[0]) );
  DFFRQX2M \product_reg[11]  ( .D(n45), .CK(clk), .RN(rst_n), .Q(product[11])
         );
  DFFRQX2M \product_reg[10]  ( .D(n44), .CK(clk), .RN(rst_n), .Q(product[10])
         );
  DFFRQX2M \product_reg[9]  ( .D(n43), .CK(clk), .RN(rst_n), .Q(product[9]) );
  DFFRQX2M \pp5_pipe_reg[6]  ( .D(\pp[5][6] ), .CK(clk), .RN(rst_n), .Q(
        pp5_pipe[6]) );
  DFFRQX2M \pp5_pipe_reg[5]  ( .D(\pp[5][5] ), .CK(clk), .RN(rst_n), .Q(
        pp5_pipe[5]) );
  DFFRQX2M \pp5_pipe_reg[4]  ( .D(\pp[5][4] ), .CK(clk), .RN(rst_n), .Q(
        pp5_pipe[4]) );
  DFFRQX2M \pp7_pipe_reg[3]  ( .D(\pp[7][3] ), .CK(clk), .RN(rst_n), .Q(
        pp7_pipe[3]) );
  DFFRQX2M \pp7_pipe_reg[1]  ( .D(\pp[7][1] ), .CK(clk), .RN(rst_n), .Q(
        pp7_pipe[1]) );
  DFFRQX2M \pp4_pipe_reg[7]  ( .D(\pp[4][7] ), .CK(clk), .RN(rst_n), .Q(
        pp4_pipe[7]) );
  DFFRQX2M \pp4_pipe_reg[6]  ( .D(\pp[4][6] ), .CK(clk), .RN(rst_n), .Q(
        pp4_pipe[6]) );
  DFFRQX2M \pp4_pipe_reg[5]  ( .D(\pp[4][5] ), .CK(clk), .RN(rst_n), .Q(
        pp4_pipe[5]) );
  DFFRQX2M \pp6_pipe_reg[6]  ( .D(\pp[6][6] ), .CK(clk), .RN(rst_n), .Q(
        pp6_pipe[6]) );
  DFFRQX2M \level3_pipe_reg[10]  ( .D(level3[10]), .CK(clk), .RN(rst_n), .Q(
        level3_pipe[10]) );
  DFFRQX2M \level3_pipe_reg[9]  ( .D(level3[9]), .CK(clk), .RN(rst_n), .Q(
        level3_pipe[9]) );
  DFFRQX2M \level3_pipe_reg[8]  ( .D(level3[8]), .CK(clk), .RN(rst_n), .Q(
        level3_pipe[8]) );
  DFFRQX2M \level3_pipe_reg[5]  ( .D(level3[5]), .CK(clk), .RN(rst_n), .Q(
        \level5[5] ) );
  DFFRQX2M \pp5_pipe_reg[3]  ( .D(\pp[5][3] ), .CK(clk), .RN(rst_n), .Q(
        pp5_pipe[3]) );
  DFFRQX2M \pp5_pipe_reg[2]  ( .D(\pp[5][2] ), .CK(clk), .RN(rst_n), .Q(
        pp5_pipe[2]) );
  DFFRQX2M \pp4_pipe_reg[4]  ( .D(\pp[4][4] ), .CK(clk), .RN(rst_n), .Q(
        pp4_pipe[4]) );
  DFFRQX2M \pp4_pipe_reg[3]  ( .D(\pp[4][3] ), .CK(clk), .RN(rst_n), .Q(
        pp4_pipe[3]) );
  DFFRQX2M \pp6_pipe_reg[5]  ( .D(\pp[6][5] ), .CK(clk), .RN(rst_n), .Q(
        pp6_pipe[5]) );
  DFFRQX2M \pp6_pipe_reg[4]  ( .D(\pp[6][4] ), .CK(clk), .RN(rst_n), .Q(
        pp6_pipe[4]) );
  DFFRQX2M \pp6_pipe_reg[3]  ( .D(\pp[6][3] ), .CK(clk), .RN(rst_n), .Q(
        pp6_pipe[3]) );
  DFFRQX2M \pp6_pipe_reg[2]  ( .D(\pp[6][2] ), .CK(clk), .RN(rst_n), .Q(
        pp6_pipe[2]) );
  DFFRQX2M \pp7_pipe_reg[0]  ( .D(\pp[7][0] ), .CK(clk), .RN(rst_n), .Q(
        pp7_pipe[0]) );
  DFFRX1M \a_reg_reg[7]  ( .D(a[7]), .CK(clk), .RN(rst_n), .Q(n33) );
  DFFRX1M \a_reg_reg[6]  ( .D(a[6]), .CK(clk), .RN(rst_n), .Q(n31) );
  DFFRQX2M \level3_pipe_reg[4]  ( .D(level3[4]), .CK(clk), .RN(rst_n), .Q(
        \level5[4] ) );
  DFFRQX2M \level3_pipe_reg[11]  ( .D(level3[11]), .CK(clk), .RN(rst_n), .Q(
        level3_pipe[11]) );
  DFFRQX2M \product_reg[13]  ( .D(n47), .CK(clk), .RN(rst_n), .Q(product[13])
         );
  DFFRX2M \a_reg_reg[4]  ( .D(a[4]), .CK(clk), .RN(rst_n), .Q(n29) );
  DFFRX2M \a_reg_reg[3]  ( .D(a[3]), .CK(clk), .RN(rst_n), .Q(n28) );
  DFFRX2M \b_reg_reg[2]  ( .D(b[2]), .CK(clk), .RN(rst_n), .Q(n20) );
  DFFRQX2M \product_reg[15]  ( .D(n49), .CK(clk), .RN(rst_n), .Q(product[15])
         );
  DFFRQX1M \product_reg[14]  ( .D(n48), .CK(clk), .RN(rst_n), .Q(product[14])
         );
  DFFRQX2M \pp4_pipe_reg[0]  ( .D(\pp[4][0] ), .CK(clk), .RN(rst_n), .Q(
        \level4[4] ) );
  DFFRX4M \a_reg_reg[1]  ( .D(a[1]), .CK(clk), .RN(rst_n), .Q(n26) );
  DFFRHQX8M \pp6_pipe_reg[0]  ( .D(\pp[6][0] ), .CK(clk), .RN(rst_n), .Q(
        pp6_pipe[0]) );
  DFFRHQX8M \level3_pipe_reg[7]  ( .D(level3[7]), .CK(clk), .RN(rst_n), .Q(
        level3_pipe[7]) );
  DFFRQX2M \pp7_pipe_reg[2]  ( .D(\pp[7][2] ), .CK(clk), .RN(rst_n), .Q(
        pp7_pipe[2]) );
  DFFRHQX8M \pp6_pipe_reg[1]  ( .D(\pp[6][1] ), .CK(clk), .RN(rst_n), .Q(
        pp6_pipe[1]) );
  DFFRHQX8M \level3_pipe_reg[6]  ( .D(level3[6]), .CK(clk), .RN(rst_n), .Q(
        level3_pipe[6]) );
  DFFRX4M \b_reg_reg[3]  ( .D(b[3]), .CK(clk), .RN(rst_n), .QN(n4) );
  DFFRQX2M en_reg_reg ( .D(en), .CK(clk), .RN(rst_n), .Q(en_reg) );
  DFFRQX2M \b_reg_reg[1]  ( .D(b[1]), .CK(clk), .RN(rst_n), .Q(n59) );
  DFFRQX4M \b_reg_reg[0]  ( .D(b[0]), .CK(clk), .RN(rst_n), .Q(n18) );
  DFFRQX4M \pp5_pipe_reg[1]  ( .D(\pp[5][1] ), .CK(clk), .RN(rst_n), .Q(
        pp5_pipe[1]) );
  DFFRQX4M \pp4_pipe_reg[2]  ( .D(\pp[4][2] ), .CK(clk), .RN(rst_n), .Q(
        pp4_pipe[2]) );
  DFFRQX2M \product_reg[12]  ( .D(n46), .CK(clk), .RN(rst_n), .Q(product[12])
         );
  DFFRQX2M \pp7_pipe_reg[6]  ( .D(\pp[7][6] ), .CK(clk), .RN(rst_n), .Q(
        pp7_pipe[6]) );
  DFFRX1M \a_reg_reg[5]  ( .D(a[5]), .CK(clk), .RN(rst_n), .Q(n30) );
  DFFRHQX8M \pp4_pipe_reg[1]  ( .D(\pp[4][1] ), .CK(clk), .RN(rst_n), .Q(
        pp4_pipe[1]) );
  DFFRHQX8M \pp5_pipe_reg[0]  ( .D(\pp[5][0] ), .CK(clk), .RN(rst_n), .Q(
        pp5_pipe[0]) );
  DFFRX4M \a_reg_reg[2]  ( .D(a[2]), .CK(clk), .RN(rst_n), .Q(n27) );
  DFFRX2M \a_reg_reg[0]  ( .D(a[0]), .CK(clk), .RN(rst_n), .Q(n25) );
  NAND2X3M U3 ( .A(\add_3_root_add_0_root_add_158/carry[6] ), .B(pp5_pipe[1]), 
        .Y(n17) );
  NAND2X4M U4 ( .A(\add_2_root_add_0_root_add_158/carry[7] ), .B(pp6_pipe[1]), 
        .Y(n63) );
  NAND2X4M U5 ( .A(\add_2_root_add_0_root_add_158/carry[7] ), .B(
        level3_pipe[7]), .Y(n62) );
  XOR2X2M U6 ( .A(pp6_pipe[6]), .B(\add_2_root_add_0_root_add_158/carry[12] ), 
        .Y(\level6[12] ) );
  XOR2X8M U7 ( .A(\pp[3][7] ), .B(\add_1_root_add_0_root_add_119/carry[10] ), 
        .Y(\add_1_root_add_0_root_add_119/SUM[10] ) );
  ADDFHX4M U8 ( .A(\pp[0][4] ), .B(\pp[1][3] ), .CI(
        \add_2_root_add_0_root_add_119/carry[4] ), .CO(
        \add_2_root_add_0_root_add_119/carry[5] ), .S(
        \add_2_root_add_0_root_add_119/SUM[4] ) );
  INVX14M U9 ( .A(n28), .Y(n82) );
  CLKAND2X16M U10 ( .A(\level6[7] ), .B(pp7_pipe[0]), .Y(
        \add_1_root_add_0_root_add_158/carry[8] ) );
  XOR2X8M U11 ( .A(\level6[7] ), .B(pp7_pipe[0]), .Y(\level5[7] ) );
  CLKXOR2X8M U12 ( .A(\add_2_root_add_0_root_add_158/carry[7] ), .B(n61), .Y(
        \level6[7] ) );
  INVX14M U13 ( .A(n25), .Y(n85) );
  ADDFHX4M U14 ( .A(pp4_pipe[4]), .B(pp5_pipe[3]), .CI(
        \add_3_root_add_0_root_add_158/carry[8] ), .CO(
        \add_3_root_add_0_root_add_158/carry[9] ), .S(\level4[8] ) );
  BUFX32M U15 ( .A(n4), .Y(n1) );
  INVX16M U16 ( .A(n27), .Y(n83) );
  CLKAND2X16M U17 ( .A(\pp[2][1] ), .B(\pp[3][0] ), .Y(
        \add_1_root_add_0_root_add_119/carry[4] ) );
  NOR2X5M U18 ( .A(n84), .B(n76), .Y(\pp[2][1] ) );
  ADDFHX8M U19 ( .A(pp4_pipe[5]), .B(pp5_pipe[4]), .CI(
        \add_3_root_add_0_root_add_158/carry[9] ), .CO(
        \add_3_root_add_0_root_add_158/carry[10] ), .S(\level4[9] ) );
  INVX12M U20 ( .A(pp5_pipe[0]), .Y(n10) );
  CLKNAND2X12M U21 ( .A(pp5_pipe[0]), .B(n11), .Y(n12) );
  NOR2X8M U22 ( .A(n83), .B(n77), .Y(n2) );
  NOR2X4M U23 ( .A(n83), .B(n60), .Y(\pp[1][2] ) );
  NOR2X6M U24 ( .A(n83), .B(n1), .Y(\pp[3][2] ) );
  NOR2X1M U25 ( .A(n83), .B(n75), .Y(\pp[4][2] ) );
  NOR2X1M U26 ( .A(n83), .B(n73), .Y(\pp[6][2] ) );
  NOR2X12M U27 ( .A(n85), .B(n60), .Y(\pp[1][0] ) );
  NOR2X2M U28 ( .A(n85), .B(n76), .Y(\pp[2][0] ) );
  NOR2X1M U29 ( .A(n85), .B(n75), .Y(\pp[4][0] ) );
  NOR2X1M U30 ( .A(n85), .B(n77), .Y(\pp[0][0] ) );
  NOR2X1M U31 ( .A(n72), .B(n85), .Y(\pp[7][0] ) );
  INVX12M U32 ( .A(pp4_pipe[1]), .Y(n11) );
  NAND2X12M U33 ( .A(n10), .B(pp4_pipe[1]), .Y(n13) );
  CLKXOR2X16M U34 ( .A(pp6_pipe[7]), .B(
        \add_2_root_add_0_root_add_158/carry[13] ), .Y(\level6[13] ) );
  CLKAND2X8M U35 ( .A(pp6_pipe[6]), .B(
        \add_2_root_add_0_root_add_158/carry[12] ), .Y(
        \add_2_root_add_0_root_add_158/carry[13] ) );
  XOR2X4M U36 ( .A(pp5_pipe[1]), .B(pp4_pipe[2]), .Y(n16) );
  ADDFHX8M U37 ( .A(\pp[2][2] ), .B(\pp[3][1] ), .CI(
        \add_1_root_add_0_root_add_119/carry[4] ), .CO(
        \add_1_root_add_0_root_add_119/carry[5] ), .S(
        \add_1_root_add_0_root_add_119/SUM[4] ) );
  NOR2X4M U38 ( .A(n83), .B(n76), .Y(\pp[2][2] ) );
  XOR2X8M U39 ( .A(\add_3_root_add_0_root_add_158/carry[6] ), .B(n16), .Y(
        \level4[6] ) );
  INVX10M U40 ( .A(n59), .Y(n60) );
  ADDFHX4M U41 ( .A(pp7_pipe[7]), .B(\level6[14] ), .CI(
        \add_1_root_add_0_root_add_158/carry[14] ), .CO(\level5[15] ), .S(
        \level5[14] ) );
  CLKAND2X3M U42 ( .A(\add_3_root_add_0_root_add_158/carry[12] ), .B(
        pp5_pipe[7]), .Y(\level4[13] ) );
  NAND2X8M U43 ( .A(level3_pipe[7]), .B(n51), .Y(n52) );
  ADDFHX4M U44 ( .A(n2), .B(\pp[1][1] ), .CI(
        \add_2_root_add_0_root_add_119/carry[2] ), .CO(
        \add_2_root_add_0_root_add_119/carry[3] ), .S(
        \add_2_root_add_0_root_add_119/SUM[2] ) );
  NOR2X3M U45 ( .A(n84), .B(n60), .Y(\pp[1][1] ) );
  ADDFHX4M U46 ( .A(pp6_pipe[5]), .B(level3_pipe[11]), .CI(
        \add_2_root_add_0_root_add_158/carry[11] ), .CO(
        \add_2_root_add_0_root_add_158/carry[12] ), .S(\level6[11] ) );
  INVX4M U47 ( .A(level3_pipe[7]), .Y(n50) );
  XOR3X2M U48 ( .A(pp6_pipe[3]), .B(level3_pipe[9]), .C(
        \add_2_root_add_0_root_add_158/carry[9] ), .Y(n9) );
  ADDFX2M U49 ( .A(\pp[2][7] ), .B(\pp[3][6] ), .CI(
        \add_1_root_add_0_root_add_119/carry[9] ), .CO(
        \add_1_root_add_0_root_add_119/carry[10] ), .S(
        \add_1_root_add_0_root_add_119/SUM[9] ) );
  ADDFHX4M U50 ( .A(\pp[0][7] ), .B(\pp[1][6] ), .CI(
        \add_2_root_add_0_root_add_119/carry[7] ), .CO(
        \add_2_root_add_0_root_add_119/carry[8] ), .S(
        \add_2_root_add_0_root_add_119/SUM[7] ) );
  INVX4M U51 ( .A(n31), .Y(n79) );
  INVX4M U52 ( .A(n29), .Y(n81) );
  INVX6M U53 ( .A(n18), .Y(n77) );
  INVX6M U54 ( .A(n54), .Y(n58) );
  NAND2X2M U55 ( .A(n14), .B(n15), .Y(n46) );
  NAND2X2M U56 ( .A(product[12]), .B(n71), .Y(n15) );
  NAND2X2M U57 ( .A(level7[12]), .B(n70), .Y(n14) );
  NAND2X6M U58 ( .A(n65), .B(n66), .Y(n49) );
  NAND2X6M U59 ( .A(product[15]), .B(n71), .Y(n66) );
  NAND2X4M U60 ( .A(level7[13]), .B(n70), .Y(n67) );
  CLKXOR2X8M U61 ( .A(n9), .B(n55), .Y(\level5[9] ) );
  CLKBUFX8M U62 ( .A(n86), .Y(n71) );
  NAND2X2M U63 ( .A(\level6[9] ), .B(pp7_pipe[2]), .Y(n3) );
  CLKINVX12M U64 ( .A(n69), .Y(n70) );
  NOR2X8M U65 ( .A(n85), .B(n1), .Y(\pp[3][0] ) );
  NOR2X3M U66 ( .A(n84), .B(n1), .Y(\pp[3][1] ) );
  XOR2X4M U67 ( .A(pp5_pipe[7]), .B(\add_3_root_add_0_root_add_158/carry[12] ), 
        .Y(\level4[12] ) );
  NAND2X2M U68 ( .A(\add_1_root_add_0_root_add_158/carry[13] ), .B(pp7_pipe[6]), .Y(n7) );
  NAND2X2M U69 ( .A(\add_1_root_add_0_root_add_158/carry[13] ), .B(
        \level6[13] ), .Y(n6) );
  AO22X8M U70 ( .A0(level7[14]), .A1(n70), .B0(product[14]), .B1(n71), .Y(n48)
         );
  NAND2X12M U71 ( .A(n52), .B(n53), .Y(n61) );
  NAND3X12M U72 ( .A(n64), .B(n63), .C(n62), .Y(
        \add_2_root_add_0_root_add_158/carry[8] ) );
  NAND2X2M U73 ( .A(level3_pipe[7]), .B(pp6_pipe[1]), .Y(n64) );
  XOR2X4M U74 ( .A(\level6[13] ), .B(pp7_pipe[6]), .Y(n5) );
  XOR2X8M U75 ( .A(\add_1_root_add_0_root_add_158/carry[13] ), .B(n5), .Y(
        \level5[13] ) );
  NAND2X2M U76 ( .A(\level6[13] ), .B(pp7_pipe[6]), .Y(n8) );
  NAND3X4M U77 ( .A(n8), .B(n7), .C(n6), .Y(
        \add_1_root_add_0_root_add_158/carry[14] ) );
  ADDFHX8M U78 ( .A(pp7_pipe[5]), .B(\level6[12] ), .CI(
        \add_1_root_add_0_root_add_158/carry[12] ), .CO(
        \add_1_root_add_0_root_add_158/carry[13] ), .S(\level5[12] ) );
  NAND3X12M U79 ( .A(n57), .B(n3), .C(n56), .Y(
        \add_1_root_add_0_root_add_158/carry[10] ) );
  NAND2X4M U80 ( .A(n9), .B(\add_1_root_add_0_root_add_158/carry[9] ), .Y(n56)
         );
  NAND2X4M U81 ( .A(\add_1_root_add_0_root_add_158/carry[9] ), .B(pp7_pipe[2]), 
        .Y(n57) );
  ADDFHX4M U82 ( .A(pp6_pipe[3]), .B(level3_pipe[9]), .CI(
        \add_2_root_add_0_root_add_158/carry[9] ), .CO(
        \add_2_root_add_0_root_add_158/carry[10] ), .S(\level6[9] ) );
  ADDFHX8M U83 ( .A(pp6_pipe[2]), .B(level3_pipe[8]), .CI(
        \add_2_root_add_0_root_add_158/carry[8] ), .CO(
        \add_2_root_add_0_root_add_158/carry[9] ), .S(\level6[8] ) );
  ADDFHX4M U84 ( .A(\pp[2][3] ), .B(\pp[3][2] ), .CI(
        \add_1_root_add_0_root_add_119/carry[5] ), .CO(
        \add_1_root_add_0_root_add_119/carry[6] ), .S(
        \add_1_root_add_0_root_add_119/SUM[5] ) );
  XOR2X2M U85 ( .A(\pp[3][0] ), .B(\pp[2][1] ), .Y(
        \add_1_root_add_0_root_add_119/SUM[3] ) );
  ADDFHX4M U86 ( .A(\pp[1][2] ), .B(\pp[0][3] ), .CI(
        \add_2_root_add_0_root_add_119/carry[3] ), .CO(
        \add_2_root_add_0_root_add_119/carry[4] ), .S(
        \add_2_root_add_0_root_add_119/SUM[3] ) );
  ADDFHX8M U87 ( .A(\pp[0][5] ), .B(\pp[1][4] ), .CI(
        \add_2_root_add_0_root_add_119/carry[5] ), .CO(
        \add_2_root_add_0_root_add_119/carry[6] ), .S(
        \add_2_root_add_0_root_add_119/SUM[5] ) );
  NAND2X8M U88 ( .A(n12), .B(n13), .Y(\level4[5] ) );
  NAND2X5M U89 ( .A(\add_3_root_add_0_root_add_158/carry[6] ), .B(pp4_pipe[2]), 
        .Y(n19) );
  NAND2X6M U90 ( .A(pp5_pipe[1]), .B(pp4_pipe[2]), .Y(n21) );
  NAND3X12M U91 ( .A(n21), .B(n19), .C(n17), .Y(
        \add_3_root_add_0_root_add_158/carry[7] ) );
  AND2X12M U92 ( .A(pp5_pipe[0]), .B(pp4_pipe[1]), .Y(
        \add_3_root_add_0_root_add_158/carry[6] ) );
  ADDFHX8M U93 ( .A(pp4_pipe[3]), .B(pp5_pipe[2]), .CI(
        \add_3_root_add_0_root_add_158/carry[7] ), .CO(
        \add_3_root_add_0_root_add_158/carry[8] ), .S(\level4[7] ) );
  INVX12M U94 ( .A(n20), .Y(n76) );
  NAND2X6M U95 ( .A(n50), .B(pp6_pipe[1]), .Y(n53) );
  INVX3M U96 ( .A(pp6_pipe[1]), .Y(n51) );
  NAND2BX8M U97 ( .AN(n84), .B(n18), .Y(n54) );
  CLKXOR2X16M U98 ( .A(\add_1_root_add_0_root_add_158/carry[9] ), .B(
        pp7_pipe[2]), .Y(n55) );
  ADDFHX8M U99 ( .A(pp7_pipe[1]), .B(\level6[8] ), .CI(
        \add_1_root_add_0_root_add_158/carry[8] ), .CO(
        \add_1_root_add_0_root_add_158/carry[9] ), .S(\level5[8] ) );
  ADDFHX4M U100 ( .A(pp7_pipe[3]), .B(\level6[10] ), .CI(
        \add_1_root_add_0_root_add_158/carry[10] ), .CO(
        \add_1_root_add_0_root_add_158/carry[11] ), .S(\level5[10] ) );
  NAND2X12M U101 ( .A(level7[15]), .B(n70), .Y(n65) );
  AND2X12M U102 ( .A(n58), .B(\pp[1][0] ), .Y(
        \add_2_root_add_0_root_add_119/carry[2] ) );
  ADDFX2M U103 ( .A(\pp[2][5] ), .B(\pp[3][4] ), .CI(
        \add_1_root_add_0_root_add_119/carry[7] ), .CO(
        \add_1_root_add_0_root_add_119/carry[8] ), .S(
        \add_1_root_add_0_root_add_119/SUM[7] ) );
  NOR2X1M U104 ( .A(n80), .B(n76), .Y(\pp[2][5] ) );
  ADDFX4M U105 ( .A(pp4_pipe[6]), .B(pp5_pipe[5]), .CI(
        \add_3_root_add_0_root_add_158/carry[10] ), .CO(
        \add_3_root_add_0_root_add_158/carry[11] ), .S(\level4[10] ) );
  AND2X12M U106 ( .A(level3_pipe[6]), .B(pp6_pipe[0]), .Y(
        \add_2_root_add_0_root_add_158/carry[7] ) );
  INVX14M U107 ( .A(n26), .Y(n84) );
  NOR2X1M U108 ( .A(n79), .B(n77), .Y(\pp[0][6] ) );
  INVX4M U109 ( .A(n30), .Y(n80) );
  CLKXOR2X2M U110 ( .A(\pp[1][0] ), .B(n58), .Y(
        \add_2_root_add_0_root_add_119/SUM[1] ) );
  ADDFX2M U111 ( .A(pp7_pipe[4]), .B(\level6[11] ), .CI(
        \add_1_root_add_0_root_add_158/carry[11] ), .CO(
        \add_1_root_add_0_root_add_158/carry[12] ), .S(\level5[11] ) );
  NOR2X1M U112 ( .A(n79), .B(n60), .Y(\pp[1][6] ) );
  ADDFHX4M U113 ( .A(\pp[0][6] ), .B(\pp[1][5] ), .CI(
        \add_2_root_add_0_root_add_119/carry[6] ), .CO(
        \add_2_root_add_0_root_add_119/carry[7] ), .S(
        \add_2_root_add_0_root_add_119/SUM[6] ) );
  NOR2X1M U114 ( .A(n79), .B(n1), .Y(\pp[3][6] ) );
  NOR2X1M U115 ( .A(n79), .B(n76), .Y(\pp[2][6] ) );
  NOR2X1M U116 ( .A(n79), .B(n73), .Y(\pp[6][6] ) );
  NOR2X1M U117 ( .A(n79), .B(n74), .Y(\pp[5][6] ) );
  NOR2X1M U118 ( .A(n79), .B(n75), .Y(\pp[4][6] ) );
  NOR2X1M U119 ( .A(n72), .B(n79), .Y(\pp[7][6] ) );
  NOR2X1M U120 ( .A(n72), .B(n84), .Y(\pp[7][1] ) );
  NOR2X1M U121 ( .A(n84), .B(n73), .Y(\pp[6][1] ) );
  NOR2X1M U122 ( .A(n84), .B(n74), .Y(\pp[5][1] ) );
  NOR2X1M U123 ( .A(n84), .B(n75), .Y(\pp[4][1] ) );
  INVX4M U124 ( .A(n33), .Y(n78) );
  INVX4M U125 ( .A(n32), .Y(n72) );
  INVX4M U126 ( .A(n24), .Y(n73) );
  INVX4M U127 ( .A(n23), .Y(n74) );
  INVX4M U128 ( .A(n22), .Y(n75) );
  NAND2X2M U129 ( .A(product[13]), .B(n71), .Y(n68) );
  NAND2X2M U130 ( .A(n67), .B(n68), .Y(n47) );
  INVX2M U131 ( .A(en_pipe), .Y(n86) );
  NOR2X2M U132 ( .A(n78), .B(n77), .Y(\pp[0][7] ) );
  NOR2X2M U133 ( .A(n78), .B(n76), .Y(\pp[2][7] ) );
  NOR2X2M U134 ( .A(n82), .B(n77), .Y(\pp[0][3] ) );
  NOR2X2M U135 ( .A(n82), .B(n60), .Y(\pp[1][3] ) );
  NOR2X2M U136 ( .A(n81), .B(n77), .Y(\pp[0][4] ) );
  NOR2X2M U137 ( .A(n81), .B(n60), .Y(\pp[1][4] ) );
  NOR2X2M U138 ( .A(n80), .B(n77), .Y(\pp[0][5] ) );
  NOR2X2M U139 ( .A(n80), .B(n60), .Y(\pp[1][5] ) );
  NOR2X2M U140 ( .A(n82), .B(n76), .Y(\pp[2][3] ) );
  ADDFX2M U141 ( .A(\pp[2][4] ), .B(\pp[3][3] ), .CI(
        \add_1_root_add_0_root_add_119/carry[6] ), .CO(
        \add_1_root_add_0_root_add_119/carry[7] ), .S(
        \add_1_root_add_0_root_add_119/SUM[6] ) );
  NOR2X2M U142 ( .A(n82), .B(n1), .Y(\pp[3][3] ) );
  NOR2X2M U143 ( .A(n81), .B(n76), .Y(\pp[2][4] ) );
  NOR2X2M U144 ( .A(n81), .B(n1), .Y(\pp[3][4] ) );
  ADDFX2M U145 ( .A(\pp[2][6] ), .B(\pp[3][5] ), .CI(
        \add_1_root_add_0_root_add_119/carry[8] ), .CO(
        \add_1_root_add_0_root_add_119/carry[9] ), .S(
        \add_1_root_add_0_root_add_119/SUM[8] ) );
  NOR2X2M U146 ( .A(n80), .B(n1), .Y(\pp[3][5] ) );
  NOR2X2M U147 ( .A(n78), .B(n1), .Y(\pp[3][7] ) );
  NOR2X2M U148 ( .A(n78), .B(n60), .Y(\pp[1][7] ) );
  NOR2X2M U149 ( .A(n85), .B(n73), .Y(\pp[6][0] ) );
  NOR2X2M U150 ( .A(n82), .B(n73), .Y(\pp[6][3] ) );
  NOR2X2M U151 ( .A(n81), .B(n73), .Y(\pp[6][4] ) );
  NOR2X2M U152 ( .A(n80), .B(n73), .Y(\pp[6][5] ) );
  NOR2X2M U153 ( .A(n78), .B(n73), .Y(\pp[6][7] ) );
  NOR2X2M U154 ( .A(n85), .B(n74), .Y(\pp[5][0] ) );
  NOR2X2M U155 ( .A(n83), .B(n74), .Y(\pp[5][2] ) );
  NOR2X2M U156 ( .A(n82), .B(n74), .Y(\pp[5][3] ) );
  NOR2X2M U157 ( .A(n81), .B(n74), .Y(\pp[5][4] ) );
  NOR2X2M U158 ( .A(n80), .B(n74), .Y(\pp[5][5] ) );
  NOR2X2M U159 ( .A(n78), .B(n74), .Y(\pp[5][7] ) );
  NOR2X2M U160 ( .A(n82), .B(n75), .Y(\pp[4][3] ) );
  NOR2X2M U161 ( .A(n81), .B(n75), .Y(\pp[4][4] ) );
  NOR2X2M U162 ( .A(n80), .B(n75), .Y(\pp[4][5] ) );
  NOR2X2M U163 ( .A(n78), .B(n75), .Y(\pp[4][7] ) );
  NOR2X2M U164 ( .A(n72), .B(n83), .Y(\pp[7][2] ) );
  NOR2X2M U165 ( .A(n72), .B(n82), .Y(\pp[7][3] ) );
  NOR2X2M U166 ( .A(n72), .B(n81), .Y(\pp[7][4] ) );
  NOR2X2M U167 ( .A(n72), .B(n80), .Y(\pp[7][5] ) );
  NOR2X2M U168 ( .A(n78), .B(n72), .Y(\pp[7][7] ) );
  ADDFX2M U169 ( .A(pp4_pipe[7]), .B(pp5_pipe[6]), .CI(
        \add_3_root_add_0_root_add_158/carry[11] ), .CO(
        \add_3_root_add_0_root_add_158/carry[12] ), .S(\level4[11] ) );
  ADDFX2M U170 ( .A(pp6_pipe[4]), .B(level3_pipe[10]), .CI(
        \add_2_root_add_0_root_add_158/carry[10] ), .CO(
        \add_2_root_add_0_root_add_158/carry[11] ), .S(\level6[10] ) );
  AO22X1M U171 ( .A0(level7[11]), .A1(n70), .B0(product[11]), .B1(n71), .Y(n45) );
  AO22X1M U172 ( .A0(level7[9]), .A1(n70), .B0(product[9]), .B1(n71), .Y(n43)
         );
  AO22X1M U173 ( .A0(level7[10]), .A1(n70), .B0(product[10]), .B1(n71), .Y(n44) );
  AO22X1M U174 ( .A0(level7[8]), .A1(n70), .B0(product[8]), .B1(n71), .Y(n42)
         );
  AO22X1M U175 ( .A0(level7[5]), .A1(n70), .B0(product[5]), .B1(n71), .Y(n39)
         );
  AO22X1M U176 ( .A0(level7[6]), .A1(n70), .B0(product[6]), .B1(n71), .Y(n40)
         );
  AO22X1M U177 ( .A0(level7[7]), .A1(n70), .B0(product[7]), .B1(n71), .Y(n41)
         );
  AO22X1M U178 ( .A0(level7[0]), .A1(n70), .B0(product[0]), .B1(n71), .Y(n34)
         );
  AO22X1M U179 ( .A0(level7[1]), .A1(n70), .B0(product[1]), .B1(n71), .Y(n35)
         );
  AO22X1M U180 ( .A0(level7[2]), .A1(n70), .B0(product[2]), .B1(n86), .Y(n36)
         );
  AO22X1M U181 ( .A0(level7[3]), .A1(n70), .B0(product[3]), .B1(n71), .Y(n37)
         );
  AO22X1M U182 ( .A0(level7[4]), .A1(n70), .B0(product[4]), .B1(n86), .Y(n38)
         );
  INVX2M U183 ( .A(en_pipe), .Y(n69) );
  AND2X1M U184 ( .A(\add_2_root_add_0_root_add_158/carry[13] ), .B(pp6_pipe[7]), .Y(\level6[14] ) );
  CLKXOR2X2M U185 ( .A(level3_pipe[6]), .B(pp6_pipe[0]), .Y(\level5[6] ) );
  AND2X1M U186 ( .A(\add_2_root_add_0_root_add_119/carry[8] ), .B(\pp[1][7] ), 
        .Y(\add_2_root_add_0_root_add_119/SUM[9] ) );
  CLKXOR2X2M U187 ( .A(\pp[1][7] ), .B(
        \add_2_root_add_0_root_add_119/carry[8] ), .Y(
        \add_2_root_add_0_root_add_119/SUM[8] ) );
  AND2X1M U188 ( .A(\add_1_root_add_0_root_add_119/carry[10] ), .B(\pp[3][7] ), 
        .Y(\add_1_root_add_0_root_add_119/SUM[11] ) );
endmodule


module alu8_top ( clk, rst_n, mode, add_en, mul_en, a, b, result, valid );
  input [7:0] a;
  input [7:0] b;
  output [15:0] result;
  input clk, rst_n, mode, add_en, mul_en;
  output valid;
  wire   add_cout, add_valid, mul_valid, n2, n3, n4, n5, n6;
  wire   [7:0] add_sum;
  wire   [15:0] mul_product;

  AO22X8M U2 ( .A0(mul_valid), .A1(n4), .B0(add_valid), .B1(n5), .Y(valid) );
  AO22X8M U4 ( .A0(mul_product[8]), .A1(n4), .B0(add_cout), .B1(n5), .Y(
        result[8]) );
  AO22X8M U5 ( .A0(mul_product[7]), .A1(n4), .B0(add_sum[7]), .B1(n5), .Y(
        result[7]) );
  AO22X8M U6 ( .A0(mul_product[6]), .A1(n4), .B0(add_sum[6]), .B1(n5), .Y(
        result[6]) );
  AO22X8M U7 ( .A0(mul_product[5]), .A1(n4), .B0(add_sum[5]), .B1(n5), .Y(
        result[5]) );
  AO22X8M U8 ( .A0(mul_product[4]), .A1(n4), .B0(add_sum[4]), .B1(n5), .Y(
        result[4]) );
  AO22X8M U9 ( .A0(mul_product[3]), .A1(n4), .B0(add_sum[3]), .B1(n5), .Y(
        result[3]) );
  AO22X8M U10 ( .A0(mul_product[2]), .A1(n4), .B0(add_sum[2]), .B1(n5), .Y(
        result[2]) );
  AO22X8M U11 ( .A0(mul_product[1]), .A1(n4), .B0(add_sum[1]), .B1(n5), .Y(
        result[1]) );
  AO22X8M U18 ( .A0(mul_product[0]), .A1(n4), .B0(add_sum[0]), .B1(n5), .Y(
        result[0]) );
  add_unit u_add ( .clk(clk), .rst_n(rst_n), .en(add_en), .a({a[7:1], n2}), 
        .b({b[7:1], n3}), .sum(add_sum), .cout(add_cout), .valid(add_valid) );
  mult_unit u_mul ( .clk(clk), .rst_n(rst_n), .en(mul_en), .a({a[7:1], n2}), 
        .b({b[7:1], n3}), .product(mul_product), .valid(mul_valid) );
  BUFX20M U20 ( .A(a[0]), .Y(n2) );
  BUFX20M U21 ( .A(b[0]), .Y(n3) );
  CLKBUFX6M U22 ( .A(n6), .Y(n5) );
  INVX2M U23 ( .A(n4), .Y(n6) );
  BUFX10M U24 ( .A(mode), .Y(n4) );
  AND2X8M U25 ( .A(mul_product[9]), .B(n4), .Y(result[9]) );
  AND2X8M U26 ( .A(mul_product[10]), .B(n4), .Y(result[10]) );
  AND2X8M U27 ( .A(mul_product[11]), .B(n4), .Y(result[11]) );
  AND2X8M U28 ( .A(mul_product[12]), .B(n4), .Y(result[12]) );
  AND2X8M U29 ( .A(mul_product[13]), .B(n4), .Y(result[13]) );
  AND2X8M U30 ( .A(mul_product[14]), .B(n4), .Y(result[14]) );
  AND2X8M U31 ( .A(mul_product[15]), .B(n4), .Y(result[15]) );
endmodule

