module chip_7404( input logic Clk, 
						input logic Reset,
						input logic Run,
						output logic Pin13,
						input logic Pin12,
						output logic Pin11,
						input logic Pin10,
						output logic Pin9,
						input logic Pin8,
						input logic Pin6,
						output logic Pin5,
						input logic Pin4,
						output logic Pin3,
						input logic Pin2,
						output logic Pin1,
						output logic Done,
						output logic RSLT,
						input logic DISP_RSLT);

									
enum logic [3:0] { Halted,
						Set, 
						Test,
						Done_s}   State, Next_state;   // Internal state logic

logic inputs;
logic RSLT_Save;
logic A, Y;

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
	A = inputs;
	Y = ~inputs;
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
			if (inputs == 1'b1)
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

always @ (A)
	begin 
		// Default next state is staying at current state
		Pin13 = 0;
		Pin11 = 0;
		Pin9 = 0;
		Pin5 = 0;
		Pin3 = 0;
		Pin1 = 0;
		
		RSLT_Save = RSLT;			
		unique case (State)
			Halted : ;
			Set :
			begin
				RSLT_Save = 1;
			end
			Test :
			begin
				
				Pin1 = A;
				if (Pin2 != Y)
					RSLT_Save = 0;
				Pin3 = A;
				if (Pin4 != Y)
					RSLT_Save = 0;
				Pin5 = A;
				if (Pin6 != Y)
					RSLT_Save = 0;
				Pin9 = A;
				if (Pin8 != Y)
					RSLT_Save = 0;
				Pin11 = A;
				if (Pin10 != Y)
					RSLT_Save = 0;
				Pin13 = A;
				if (Pin12 != Y)
					RSLT_Save = 0;
			end
			Done_s : ;
			endcase
		end
		
endmodule
