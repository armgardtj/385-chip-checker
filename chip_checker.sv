module chip_checker(	input logic [9:0] SW,
	input logic	Clk, Reset, Run,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	output logic Pin13,
	output logic Pin12,
	input logic Pin11,
	output logic Pin10,
	output logic Pin9,
	input logic Pin8,
	input logic Pin6,
	output logic Pin5,
	output logic Pin4,
	input logic Pin3,
	output logic Pin2,
	output logic Pin1
	);

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

logic [5:0]Pin10_agg;
logic [5:0]Pin9_agg;

logic [5:0]Pin5_agg;
logic [5:0]Pin4_agg;

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

	selection = SW;
	
	Pin13 = Pin13_agg[selection];
	Pin12 = Pin12_agg[selection];	
	
	Pin10 = Pin10_agg[selection];
	Pin9 = Pin9_agg[selection];		

	Pin5 = Pin5_agg[selection];
	Pin4 = Pin4_agg[selection];		

	Pin2 = Pin2_agg[selection];
	Pin1 = Pin1_agg[selection];	
	
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

chip_7402 chip_7402_0(.DISP_RSLT(DISP_RSLT), .Clk(Clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[0]), .RSLT(RSLT_0), .Pin13(Pin13_agg[1]), .Pin12(Pin12_agg[1]), .Pin11(Pin11), .Pin10(Pin10_agg[1]), .Pin9(Pin9_agg[1]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[1]), .Pin4(Pin4_agg[1]), .Pin3(Pin3), .Pin2(Pin2_agg[1]), .Pin1(Pin1_agg[1]));		
//chip_Quad_2_input_NOR chip_Quad_2_input_NOR0(.Clk(Clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[1]), .RSLT(RSLT_1), .Pin13(Pin13), .Pin12(Pin12), .Pin11(Pin11), .Pin10(Pin10), .Pin9(Pin9), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5), .Pin4(Pin4), .Pin3(Pin3), .Pin2(Pin2), .Pin1(Pin1));		
						
endmodule