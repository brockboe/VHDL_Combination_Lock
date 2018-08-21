

`timescale 1ns / 1ps

module lockFSM(
input				i_clk,		
input	 [4:0]	Switch,	
output [7:0]	LED			
);	

	parameter	s_idle		= 2'b00;	
	parameter	s_correct	= 2'b01;	
	parameter	s_complete	= 2'b10;	
	parameter	s_codeset	= 2'b11;	
	parameter	on_LED		= 8'hFF;
	parameter	off_LED		= 8'h00;
	reg [1:0]	state			= 2'b11;	
   reg [1:0]	code_index	= 2'b00;	
   reg [7:0] 	code [0:3];				
	reg [7:0]	LED;

always @(posedge i_clk) 				
	begin

	case(state)
	
		s_codeset :
			begin
			
				code[0] = 4'hE;			
				code[1] = 4'hD;			
				code[2] = 4'hB;
				code[3] = 4'h7;
				
				state <= s_idle;
			end

		s_idle :								
			begin
				if (Switch == code[code_index])	
					begin
						state <= s_correct;
					end
				else if (Switch == (4'hF))	
					begin
						state <= s_idle;
					end
				else if (Switch == code[0])	
					begin
						code_index <= 0;
						state <= s_correct;
					end
				else								
					begin
						code_index <= 0;
						state <= s_idle;
						
						LED <= 8'h00;
					end
			end
		
		s_correct :							
			begin		

				LED <= LED |	(code_index == 0 ? 8'd4 :
									 code_index == 1 ? 8'd8 :
									 code_index == 2 ? 8'd16 :
									 code_index == 3 ? 8'd32 : LED);
			
				if (Switch == code[code_index])	
					begin
						state 								<= s_correct;
					end
				else if (Switch == (4'hF))		
					begin
						code_index <= code_index + 1;
						if (code_index < 3)			
							begin
								state <= s_idle;	
							end
						else
							state <= s_complete;
					end
				else if (Switch == code[0])
					begin
						code_index <= 0;
						state <= s_correct;
					end
				else							
					begin
						state <= s_idle;
						code_index <= 0;
					end
			end
			
		s_complete :					
			begin
				if((Switch == (4'hF))||(Switch == code[3]))
					begin
						LED <= on_LED;	
						state <= s_complete;
					end
				else
					begin	
						state <= s_idle;
						code_index <= 0;
						LED <= off_LED;
					end
			end
		
		default :
		        state <= s_idle;
			
	endcase
end 

endmodule