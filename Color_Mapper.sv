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


module  color_mapper (input        Clk, input        RSLT,  input        [9:0] DrawX, DrawY, Ball_size, input [7:0] keycode,
                       output logic [7:0]  Red, Green, Blue, output int select );
    
    logic ball_on;
	 
	 logic  [94:0][12:0][7:0] letters;
    
	 // 800 horizontal pixels indexed 0 to 799
    // 525 vertical pixels indexed 0 to 524
    parameter [9:0] hpixels = 10'b1100011111;
    parameter [9:0] vlines = 10'b1000001100;
	
	logic [39:0]filled_lines;
	
	assign filled_lines = 40'b0000000000000000000000000000000000001000;
	
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
	 assign select = selection + 1;
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
		else if (selection > 17)
			selection <= 17;
		
	 end
	 	 
	 
    always_comb
    begin

		ball_on = 1'b0;
		character = 94;
	 
		//if(DistX >= 0 && DistY >= 0 &&  DistX < SizeX && DistY < SizeY )
		//begin
		
			//if(filled_lines[squareY] == 1)
			//begin
			  if (squareX == 3 && squareY == 3) 
					begin
					ball_on <= 1'b1;
					character <= 59;
					end
			  if (squareX == 4 && squareY == 3) 
					begin
					ball_on <= 1'b1;
					character <= 54;
					end
			  if (squareX == 5 && squareY == 3) 
					begin
					ball_on <= 1'b1;
					character <= 53;
					end
			  if (squareX == 6 && squareY == 3) 
					begin
					ball_on <= 1'b1;
					character <= 46;
					end
					
					/*
			  if (squareX == 10 && squareY == 3) 
					begin
					ball_on <= 1'b1;
					character <= 43;
					end
			  if (squareX == 11 && squareY == 3) 
					begin
					ball_on <= 1'b1;
					character <= 42;
					end
			  if (squareX == 12 && squareY == 3) 
					begin
					ball_on <= 1'b1;
					character <= 61;
					end
			  if (squareX == 13 && squareY == 3) 
					begin
					ball_on <= 1'b1;
					character <= 44;
					end
			  if (squareX == 14 && squareY == 3) 
					begin
					ball_on <= 1'b1;
					character <= 42;
					end
					*/
				if(RSLT)
				begin
					if (squareX == 17 && squareY == 3) 
						begin
						ball_on <= 1'b1;
						character <= 55;
						end
				  if (squareX == 18 && squareY == 3) 
						begin
						ball_on <= 1'b1;
						character <= 47;
						end
				  if (squareX == 19 && squareY == 3) 
						begin
						ball_on <= 1'b1;
						character <= 47;
						end
				  if (squareX == 20 && squareY == 3) 
						begin
						ball_on <= 1'b1;
						character <= 58;
						end
				end
				else
				begin
				
					if (squareX == 17 && squareY == 3) 
						begin
						ball_on <= 1'b1;
						character <= 60;
						end
					if (squareX == 18 && squareY == 3) 
						begin
						ball_on <= 1'b1;
						character <= 61;
						end
					if (squareX == 19 && squareY == 3) 
						begin
						ball_on <= 1'b1;
						character <= 58;
						end			
					
				end
		
			
			//end
			
        if (squareX == 3 && squareY == 5) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 5) 
            begin
				ball_on <= 1'b1;
				character <= 74;
				end
        if (squareX == 5 && squareY == 5) 
            begin
				ball_on <= 1'b1;
				character <= 78;
				end
        if (squareX == 6 && squareY == 5) 
            begin
				ball_on <= 1'b1;
				character <= 78;
				end
				
        if (squareX == 3 && squareY == 6) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 6) 
            begin
				ball_on <= 1'b1;
				character <= 74;
				end
        if (squareX == 5 && squareY == 6) 
            begin
				ball_on <= 1'b1;
				character <= 78;
				end
        if (squareX == 6 && squareY == 6) 
            begin
				ball_on <= 1'b1;
				character <= 76;
				end
			
			//7404
        if (squareX == 3 && squareY == 7) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 7) 
            begin
				ball_on <= 1'b1;
				character <= 74;
				end
        if (squareX == 5 && squareY == 7) 
            begin
				ball_on <= 1'b1;
				character <= 78;
				end
        if (squareX == 6 && squareY == 7) 
            begin
				ball_on <= 1'b1;
				character <= 74;
				end

		 //7410
		  if (squareX == 3 && squareY == 8) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 8) 
            begin
				ball_on <= 1'b1;
				character <= 74;
				end
        if (squareX == 5 && squareY == 8) 
            begin
				ball_on <= 1'b1;
				character <= 77;
				end
        if (squareX == 6 && squareY == 8) 
            begin
				ball_on <= 1'b1;
				character <= 78;
				end
				
			//7420
		  if (squareX == 3 && squareY == 9) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 9) 
            begin
				ball_on <= 1'b1;
				character <= 74;
				end
        if (squareX == 5 && squareY == 9) 
            begin
				ball_on <= 1'b1;
				character <= 76;
				end
        if (squareX == 6 && squareY == 9) 
            begin
				ball_on <= 1'b1;
				character <= 78;
				end
				
			//7427
		  if (squareX == 3 && squareY == 10) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 10) 
            begin
				ball_on <= 1'b1;
				character <= 74;
				end
        if (squareX == 5 && squareY == 10) 
            begin
				ball_on <= 1'b1;
				character <= 76;
				end
        if (squareX == 6 && squareY == 10) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end				
				
			//7474
        if (squareX == 3 && squareY == 11) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 11) 
            begin
				ball_on <= 1'b1;
				character <= 74;
				end
        if (squareX == 5 && squareY == 11) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 6 && squareY == 11) 
            begin
				ball_on <= 1'b1;
				character <= 74;
				end

			//7485
        if (squareX == 3 && squareY == 12) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 12) 
            begin
				ball_on <= 1'b1;
				character <= 74;
				end
        if (squareX == 5 && squareY == 12) 
            begin
				ball_on <= 1'b1;
				character <= 70;
				end
        if (squareX == 6 && squareY == 12) 
            begin
				ball_on <= 1'b1;
				character <= 73;
				end
				
		//7486
        if (squareX == 3 && squareY == 13) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 13) 
            begin
				ball_on <= 1'b1;
				character <=74;
				end
        if (squareX == 5 && squareY == 13) 
            begin
				ball_on <= 1'b1;
				character <= 70;
				end
        if (squareX == 6 && squareY == 13) 
            begin
				ball_on <= 1'b1;
				character <= 72;
				end		
		
		//74109N
        if (squareX == 3 && squareY == 14) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 14) 
            begin
				ball_on <= 1'b1;
				character <=74;
				end
        if (squareX == 5 && squareY == 14) 
            begin
				ball_on <= 1'b1;
				character <= 77;
				end
        if (squareX == 6 && squareY == 14) 
            begin
				ball_on <= 1'b1;
				character <= 78;
				end					
        if (squareX == 7 && squareY == 14) 
            begin
				ball_on <= 1'b1;
				character <= 69;
				end
        if (squareX == 8 && squareY == 14) 
            begin
				ball_on <= 1'b1;
				character <= 48;
				end	

		//74151N
        if (squareX == 3 && squareY == 15) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 15) 
            begin
				ball_on <= 1'b1;
				character <=74;
				end
        if (squareX == 5 && squareY == 15) 
            begin
				ball_on <= 1'b1;
				character <= 77;
				end
        if (squareX == 6 && squareY == 15) 
            begin
				ball_on <= 1'b1;
				character <= 73;
				end					
        if (squareX == 7 && squareY == 15) 
            begin
				ball_on <= 1'b1;
				character <= 77;
				end
        if (squareX == 8 && squareY == 15) 
            begin
				ball_on <= 1'b1;
				character <= 48;
				end	

		//74153N
        if (squareX == 3 && squareY == 16) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 16) 
            begin
				ball_on <= 1'b1;
				character <=74;
				end
        if (squareX == 5 && squareY == 16) 
            begin
				ball_on <= 1'b1;
				character <= 77;
				end
        if (squareX == 6 && squareY == 16) 
            begin
				ball_on <= 1'b1;
				character <= 73;
				end					
        if (squareX == 7 && squareY == 16) 
            begin
				ball_on <= 1'b1;
				character <= 75;
				end
        if (squareX == 8 && squareY == 16) 
            begin
				ball_on <= 1'b1;
				character <= 48;
				end	

		//74157N
        if (squareX == 3 && squareY == 17) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 17) 
            begin
				ball_on <= 1'b1;
				character <=74;
				end
        if (squareX == 5 && squareY == 17) 
            begin
				ball_on <= 1'b1;
				character <= 77;
				end
        if (squareX == 6 && squareY == 17) 
            begin
				ball_on <= 1'b1;
				character <= 73;
				end					
        if (squareX == 7 && squareY == 17) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 8 && squareY == 17) 
            begin
				ball_on <= 1'b1;
				character <= 48;
				end				
				
		//74161N
        if (squareX == 3 && squareY == 18) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 18) 
            begin
				ball_on <= 1'b1;
				character <=74;
				end
        if (squareX == 5 && squareY == 18) 
            begin
				ball_on <= 1'b1;
				character <= 77;
				end
        if (squareX == 6 && squareY == 18) 
            begin
				ball_on <= 1'b1;
				character <= 72;
				end					
        if (squareX == 7 && squareY == 18) 
            begin
				ball_on <= 1'b1;
				character <= 77;
				end
        if (squareX == 8 && squareY == 18) 
            begin
				ball_on <= 1'b1;
				character <= 48;
				end								

		//74163N
        if (squareX == 3 && squareY == 19) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 19) 
            begin
				ball_on <= 1'b1;
				character <=74;
				end
        if (squareX == 5 && squareY == 19) 
            begin
				ball_on <= 1'b1;
				character <= 77;
				end
        if (squareX == 6 && squareY == 19) 
            begin
				ball_on <= 1'b1;
				character <= 72;
				end					
        if (squareX == 7 && squareY == 19) 
            begin
				ball_on <= 1'b1;
				character <= 75;
				end
        if (squareX == 8 && squareY == 19) 
            begin
				ball_on <= 1'b1;
				character <= 48;
				end		
				
		//74194N
        if (squareX == 3 && squareY == 20) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 20) 
            begin
				ball_on <= 1'b1;
				character <=74;
				end
        if (squareX == 5 && squareY == 20) 
            begin
				ball_on <= 1'b1;
				character <= 77;
				end
        if (squareX == 6 && squareY == 20) 
            begin
				ball_on <= 1'b1;
				character <= 69;
				end					
        if (squareX == 7 && squareY == 20) 
            begin
				ball_on <= 1'b1;
				character <= 74;
				end
        if (squareX == 8 && squareY == 20) 
            begin
				ball_on <= 1'b1;
				character <= 48;
				end	
				
		//74195N
        if (squareX == 3 && squareY == 21) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 21) 
            begin
				ball_on <= 1'b1;
				character <=74;
				end
        if (squareX == 5 && squareY == 21) 
            begin
				ball_on <= 1'b1;
				character <= 77;
				end
        if (squareX == 6 && squareY == 21) 
            begin
				ball_on <= 1'b1;
				character <= 69;
				end					
        if (squareX == 7 && squareY == 21) 
            begin
				ball_on <= 1'b1;
				character <= 73;
				end
        if (squareX == 8 && squareY == 21) 
            begin
				ball_on <= 1'b1;
				character <= 48;
				end	

			//74279
        if (squareX == 3 && squareY == 22) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end
        if (squareX == 4 && squareY == 22) 
            begin
				ball_on <= 1'b1;
				character <=74;
				end
        if (squareX == 5 && squareY == 22) 
            begin
				ball_on <= 1'b1;
				character <= 76;
				end
        if (squareX == 6 && squareY == 22) 
            begin
				ball_on <= 1'b1;
				character <= 71;
				end					
        if (squareX == 7 && squareY == 22) 
            begin
				ball_on <= 1'b1;
				character <= 69;
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
