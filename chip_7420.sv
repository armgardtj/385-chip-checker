module chip_7420( input logic Clk, 
						input logic Reset,
						input logic Run,
						output logic Pin13,
						output logic Pin12,
						output logic Pin10,
						output logic Pin9,
						input logic Pin8,
						input logic Pin6,
						output logic Pin5,
						output logic Pin4,
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
		// Default next state is staying at current state
		logic A, B, C, D, Y;
		Next_state = State;
		Done = 0;
		RSLT_Save = RSLT;
		Pin1 = 0;
		Pin2 = 0;
		Pin4 = 0;
		Pin5 = 0;
		Pin9 = 0;
		Pin10 = 0;
		Pin12 = 0;
		Pin13 = 0;
		// Assign next state
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
				if(DISP_RSLT)
					Next_state = Halted;
				else
					Next_state = Done_s;
			end
		endcase
			
		unique case (State)
			Halted : ;
			Set :
			begin
				RSLT_Save = 1;
			end   
			Test :
			begin
				A = inputs[0];
				B = inputs[1];
				C = inputs[2];
				D = inputs[3];
				Y = ~&inputs;
				Pin1 = A;
				Pin2 = B;
				Pin4 = C;
				Pin5 = D;
				if (Pin6 != Y)
					RSLT_Save = 0;
				Pin13 = A;
				Pin12 = B;
				Pin10 = C;
				Pin9 = D;
				if (Pin8 != Y)
					RSLT_Save = 0;
			end
			Done_s :
			begin
				Done = 1;
			end
			endcase
		end
		
endmodule
