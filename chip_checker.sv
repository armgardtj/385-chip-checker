module chip_checker(	input logic [9:0] SW,
	input logic	Clk, Reset, Run,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	inout logic Pin16,
	inout logic Pin15,
	inout logic Pin14,
	inout logic Pin13,
	inout logic Pin12,
	inout logic Pin11,
	inout logic Pin10,
	inout logic Pin9,
	inout logic Pin8,
	inout logic Pin7,
	inout logic Pin6,
	inout logic Pin5,
	inout logic Pin4,
	inout logic Pin3,
	inout logic Pin2,
	inout logic Pin1
	);
	
logic [16:0] io;

//bit [3:0] [15:0] io  = {
//{1'b1,1'b1,1'b0,1'b1,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1,1'b0,1'b1,1'b0,1'b0},
//{1'b1,1'b0,1'b1,1'b1,1'b0,1'b1,1'b1,1'b0,1'b1,1'b1,1'b0,1'b1,1'b1,1'b0,1'b0,1'b0},
//{1'b1,1'b1,1'b1,1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b1,1'b1,1'b0,1'b0},
//{1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0},
//};

logic TPin16;
logic TPin15;
logic TPin14;
logic TPin13;
logic TPin12;
logic TPin11;
logic TPin10;
logic TPin9;
logic TPin8;
logic TPin7;
logic TPin6;
logic TPin5;
logic TPin4;
logic TPin3;
logic TPin2;
logic TPin1;

assign Pin16 = io[16] ? TPin16 : 8'bZ ;
assign Pin15 = io[15] ? TPin15 : 8'bZ ;
assign Pin14 = io[14] ? TPin14 : 8'bZ ;
assign Pin13 = io[13] ? TPin13 : 8'bZ ;
assign Pin12 = io[12] ? TPin12 : 8'bZ ;
assign Pin11 = io[11] ? TPin11 : 8'bZ ;
assign Pin10 = io[10] ? TPin10 : 8'bZ ;
assign Pin9 = io[9] ? TPin9 : 8'bZ ;
assign Pin8 = io[8] ? TPin8 : 8'bZ ;
assign Pin6 = io[6] ? TPin6 : 8'bZ ;
assign Pin5 = io[5] ? TPin5 : 8'bZ ;
assign Pin4 = io[4] ? TPin4 : 8'bZ ;
assign Pin3 = io[3] ? TPin3 : 8'bZ ;
assign Pin2 = io[2] ? TPin2 : 8'bZ ;
assign Pin1 = io[1] ? TPin1 : 8'bZ ;
	
logic LD_SW;
logic LD_RSLT;
logic RSLT;
logic [3:0] hex0in;
logic [3:0] hex1in;
logic [3:0] hex2in;
logic [3:0] hex3in;
logic [3:0] hex4in;
logic Check_Done;
logic Reset_h;
logic Run_h;
logic slow_clk;
logic [63:0] ctr;
logic [3:0] input_o;
logic [1:0] state_o;



logic Start_Check;

logic [18:0] done;
logic [18:0] RSLT_O;
logic [18:0] selection;
logic DISP_RSLT;

logic [18:0]Pin16_agg;
logic [18:0]Pin15_agg;
logic [18:0]Pin14_agg;
logic [18:0]Pin13_agg;
logic [18:0]Pin12_agg;
logic [18:0]Pin11_agg;
logic [18:0]Pin10_agg;
logic [18:0]Pin9_agg;
logic [18:0]Pin8_agg;
logic [18:0]Pin7_agg;
logic [18:0]Pin6_agg;
logic [18:0]Pin5_agg;
logic [18:0]Pin4_agg;
logic [18:0]Pin3_agg;
logic [18:0]Pin2_agg;
logic [18:0]Pin1_agg;

HexDriver		AHex0 (
						.In0(hex0in),
						.Out0(HEX0) );
						
HexDriver		AHex1 (
						.In0(hex1in),
						.Out0(HEX1) );

HexDriver		BHex0 (
						.In0(hex2in),
						.Out0(HEX2) );
						
HexDriver		BHex1 (
						.In0(hex3in),
						.Out0(HEX3) );

HexDriver		CHex2 (
						.In0(hex4in),
						.Out0(HEX4) );
						
HexDriver		CHex3 (
						.In0(hex5in),
						.Out0(HEX5) );

always_comb
begin
	Reset_h = ~Reset;
	Run_h = ~Run;
end

always_comb
begin

	unique case (selection)
		1 : 
		begin
			io[16] = 0;
			io[15] = 0;
			io[14] = 0;
			io[13] = 1;
			io[12] = 1;
			io[11] = 0;
			io[10] = 1;
			io[9] = 1;
			io[8] = 0;
			io[7] = 0;
			io[6] = 0;
			io[5] = 1;
			io[4] = 1;
			io[3] = 0;
			io[2] = 1;
			io[1] = 1;
			io[0] = 1;
		end
		2 : 
		begin
			io[16] = 0;
			io[15] = 0;
			io[14] = 0;
			io[13] = 0;
			io[12] = 1;
			io[11] = 1;
			io[10] = 0;
			io[9] = 1;
			io[8] = 1;
			io[7] = 0;
			io[6] = 1;
			io[5] = 1;
			io[4] = 0;
			io[3] = 1;
			io[2] = 1;
			io[1] = 0;
			io[0] = 1;
		end
		3 : 
		begin
			io[16] = 0;
			io[15] = 0;
			io[14] = 0;
			io[13] = 1;
			io[12] = 0;
			io[11] = 1;
			io[10] = 0;
			io[9] = 1;
			io[8] = 0;
			io[7] = 0;
			io[6] = 0;
			io[5] = 1;
			io[4] = 0;
			io[3] = 1;
			io[2] = 0;
			io[1] = 1;
			io[0] = 1;
		end
		4 : 
		begin
			io[16] = 0;
			io[15] = 0;
			io[14] = 0;
			io[13] = 1;
			io[12] = 0;
			io[11] = 1;
			io[10] = 1;
			io[9] = 1;
			io[8] = 0;
			io[7] = 0;
			io[6] = 0;
			io[5] = 1;
			io[4] = 1;
			io[3] = 1;
			io[2] = 1;
			io[1] = 1;
			io[0] = 1;
		end
		5 : 
		begin
			io[16] = 0;
			io[15] = 0;
			io[14] = 0;
			io[13] = 1;
			io[12] = 1;
			io[11] = 1;
			io[10] = 1;
			io[9] = 1;
			io[8] = 0;
			io[7] = 0;
			io[6] = 0;
			io[5] = 1;
			io[4] = 1;
			io[3] = 1;
			io[2] = 1;
			io[1] = 1;
			io[0] = 1;
		end
		6 : 
		begin
			io[16] = 0;
			io[15] = 0;
			io[14] = 0;
			io[13] = 1;
			io[12] = 0;
			io[11] = 1;
			io[10] = 1;
			io[9] = 1;
			io[8] = 0;
			io[7] = 0;
			io[6] = 0;
			io[5] = 1;
			io[4] = 1;
			io[3] = 1;
			io[2] = 1;
			io[1] = 1;
			io[0] = 1;
		end
		7 : 
		begin
			io[16] = 0;
			io[15] = 0;
			io[14] = 0;
			io[13] = 1;
			io[12] = 1;
			io[11] = 1;
			io[10] = 1;
			io[9] = 0;
			io[8] = 0;
			io[7] = 0;
			io[6] = 0;
			io[5] = 0;
			io[4] = 1;
			io[3] = 1;
			io[2] = 1;
			io[1] = 1;
			io[0] = 1;
		end
		9 : 
		begin
			io[16] = 0;
			io[15] = 0;
			io[14] = 0;
			io[13] = 1;
			io[12] = 1;
			io[11] = 0;
			io[10] = 1;
			io[9] = 1;
			io[8] = 0;
			io[7] = 0;
			io[6] = 0;
			io[5] = 1;
			io[4] = 1;
			io[3] = 0;
			io[2] = 1;
			io[1] = 1;
			io[0] = 1;
		end
		default :
		begin
			io[16:0] = 0;
		end
	endcase
	
end

always_comb
begin

	selection = SW;

	TPin16 = Pin16_agg[selection];
	TPin15 = Pin15_agg[selection];
	TPin14 = Pin14_agg[selection];
	TPin13 = Pin13_agg[selection];
	TPin12 = Pin12_agg[selection];	
	TPin11 = Pin11_agg[selection];
	TPin10 = Pin10_agg[selection];
	TPin9 = Pin9_agg[selection];		
	TPin8 = Pin8_agg[selection];
	TPin6 = Pin6_agg[selection];
	TPin5 = Pin5_agg[selection];
	TPin4 = Pin4_agg[selection];		
	TPin3 = Pin3_agg[selection];
	TPin2 = Pin2_agg[selection];
	TPin1 = Pin1_agg[selection];	
	
	if(LD_SW)
	begin
		hex0in = SW[3:0];
//		hex1in = 0;
//		hex2in = SW[3:0];
//		hex3in = SW[7:4];
	end
	else if (LD_RSLT)
	begin
		hex0in = SW[3:0];
//		hex1in = 0;
//		hex2in = SW[3:0];
//		hex3in = SW[7:4];
	end
	else if(DISP_RSLT)
	begin
		if(RSLT)
		begin
		hex0in = 8'hAA;
//		hex1in = 8'hAA;
//		hex2in = SW[3:0];
//		hex3in = SW[7:4];
		end
		else
		begin
		hex0in = 8'hFF;
//		hex1in = 8'hFF;
//		hex2in = SW[3:0];
//		hex3in = SW[7:4];		
		end
	end
	else
	begin
		hex0in = 0;
//		hex1in = 0;
//		hex2in = 0;
//		hex3in = 0;
	end
end

always_comb
begin
	hex1in = state_o[1:0];
	hex2in = input_o[1:0];
	hex3in = Pin6;
	hex4in = RSLT;	
	hex5in = slow_clk;
	
end

always_ff @ (posedge Clk)
begin
	ctr++;
	if (ctr % 500000 == 0)
		slow_clk = ~slow_clk;
	if (Reset_h)
		ctr = 0;
	if(LD_RSLT)
	begin
		RSLT = RSLT_O[selection];
	end
	Check_Done = done[selection];
end

chip_checker_state chip_checker_state0(.Clk(slow_clk), .Reset(Reset_h), .Run(Run_h), .LD_SW(LD_SW), .LD_RSLT(LD_RSLT), .Check_Done(Check_Done), .Start_Check(Start_Check), .DISP_RSLT(DISP_RSLT));


chip_7400 chip_7400_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[1]), .RSLT(RSLT_O[1]), .Pin13(Pin13_agg[1]), .Pin12(Pin12_agg[1]), .Pin11(Pin11), .Pin10(Pin10_agg[1]), .Pin9(Pin9_agg[1]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[1]), .Pin4(Pin4_agg[1]), .Pin3(Pin3), .Pin2(Pin2_agg[1]), .Pin1(Pin1_agg[1]));//, .state_o(state_o), .input_o(input_o));		
chip_7402 chip_7402_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[2]), .RSLT(RSLT_O[2]), .Pin13(Pin13), .Pin12(Pin12_agg[2]), .Pin11(Pin11_agg[2]), .Pin10(Pin10), .Pin9(Pin9_agg[2]), .Pin8(Pin8_agg[2]), .Pin6(Pin6_agg[2]), .Pin5(Pin5_agg[2]), .Pin4(Pin4), .Pin3(Pin3_agg[2]), .Pin2(Pin2_agg[2]), .Pin1(Pin1));//, .state_o(state_o), .input_o(input_o));		
chip_7404 chip_7404_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[3]), .RSLT(RSLT_O[3]), .Pin13(Pin13_agg[3]), .Pin12(Pin12), .Pin11(Pin11_agg[3]), .Pin10(Pin10), .Pin9(Pin9_agg[3]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[3]), .Pin4(Pin4), .Pin3(Pin3_agg[3]), .Pin2(Pin2), .Pin1(Pin1_agg[3]));//, .state_o(state_o), .input_o(input_o));		
chip_7410 chip_7410_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[4]), .RSLT(RSLT_O[4]), .Pin13(Pin13_agg[4]), .Pin12(Pin12), .Pin11(Pin11_agg[4]), .Pin10(Pin10_agg[4]), .Pin9(Pin9_agg[4]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[4]), .Pin4(Pin4_agg[4]), .Pin3(Pin3_agg[4]), .Pin2(Pin2_agg[4]), .Pin1(Pin1_agg[4]));//, .state_o(state_o), .input_o(input_o));		
chip_7420 chip_7420_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[5]), .RSLT(RSLT_O[5]), .Pin13(Pin13_agg[5]), .Pin12(Pin12_agg[5]), .Pin10(Pin10_agg[5]), .Pin9(Pin9_agg[5]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[5]), .Pin4(Pin4_agg[5]), .Pin2(Pin2_agg[5]), .Pin1(Pin1_agg[5]), .state_o(state_o), .input_o(input_o));		
chip_7427 chip_7427_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[6]), .RSLT(RSLT_O[6]), .Pin13(Pin13_agg[6]), .Pin12(Pin12), .Pin11(Pin11_agg[6]), .Pin10(Pin10_agg[6]), .Pin9(Pin9_agg[6]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[6]), .Pin4(Pin4_agg[6]), .Pin3(Pin3_agg[6]), .Pin2(Pin2_agg[6]), .Pin1(Pin1_agg[6]));//, .state_o(state_o), .input_o(input_o));		
chip_7474 chip_7474_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[7]), .RSLT(RSLT_O[7]), .Pin13(Pin13_agg[7]), .Pin12(Pin12_agg[7]), .Pin11(Pin11_agg[7]), .Pin10(Pin10_agg[7]), .Pin9(Pin9), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5), .Pin4(Pin4_agg[7]), .Pin3(Pin3_agg[7]), .Pin2(Pin2_agg[7]), .Pin1(Pin1_agg[7]));//, .CCLK_O(state_o), .D_O(input_o));		
//chip_7485 chip_7485_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[8]), .RSLT(RSLT_O[8]), .Pin13(Pin13_agg[8]), .Pin12(Pin12_agg[8]), .Pin11(Pin11), .Pin10(Pin10_agg[8]), .Pin9(Pin9_agg[8]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[8]), .Pin4(Pin4_agg[8]), .Pin3(Pin3), .Pin2(Pin2_agg[8]), .Pin1(Pin1_agg[8]));//, .state_o(state_o), .input_o(input_o));		
chip_7486 chip_7486_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[9]), .RSLT(RSLT_O[9]), .Pin13(Pin13_agg[9]), .Pin12(Pin12_agg[9]), .Pin11(Pin11), .Pin10(Pin10_agg[9]), .Pin9(Pin9_agg[9]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[9]), .Pin4(Pin4_agg[9]), .Pin3(Pin3), .Pin2(Pin2_agg[9]), .Pin1(Pin1_agg[9]));//, .state_o(state_o), .input_o(input_o));		
//chip_74109N chip_74109N_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[8]), .RSLT(RSLT_O[8]), .Pin13(Pin13_agg[8]), .Pin12(Pin12_agg[8]), .Pin11(Pin11), .Pin10(Pin10_agg[8]), .Pin9(Pin9_agg[8]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[8]), .Pin4(Pin4_agg[8]), .Pin3(Pin3), .Pin2(Pin2_agg[8]), .Pin1(Pin1_agg[8]));//, .state_o(state_o), .input_o(input_o));		
//chip_74151N chip_74151N_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[8]), .RSLT(RSLT_O[8]), .Pin13(Pin13_agg[8]), .Pin12(Pin12_agg[8]), .Pin11(Pin11), .Pin10(Pin10_agg[8]), .Pin9(Pin9_agg[8]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[8]), .Pin4(Pin4_agg[8]), .Pin3(Pin3), .Pin2(Pin2_agg[8]), .Pin1(Pin1_agg[8]));//, .state_o(state_o), .input_o(input_o));		
//chip_74153N chip_74153N_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[8]), .RSLT(RSLT_O[8]), .Pin13(Pin13_agg[8]), .Pin12(Pin12_agg[8]), .Pin11(Pin11), .Pin10(Pin10_agg[8]), .Pin9(Pin9_agg[8]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[8]), .Pin4(Pin4_agg[8]), .Pin3(Pin3), .Pin2(Pin2_agg[8]), .Pin1(Pin1_agg[8]));//, .state_o(state_o), .input_o(input_o));		
//chip_74157N chip_74157N_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[8]), .RSLT(RSLT_O[8]), .Pin13(Pin13_agg[8]), .Pin12(Pin12_agg[8]), .Pin11(Pin11), .Pin10(Pin10_agg[8]), .Pin9(Pin9_agg[8]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[8]), .Pin4(Pin4_agg[8]), .Pin3(Pin3), .Pin2(Pin2_agg[8]), .Pin1(Pin1_agg[8]));//, .state_o(state_o), .input_o(input_o));		
//chip_74161N chip_74161N_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[8]), .RSLT(RSLT_O[8]), .Pin13(Pin13_agg[8]), .Pin12(Pin12_agg[8]), .Pin11(Pin11), .Pin10(Pin10_agg[8]), .Pin9(Pin9_agg[8]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[8]), .Pin4(Pin4_agg[8]), .Pin3(Pin3), .Pin2(Pin2_agg[8]), .Pin1(Pin1_agg[8]));//, .state_o(state_o), .input_o(input_o));		
//chip_74163N chip_74163N_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[8]), .RSLT(RSLT_O[8]), .Pin13(Pin13_agg[8]), .Pin12(Pin12_agg[8]), .Pin11(Pin11), .Pin10(Pin10_agg[8]), .Pin9(Pin9_agg[8]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[8]), .Pin4(Pin4_agg[8]), .Pin3(Pin3), .Pin2(Pin2_agg[8]), .Pin1(Pin1_agg[8]));//, .state_o(state_o), .input_o(input_o));		
//chip_74194N chip_74194N_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[8]), .RSLT(RSLT_O[8]), .Pin13(Pin13_agg[8]), .Pin12(Pin12_agg[8]), .Pin11(Pin11), .Pin10(Pin10_agg[8]), .Pin9(Pin9_agg[8]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[8]), .Pin4(Pin4_agg[8]), .Pin3(Pin3), .Pin2(Pin2_agg[8]), .Pin1(Pin1_agg[8]));//, .state_o(state_o), .input_o(input_o));		
//chip_74195N chip_74195N_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[8]), .RSLT(RSLT_O[8]), .Pin13(Pin13_agg[8]), .Pin12(Pin12_agg[8]), .Pin11(Pin11), .Pin10(Pin10_agg[8]), .Pin9(Pin9_agg[8]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[8]), .Pin4(Pin4_agg[8]), .Pin3(Pin3), .Pin2(Pin2_agg[8]), .Pin1(Pin1_agg[8]));//, .state_o(state_o), .input_o(input_o));		
//chip_74279 chip_74279_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[8]), .RSLT(RSLT_O[8]), .Pin13(Pin13_agg[8]), .Pin12(Pin12_agg[8]), .Pin11(Pin11), .Pin10(Pin10_agg[8]), .Pin9(Pin9_agg[8]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[8]), .Pin4(Pin4_agg[8]), .Pin3(Pin3), .Pin2(Pin2_agg[8]), .Pin1(Pin1_agg[8]));//, .state_o(state_o), .input_o(input_o));		

	
endmodule
