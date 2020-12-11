module chip_74153N(input logic Clk, 
						input logic Reset,
						input logic Run,
						output logic Pin15,
						output logic Pin14,
						output logic Pin13,
						output logic Pin12,
						output logic Pin11,
						output logic Pin10,
						input logic Pin9,
						input logic Pin7,
						output logic Pin6,
						output logic Pin5,
						output logic Pin4,
						output logic Pin3,
						output logic Pin2,
						output logic Pin1,
						output logic Done,
						output logic RSLT,
						//output logic E,
						//output logic [3:0] input_o,
						input logic DISP_RSLT);
						
enum logic [1:0] { Halted,
						Set, 
						Test,
						Done_s}   State, Next_state;   // Internal state logic


logic [6:0] inputs;
logic RSLT_Save;
logic [1:0] S;
logic [3:0] D;
logic Y, G;

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
		inputs = 0;
	else if (State == Test)
		inputs++;
end

always_comb
begin
	// Assign next state
	Done = 0;
	Next_state = State;
	D[3:0] = inputs[3:0];
	S[1:0] = inputs[5:4];
	G = inputs[6];
	Y = G ? D[{S[1], S[0]}] : 0;
	//input_o = inputs;
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
			if (inputs == 7'b1111111)
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

always @ (D or S or G)
	begin 
		// Default next state is staying at current state		
		Pin1 = 0;
		Pin2 = 0;
		Pin3 = 0;
		Pin4 = 0;
		Pin5 = 0;
		Pin6 = 0;
		Pin10 = 0;
		Pin11 = 0;
		Pin12 = 0;
		Pin13 = 0;
		Pin14 = 0;
		Pin15 = 0;
		
		RSLT_Save = RSLT;
			
		unique case (State)
			Halted : ;
			Set :
			begin
				RSLT_Save = 1;
			end   
			Test :
			begin
				Pin14 = S[0];
				Pin2 = S[1];
				
				Pin1 = ~G;
				Pin3 = D[3];
				Pin4 = D[2];
				Pin5 = D[1];
				Pin6 = D[0];
				if (Pin7 != Y)
					RSLT_Save = 0;
				Pin15 = ~G;
				Pin13 = D[3];
				Pin12 = D[2];
				Pin11 = D[1];
				Pin10 = D[0];
				if (Pin9 != Y)
					RSLT_Save = 0;
			end
			Done_s : ;
			endcase
		end
		
endmodule