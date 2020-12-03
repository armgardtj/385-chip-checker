module chip_checker_state( input logic Clk, 
									input logic Reset,
									input logic Run,
									input logic Check_Done,
									

									output logic LD_SW,

									output logic Start_Check,
									output logic LD_RSLT,
									output logic DISP_RSLT);

enum logic [5:0] { Halted, 
						Choose1,
						Choose2, 
						Choose3,
						GetResult, 	
						DispResult}   State, Next_state;   // Internal state logic
						
always_ff @ (posedge Clk)
begin
	if (Reset) 
		State <= Halted;
	else 
		State <= Next_state;
end

always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		LD_SW = 0;
		LD_RSLT = 0;
		Start_Check = 0;
		DISP_RSLT = 0;

		// Assign next state
		unique case (State)
			Halted : 
				if (Run) 
					Next_state = Choose2;                      
			Choose1 : 
				begin
				
					if(~Run)
						Next_state = Choose2;
					else
						Next_state = Choose1;
					
				end
			Choose2 : 
				begin
				
						Next_state = Choose3;
					
				end
			Choose3 : 
				begin
				
					if(Check_Done)
						Next_state = GetResult;
					else
						Next_state = Choose3;
					
				end
			GetResult : 
				begin
				
						Next_state = DispResult;
					
				end
			DispResult : 
				begin
				
					if(Run)
						Next_state = Choose1;
					else
						Next_state = DispResult;
				end
			endcase
			
		// Assign next state
		unique case (State)
			Halted : ;                      
			Choose1 :
			begin
				LD_SW  = 1;
				Start_Check = 1;
			end
			Choose2 :
			begin
				LD_SW  = 1;
				Start_Check = 1;
			end
			Choose3 :
			begin
			LD_SW  = 1;
			LD_RSLT = 1;
			end
			GetResult : LD_RSLT = 1;
			DispResult : DISP_RSLT = 1;
			endcase
		end
endmodule