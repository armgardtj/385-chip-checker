module chip_74157N(input logic Clk, 
						input logic Reset,
						input logic Run,
						output logic Pin15,
						output logic Pin14,
						output logic Pin13,
						input logic Pin12,
						output logic Pin11,
						output logic Pin10,
						input logic Pin9,
						input logic Pin7,
						output logic Pin6,
						output logic Pin5,
						input logic Pin4,
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


logic [3:0] inputs;
logic RSLT_Save;
logic A, B, S, G, Y;

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
	G = inputs[3];
	S = inputs[2];
	A = inputs[1];
	B = inputs[0];
	Y = G ? (S ? B : A) : 0;
	//E = Y;
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
			if (inputs == 4'b1111)
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

always @ (A or B or S or G)
	begin 
		// Default next state is staying at current state		
		Pin1 = 0;
		Pin2 = 0;
		Pin3 = 0;
		Pin5 = 0;
		Pin6 = 0;
		Pin10 = 0;
		Pin11 = 0;
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
				Pin1 = S;
				Pin15 = ~G;
				
				Pin2 = A;
				Pin3 = B;
				if (Pin4 != Y)
					RSLT_Save = 0;
				Pin5 = A;
				Pin6 = B;
				if (Pin7 != Y)
					RSLT_Save = 0;
				Pin11 = A;
				Pin10 = B;
				if (Pin9 != Y)
					RSLT_Save = 0;
				Pin14 = A;
				Pin13 = B;
				if (Pin12 != Y)
					RSLT_Save = 0;
			end
			Done_s : ;
			endcase
		end
		
endmodule