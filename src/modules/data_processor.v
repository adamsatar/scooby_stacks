////////////////////////////////////////////////////////////////////////////////
// Course: 				 CSSE220
// Engineer(s):		 Adam Satar, Frank Lancaster, August Dailey,
//                    Will McEvoy, Adam Czyzewski
//
// Create Date: 2.9.18
// Design Name: <name_of_top-level_design>

// Module Name: data_processor
// 
// Target Device: 	Spartan3E XC3S500E
// Tool versions: 	<tool_versions>
// 
// Description:	 	The scooby_stack work-horse.
//   					 
// Dependencies:	 	data_stack.v
//						 	mem_stack.v
//    
// Revision:
//    <Code_revision_information>
// Additional Comments:
//    <Additional_comments>
////////////////////////////////////////////////////////////////////////////////

module data_processor(

		input clk, async_reset,
		
		//input [1:0] ALUA_src, ALUB_src,
		
		//input wire signed [15:0] sr0, sr1, //want to  drop these in for ALUA,ALUB

		input wire signed [15:0] ALUA, ALUB,
		input wire [2:0] ALUOP, //from control

		output reg signed [15:0]ALUOUT,
		
		output reg [2:0] STATUS

    );

	// reg extra;
	 //reg result[15:0];
	 reg [2:0] STATUS_int;
	 reg signed [15:0] ALUOUT_int;

/************************STATUS codes*****************************
								STATUS[1:0] 
									00: equal
									01: A < B
									10: A > B
									11: UNUSED
			
								STATUS[2]
									0: 
									1: overflow
************************STATUS codes*****************************/	 
	 
	 always @ * begin 
			STATUS_int[1:0] = 2'b00;
			case(ALUOP)
				3'b000 : ALUOUT_int = ALUA + ALUB; 			//add
				3'b001 : ALUOUT_int = ALUB - ALUA; 			//sub
				3'b010 : ALUOUT_int = ALUA & ALUB; 			//bit and
				3'b110 : ALUOUT_int = ALUA | ALUB; 			//bit or


				
				3'b100 : begin
								ALUOUT_int = ALUA - ALUB;
								STATUS_int[1:0] = ALUOUT_int == 0 	 ? 2'b00  :	// equal
														ALUOUT_int < 0  	 ? 2'b01  : // A < B
																					2'b10;  	// A > B
											 
							end
				//Remove after debug; have to implement something for default though.
				default : $display("Unimplemented ALUOP");
			endcase
			end
	 
	 always @ * begin
		STATUS_int[2] = 0;
			if(ALUOP == 3'b000)
				begin
				STATUS_int[2] = ((ALUA > 0 && ALUB > 0 && ALUOUT_int <= 0) || 
				(ALUA > 0 && ALUB > 0 && (ALUOUT_int <= ALUA || ALUOUT_int <= ALUB)));
				//$display("Here I am. ALUA = %b ALUB = %b ALUOUT %b", ALUA, ALUB, ALUOUT);
				end
			if(ALUOP == 3'b001)
				begin
				STATUS_int[2] = ((ALUA > 0 && ALUB < 0 && ALUOUT_int <= 0) || 
				(ALUA < 0 && ALUB > 0 && ALUOUT_int >= 0));
				end
	 end
	 
	 
	always @(posedge clk or posedge async_reset)
		begin
			if(async_reset)
				begin
					STATUS <= 0;
					//ALUA <=0; ALUB <= 0; don't need to do this because they're inputs
					ALUOUT <= 0;
				end
				else begin
					
				
					ALUOUT <= ALUOUT_int;
					STATUS <= STATUS_int;
				end
		end

			
endmodule

