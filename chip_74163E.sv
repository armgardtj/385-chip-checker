module chip_74163E( input logic Clk, 
						input logic Reset,
						input logic Run,
						input logic Pin15,
						input logic Pin14,
						input logic Pin13,
						input logic Pin12,
						input logic Pin11,
						output logic Pin10,
						output logic Pin9,
						output logic Pin7,
						output logic Pin6,
						output logic Pin5,
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


logic [6:0] inputs;
logic RSLT_Save;
logic A, B, C, D, CLR, LOAD, CCLK, ENP, ENT;
logic [3:0] Q = {4'b0000};
logic [3:0] ctr;

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
	begin
		inputs = 0;
		ctr = 0;
	end
	else if (State == Test)
	begin
		ctr++;
		if (ctr == 4'b1111)
		begin
			ctr = 0;
			inputs++;
		end
	end
end

always_comb
begin
	// Assign next state
	Done = 0;
	Next_state = State;
	
	CCLK = inputs[0];
	LOAD = ~inputs[1];
	A = inputs[2];
	B = inputs[3];
	C = inputs[4];
	D = inputs[5];
	CLR = ~inputs[6];
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
			if (inputs == 7'b1011111)
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
		Pin5 = 0;
		Pin6 = 0;
		Pin7 = 0;
		Pin9 = 0;
		Pin10 = 0;
		
		RSLT_Save = RSLT;
		
		if (~CLR)
			Q = 4'b0000;
		else if (~LOAD)
			Q = {D, C, B, A};
		else
			Q = ctr;
			
		unique case (State)
			Halted : ;
			Set :
			begin
				RSLT_Save = 1;
			end   
			Test :
			begin
				Pin1 = CLR;
				Pin2 = CCLK;
				Pin3 = A;
				Pin4 = B;
				Pin5 = C;
				Pin6 = D;
				Pin7 = 1;
				Pin9 = LOAD;
				Pin10 = 1;
				if (Q != {Pin11, Pin12, Pin13, Pin14})
					RSLT_Save = 0;
			end
			Done_s : ;
			endcase
		end
		
endmodule
