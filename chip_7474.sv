module chip_7474( input logic Clk, 
						input logic Reset,
						input logic Run,
						output logic Pin13,
						output logic Pin12,
						output logic Pin11,
						output logic Pin10,
						input logic Pin9,
						input logic Pin8,
						input logic Pin6,
						input logic Pin5,
						output logic Pin4,
						output logic Pin3,
						output logic Pin2,
						output logic Pin1,
						output logic Done,
						output logic RSLT,
						
						input logic DISP_RSLT);
						

									
enum logic [1:0] { Halted,
						Set, 
						Test,
						Done_s}   State, Next_state;   // Internal state logic


logic [3:0] inputs;
logic RSLT_Save;
logic PRE, CLR, CCLK, D, Q, QN;
wire m1, m2, m3, m4;
nand(m1, PRE, m4, m2);
nand(m2, m1, CLR, CCLK);
nand(m3, m2, CCLK, m4);
nand(m4, m3, CLR, D);
nand(Q, PRE, m2, QN);
nand(QN, Q, CLR, m3);

always_ff @ (posedge Clk)
begin
	if (Reset)
	begin
		State <= Halted;
	end
	else 
	begin
		State <= Next_state;
		RSLT = RSLT_Save; 
	end
	
	if (State == Set)
		inputs = 1;
	else if (State == Test)
		inputs++;
end

always_comb
begin
	// Assign next state
	Done = 0;
	Next_state = State;
	CCLK = inputs[0];
	D = inputs[1];
	PRE = ~inputs[2];
	CLR = ~inputs[3];
	unique case (State)
		Halted : 
		begin
			if (Run) 
				Next_state = Set;
			else
				Next_state = Halted;
		end
		Set: Next_state = Test;
		Test:
		begin
			if (inputs == 4'b1011)
			begin
				Next_state = Done_s;
				Done = 1;
			end
			else
				Next_state = Test;
		end
		Done_s : 
		begin
			Done = 1;
			if(DISP_RSLT)
				Next_state = Halted;
			else
				Next_state = Done_s;
		end
	endcase
end

always @ (inputs)
	begin 
		// Default next state is staying at current state	
		Pin1 = 0;
		Pin2 = 0;
		Pin3 = 0;
		Pin4 = 0;
		Pin10 = 0;
		Pin11 = 0;
		Pin12 = 0;
		Pin13 = 0;
			
		RSLT_Save = RSLT;
		unique case (State)
			Halted : ;
			Set :
			begin
				RSLT_Save = 1;
			end   
			Test :
			begin
				Pin1 = CLR;
				Pin2 = D;
				Pin3 = CCLK;
				Pin4 = PRE;
				if (Pin5 != Q || Pin6 != QN)
					RSLT_Save = 0;
				Pin13 = CLR;
				Pin12 = D;
				Pin11 = CCLK;
				Pin10 = PRE;
				if (Pin9 != Q || Pin8 != QN)
					RSLT_Save = 0;
			end
			Done_s : ;
			endcase
		end
		
endmodule
