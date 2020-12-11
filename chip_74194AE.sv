module chip_74194AE(input logic Clk, 
						input logic Reset,
						input logic Run,
						input logic Pin15,
						input logic Pin14,
						input logic Pin13,
						input logic Pin12,
						output logic Pin11,
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


logic [9:0] inputs;
logic RSLT_Save;
logic CLR, CCLK, SR, SL, S0, S1, A, B, C, D;
logic [3:0] Q = {4'b0000};

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
	A = inputs[1];
	B = inputs[2];
	C = inputs[3];
	D = inputs[4];
	S0 = inputs[5];
	S1 = inputs[6];
	CLR = ~inputs[7];
	SR = inputs[8];
	SL = inputs[9];
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
			if (inputs == 10'b1111111111)
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
		if (~CLR)
			Q[3:0] = 0;
		else if (S1 && S0)
			Q[3:0] = {A,B,C,D};
		else if (CCLK)
		begin
			if (S1)
				Q = {Q[2],Q[1],Q[0],SL};
			else if (S0)
				Q = {SR,Q[3],Q[2],Q[1]};
			else
				Q = {Q[3],Q[2],Q[1],Q[0]};
		end
		Pin1 = 0;
		Pin2 = 0;
		Pin3 = 0;
		Pin4 = 0;
		Pin5 = 0;
		Pin6 = 0;
		Pin7 = 0;
		Pin9 = 0;
		Pin10 = 0;
		Pin11 = 0;
			
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
				Pin2 = SR;
				Pin3 = A;
				Pin4 = B;
				Pin5 = C;
				Pin6 = D;
				Pin7 = SL;
				Pin9 = S0;
				Pin10 = S1;
				Pin11 = CCLK;
				if (Q[3:0] != {Pin15, Pin14, Pin13, Pin12})
					RSLT_Save = 0;
			end
			Done_s : ;
			endcase
		end
		
endmodule
