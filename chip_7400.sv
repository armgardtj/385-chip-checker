module chip_7400( input logic Clk, 
									input logic Reset,
									input logic Run,
									output logic Pin13,
									output logic Pin12,
									input logic Pin11,
									output logic Pin10,
									output logic Pin9,
									input logic Pin8,
									input logic Pin6,
									output logic Pin5,
									output logic Pin4,
									input logic Pin3,
									output logic Pin2,
									output logic Pin1,
									output logic Done,
									output logic RSLT,
									input logic DISP_RSLT);

									
enum logic [5:0] { Halted,
						Set, 
						Test,
						Done_s}   State, Next_state;   // Internal state logic


reg [1:0] inputs;

logic RSLT_Save;
const int max_states = 3;

always_ff @ (posedge Clk)
begin
	if (Reset)
	begin
		State <= Halted;
		inputs = 0;
	end
	else 
	begin
		State <= Next_state;
		RSLT = RSLT_Save; 
	end
	
	if (State == Test)
		inputs++;
end

always_comb
	begin 
		// Default next state is staying at current state
		reg A, B, Y;
		Next_state = State;
		Done = 0;
		RSLT_Save = RSLT;
		Pin1 = 0;
		Pin2 = 0;
		Pin4 = 0;
		Pin5 = 0;
		Pin10 = 0;
		Pin9 = 0;
		Pin13 = 0;
		Pin12 = 0
		;
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
				if (inputs == max_states)
					Next_state = Done_s;
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
				A = inputs[1];
				B = inputs[0];
				Y = ~&inputs;
				Pin1 = A;
				Pin2 = B;
				if (Pin3 != Y)
					RSLT_Save = 0;
				Pin4 = A;
				Pin5 = B;
				if (Pin6 != Y)
					RSLT_Save = 0;
				Pin10 = A;
				Pin9 = B;
				if (Pin8 != Y)
					RSLT_Save = 0;
				Pin13 = A;
				Pin12 = B;
				if (Pin11 != Y)
					RSLT_Save = 0;
			end
			Done_s :
			begin
				Done = 1;
			end
			
			endcase
			
			//

		end
		
endmodule

/*
module chip_Quad_2_input_NOR( input logic Clk, 
									input logic Reset,
									input logic Run,
									output logic Pin13,
									output logic Pin12,
									input logic Pin11,
									output logic Pin10,
									output logic Pin9,
									input logic Pin8,
									input logic Pin6,
									output logic Pin5,
									output logic Pin4,
									input logic Pin3,
									output logic Pin2,
									output logic Pin1,
									output logic Done,
									output logic RSLT);

									
enum logic [5:0] { Halted,
						Set, 
						LowLow,
						LowHigh, 
						HighLow, 	
						HighHigh,
						Done_s}   State, Next_state;   // Internal state logic


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
end

always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		Done = 0;
		RSLT_Save = RSLT;
		Pin13  = 0;
		Pin12  = 0;
		// Assign next state
		unique case (State)
			Halted : 
				if (Run) 
					Next_state = Set;
			Set: Next_state = LowLow;
			LowLow : 
				begin
					Next_state = LowHigh;
				end
			LowHigh : 
				begin
					Next_state = HighLow;
				end
			HighLow : 
				begin
					Next_state = HighHigh;
				end
			HighHigh : 
				begin
					Next_state = Done_s;
				end
			Done_s : 
				begin
				if()
					Next_state = Halted;
				end
			endcase
			
		unique case (State)
			Halted : ;
			Set :
			begin
				RSLT_Save = 1;
			end                     
			LowLow : 
			begin
				Pin13  = 0;
				Pin12  = 0;
				if(Pin11 != 1)
				begin
					RSLT_Save = 0;
				end
			end
			LowHigh :
			begin
				Pin13  = 0;
				Pin12  = 1;
				if(Pin11 != 0)
				begin
					RSLT_Save = 0;
				end
			end
			HighLow :
			begin
				Pin13  = 1;
				Pin12  = 0;
				if(Pin11 != 0)
				begin
					RSLT_Save = 0;
				end
			end
			HighHigh : 
			begin
				Pin13  = 1;
				Pin12  = 1;
				if(Pin11 != 0)
				begin
					RSLT_Save = 0;
				end
			end
			Done_s :
			begin
				Done = 1;
			end
			endcase
			
			//

		end
		
endmodule
*/