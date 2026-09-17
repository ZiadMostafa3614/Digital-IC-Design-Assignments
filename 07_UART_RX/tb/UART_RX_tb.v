// ************************************************************* //
// Author : Ziad Mostafa Abdelaziz
// ************************************************************* //

`timescale 1ns/1fs    // precision must be equivalent to number of points in clock to avoid simulation infinite loop since the timing results from division might lead to rounding effects, which can cause timing mismatches.

module UART_RX_tb ();

///////////////////////////////////////////////////////////////
//////////////////////// DUT Signals //////////////////////////
///////////////////////////////////////////////////////////////

reg				  CLK_tb;
reg				  RST_tb;
reg				  RX_IN_tb;
reg		[5:0]	Prescale_tb;
reg				  PAR_EN_tb;
reg				  PAR_TYP_tb;
wire			  data_valid_tb;
wire	[7:0]	P_DATA_tb;	

parameter TX_CLK_PERIOD = 8680.555;

///////////////////////////////////////////////////////////////
//////////////////////// Initial Block ////////////////////////
///////////////////////////////////////////////////////////////

initial 
 begin
 	// System functions
 	$dumpfile("UART_RX.vcd");
 	$dumpvars;

 	// Initialize the signals
 	initialize();

 	//////////////////////////////////////////////////// Prescale = 8 ////////////////////////////////////////////////////////////////////////

 	check_frame (11'b1_0_1011_1101_0,     'd8,      1'b1,   1'b0,      1, "Prescale = 8 | Parity is enabled & Parity Type is even = 0");

 	check_frame (11'b1_1_1111_1000_0,     'd8,      1'b1,   1'b0,      2, "Prescale = 8 | Parity is enabled & Parity Type is even = 1");

 	check_frame (11'b1_0_1000_1001_0,     'd8,      1'b1,   1'b1,      3, "Prescale = 8 | Parity is enabled & Parity Type is odd = 0");

 	check_frame (11'b1_1_0111_1000_0,     'd8,      1'b1,   1'b1,      4, "Prescale = 8 | Parity is enabled & Parity Type is odd = 1");

 	check_frame (10'b1_0111_1100_0,       'd8,      1'b0,   1'b0,      5, "Prescale = 8 | Parity is not enabled");

 	consecutive_frames (10'b1_0111_1100_0,  10'b1_0011_1111_0,        'd8,         'd8,       1'b0,      1'b0,       1'b0,       1'b0,         6, "Consecutive frames | Prescale = 8 | Parity is not enabled");

 	consecutive_frames (10'b1_0111_1100_0,  11'b1_0_0011_1111_0,      'd8,         'd8,       1'b0,      1'b1,       1'b0,       1'b0,         7, "Consecutive frames | Prescale = 8 | Parity is not enabled for frame 1 | Parity is enabled and even for frame 2");

 	//////////////////////////////////////////////////// Prescale = 16 ////////////////////////////////////////////////////////////////////////

 	check_frame (11'b1_0_1011_1101_0,     'd16,      1'b1,   1'b0,     8,  "Prescale = 16 | Parity is enabled & Parity Type is even = 0");

 	check_frame (11'b1_1_1111_1000_0,     'd16,      1'b1,   1'b0,     9,  "Prescale = 16 | Parity is enabled & Parity Type is even = 1");

 	check_frame (11'b1_0_1000_1001_0,     'd16,      1'b1,   1'b1,     10,  "Prescale = 16 | Parity is enabled & Parity Type is odd = 0");

 	check_frame (11'b1_1_0111_1000_0,     'd16,      1'b1,   1'b1,     11,  "Prescale = 16 | Parity is enabled & Parity Type is odd = 1");

 	check_frame (10'b1_0111_1100_0,       'd16,      1'b0,   1'b0,     12, "Prescale = 16 | Parity is not enabled");

 	consecutive_frames (10'b1_0111_1100_0,  10'b1_0011_1111_0,        'd16,         'd16,       1'b0,      1'b0,       1'b0,       1'b0,         13, "Consecutive frames | Prescale = 16 | Parity is not enabled");

 	//////////////////////////////////////////////////// Prescale = 32 ////////////////////////////////////////////////////////////////////////

 	check_frame (11'b1_0_1011_1101_0,     'd32,      1'b1,   1'b0,     14,  "Prescale = 32 | Parity is enabled & Parity Type is even = 0");

 	check_frame (11'b1_1_1111_1000_0,     'd32,      1'b1,   1'b0,     15,  "Prescale = 32 | Parity is enabled & Parity Type is even = 1");

 	check_frame (11'b1_0_1000_1001_0,     'd32,      1'b1,   1'b1,     16,  "Prescale = 32 | Parity is enabled & Parity Type is odd = 0");

 	check_frame (11'b1_1_0111_1000_0,     'd32,      1'b1,   1'b1,     17,  "Prescale = 32 | Parity is enabled & Parity Type is odd = 1");

 	check_frame (10'b1_0111_1100_0,       'd32,      1'b0,   1'b0,     18, "Prescale = 32 | Parity is not enabled");

 	consecutive_frames (10'b1_0111_1100_0,  10'b1_0011_1111_0,        'd32,         'd32,       1'b0,      1'b0,       1'b0,       1'b0,         19, "Consecutive frames | Prescale = 32 | Parity is not enabled");

 	$stop;

 end

///////////////////////////////////////////////////////////////
/////////////////////////// Tasks /////////////////////////////
///////////////////////////////////////////////////////////////

task reset;
 begin
 	RST_tb = 1'b1;
    #(TX_CLK_PERIOD/Prescale_tb)
 	RST_tb = 1'b0;
    #(TX_CLK_PERIOD/Prescale_tb)
 	RST_tb = 1'b1;
 end
endtask

task initialize;
 begin
 	CLK_tb = 1'b0;
    Prescale_tb = 6'd8;
    RX_IN_tb = 1'b1;
    PAR_EN_tb = 1'b0;
    PAR_TYP_tb = 1'b0;
 	reset();
    #((TX_CLK_PERIOD/Prescale_tb));
 end
endtask

task check_frame;

 input 	[10:0]	RX_IN_task;
 input	[5:0] 	Prescale_task;
 input 			    PAR_EN_task;
 input			    PAR_TYP_task;
 input integer 	test_case_no;
 input [511:0] 	test_case;
 
 integer		frame_size;
 integer 		i;

 begin

 	@(negedge CLK_tb)
 	Prescale_tb = Prescale_task;
 	PAR_EN_tb 	= PAR_EN_task;
 	PAR_TYP_tb 	= PAR_TYP_task;
 	if (PAR_EN_tb)
 	 frame_size = 11;
 	else begin
 	 frame_size = 10;
 	end

 	for (i=0; i<frame_size; i=i+1)
 	 begin
 	 	@(posedge CLK_tb) RX_IN_tb = RX_IN_task[i];
        #(TX_CLK_PERIOD);
 	 end

 	@(posedge data_valid_tb)
 	if (P_DATA_tb == RX_IN_task[8:1])
 	 begin
 	 	$display("TEST CASE %0d Passed: (%0s)", test_case_no, test_case);
 	 end
 	else
 	 begin
 	 	$display("TEST CASE %0d Failed: (%0s) expected %b and got %b", test_case_no, test_case, RX_IN_task[8:1], P_DATA_tb);
 	 end

    #(TX_CLK_PERIOD);

 end

endtask

task consecutive_frames;

  input  [10:0] RX_IN_frame1;
  input  [10:0] RX_IN_frame2;
  input  [5:0]  Prescale_task1;
  input  [5:0]  Prescale_task2;
  input         PAR_EN_task1;
  input         PAR_EN_task2;
  input         PAR_TYP_task1;
  input         PAR_TYP_task2;
  input integer test_case_no;
  input [1023:0] test_case;

  integer i;
  integer frame_size_1;
  integer frame_size_2;

  begin

  	$display("TEST CASE %0d : (%0s)", test_case_no, test_case);

  @(negedge CLK_tb)
 	Prescale_tb = Prescale_task1;
 	PAR_EN_tb 	= PAR_EN_task1;
 	PAR_TYP_tb 	= PAR_TYP_task1;
 	if (PAR_EN_tb)
 	 frame_size_1 = 11;
 	else begin
 	 frame_size_1 = 10;
 	end

 	for (i=0; i<frame_size_1; i=i+1)
 	 begin
 	 	@(posedge CLK_tb) RX_IN_tb = RX_IN_frame1[i];
        #(TX_CLK_PERIOD);
 	 end

 	@(posedge data_valid_tb)
 	RX_IN_tb = RX_IN_frame2[0];
 	if (P_DATA_tb == RX_IN_frame1[8:1])
 	 begin
 	 	$display("frame 1 Passed");
 	 end
 	else
 	 begin
 	 	$display("frame 1 Failed: expected %b and got %b", RX_IN_frame1[8:1], P_DATA_tb);
 	 end

 	Prescale_tb = Prescale_task2;
 	PAR_EN_tb 	= PAR_EN_task2;
 	PAR_TYP_tb 	= PAR_TYP_task2;
 	if (PAR_EN_tb)
 	 frame_size_2 = 11;
 	else begin
 	 frame_size_2 = 10;
 	end

    #(TX_CLK_PERIOD);
 	for (i=1; i<frame_size_2; i=i+1)
 	 begin
 	 	@(posedge CLK_tb) RX_IN_tb = RX_IN_frame2[i];
        #(TX_CLK_PERIOD);
 	 end

 	@(posedge data_valid_tb)
 	if (P_DATA_tb == RX_IN_frame2[8:1])
 	 begin
 	 	$display("frame 2 Passed");
 	 end
 	else
 	 begin
 	 	$display("frame 2 Failed: expected %b and got %b", RX_IN_frame2[8:1], P_DATA_tb);
 	 end

  end

endtask

always #(TX_CLK_PERIOD/Prescale_tb/2) CLK_tb = ~CLK_tb; 

UART_RX DUT (
	.CLK(CLK_tb),
	.RST(RST_tb),
	.RX_IN(RX_IN_tb),
	.Prescale(Prescale_tb),
	.PAR_EN(PAR_EN_tb),
	.PAR_TYP(PAR_TYP_tb),
	.data_valid(data_valid_tb),
	.P_DATA(P_DATA_tb)
	);

endmodule