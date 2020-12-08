module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;


logic Clk = 0;
logic [9:0] SW;
logic Run = 1;
logic Reset = 1;
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

logic io13;

wire Pin13;
wire Pin12;
wire Pin11;
wire Pin10;
wire Pin9;
wire Pin8;
wire Pin6;
wire Pin5;
wire Pin4;
wire Pin3;
wire Pin2;
wire Pin1;

logic Pin13D;
logic Pin12D;
logic Pin11D;
logic Pin10D;
logic Pin9D;
logic Pin8D;
logic Pin6D;
logic Pin5D;
logic Pin4D;
logic Pin3D;
logic Pin2D;
logic Pin1D;

//assign Pin13 = io13 ? Pin13D : 8'bZ ;

// A counter to count the instances where simulation results
// do no match with expected results
integer ErrorCnt = 0;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
chip_checker chip_checker0(.*);	
//slc3_testtop slc3_testtop0(.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
SW = 8'h01;
Run = 1;
Reset = 1;

#2;
Reset = 0;
#2;
Reset = 1;
#2;
Run = 0;
#2;
Run = 1;
#2;
Run = 0;
#2;
Run = 1;

end
endmodule