module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;


logic Clk = 0;
logic [9:0] SW;
logic Run = 1;
logic Reset = 1;
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
logic Pin13;
logic Pin12;
logic Pin11;
logic Pin10;
logic Pin9;
logic Pin8;
logic Pin6;
logic Pin5;
logic Pin4;
logic Pin3;
logic Pin2;
logic Pin1;				
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