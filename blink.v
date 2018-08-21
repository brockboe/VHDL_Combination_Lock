`include "lock.v"

module blink(
input					blink_clk,
input 	[7:0]	 	complete,
output 	[7:0] 	out  
);

//period 		= 0.25 seconds
//frequency 	= 1 000 000 Hz
//wait time		= 250 000 cycles

	parameter 	PERIOD	= 250000;
	reg			state		= 1'b0;
	parameter	s_on		= 1'b1;
	parameter	s_off		= 1'b0;
	reg	[7:0]	out;
	
	always @(posedge blink_clk)
		begin
			case (state)
					s_on :
						begin		
						
							out <= 8'h01;
						
							repeat (8)
								begin
									out <= out + out;
								
									if (complete == 8'h00)
										begin
											state <= s_off;
										end
								end
								
							state <= s_on;
							
						end
					s_off :
						begin
							out <= 8'h00;
							
							if (complete)
							begin
								state <= s_on;
							end
						end
				endcase
		end

endmodule
