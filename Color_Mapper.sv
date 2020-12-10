//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper (input        Clk,  input        [9:0] DrawX, DrawY, Ball_size, input [7:0] keycode,
                       output logic [7:0]  Red, Green, Blue );
    
    logic ball_on;
	 
	 logic  [94:0][12:0][7:0] letters;
    
	 // 800 horizontal pixels indexed 0 to 799
    // 525 vertical pixels indexed 0 to 524
    parameter [9:0] hpixels = 10'b1100011111;
    parameter [9:0] vlines = 10'b1000001100;
	
	logic [39:0]filled_lines;
	
	assign filled_lines = '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0};
	
	assign letters = '{'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},// space :32
	'{8'h00, 8'h00, 8'h18, 8'h18, 8'h00, 8'h00, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18},// ! :33
	'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h36, 8'h36, 8'h36, 8'h36},
	'{8'h00, 8'h00, 8'h00, 8'h66, 8'h66, 8'hff, 8'h66, 8'h66, 8'hff, 8'h66, 8'h66, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'h18, 8'h7e, 8'hff, 8'h1b, 8'h1f, 8'h7e, 8'hf8, 8'hd8, 8'hff, 8'h7e, 8'h18},
	'{8'h00, 8'h00, 8'h0e, 8'h1b, 8'hdb, 8'h6e, 8'h30, 8'h18, 8'h0c, 8'h76, 8'hdb, 8'hd8, 8'h70},
	'{8'h00, 8'h00, 8'h7f, 8'hc6, 8'hcf, 8'hd8, 8'h70, 8'h70, 8'hd8, 8'hcc, 8'hcc, 8'h6c, 8'h38},
	'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h18, 8'h1c, 8'h0c, 8'h0e},
	'{8'h00, 8'h00, 8'h0c, 8'h18, 8'h30, 8'h30, 8'h30, 8'h30, 8'h30, 8'h30, 8'h30, 8'h18, 8'h0c},
	'{8'h00, 8'h00, 8'h30, 8'h18, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'h18, 8'h30},
	'{8'h00, 8'h00, 8'h00, 8'h00, 8'h99, 8'h5a, 8'h3c, 8'hff, 8'h3c, 8'h5a, 8'h99, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'h00, 8'h18, 8'h18, 8'h18, 8'hff, 8'hff, 8'h18, 8'h18, 8'h18, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'h30, 8'h18, 8'h1c, 8'h1c, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'h00, 8'h38, 8'h38, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h60, 8'h60, 8'h30, 8'h30, 8'h18, 8'h18, 8'h0c, 8'h0c, 8'h06, 8'h06, 8'h03, 8'h03},
	'{8'h00, 8'h00, 8'h3c, 8'h66, 8'hc3, 8'he3, 8'hf3, 8'hdb, 8'hcf, 8'hc7, 8'hc3, 8'h66, 8'h3c},
	'{8'h00, 8'h00, 8'h7e, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h78, 8'h38, 8'h18},
	'{8'h00, 8'h00, 8'hff, 8'hc0, 8'hc0, 8'h60, 8'h30, 8'h18, 8'h0c, 8'h06, 8'h03, 8'he7, 8'h7e},
	'{8'h00, 8'h00, 8'h7e, 8'he7, 8'h03, 8'h03, 8'h07, 8'h7e, 8'h07, 8'h03, 8'h03, 8'he7, 8'h7e},
	'{8'h00, 8'h00, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'hff, 8'hcc, 8'h6c, 8'h3c, 8'h1c, 8'h0c},
	'{8'h00, 8'h00, 8'h7e, 8'he7, 8'h03, 8'h03, 8'h07, 8'hfe, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hff},
	'{8'h00, 8'h00, 8'h7e, 8'he7, 8'hc3, 8'hc3, 8'hc7, 8'hfe, 8'hc0, 8'hc0, 8'hc0, 8'he7, 8'h7e},
	'{8'h00, 8'h00, 8'h30, 8'h30, 8'h30, 8'h30, 8'h18, 8'h0c, 8'h06, 8'h03, 8'h03, 8'h03, 8'hff},
	'{8'h00, 8'h00, 8'h7e, 8'he7, 8'hc3, 8'hc3, 8'he7, 8'h7e, 8'he7, 8'hc3, 8'hc3, 8'he7, 8'h7e},
	'{8'h00, 8'h00, 8'h7e, 8'he7, 8'h03, 8'h03, 8'h03, 8'h7f, 8'he7, 8'hc3, 8'hc3, 8'he7, 8'h7e},
	'{8'h00, 8'h00, 8'h00, 8'h38, 8'h38, 8'h00, 8'h00, 8'h38, 8'h38, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'h30, 8'h18, 8'h1c, 8'h1c, 8'h00, 8'h00, 8'h1c, 8'h1c, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'h06, 8'h0c, 8'h18, 8'h30, 8'h60, 8'hc0, 8'h60, 8'h30, 8'h18, 8'h0c, 8'h06},
	'{8'h00, 8'h00, 8'h00, 8'h00, 8'hff, 8'hff, 8'h00, 8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'h60, 8'h30, 8'h18, 8'h0c, 8'h06, 8'h03, 8'h06, 8'h0c, 8'h18, 8'h30, 8'h60},
	'{8'h00, 8'h00, 8'h18, 8'h00, 8'h00, 8'h18, 8'h18, 8'h0c, 8'h06, 8'h03, 8'hc3, 8'hc3, 8'h7e},
	'{8'h00, 8'h00, 8'h3f, 8'h60, 8'hcf, 8'hdb, 8'hd3, 8'hdd, 8'hc3, 8'h7e, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hff, 8'hc3, 8'hc3, 8'hc3, 8'h66, 8'h3c, 8'h18},
	'{8'h00, 8'h00, 8'hfe, 8'hc7, 8'hc3, 8'hc3, 8'hc7, 8'hfe, 8'hc7, 8'hc3, 8'hc3, 8'hc7, 8'hfe},
	'{8'h00, 8'h00, 8'h7e, 8'he7, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'he7, 8'h7e},
	'{8'h00, 8'h00, 8'hfc, 8'hce, 8'hc7, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc7, 8'hce, 8'hfc},
	'{8'h00, 8'h00, 8'hff, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hfc, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hff},
	'{8'h00, 8'h00, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hfc, 8'hc0, 8'hc0, 8'hc0, 8'hff},
	'{8'h00, 8'h00, 8'h7e, 8'he7, 8'hc3, 8'hc3, 8'hcf, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'he7, 8'h7e},
	'{8'h00, 8'h00, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hff, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3},
	'{8'h00, 8'h00, 8'h7e, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h7e},
	'{8'h00, 8'h00, 8'h7c, 8'hee, 8'hc6, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06, 8'h06},
	'{8'h00, 8'h00, 8'hc3, 8'hc6, 8'hcc, 8'hd8, 8'hf0, 8'he0, 8'hf0, 8'hd8, 8'hcc, 8'hc6, 8'hc3},
	'{8'h00, 8'h00, 8'hff, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hc0},
	'{8'h00, 8'h00, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hdb, 8'hff, 8'hff, 8'he7, 8'hc3},
	'{8'h00, 8'h00, 8'hc7, 8'hc7, 8'hcf, 8'hcf, 8'hdf, 8'hdb, 8'hfb, 8'hf3, 8'hf3, 8'he3, 8'he3},
	'{8'h00, 8'h00, 8'h7e, 8'he7, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'he7, 8'h7e},
	'{8'h00, 8'h00, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hfe, 8'hc7, 8'hc3, 8'hc3, 8'hc7, 8'hfe},
	'{8'h00, 8'h00, 8'h3f, 8'h6e, 8'hdf, 8'hdb, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'h66, 8'h3c},
	'{8'h00, 8'h00, 8'hc3, 8'hc6, 8'hcc, 8'hd8, 8'hf0, 8'hfe, 8'hc7, 8'hc3, 8'hc3, 8'hc7, 8'hfe},
	'{8'h00, 8'h00, 8'h7e, 8'he7, 8'h03, 8'h03, 8'h07, 8'h7e, 8'he0, 8'hc0, 8'hc0, 8'he7, 8'h7e},
	'{8'h00, 8'h00, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'hff},
	'{8'h00, 8'h00, 8'h7e, 8'he7, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3},
	'{8'h00, 8'h00, 8'h18, 8'h3c, 8'h3c, 8'h66, 8'h66, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3},
	'{8'h00, 8'h00, 8'hc3, 8'he7, 8'hff, 8'hff, 8'hdb, 8'hdb, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3},
	'{8'h00, 8'h00, 8'hc3, 8'h66, 8'h66, 8'h3c, 8'h3c, 8'h18, 8'h3c, 8'h3c, 8'h66, 8'h66, 8'hc3},
	'{8'h00, 8'h00, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h3c, 8'h3c, 8'h66, 8'h66, 8'hc3},
	'{8'h00, 8'h00, 8'hff, 8'hc0, 8'hc0, 8'h60, 8'h30, 8'h7e, 8'h0c, 8'h06, 8'h03, 8'h03, 8'hff},
	'{8'h00, 8'h00, 8'h3c, 8'h30, 8'h30, 8'h30, 8'h30, 8'h30, 8'h30, 8'h30, 8'h30, 8'h30, 8'h3c},
	'{8'h00, 8'h03, 8'h03, 8'h06, 8'h06, 8'h0c, 8'h0c, 8'h18, 8'h18, 8'h30, 8'h30, 8'h60, 8'h60},
	'{8'h00, 8'h00, 8'h3c, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'h3c},
	'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'hc3, 8'h66, 8'h3c, 8'h18},
	'{8'hff, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h18, 8'h38, 8'h30, 8'h70},
	'{8'h00, 8'h00, 8'h7f, 8'hc3, 8'hc3, 8'h7f, 8'h03, 8'hc3, 8'h7e, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'hfe, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hfe, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hc0},
	'{8'h00, 8'h00, 8'h7e, 8'hc3, 8'hc0, 8'hc0, 8'hc0, 8'hc3, 8'h7e, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'h7f, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'h7f, 8'h03, 8'h03, 8'h03, 8'h03, 8'h03},
	'{8'h00, 8'h00, 8'h7f, 8'hc0, 8'hc0, 8'hfe, 8'hc3, 8'hc3, 8'h7e, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'h30, 8'h30, 8'h30, 8'h30, 8'h30, 8'hfc, 8'h30, 8'h30, 8'h30, 8'h33, 8'h1e},
	'{8'h7e, 8'hc3, 8'h03, 8'h03, 8'h7f, 8'hc3, 8'hc3, 8'hc3, 8'h7e, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hfe, 8'hc0, 8'hc0, 8'hc0, 8'hc0},
	'{8'h00, 8'h00, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h00, 8'h00, 8'h18, 8'h00},
	'{8'h38, 8'h6c, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'h0c, 8'h00, 8'h00, 8'h0c, 8'h00},
	'{8'h00, 8'h00, 8'hc6, 8'hcc, 8'hf8, 8'hf0, 8'hd8, 8'hcc, 8'hc6, 8'hc0, 8'hc0, 8'hc0, 8'hc0},
	'{8'h00, 8'h00, 8'h7e, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h78},
	'{8'h00, 8'h00, 8'hdb, 8'hdb, 8'hdb, 8'hdb, 8'hdb, 8'hdb, 8'hfe, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'hc6, 8'hc6, 8'hc6, 8'hc6, 8'hc6, 8'hc6, 8'hfc, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'h7c, 8'hc6, 8'hc6, 8'hc6, 8'hc6, 8'hc6, 8'h7c, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'hc0, 8'hc0, 8'hc0, 8'hfe, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'hfe, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h03, 8'h03, 8'h03, 8'h7f, 8'hc3, 8'hc3, 8'hc3, 8'hc3, 8'h7f, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'hc0, 8'he0, 8'hfe, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'hfe, 8'h03, 8'h03, 8'h7e, 8'hc0, 8'hc0, 8'h7f, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'h1c, 8'h36, 8'h30, 8'h30, 8'h30, 8'h30, 8'hfc, 8'h30, 8'h30, 8'h30, 8'h00},
	'{8'h00, 8'h00, 8'h7e, 8'hc6, 8'hc6, 8'hc6, 8'hc6, 8'hc6, 8'hc6, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'h18, 8'h3c, 8'h3c, 8'h66, 8'h66, 8'hc3, 8'hc3, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'hc3, 8'he7, 8'hff, 8'hdb, 8'hc3, 8'hc3, 8'hc3, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'hc3, 8'h66, 8'h3c, 8'h18, 8'h3c, 8'h66, 8'hc3, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'hc0, 8'h60, 8'h60, 8'h30, 8'h18, 8'h3c, 8'h66, 8'h66, 8'hc3, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'hff, 8'h60, 8'h30, 8'h18, 8'h0c, 8'h06, 8'hff, 8'h00, 8'h00, 8'h00, 8'h00},
	'{8'h00, 8'h00, 8'h0f, 8'h18, 8'h18, 8'h18, 8'h38, 8'hf0, 8'h38, 8'h18, 8'h18, 8'h18, 8'h0f},
	'{8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18, 8'h18},
	'{8'h00, 8'h00, 8'hf0, 8'h18, 8'h18, 8'h18, 8'h1c, 8'h0f, 8'h1c, 8'h18, 8'h18, 8'h18, 8'hf0},
	'{8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h06, 8'h8f, 8'hf1, 8'h60, 8'h00, 8'h00, 8'h00}};  // :126
	
	
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, Size, testSize_X, SizeX, SizeY, line, squareX, squareY, character;
	 int selection = 0;
	 int primed;
	 assign DistX = DrawX % SizeX;
    assign DistY = DrawY % SizeY;
	 assign squareX = DrawX/SizeX;
	 assign squareY = DrawY/SizeY;
    assign Size = Ball_size;
    assign SizeX = 8;
    assign SizeY = 13;	 
	 assign test = 0;
	 assign line = DrawY/SizeY;
	 
	 always_ff @ (posedge Clk )
    begin
			case (keycode)
					8'h1A : begin

								primed <= -1;//w
							  end
					8'h00 : begin
					
								if(primed != 0)
									begin
									selection <= selection + primed;//A
									primed <= 0;
									end
								else
									primed <= 0;
								
							  end							  
					8'h16 : begin

					        primed <= 1;//S
							 end
							   
					default: primed <= 0;
			   endcase	 
				
		if( selection < 0 )
			selection <= 0;
		else if (selection > 4)
			selection <= 4;
		
	 end
	 	 
	 
    always_comb
    begin:Ball_on_proc
	 
		if(DistX >= 0 && DistY >= 0 &&  DistX < SizeX && DistY < SizeY )
		begin

        if (squareX == 3 && squareY == 3) 
            begin
				ball_on = 1'b1;
				character = 59;
				end
        else if (squareX == 4 && squareY == 3) 
            begin
				ball_on = 1'b1;
				character = 54;
				end
        else if (squareX == 5 && squareY == 3) 
            begin
				ball_on = 1'b1;
				character = 53;
				end
        else if (squareX == 6 && squareY == 3) 
            begin
				ball_on = 1'b1;
				character = 46;
				end
				
        else if (squareX == 3 && squareY == 5) 
            begin
				ball_on = 1'b1;
				character = 71;
				end
        else if (squareX == 4 && squareY == 5) 
            begin
				ball_on = 1'b1;
				character = 74;
				end
        else if (squareX == 5 && squareY == 5) 
            begin
				ball_on = 1'b1;
				character = 78;
				end
        else if (squareX == 6 && squareY == 5) 
            begin
				ball_on = 1'b1;
				character = 78;
				end
				
        else if (squareX == 3 && squareY == 6) 
            begin
				ball_on = 1'b1;
				character = 71;
				end
        else if (squareX == 4 && squareY == 6) 
            begin
				ball_on = 1'b1;
				character = 74;
				end
        else if (squareX == 5 && squareY == 6) 
            begin
				ball_on = 1'b1;
				character = 78;
				end
        else if (squareX == 6 && squareY == 6) 
            begin
				ball_on = 1'b1;
				character = 76;
				end
				
        else if (squareX == 3 && squareY == 7) 
            begin
				ball_on = 1'b1;
				character = 71;
				end
        else if (squareX == 4 && squareY == 7) 
            begin
				ball_on = 1'b1;
				character = 74;
				end
        else if (squareX == 5 && squareY == 7) 
            begin
				ball_on = 1'b1;
				character = 78;
				end
        else if (squareX == 6 && squareY == 7) 
            begin
				ball_on = 1'b1;
				character = 74;
				end
				
        else if (squareX == 3 && squareY == 8) 
            begin
				ball_on = 1'b1;
				character = 71;
				end
        else if (squareX == 4 && squareY == 8) 
            begin
				ball_on = 1'b1;
				character = 74;
				end
        else if (squareX == 5 && squareY == 8) 
            begin
				ball_on = 1'b1;
				character = 71;
				end
        else if (squareX == 6 && squareY == 8) 
            begin
				ball_on = 1'b1;
				character = 74;
				end
				
        else if (squareX == 3 && squareY == 9) 
            begin
				ball_on = 1'b1;
				character = 71;
				end
        else if (squareX == 4 && squareY == 9) 
            begin
				ball_on = 1'b1;
				character = 74;
				end
        else if (squareX == 5 && squareY == 9) 
            begin
				ball_on = 1'b1;
				character = 70;
				end
        else if (squareX == 6 && squareY == 9) 
            begin
				ball_on = 1'b1;
				character = 72;
				end				
			else 
			begin
            ball_on = 1'b0;
				character = 94;
			end
		end 
		  else 
			begin
            ball_on = 1'b0;
				character = 94;
			end
		
			
     end 
       
    always_comb
    begin:RGB_Display
        if ((ball_on == 1'b1)) 
        begin 
				if(letters[character][DistY][SizeX-DistX-1] == 1)//SizeX-DistX
				begin
            Red = 8'hff - test;
            Green = 8'hff - test;
            Blue = 8'hff - test;
				
				end
				else
				begin
					if((squareY -5) == selection)
					begin
						Red = 8'hff - test;
						Green = 8'h00 - test;
						Blue = 8'h00 - test;	
					end
					else
					begin
						Red = 8'h00 - test;
						Green = 8'h00 - test;
						Blue = 8'h00 - test;						
					end
				end
				
				
		  end       
        else 
        begin 
            Red = 8'h00- test; 
            Green = 8'h00- test;
            Blue = 8'h00 - test;
        end      
    end 
    
endmodule
