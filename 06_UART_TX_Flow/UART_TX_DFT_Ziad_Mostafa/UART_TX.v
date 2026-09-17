/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06-SP1
// Date      : Wed Sep  2 03:40:27 2026
/////////////////////////////////////////////////////////////


module uart_fsm_test_1 ( CLK, RST, Data_Valid, ser_done, PAR_EN, ser_en, 
        mux_sel, Busy, test_si, test_so, test_se );
  output [1:0] mux_sel;
  input CLK, RST, Data_Valid, ser_done, PAR_EN, test_si, test_se;
  output ser_en, Busy, test_so;
  wire   current_state_1_, current_state_0_, n9, n10, n11, n12, n13, n7, n8,
         n14, n15, n16, n19, n20;
  wire   [2:0] next_state;

  SDFFRX2M current_state_reg_0_ ( .D(next_state[0]), .SI(test_si), .SE(n19), 
        .CK(CLK), .RN(RST), .Q(current_state_0_), .QN(n8) );
  SDFFRX2M current_state_reg_1_ ( .D(next_state[1]), .SI(n8), .SE(n19), .CK(
        CLK), .RN(RST), .Q(current_state_1_), .QN(n15) );
  SDFFRX2M current_state_reg_2_ ( .D(next_state[2]), .SI(n15), .SE(test_se), 
        .CK(CLK), .RN(RST), .Q(test_so), .QN(n14) );
  NAND3X4M U6 ( .A(n20), .B(n14), .C(current_state_1_), .Y(n10) );
  OAI211X2M U7 ( .A0(current_state_1_), .A1(current_state_0_), .B0(n11), .C0(
        n14), .Y(mux_sel[0]) );
  OAI32X2M U8 ( .A0(n8), .A1(test_so), .A2(current_state_1_), .B0(n12), .B1(
        n10), .Y(next_state[1]) );
  NAND3XLM U9 ( .A(n8), .B(n15), .C(Data_Valid), .Y(n13) );
  OAI31X2M U13 ( .A0(n7), .A1(PAR_EN), .A2(n10), .B0(n11), .Y(next_state[2])
         );
  OAI31X2M U14 ( .A0(n16), .A1(n10), .A2(n7), .B0(n13), .Y(next_state[0]) );
  INVX2M U15 ( .A(PAR_EN), .Y(n16) );
  AO21X4M U16 ( .A0(n15), .A1(n9), .B0(mux_sel[1]), .Y(Busy) );
  NAND2X2M U17 ( .A(n10), .B(n11), .Y(mux_sel[1]) );
  INVX2M U18 ( .A(ser_done), .Y(n7) );
  NOR3X2M U19 ( .A(n15), .B(current_state_0_), .C(n9), .Y(ser_en) );
  NOR2X2M U20 ( .A(PAR_EN), .B(n7), .Y(n12) );
  XNOR2X4M U21 ( .A(n8), .B(test_so), .Y(n9) );
  NAND3X2M U22 ( .A(current_state_0_), .B(n14), .C(current_state_1_), .Y(n11)
         );
  DLY1X1M U23 ( .A(test_se), .Y(n19) );
  INVXLM U24 ( .A(current_state_0_), .Y(n20) );
endmodule


module uart_serializer_test_1 ( CLK, RST, P_DATA, ser_en, Data_Valid, Busy, 
        ser_done, ser_data, test_si, test_so, test_se );
  input [7:0] P_DATA;
  input CLK, RST, ser_en, Data_Valid, Busy, test_si, test_se;
  output ser_done, ser_data, test_so;
  wire   n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n47, n48, n49, n50,
         n51, n52, n55, n56, n57, n58, n59, n60, n61, n63, n64, n65, n66, n67,
         n68, n69, n70, n71;
  wire   [7:1] shift_reg;
  wire   [2:0] bit_cnt;

  SDFFRX1M shift_reg_reg_6_ ( .D(n35), .SI(n56), .SE(n65), .CK(CLK), .RN(RST), 
        .Q(shift_reg[6]), .QN(n55) );
  SDFFRX1M shift_reg_reg_5_ ( .D(n36), .SI(n57), .SE(n64), .CK(CLK), .RN(RST), 
        .Q(shift_reg[5]), .QN(n56) );
  SDFFRX1M shift_reg_reg_4_ ( .D(n37), .SI(n58), .SE(n65), .CK(CLK), .RN(RST), 
        .Q(shift_reg[4]), .QN(n57) );
  SDFFRX1M shift_reg_reg_3_ ( .D(n38), .SI(n59), .SE(n71), .CK(CLK), .RN(RST), 
        .Q(shift_reg[3]), .QN(n58) );
  SDFFRX1M shift_reg_reg_2_ ( .D(n39), .SI(n60), .SE(n64), .CK(CLK), .RN(RST), 
        .Q(shift_reg[2]), .QN(n59) );
  SDFFRX1M shift_reg_reg_1_ ( .D(n40), .SI(n61), .SE(n71), .CK(CLK), .RN(RST), 
        .Q(shift_reg[1]), .QN(n60) );
  SDFFRX1M shift_reg_reg_0_ ( .D(n33), .SI(bit_cnt[2]), .SE(n69), .CK(CLK), 
        .RN(RST), .Q(ser_data), .QN(n61) );
  SDFFRX1M shift_reg_reg_7_ ( .D(n34), .SI(n55), .SE(n70), .CK(CLK), .RN(RST), 
        .Q(shift_reg[7]), .QN(test_so) );
  SDFFRX1M bit_cnt_reg_2_ ( .D(n30), .SI(bit_cnt[1]), .SE(n69), .CK(CLK), .RN(
        RST), .Q(bit_cnt[2]), .QN(n50) );
  SDFFRX2M bit_cnt_reg_1_ ( .D(n31), .SI(bit_cnt[0]), .SE(n68), .CK(CLK), .RN(
        RST), .Q(bit_cnt[1]), .QN(n49) );
  SDFFRX2M bit_cnt_reg_0_ ( .D(n32), .SI(test_si), .SE(n68), .CK(CLK), .RN(RST), .Q(bit_cnt[0]), .QN(n48) );
  OAI32X2M U14 ( .A0(n48), .A1(bit_cnt[1]), .A2(n18), .B0(n20), .B1(n49), .Y(
        n31) );
  NOR3X2M U15 ( .A(n50), .B(n48), .C(n49), .Y(ser_done) );
  INVX4M U27 ( .A(n29), .Y(n51) );
  NAND2X2M U28 ( .A(ser_en), .B(n29), .Y(n18) );
  CLKBUFX6M U29 ( .A(n21), .Y(n47) );
  NOR2X2M U30 ( .A(n51), .B(n52), .Y(n21) );
  AOI21X2M U31 ( .A0(n48), .A1(n52), .B0(n47), .Y(n20) );
  NAND2BX2M U32 ( .AN(Busy), .B(Data_Valid), .Y(n29) );
  INVX6M U33 ( .A(n18), .Y(n52) );
  OAI2BB2X1M U34 ( .B0(bit_cnt[0]), .B1(n18), .A0N(bit_cnt[0]), .A1N(n47), .Y(
        n32) );
  OAI2BB1X2M U35 ( .A0N(n47), .A1N(shift_reg[6]), .B0(n23), .Y(n35) );
  AOI22X1M U36 ( .A0(P_DATA[6]), .A1(n51), .B0(shift_reg[7]), .B1(n52), .Y(n23) );
  OAI2BB1X2M U37 ( .A0N(n47), .A1N(shift_reg[2]), .B0(n27), .Y(n39) );
  AOI22X1M U38 ( .A0(P_DATA[2]), .A1(n51), .B0(shift_reg[3]), .B1(n52), .Y(n27) );
  OAI2BB1X2M U39 ( .A0N(n47), .A1N(shift_reg[3]), .B0(n26), .Y(n38) );
  AOI22X1M U40 ( .A0(P_DATA[3]), .A1(n51), .B0(shift_reg[4]), .B1(n52), .Y(n26) );
  OAI2BB1X2M U41 ( .A0N(ser_data), .A1N(n47), .B0(n22), .Y(n33) );
  AOI22X1M U42 ( .A0(P_DATA[0]), .A1(n51), .B0(shift_reg[1]), .B1(n52), .Y(n22) );
  OAI2BB1X2M U43 ( .A0N(n47), .A1N(shift_reg[4]), .B0(n25), .Y(n37) );
  AOI22X1M U44 ( .A0(P_DATA[4]), .A1(n51), .B0(shift_reg[5]), .B1(n52), .Y(n25) );
  OAI2BB1X2M U45 ( .A0N(n47), .A1N(shift_reg[1]), .B0(n28), .Y(n40) );
  AOI22X1M U46 ( .A0(P_DATA[1]), .A1(n51), .B0(shift_reg[2]), .B1(n52), .Y(n28) );
  OAI2BB1X2M U47 ( .A0N(n47), .A1N(shift_reg[5]), .B0(n24), .Y(n36) );
  AOI22X1M U48 ( .A0(P_DATA[5]), .A1(n51), .B0(shift_reg[6]), .B1(n52), .Y(n24) );
  AO22X1M U49 ( .A0(n47), .A1(shift_reg[7]), .B0(P_DATA[7]), .B1(n51), .Y(n34)
         );
  OAI32X2M U50 ( .A0(n17), .A1(bit_cnt[2]), .A2(n18), .B0(n19), .B1(n50), .Y(
        n30) );
  NAND2X2M U51 ( .A(bit_cnt[1]), .B(bit_cnt[0]), .Y(n17) );
  AOI21BX2M U52 ( .A0(n52), .A1(n49), .B0N(n20), .Y(n19) );
  DLY1X1M U53 ( .A(n66), .Y(n63) );
  DLY1X1M U54 ( .A(n70), .Y(n64) );
  DLY1X1M U55 ( .A(n66), .Y(n65) );
  DLY1X1M U56 ( .A(test_se), .Y(n66) );
  DLY1X1M U57 ( .A(test_se), .Y(n67) );
  DLY1X1M U58 ( .A(n67), .Y(n68) );
  DLY1X1M U59 ( .A(n63), .Y(n69) );
  DLY1X1M U60 ( .A(n67), .Y(n70) );
  DLY1X1M U61 ( .A(n63), .Y(n71) );
endmodule


module uart_parity_calc_test_1 ( CLK, RST, P_DATA, Data_Valid, PAR_TYP, PAR_EN, 
        Busy, par_bit, test_si, test_so, test_se );
  input [7:0] P_DATA;
  input CLK, RST, Data_Valid, PAR_TYP, PAR_EN, Busy, test_si, test_se;
  output par_bit, test_so;
  wire   n1, n2, n3, n4, n5, n6, n8;

  SDFFRX1M parity_reg_reg ( .D(n8), .SI(test_si), .SE(test_se), .CK(CLK), .RN(
        RST), .Q(par_bit), .QN(test_so) );
  OAI2BB2X1M U3 ( .B0(n1), .B1(n2), .A0N(par_bit), .A1N(n2), .Y(n8) );
  NAND3BX2M U4 ( .AN(Busy), .B(Data_Valid), .C(PAR_EN), .Y(n2) );
  XOR3XLM U5 ( .A(n3), .B(PAR_TYP), .C(n4), .Y(n1) );
  XOR3XLM U6 ( .A(P_DATA[1]), .B(P_DATA[0]), .C(n5), .Y(n4) );
  XOR3XLM U7 ( .A(P_DATA[5]), .B(P_DATA[4]), .C(n6), .Y(n3) );
  CLKXOR2X2M U8 ( .A(P_DATA[7]), .B(P_DATA[6]), .Y(n6) );
  XNOR2X2M U10 ( .A(P_DATA[3]), .B(P_DATA[2]), .Y(n5) );
endmodule


module uart_mux_test_1 ( CLK, RST, mux_sel, ser_data, par_bit, TX_OUT, test_si, 
        test_se );
  input [1:0] mux_sel;
  input CLK, RST, ser_data, par_bit, test_si, test_se;
  output TX_OUT;
  wire   N13, n3, n4, n2;

  SDFFSQX2M TX_OUT_reg ( .D(N13), .SI(test_si), .SE(test_se), .CK(CLK), .SN(
        RST), .Q(TX_OUT) );
  OAI21X2M U4 ( .A0(n3), .A1(n2), .B0(n4), .Y(N13) );
  NAND3X2M U5 ( .A(mux_sel[1]), .B(n2), .C(ser_data), .Y(n4) );
  INVX2M U6 ( .A(mux_sel[0]), .Y(n2) );
  NOR2BX2M U7 ( .AN(mux_sel[1]), .B(par_bit), .Y(n3) );
endmodule


module UART_TX ( CLK, RST, PAR_TYP, PAR_EN, P_DATA, DATA_VALID, SI, SE, 
        scan_clk, scan_rst, test_mode, SO, TX_OUT, Busy );
  input [7:0] P_DATA;
  input CLK, RST, PAR_TYP, PAR_EN, DATA_VALID, SI, SE, scan_clk, scan_rst,
         test_mode;
  output SO, TX_OUT, Busy;
  wire   clk_mux, rst_mux, ser_done, ser_en, ser_data, par_bit, n3, n4, n6, n7,
         n8, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20;
  wire   [1:0] mux_sel;

  INVX2M U4 ( .A(TX_OUT), .Y(SO) );
  MX2X8M U6 ( .A(RST), .B(scan_rst), .S0(test_mode), .Y(rst_mux) );
  BUFX2M U7 ( .A(PAR_EN), .Y(n4) );
  BUFX2M U8 ( .A(DATA_VALID), .Y(n3) );
  MX2X6M U9 ( .A(CLK), .B(scan_clk), .S0(test_mode), .Y(clk_mux) );
  DLY1X1M U10 ( .A(n16), .Y(n10) );
  DLY1X1M U11 ( .A(n14), .Y(n11) );
  DLY1X1M U12 ( .A(n15), .Y(n12) );
  DLY1X1M U13 ( .A(n18), .Y(n13) );
  INVXLM U14 ( .A(SE), .Y(n14) );
  INVXLM U15 ( .A(SE), .Y(n15) );
  DLY1X1M U16 ( .A(n17), .Y(n16) );
  INVXLM U17 ( .A(n11), .Y(n17) );
  INVXLM U18 ( .A(n12), .Y(n18) );
  INVXLM U19 ( .A(n11), .Y(n19) );
  INVXLM U20 ( .A(n12), .Y(n20) );
  uart_fsm_test_1 u_fsm ( .CLK(clk_mux), .RST(rst_mux), .Data_Valid(n3), 
        .ser_done(ser_done), .PAR_EN(n4), .ser_en(ser_en), .mux_sel(mux_sel), 
        .Busy(Busy), .test_si(SI), .test_so(n8), .test_se(n13) );
  uart_serializer_test_1 u_serializer ( .CLK(clk_mux), .RST(rst_mux), .P_DATA(
        P_DATA), .ser_en(ser_en), .Data_Valid(n3), .Busy(Busy), .ser_done(
        ser_done), .ser_data(ser_data), .test_si(n7), .test_so(n6), .test_se(
        n10) );
  uart_parity_calc_test_1 u_parity_calc ( .CLK(clk_mux), .RST(rst_mux), 
        .P_DATA(P_DATA), .Data_Valid(n3), .PAR_TYP(PAR_TYP), .PAR_EN(n4), 
        .Busy(Busy), .par_bit(par_bit), .test_si(n8), .test_so(n7), .test_se(
        n19) );
  uart_mux_test_1 u_mux ( .CLK(clk_mux), .RST(rst_mux), .mux_sel(mux_sel), 
        .ser_data(ser_data), .par_bit(par_bit), .TX_OUT(TX_OUT), .test_si(n6), 
        .test_se(n20) );
endmodule

