module chip_checker(	input logic [9:0] SW,
	input logic	Clk, Reset, Run,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	inout logic Pin13,
	inout logic Pin12,
	inout logic Pin11,
	inout logic Pin10,
	inout logic Pin9,
	inout logic Pin8,
	inout logic Pin6,
	inout logic Pin5,
	inout logic Pin4,
	inout logic Pin3,
	inout logic Pin2,
	inout logic Pin1
	);
	
logic io13;
logic io12;
logic io11;
logic io10;
logic io9;
logic io8;
logic io7;
logic io6;
logic io5;
logic io4;
logic io3;
logic io2;
logic io1;

logic [15:0] io;

logic TPin13;
logic TPin12;
logic TPin11;
logic TPin10;
logic TPin9;
logic TPin8;
logic TPin6;
logic TPin5;
logic TPin4;
logic TPin3;
logic TPin2;
logic TPin1;

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
logic RSLT_0;
logic RSLT_1;
logic [3:0] hex0in;
logic [3:0] hex1in;
logic [3:0] hex2in;
logic [3:0] hex3in;
logic Check_Done;
logic Reset_h;
logic Run_h;




logic Start_Check;

logic [1:0] done;

logic [9:0] selection;
logic DISP_RSLT;

logic [5:0]Pin13_agg;
logic [5:0]Pin12_agg;
logic [5:0]Pin11_agg;
logic [5:0]Pin10_agg;
logic [5:0]Pin9_agg;
logic [5:0]Pin8_agg;
logic [5:0]Pin7_agg;
logic [5:0]Pin6_agg;
logic [5:0]Pin5_agg;
logic [5:0]Pin4_agg;
logic [5:0]Pin3_agg;
logic [5:0]Pin2_agg;
logic [5:0]Pin1_agg;

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
						.In0(),
						.Out0(HEX4) );
						
HexDriver		CHex3 (
						.In0(),
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
		
			io[15] = 0;
			io[14] = 0;
			io[13] = 1;
			io[12] = 1;
			io[11] = 1;
			io[10] = 1;
			io[9] = 1;
			io[8] = 1;
			io[7] = 0;
			io[6] = 1;
			io[5] = 1;
			io[4] = 1;
			io[3] = 1;
			io[2] = 1;
			io[1] = 0;
			io[0] = 1;
		end
		2 : 
		begin
			io[15:0] = 0;
		end
		default :
		begin
			io[15:0] = 0;
		end
	endcase
	
end

always_comb
begin

	selection = SW;

	
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
		hex1in = SW[7:4];
		hex2in = 0;
		hex3in = 0;
	end
	else if(DISP_RSLT)
	begin
		if(RSLT)
		begin
		hex0in = 8'hAA;
		hex1in = 8'hAA;
		hex2in = 8'hAA;
		hex3in = 8'hAA;
		end
		else
		begin
		hex0in = 8'h11;
		hex1in = 8'h11;
		hex2in = 8'h11;
		hex3in = 8'h11;		
		end
	end
	else
	begin
		hex0in = 0;
		hex1in = 0;
		hex2in = 0;
		hex3in = 0;	
	end
end

always_ff @ (posedge Clk)
begin
	if(LD_RSLT)
	begin
		unique case (selection)
			1 : 
			begin
				RSLT = RSLT_0;
			end
			2 : 
			begin
				RSLT = RSLT_1;
			end
			default :
			begin
				RSLT = 0;
			end
		endcase
	end
	
	unique case (selection)
		1 : 
		begin
			Check_Done = done[0];
		end
		2 : 
		begin
			Check_Done = done[1];
		end
		default :
		begin
			Check_Done = 0;
		end
	endcase

end

chip_checker_state chip_checker_state0(.Clk(Clk), .Reset(Reset_h), .Run(Run_h), .LD_SW(LD_SW), .LD_RSLT(LD_RSLT), .Check_Done(Check_Done), .Start_Check(Start_Check), .DISP_RSLT(DISP_RSLT));


//chip_7400 chip_7400_0(.DISP_RSLT(DISP_RSLT), .Clk(Clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[0]), .RSLT(RSLT_0), .Pin13(Pin13_agg[1]), .Pin12(Pin12_agg[1]), .Pin11(Pin11), .Pin10(Pin10_agg[1]), .Pin9(Pin9_agg[1]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[1]), .Pin4(Pin4_agg[1]), .Pin3(Pin3), .Pin2(Pin2_agg[1]), .Pin1(Pin1_agg[1]));		
chip_7402 chip_7402_0(.DISP_RSLT(DISP_RSLT), .Clk(Clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[0]), .RSLT(RSLT_0), .Pin13(Pin13_agg[1]), .Pin12(Pin12_agg[1]), .Pin11(Pin11_agg[1]), .Pin10(Pin10_agg[1]), .Pin9(Pin9_agg[1]), .Pin8(Pin8_agg[1]), .Pin6(Pin6_agg[1]), .Pin5(Pin5_agg[1]), .Pin4(Pin4_agg[1]), .Pin3(Pin3_agg[1]), .Pin2(Pin2_agg[1]), .Pin1(Pin1_agg[1]));		
						
endmodule