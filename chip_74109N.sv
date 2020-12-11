module chip_74109N(input logic Clk, 
						input logic Reset,
						input logic Run,
						output logic Pin15,
						output logic Pin14,
						output logic Pin13,
						output logic Pin12,
						output logic Pin11,
						input logic Pin10,
						input logic Pin9,
						input logic Pin7,
						input logic Pin6,
						output logic Pin5,
						output logic Pin4,
						output logic Pin3,
						output logic Pin2,
						output logic Pin1,
						output logic Done,
						output logic RSLT,
						output logic [3:0] E,
						output logic [3:0] input_o,
						input logic DISP_RSLT);
						
enum logic [1:0] { Halted,
						Set, 
						Test,
						Done_s}   State, Next_state;   // Internal state logic


logic [4:0] inputs;
logic RSLT_Save;
logic PRE, CLR, CCLK, D, J, K, Q, QN;

wire a1, a2, b1, b2, c1, c2;
and(a1,J,QN,CLR,c2);
and(a2,Q,K,CLR,c2);
nand(b1,c1,PRE,b2);
nor(b2,a1,a2);
nand(c1,b1,CCLK,CLR);
nand(c2,c1,CCLK,b2);
nand(Q,PRE,c1,QN);
nand(QN,Q,c2,CLR);

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
	CCLK = inputs[0];
	J = inputs[1];
	K = ~inputs[2];
	PRE = ~inputs[3];
	CLR = ~inputs[4];
	E = {Q, QN};
	input_o[3:0] = inputs[3:0];
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
			if (inputs == 5'b10111)
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
		Pin5 = 0;
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
				Pin1 = CLR;
				Pin2 = J;
				Pin3 = K;
				Pin4 = CCLK;
				Pin5 = PRE;
				if (Pin6 != Q || Pin7 != QN)
					RSLT_Save = 0;
				Pin15 = CLR;
				Pin14 = J;
				Pin13 = K;
				Pin12 = CCLK;
				Pin11 = PRE;
				if (Pin10 != Q || Pin9 != QN)
					RSLT_Save = 0;
			end
			Done_s : ;
			endcase
		end
		
endmodule
