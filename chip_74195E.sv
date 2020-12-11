module chip_74195E(input logic Clk, 
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
						output logic [3:0] E,
						output logic [3:0] input_o,
						input logic DISP_RSLT);
						
enum logic [1:0] { Halted,
						Set, 
						Test,
						Done_s}   State, Next_state;   // Internal state logic


logic [8:0] inputs;
logic RSLT_Save;
logic SHLD, CLR, CCLK, A, B, C, D, J, K;
logic [4:0] Q = {5'b00000};

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
	SHLD = ~inputs[5];
	J = inputs[6];
	K = ~inputs[7];
	CLR = ~inputs[8];
	input_o = inputs[3:0];
	E = Q[4:1];
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
			if (inputs == 9'b101111111)
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
			Q[4:0] = 0;
		else if (~SHLD)
			Q[4:0] = {A,B,C,D,~D};
		else if (CCLK)
		begin
			if (~J && K)
				Q[4:0] = {Q[4],Q[4],Q[3],Q[2],~Q[2]};
			else if (~J && ~K)
				Q[4:0] = {1'b0,Q[4],Q[3],Q[2],~Q[2]};
			else if (J && K)
				Q[4:0] = {1'b1,Q[4],Q[3],Q[2],~Q[2]};
			else
				Q[4:0] = {~Q[4],Q[4],Q[3],Q[2],~Q[2]};
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
				Pin2 = J;
				Pin3 = K;
				Pin4 = A;
				Pin5 = B;
				Pin6 = C;
				Pin7 = D;
				Pin9 = SHLD;
				Pin10 = CCLK;
				if (Q[4:0] != {Pin15, Pin14, Pin13, Pin12, Pin11})
					RSLT_Save = 0;
			end
			Done_s : ;
			endcase
		end
		
endmodule
