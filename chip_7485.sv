module chip_7485( input logic Clk, 
						input logic Reset,
						input logic Run,
						output logic Pin15,
						output logic Pin14,
						output logic Pin13,
						output logic Pin12,
						output logic Pin11,
						output logic Pin10,
						output logic Pin9,
						input logic Pin7,
						input logic Pin6,
						input logic Pin5,
						output logic Pin4,
						output logic Pin3,
						output logic Pin2,
						output logic Pin1,
						output logic Done,
						output logic RSLT,
						output logic [3:0] expected,
						output logic [3:0] input_o,
						input logic DISP_RSLT);
						
enum logic [1:0] {Halted,
						Set, 
						Test,
						Done_s}   State, Next_state;   // Internal state logic


logic [10:0] inputs;
logic RSLT_Save;
logic [3:0] A;
logic [3:0] B;
logic [2:0] C;
logic G, L, E;

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
	A[3:0] = inputs[3:0];
	B[3:0] = inputs[7:4];
	C[2:0] = inputs[10:8];
	if (A > B) begin
		G = 1;
		L = 0;
		E = 0;
	end
	else if (A < B) begin
		G = 0;
		L = 1;
		E = 0;
	end
	else begin
		if (C[0] == 1) begin
			G = 0;
			L = 0;
			E = 1;
		end
		else if (C[2] == C[1]) begin
			G = ~C[2];
			L = ~C[1];
			E = 0;
		end
		else begin
			G = C[2];
			L = C[1];
			E = 0;
		end
	end
	expected[2:0] = {G,E,L};
	input_o[3:0] = A;
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
			if (inputs == 11'b11111111111)
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
		Pin4 = 0;
		Pin9 = 0;
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
				Pin1 = B[3];
				Pin2 = C[1];
				Pin3 = C[0];
				Pin4 = C[2];
				Pin9 = B[0];
				Pin10 = A[0];
				Pin11 = B[1];
				Pin12 = A[1];
				Pin13 = A[2];
				Pin14 = B[2];
				Pin15 = A[3];
				if (Pin5 != G || Pin6 != E || Pin7 != L)
					RSLT_Save = 0;
			end
			Done_s : ;
			endcase
		end
		
endmodule
