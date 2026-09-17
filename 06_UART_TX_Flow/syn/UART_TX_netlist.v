/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06-SP1
// Date      : Wed Sep  2 03:39:27 2026
/////////////////////////////////////////////////////////////


module uart_fsm ( CLK, RST, Data_Valid, ser_done, PAR_EN, ser_en, mux_sel, 
        Busy );
  output [1:0] mux_sel;
  input CLK, RST, Data_Valid, ser_done, PAR_EN;
  output ser_en, Busy;
  wire   n14, n8, n9, n10, n11, n12, n2, n3, n4, n5, n6, n7, n13;
  wire   [2:0] current_state;
  wire   [2:0] next_state;

  DFFRX1M \current_state_reg[1]  ( .D(next_state[1]), .CK(CLK), .RN(RST), .Q(
        current_state[1]), .QN(n6) );
  DFFRX2M \current_state_reg[0]  ( .D(next_state[0]), .CK(CLK), .RN(RST), .Q(
        current_state[0]) );
  DFFRX2M \current_state_reg[2]  ( .D(next_state[2]), .CK(CLK), .RN(RST), .Q(
        current_state[2]), .QN(n7) );
  OAI211X1M U3 ( .A0(n3), .A1(n7), .B0(n10), .C0(n4), .Y(n14) );
  NAND3X1M U4 ( .A(n6), .B(n7), .C(current_state[0]), .Y(n10) );
  BUFX10M U5 ( .A(n14), .Y(Busy) );
  NOR3X4M U6 ( .A(current_state[0]), .B(current_state[2]), .C(n6), .Y(ser_en)
         );
  NOR2X2M U7 ( .A(current_state[0]), .B(current_state[1]), .Y(n12) );
  NAND3X2M U8 ( .A(current_state[1]), .B(n7), .C(current_state[0]), .Y(n8) );
  INVX2M U9 ( .A(mux_sel[1]), .Y(n4) );
  INVX2M U10 ( .A(ser_en), .Y(n5) );
  NAND2X2M U11 ( .A(n5), .B(n8), .Y(mux_sel[1]) );
  INVX2M U12 ( .A(n12), .Y(n3) );
  OAI31X2M U13 ( .A0(n13), .A1(n5), .A2(n2), .B0(n11), .Y(next_state[0]) );
  NAND2X2M U14 ( .A(Data_Valid), .B(n12), .Y(n11) );
  INVX2M U15 ( .A(PAR_EN), .Y(n13) );
  OAI31X2M U16 ( .A0(n2), .A1(PAR_EN), .A2(n5), .B0(n8), .Y(next_state[2]) );
  OAI21X2M U17 ( .A0(n9), .A1(n5), .B0(n10), .Y(next_state[1]) );
  NOR2X2M U18 ( .A(PAR_EN), .B(n2), .Y(n9) );
  INVX2M U19 ( .A(ser_done), .Y(n2) );
  NAND3X2M U20 ( .A(n3), .B(n7), .C(n8), .Y(mux_sel[0]) );
endmodule


module uart_serializer ( CLK, RST, P_DATA, ser_en, Data_Valid, Busy, ser_done, 
        ser_data );
  input [7:0] P_DATA;
  input CLK, RST, ser_en, Data_Valid, Busy;
  output ser_done, ser_data;
  wire   N25, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n1, n2, n3, n4, n5,
         n30;
  wire   [7:1] shift_reg;
  wire   [2:0] bit_cnt;
  assign ser_done = N25;

  DFFRX1M \shift_reg_reg[6]  ( .D(n24), .CK(CLK), .RN(RST), .Q(shift_reg[6])
         );
  DFFRX1M \shift_reg_reg[5]  ( .D(n25), .CK(CLK), .RN(RST), .Q(shift_reg[5])
         );
  DFFRX1M \shift_reg_reg[4]  ( .D(n26), .CK(CLK), .RN(RST), .Q(shift_reg[4])
         );
  DFFRX1M \shift_reg_reg[3]  ( .D(n27), .CK(CLK), .RN(RST), .Q(shift_reg[3])
         );
  DFFRX1M \shift_reg_reg[2]  ( .D(n28), .CK(CLK), .RN(RST), .Q(shift_reg[2])
         );
  DFFRX1M \shift_reg_reg[1]  ( .D(n29), .CK(CLK), .RN(RST), .Q(shift_reg[1])
         );
  DFFRX1M \shift_reg_reg[0]  ( .D(n22), .CK(CLK), .RN(RST), .Q(ser_data) );
  DFFRX1M \shift_reg_reg[7]  ( .D(n23), .CK(CLK), .RN(RST), .Q(shift_reg[7])
         );
  DFFRX1M \bit_cnt_reg[2]  ( .D(n19), .CK(CLK), .RN(RST), .Q(bit_cnt[2]), .QN(
        n4) );
  DFFRX2M \bit_cnt_reg[0]  ( .D(n21), .CK(CLK), .RN(RST), .Q(bit_cnt[0]), .QN(
        n2) );
  DFFRX2M \bit_cnt_reg[1]  ( .D(n20), .CK(CLK), .RN(RST), .Q(bit_cnt[1]), .QN(
        n3) );
  OAI32X2M U3 ( .A0(n2), .A1(bit_cnt[1]), .A2(n7), .B0(n9), .B1(n3), .Y(n20)
         );
  NOR3X2M U4 ( .A(n4), .B(n2), .C(n3), .Y(N25) );
  NAND2BX1M U5 ( .AN(Busy), .B(Data_Valid), .Y(n18) );
  INVX4M U6 ( .A(n18), .Y(n5) );
  NAND2X2M U7 ( .A(ser_en), .B(n18), .Y(n7) );
  CLKBUFX6M U8 ( .A(n10), .Y(n1) );
  NOR2X2M U9 ( .A(n5), .B(n30), .Y(n10) );
  INVX6M U10 ( .A(n7), .Y(n30) );
  AOI21X2M U11 ( .A0(n2), .A1(n30), .B0(n1), .Y(n9) );
  OAI32X2M U12 ( .A0(n6), .A1(bit_cnt[2]), .A2(n7), .B0(n8), .B1(n4), .Y(n19)
         );
  NAND2X2M U13 ( .A(bit_cnt[1]), .B(bit_cnt[0]), .Y(n6) );
  AOI21BX2M U14 ( .A0(n30), .A1(n3), .B0N(n9), .Y(n8) );
  OAI2BB2X1M U15 ( .B0(bit_cnt[0]), .B1(n7), .A0N(bit_cnt[0]), .A1N(n1), .Y(
        n21) );
  OAI2BB1X2M U16 ( .A0N(n1), .A1N(shift_reg[6]), .B0(n12), .Y(n24) );
  AOI22X1M U17 ( .A0(P_DATA[6]), .A1(n5), .B0(shift_reg[7]), .B1(n30), .Y(n12)
         );
  OAI2BB1X2M U18 ( .A0N(n1), .A1N(shift_reg[2]), .B0(n16), .Y(n28) );
  AOI22X1M U19 ( .A0(P_DATA[2]), .A1(n5), .B0(shift_reg[3]), .B1(n30), .Y(n16)
         );
  OAI2BB1X2M U20 ( .A0N(n1), .A1N(shift_reg[3]), .B0(n15), .Y(n27) );
  AOI22X1M U21 ( .A0(P_DATA[3]), .A1(n5), .B0(shift_reg[4]), .B1(n30), .Y(n15)
         );
  OAI2BB1X2M U22 ( .A0N(ser_data), .A1N(n1), .B0(n11), .Y(n22) );
  AOI22X1M U23 ( .A0(P_DATA[0]), .A1(n5), .B0(shift_reg[1]), .B1(n30), .Y(n11)
         );
  OAI2BB1X2M U24 ( .A0N(n1), .A1N(shift_reg[4]), .B0(n14), .Y(n26) );
  AOI22X1M U25 ( .A0(P_DATA[4]), .A1(n5), .B0(shift_reg[5]), .B1(n30), .Y(n14)
         );
  OAI2BB1X2M U26 ( .A0N(n1), .A1N(shift_reg[1]), .B0(n17), .Y(n29) );
  AOI22X1M U27 ( .A0(P_DATA[1]), .A1(n5), .B0(shift_reg[2]), .B1(n30), .Y(n17)
         );
  OAI2BB1X2M U28 ( .A0N(n1), .A1N(shift_reg[5]), .B0(n13), .Y(n25) );
  AOI22X1M U29 ( .A0(P_DATA[5]), .A1(n5), .B0(shift_reg[6]), .B1(n30), .Y(n13)
         );
  AO22X1M U30 ( .A0(n1), .A1(shift_reg[7]), .B0(P_DATA[7]), .B1(n5), .Y(n23)
         );
endmodule


module uart_parity_calc ( CLK, RST, P_DATA, Data_Valid, PAR_TYP, PAR_EN, Busy, 
        par_bit );
  input [7:0] P_DATA;
  input CLK, RST, Data_Valid, PAR_TYP, PAR_EN, Busy;
  output par_bit;
  wire   n1, n2, n3, n4, n5, n6, n7;

  DFFRX1M parity_reg_reg ( .D(n7), .CK(CLK), .RN(RST), .Q(par_bit) );
  XNOR2X2M U2 ( .A(P_DATA[3]), .B(P_DATA[2]), .Y(n5) );
  OAI2BB2X1M U3 ( .B0(n1), .B1(n2), .A0N(par_bit), .A1N(n2), .Y(n7) );
  NAND3BX1M U4 ( .AN(Busy), .B(Data_Valid), .C(PAR_EN), .Y(n2) );
  XOR3XLM U5 ( .A(n3), .B(PAR_TYP), .C(n4), .Y(n1) );
  XOR3XLM U6 ( .A(P_DATA[1]), .B(P_DATA[0]), .C(n5), .Y(n4) );
  XOR3XLM U7 ( .A(P_DATA[5]), .B(P_DATA[4]), .C(n6), .Y(n3) );
  CLKXOR2X2M U8 ( .A(P_DATA[7]), .B(P_DATA[6]), .Y(n6) );
endmodule


module uart_mux ( CLK, RST, mux_sel, ser_data, par_bit, TX_OUT );
  input [1:0] mux_sel;
  input CLK, RST, ser_data, par_bit;
  output TX_OUT;
  wire   N13, n2, n3, n1;

  DFFSHQX8M TX_OUT_reg ( .D(N13), .CK(CLK), .SN(RST), .Q(TX_OUT) );
  OAI21X2M U3 ( .A0(n2), .A1(n1), .B0(n3), .Y(N13) );
  NAND3X2M U4 ( .A(mux_sel[1]), .B(n1), .C(ser_data), .Y(n3) );
  NOR2BX2M U5 ( .AN(mux_sel[1]), .B(par_bit), .Y(n2) );
  INVX2M U6 ( .A(mux_sel[0]), .Y(n1) );
endmodule


module UART_TX ( CLK, RST, PAR_TYP, PAR_EN, P_DATA, DATA_VALID, SI, SE, 
        scan_clk, scan_rst, test_mode, SO, TX_OUT, Busy );
  input [7:0] P_DATA;
  input CLK, RST, PAR_TYP, PAR_EN, DATA_VALID, SI, SE, scan_clk, scan_rst,
         test_mode;
  output SO, TX_OUT, Busy;
  wire   clk_mux, rst_mux, ser_done, ser_en, ser_data, par_bit;
  wire   [1:0] mux_sel;
  assign SO = 1'b0;

  uart_fsm u_fsm ( .CLK(clk_mux), .RST(rst_mux), .Data_Valid(DATA_VALID), 
        .ser_done(ser_done), .PAR_EN(PAR_EN), .ser_en(ser_en), .mux_sel(
        mux_sel), .Busy(Busy) );
  uart_serializer u_serializer ( .CLK(clk_mux), .RST(rst_mux), .P_DATA(P_DATA), 
        .ser_en(ser_en), .Data_Valid(DATA_VALID), .Busy(Busy), .ser_done(
        ser_done), .ser_data(ser_data) );
  uart_parity_calc u_parity_calc ( .CLK(clk_mux), .RST(rst_mux), .P_DATA(
        P_DATA), .Data_Valid(DATA_VALID), .PAR_TYP(PAR_TYP), .PAR_EN(PAR_EN), 
        .Busy(Busy), .par_bit(par_bit) );
  uart_mux u_mux ( .CLK(clk_mux), .RST(rst_mux), .mux_sel(mux_sel), .ser_data(
        ser_data), .par_bit(par_bit), .TX_OUT(TX_OUT) );
  MX2X8M U4 ( .A(RST), .B(scan_rst), .S0(test_mode), .Y(rst_mux) );
  MX2X6M U5 ( .A(CLK), .B(scan_clk), .S0(test_mode), .Y(clk_mux) );
endmodule

