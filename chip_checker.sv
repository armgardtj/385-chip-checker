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
	inout logic Pin1,
	
		output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,

      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 
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
assign Pin7 = io[7] ? TPin7 : 8'bZ ;
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
logic [3:0] expected;



logic Start_Check;


logic [18:0] done;
logic [18:0] RSLT_O;
int selection;


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


assign Run_h = (keycode == 8'h28) ? 1 : 0 ;						
always_comb
begin
	Reset_h = ~Reset;
	
	//Run_h = /*~Run*/;
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
		8 : 
		begin
			io[16] = 0;
			io[15] = 1;
			io[14] = 1;
			io[13] = 1;
			io[12] = 1;
			io[11] = 1;
			io[10] = 1;
			io[9] = 1;
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
		10 : 
		begin
			io[16] = 0;
			io[15] = 1;
			io[14] = 1;
			io[13] = 1;
			io[12] = 1;
			io[11] = 1;
			io[10] = 0;
			io[9] = 0;
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
		11 : 
		begin
			io[16] = 0;
			io[15] = 1;
			io[14] = 1;
			io[13] = 1;
			io[12] = 1;
			io[11] = 1;
			io[10] = 1;
			io[9] = 1;
			io[8] = 0;
			io[7] = 1;
			io[6] = 0;
			io[5] = 0;
			io[4] = 1;
			io[3] = 1;
			io[2] = 1;
			io[1] = 1;
			io[0] = 1;
		end
		12 : 
		begin
			io[16] = 0;
			io[15] = 1;
			io[14] = 1;
			io[13] = 1;
			io[12] = 1;
			io[11] = 1;
			io[10] = 1;
			io[9] = 0;
			io[8] = 0;
			io[7] = 0;
			io[6] = 1;
			io[5] = 1;
			io[4] = 1;
			io[3] = 1;
			io[2] = 1;
			io[1] = 1;
			io[0] = 1;
		end
		13 : 
		begin
			io[16] = 0;
			io[15] = 1;
			io[14] = 1;
			io[13] = 1;
			io[12] = 0;
			io[11] = 1;
			io[10] = 1;
			io[9] = 0;
			io[8] = 0;
			io[7] = 0;
			io[6] = 1;
			io[5] = 1;
			io[4] = 0;
			io[3] = 1;
			io[2] = 1;
			io[1] = 1;
			io[0] = 1;
		end
		14 : 
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
		15 : 
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
		16 : 
		begin
			io[16] = 0;
			io[15] = 0;
			io[14] = 0;
			io[13] = 0;
			io[12] = 0;
			io[11] = 0;
			io[10] = 1;
			io[9] = 1;
			io[8] = 1;
			io[7] = 1;
			io[6] = 1;
			io[5] = 1;
			io[4] = 1;
			io[3] = 1;
			io[2] = 1;
			io[1] = 1;
			io[0] = 1;
		end
		17 : 
		begin
			io[16] = 0;
			io[15] = 0;
			io[14] = 0;
			io[13] = 0;
			io[12] = 0;
			io[11] = 0;
			io[10] = 1;
			io[9] = 1;
			io[8] = 1;
			io[7] = 1;
			io[6] = 1;
			io[5] = 1;
			io[4] = 1;
			io[3] = 1;
			io[2] = 1;
			io[1] = 1;
			io[0] = 1;
		end
		18 : 
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

	//selection = SW;

	TPin16 = Pin16_agg[selection];
	TPin15 = Pin15_agg[selection];
	TPin14 = Pin14_agg[selection];
	TPin13 = Pin13_agg[selection];
	TPin12 = Pin12_agg[selection];	
	TPin11 = Pin11_agg[selection];
	TPin10 = Pin10_agg[selection];
	TPin9 = Pin9_agg[selection];		
	TPin8 = Pin8_agg[selection];
	TPin7 = Pin7_agg[selection];
	TPin6 = Pin6_agg[selection];
	TPin5 = Pin5_agg[selection];
	TPin4 = Pin4_agg[selection];		
	TPin3 = Pin3_agg[selection];
	TPin2 = Pin2_agg[selection];
	TPin1 = Pin1_agg[selection];	
	
	if(LD_SW)
	begin

		hex0in = 0;
		hex1in = 0;
		hex2in = SW[3:0];
		hex3in = SW[7:4];
	end
	else if (LD_RSLT)
	begin
		hex0in = 0;
		hex1in = 0;
		hex2in = SW[3:0];
		hex3in = SW[7:4];

	end
	else if(DISP_RSLT)
	begin
		if(RSLT)
		begin
		hex0in = 8'hAA;
		hex1in = 8'hAA;
		hex2in = SW[3:0];
		hex3in = SW[7:4];
		end
		else
		begin
		hex0in = 8'hFF;
		hex1in = 8'hFF;
		hex2in = SW[3:0];
		hex3in = SW[7:4];		
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
/*
always_comb
begin
	hex1in = input_o[3:0];
	hex2in = expected[3:0];
	hex3in = {Pin15, Pin14, Pin13, Pin12};
	hex4in = RSLT;	
	hex5in = slow_clk;
	
end
*/
always_ff @ (posedge Clk)
begin
	ctr++;
	if (ctr % 500 == 0)
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



//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_5, hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode;
	logic [7:0] old_key = 0;
	logic [7:0] act_key;
	logic same;

	//logic [12:0][7:0]  letters;
	//assign letters = {8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00};


//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[7:4];
	assign VGA_B = Blue[7:4];
	assign VGA_G = Green[7:4];
	
	
	Lab8_soc u0 (
		.clk_clk                           (Clk),            //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_pio_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode)
		
	 );


//instantiate a vga_controller, ball, and color_mapper here with the ports.

vga_controller vga0(.Clk(Clk),       // 50 MHz clock
					  .Reset(Reset_h),     // reset signal
						.hs(VGA_HS),        // Horizontal sync pulse.  Active low
					  .vs(VGA_VS),        // Vertical sync pulse.  Active low
					  .pixel_clk(VGA_Clk), // 25 MHz pixel clock output
					  .blank(blank),     // Blanking interval indicator.  Active low.
					  .sync(sync),      // Composite Sync signal.  Active low.  We don't use it in this lab,
									 //   but the video DAC on the DE2 board requires an input for it.
						.DrawX(drawxsig),     // horizontal coordinate
					  .DrawY(drawysig) );
					  
color_mapper color_mapper0(.Clk(Clk), .DrawX(drawxsig), .DrawY(drawysig),
                       .Red(Red), .Green(Green), .Blue(Blue), .keycode(keycode), .select(selection), .RSLT(RSLT));

			

chip_7400 chip_7400_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[1]), .RSLT(RSLT_O[1]), .Pin13(Pin13_agg[1]), .Pin12(Pin12_agg[1]), .Pin11(Pin11), .Pin10(Pin10_agg[1]), .Pin9(Pin9_agg[1]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[1]), .Pin4(Pin4_agg[1]), .Pin3(Pin3), .Pin2(Pin2_agg[1]), .Pin1(Pin1_agg[1]));//, .state_o(state_o), .input_o(input_o));		
chip_7402 chip_7402_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[2]), .RSLT(RSLT_O[2]), .Pin13(Pin13), .Pin12(Pin12_agg[2]), .Pin11(Pin11_agg[2]), .Pin10(Pin10), .Pin9(Pin9_agg[2]), .Pin8(Pin8_agg[2]), .Pin6(Pin6_agg[2]), .Pin5(Pin5_agg[2]), .Pin4(Pin4), .Pin3(Pin3_agg[2]), .Pin2(Pin2_agg[2]), .Pin1(Pin1));//, .state_o(state_o), .input_o(input_o));		
chip_7404 chip_7404_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[3]), .RSLT(RSLT_O[3]), .Pin13(Pin13_agg[3]), .Pin12(Pin12), .Pin11(Pin11_agg[3]), .Pin10(Pin10), .Pin9(Pin9_agg[3]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[3]), .Pin4(Pin4), .Pin3(Pin3_agg[3]), .Pin2(Pin2), .Pin1(Pin1_agg[3]));//, .state_o(state_o), .input_o(input_o));		
chip_7410 chip_7410_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[4]), .RSLT(RSLT_O[4]), .Pin13(Pin13_agg[4]), .Pin12(Pin12), .Pin11(Pin11_agg[4]), .Pin10(Pin10_agg[4]), .Pin9(Pin9_agg[4]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[4]), .Pin4(Pin4_agg[4]), .Pin3(Pin3_agg[4]), .Pin2(Pin2_agg[4]), .Pin1(Pin1_agg[4]));//, .state_o(state_o), .input_o(input_o));		
chip_7420 chip_7420_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[5]), .RSLT(RSLT_O[5]), .Pin13(Pin13_agg[5]), .Pin12(Pin12_agg[5]), .Pin10(Pin10_agg[5]), .Pin9(Pin9_agg[5]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[5]), .Pin4(Pin4_agg[5]), .Pin2(Pin2_agg[5]), .Pin1(Pin1_agg[5]));//, .state_o(state_o), .input_o(input_o));		
chip_7427 chip_7427_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[6]), .RSLT(RSLT_O[6]), .Pin13(Pin13_agg[6]), .Pin12(Pin12), .Pin11(Pin11_agg[6]), .Pin10(Pin10_agg[6]), .Pin9(Pin9_agg[6]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[6]), .Pin4(Pin4_agg[6]), .Pin3(Pin3_agg[6]), .Pin2(Pin2_agg[6]), .Pin1(Pin1_agg[6]));//, .state_o(state_o), .input_o(input_o));		
chip_7474 chip_7474_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[7]), .RSLT(RSLT_O[7]), .Pin13(Pin13_agg[7]), .Pin12(Pin12_agg[7]), .Pin11(Pin11_agg[7]), .Pin10(Pin10_agg[7]), .Pin9(Pin9), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5), .Pin4(Pin4_agg[7]), .Pin3(Pin3_agg[7]), .Pin2(Pin2_agg[7]), .Pin1(Pin1_agg[7]));//, .E(state_o), .D_O(input_o));		
chip_7485 chip_7485_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[8]), .RSLT(RSLT_O[8]), .Pin15(Pin15_agg[8]), .Pin14(Pin14_agg[8]), .Pin13(Pin13_agg[8]), .Pin12(Pin12_agg[8]), .Pin11(Pin11_agg[8]), .Pin10(Pin10_agg[8]), .Pin9(Pin9_agg[8]), .Pin7(Pin7), .Pin6(Pin6), .Pin5(Pin5), .Pin4(Pin4_agg[8]), .Pin3(Pin3_agg[8]), .Pin2(Pin2_agg[8]), .Pin1(Pin1_agg[8]));//, .expected(expected), .input_o(input_o));		
chip_7486 chip_7486_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[9]), .RSLT(RSLT_O[9]), .Pin13(Pin13_agg[9]), .Pin12(Pin12_agg[9]), .Pin11(Pin11), .Pin10(Pin10_agg[9]), .Pin9(Pin9_agg[9]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[9]), .Pin4(Pin4_agg[9]), .Pin3(Pin3), .Pin2(Pin2_agg[9]), .Pin1(Pin1_agg[9]));//, .state_o(state_o), .input_o(input_o));		
chip_74109N chip_74109N_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[10]), .RSLT(RSLT_O[10]), .Pin15(Pin15_agg[10]), .Pin14(Pin14_agg[10]), .Pin13(Pin13_agg[10]), .Pin12(Pin12_agg[10]), .Pin11(Pin11_agg[10]), .Pin10(Pin10), .Pin9(Pin9), .Pin7(Pin7), .Pin6(Pin6), .Pin5(Pin5_agg[10]), .Pin4(Pin4_agg[10]), .Pin3(Pin3_agg[10]), .Pin2(Pin2_agg[10]), .Pin1(Pin1_agg[10]));//, .E(expected), .input_o(input_o));		
chip_74151N chip_74151N_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[11]), .RSLT(RSLT_O[11]), .Pin15(Pin15_agg[11]), .Pin14(Pin14_agg[11]), .Pin13(Pin13_agg[11]), .Pin12(Pin12_agg[11]), .Pin11(Pin11_agg[11]), .Pin10(Pin10_agg[11]), .Pin9(Pin9_agg[11]), .Pin7(Pin7_agg[11]), .Pin6(Pin6), .Pin5(Pin5), .Pin4(Pin4_agg[11]), .Pin3(Pin3_agg[11]), .Pin2(Pin2_agg[11]), .Pin1(Pin1_agg[11]));
chip_74153N chip_74153N_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[12]), .RSLT(RSLT_O[12]), .Pin15(Pin15_agg[12]), .Pin14(Pin14_agg[12]), .Pin13(Pin13_agg[12]), .Pin12(Pin12_agg[12]), .Pin11(Pin11_agg[12]), .Pin10(Pin10_agg[12]), .Pin9(Pin9), .Pin7(Pin7), .Pin6(Pin6_agg[12]), .Pin5(Pin5_agg[12]), .Pin4(Pin4_agg[12]), .Pin3(Pin3_agg[12]), .Pin2(Pin2_agg[12]), .Pin1(Pin1_agg[12]));//, .state_o(state_o), .input_o(input_o));		
chip_74157N chip_74157N_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[13]), .RSLT(RSLT_O[13]), .Pin15(Pin15_agg[13]), .Pin14(Pin14_agg[13]), .Pin13(Pin13_agg[13]), .Pin12(Pin12), .Pin11(Pin11_agg[13]), .Pin10(Pin10_agg[13]), .Pin9(Pin9), .Pin7(Pin7), .Pin6(Pin6_agg[13]), .Pin5(Pin5_agg[13]), .Pin4(Pin4), .Pin3(Pin3_agg[13]), .Pin2(Pin2_agg[13]), .Pin1(Pin1_agg[13]));//, .E(state_o), .input_o(input_o));		
chip_74161N chip_74161N_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[14]), .RSLT(RSLT_O[14]), .Pin13(Pin13_agg[14]), .Pin12(Pin12_agg[14]), .Pin11(Pin11), .Pin10(Pin10_agg[14]), .Pin9(Pin9_agg[14]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[14]), .Pin4(Pin4_agg[14]), .Pin3(Pin3), .Pin2(Pin2_agg[14]), .Pin1(Pin1_agg[14]));//, .state_o(state_o), .input_o(input_o));		
chip_74163E chip_74163E_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[15]), .RSLT(RSLT_O[15]), .Pin13(Pin13_agg[15]), .Pin12(Pin12_agg[15]), .Pin11(Pin11), .Pin10(Pin10_agg[15]), .Pin9(Pin9_agg[15]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[15]), .Pin4(Pin4_agg[15]), .Pin3(Pin3), .Pin2(Pin2_agg[15]), .Pin1(Pin1_agg[15]));//, .state_o(state_o), .input_o(input_o));		
chip_74194AE chip_74194AE_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[16]), .RSLT(RSLT_O[16]), .Pin15(Pin15), .Pin14(Pin14), .Pin13(Pin13), .Pin12(Pin12), .Pin11(Pin11), .Pin10(Pin10_agg[16]), .Pin9(Pin9_agg[16]), .Pin7(Pin7_agg[16]), .Pin6(Pin6_agg[16]), .Pin5(Pin5_agg[16]), .Pin4(Pin4_agg[16]), .Pin3(Pin3_agg[16]), .Pin2(Pin2_agg[16]), .Pin1(Pin1_agg[16]));//, .E(expected), .input_o(input_o));		
chip_74195E chip_74195E_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[17]), .RSLT(RSLT_O[17]), .Pin15(Pin15), .Pin14(Pin14), .Pin13(Pin13), .Pin12(Pin12), .Pin11(Pin11), .Pin10(Pin10_agg[17]), .Pin9(Pin9_agg[17]), .Pin7(Pin7_agg[17]), .Pin6(Pin6_agg[17]), .Pin5(Pin5_agg[17]), .Pin4(Pin4_agg[17]), .Pin3(Pin3_agg[17]), .Pin2(Pin2_agg[17]), .Pin1(Pin1_agg[17]));//, .E(expected), .input_o(input_o));		
chip_74279 chip_74279_0(.DISP_RSLT(DISP_RSLT), .Clk(slow_clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[18]), .RSLT(RSLT_O[18]), .Pin13(Pin13_agg[18]), .Pin12(Pin12_agg[18]), .Pin11(Pin11), .Pin10(Pin10_agg[18]), .Pin9(Pin9_agg[18]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[18]), .Pin4(Pin4_agg[18]), .Pin3(Pin3), .Pin2(Pin2_agg[18]), .Pin1(Pin1_agg[18]));//, .state_o(state_o), .input_o(input_o));		

	
endmodule

