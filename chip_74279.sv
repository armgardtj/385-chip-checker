module chip_74279( input logic Clk, 
						input logic Reset,
						input logic Run,
						output logic Pin15,
						output logic Pin14,
						input logic Pin13,
						output logic Pin12,
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
						input logic DISP_RSLT);

									
enum logic [1:0] { Halted,
						Set, 
						Test,
						Done_s}   State, Next_state;   // Internal state logic


logic [1:0] inputs;
logic RSLT_Save;
logic R, S, Q;
wire rq;
nand(rq, R, Q);
nand(Q, rq, S);

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
	R = ~inputs[1];
	S = ~inputs[0];
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
			if (inputs == 2'b11)
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
		Pin5 = 0;
		Pin6 = 0;
		Pin10 = 0;
		Pin11 = 0;
		Pin12 = 0;
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
				Pin1 = R;
				Pin2 = S;
				Pin3 = S;
				if (Pin4 != Q)
					RSLT_Save = 0;
				Pin5 = R;
				Pin6 = S;
				if (Pin7 != Q)
					RSLT_Save = 0;
				Pin10 = R;
				Pin11 = S;
				Pin12 = S;
				if (Pin9 != Q)
					RSLT_Save = 0;
				Pin14 = R;
				Pin15 = S;
				if (Pin13 != Q)
					RSLT_Save = 0;
			end
			Done_s : ;
			endcase
		end
		
endmodule
