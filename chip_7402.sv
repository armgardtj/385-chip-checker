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

									
enum logic [3:0] { Halted,
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

always_latch
	begin 
		// Default next state is staying at current state
		reg A, B, Y;
		Next_state = State;
		Done = 0;
		RSLT_Save = RSLT;
		// Assign next state
		unique case (State)
			Halted : 
			begin
				if (Run) 
					Next_state = Set;
			end
			Set: Next_state = Test;
			Test:
			begin
				if (inputs == max_states)
					Next_state = Done_s;
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
				Y = ~|inputs;
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
				/*
				foreach (APins[i]) begin
					APins[i] = A;
				end
				foreach (BPins[i]) begin
					BPins[i] = B;
				end
				
				foreach (YPins[i]) begin
					if (YPins[i] != outputs)
						RSLT_Save = 0;
				end
				*/
			end
			Done_s :
			begin
				Done = 1;
			end
			endcase
		end
		
endmodule
