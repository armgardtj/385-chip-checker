module chip_checker(	input logic [9:0] SW,
	input logic	Clk, Reset, Run,
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
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
logic [3:0] hex4in;
logic Check_Done;
logic Reset_h;
logic Run_h;
logic nand_clk;
logic [63:0] nand_ctr;
logic [1:0] input_o;
logic [1:0] state_o;



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
		//hex1in = SW[7:4];
		//hex2in = 0;
		//hex3in = 0;
	end
	else if(DISP_RSLT)
	begin
		if(RSLT)
		begin
		hex0in = 8'hAA;
		//hex1in = 8'h11;
		//hex2in = 8'h11;
		//hex3in = 8'h11;
		end
		else
		begin
		hex0in = 8'hFF;
		//hex1in = 8'hFF;
		//hex2in = 8'hFF;
		//hex3in = 8'hFF;		
		end
	end
	else
	begin
		hex0in = 0;
		//hex1in = 0;

	end
end

always_comb
begin
	hex1in = state_o[1:0];
	hex2in = input_o[1:0];
	hex3in = Pin11;
	hex4in = RSLT_0;	
	hex5in = nand_clk;
	
end

always_ff @ (posedge Clk)
begin
	nand_ctr++;
	if (nand_ctr % 50000000 == 0)
		nand_clk = ~nand_clk;
	if (Reset_h)
		nand_ctr = 0;
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


chip_7400 chip_7400_0(.DISP_RSLT(DISP_RSLT), .Clk(Clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[0]), .RSLT(RSLT_0), .Pin13(Pin13_agg[1]), .Pin12(Pin12_agg[1]), .Pin11(Pin11), .Pin10(Pin10_agg[1]), .Pin9(Pin9_agg[1]), .Pin8(Pin8), .Pin6(Pin6), .Pin5(Pin5_agg[1]), .Pin4(Pin4_agg[1]), .Pin3(Pin3), .Pin2(Pin2_agg[1]), .Pin1(Pin1_agg[1]), .input_o(input_o), .state_o(state_o));		
//chip_7402 chip_7402_0(.DISP_RSLT(DISP_RSLT), .Clk(Clk), .Reset(Reset_h), .Run(Start_Check), .Done(done[0]), .RSLT(RSLT_0), .Pin13(Pin13_agg[1]), .Pin12(Pin12_agg[1]), .Pin11(Pin11_agg[1]), .Pin10(Pin10_agg[1]), .Pin9(Pin9_agg[1]), .Pin8(Pin8_agg[1]), .Pin6(Pin6_agg[1]), .Pin5(Pin5_agg[1]), .Pin4(Pin4_agg[1]), .Pin3(Pin3_agg[1]), .Pin2(Pin2_agg[1]), .Pin1(Pin1_agg[1]));		



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
	
	/*
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
			
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	*/


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
                       .Red(Red), .Green(Green), .Blue(Blue), .keycode(keycode));

			
endmodule