module chip_7402( input logic Clk, 
						input logic Reset,
						input logic Run,
						input logic Pin13,
						output logic Pin12,
						output logic Pin11,
						input logic Pin10,
						output logic Pin9,
						output logic Pin8,
						output logic Pin6,
						output logic Pin5,
						input logic Pin4,
						output logic Pin3,
						output logic Pin2,
						input logic Pin1,
						output logic Done,
						output logic RSLT,
						input logic DISP_RSLT);

									
enum logic [1:0] { Halted,
						Set, 
						Test,
						Done_s}   State, Next_state;   // Internal state logic


logic [1:0] inputs;
logic RSLT_Save;
logic A, B, Y;

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
	A = inputs[1];
	B = inputs[0];
	Y = ~|inputs;
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
		Pin2 = 0;
		Pin3 = 0;
		Pin5 = 0;
		Pin6 = 0;
		Pin8 = 0;
		Pin9 = 0;
		Pin11 = 0;
		Pin12 = 0;
		
		RSLT_Save = RSLT;

		unique case (State)
			Halted : ;
			Set :
			begin
				RSLT_Save = 1;
			end
			Test :
			begin
				Pin2 = A;
				Pin3 = B;
				if (Pin1 != Y)
					RSLT_Save = 0;
				Pin5 = A;
				Pin6 = B;
				if (Pin4 != Y)
					RSLT_Save = 0;
				Pin8 = A;
				Pin9 = B;
				if (Pin10 != Y)
					RSLT_Save = 0;
				Pin11 = A;
				Pin12 = B;
				if (Pin13 != Y)
					RSLT_Save = 0;
			end
			Done_s : ;
			endcase
		end
		
endmodule
