`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:38:03 02/13/2018 
// Design Name: 
// Module Name:    control 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module control(
 
	 input wire clk, async_reset, 
	 
	 input wire [2:0] STATUS, //from data_processor
	 
	 input wire data_stack_overflow,return_stack_overflow, //from data/return stacks for dumping to memory
	 
	 input wire [15:0] ALUOUT,
	 
	 input wire [15:0] input_data,
	 output wire [15:0] output_data,
	 
	 input go,
	 output reg done,
	
	 
	 input wire [15:0] from_sr0, from_sr1, from_rs0,
	 
	
	 input wire [15:0] INST,

	 //output [3:0] OPCODE,
	// output [15:0]PC,
	 
	 //ALU
	 output reg [2:0] ALUOP,
	 
	 //assume ALUA is sr0_out, and  ALUB is sr1_out
 	 //output [1:0] ALUA_src, ALUB_src,
	 
	 //data_stack
	 output reg [3:0] DSOP,RSOP, //data/return stack op (read,write,push,pop)
	 output reg[15:0] to_sr0, //will be the extended immediate
	 
	 output reg sr0_overwrite, sr1_overwrite,
	 output reg [15:0] to_sr1,
	 
	 //return stack
	 output reg[15:0] to_rs0,
	 
	 output reg inst_mem_write_en, data_mem_write_en,
	 output reg [9:0] PC, data_mem_ptr
	 );
	 
	 /*******************State Encodings********************
		S0 : Reset
		S1 : Fetch
		S2 : Decode
		S2 : 
		S3 : 
		S4 : 
																			*/
	 //local to this module
	 reg [3:0] current_state;
	 
	 parameter [3:0] S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5;
	 reg [3:0] next_state = S0;
	 
	// reg [31:0] n_inst;
	 //reg [31:0] n_cycles;
	 
	 always @(posedge clk, posedge async_reset)
		begin
		
			//n_cycles <= n_cycles + 1;
			if (async_reset) begin
				current_state <= S0;

				end
			else begin
				current_state <= next_state;
		end
		
		
		
	end
	
	
		/*DSOP,RSOP:
							SOP[3] : pop
							SOP[2] : push
							SOP[1] : write
							SOP[0] : read
						*/
						
	
	
	
	
	//set values of signals
	 always @(current_state) begin
	 
	 
	 
	 if(data_stack_overflow && DSOP[2] && DSOP[1])
			begin
				data_mem_ptr <= data_mem_ptr + 1;
				data_mem_write_en <= 1;
			end
		else if(data_stack_overflow && DSOP[3] && DSOP[0])
			begin
				data_mem_ptr <= data_mem_ptr - 1;
			end
			
		else if(data_mem_write_en)
			data_mem_write_en <= 0;
			
				case(current_state)
				
					S0: 
						begin
						PC <= 0; //reset
						
						done <= 0;
						data_mem_ptr <= 0;
						inst_mem_write_en <= 0;
						data_mem_write_en <= 0;
						to_sr1  <= 0;
						ALUOP <= 0;
						DSOP <= 0;
						RSOP <= 0;
						to_sr0 <= 0;
						to_rs0 <= 0;
						sr0_overwrite <= 1'b0;
						sr1_overwrite <= 1'b0;
						
				//		n_cycles <= 0;
					//	n_inst <= 0;
						
						to_sr0 <= input_data;
						DSOP <= 4'b0110;
						
				

						end
						
					S1:
						//Fetch the instruction here
					 
						//Always just do the comparison
						begin
						
						if(PC == 6'd38)
							$display("PC is 38");
						//	done <= 1'b1;
						
						
					//	n_inst <= n_inst + 1;
						
						
						DSOP <= 4'b0000; //turn off DS operations
						RSOP <= 4'b0000; //turn off RS operations
						sr0_overwrite <= 1'b0; //turn off sr1 overwrite
						sr1_overwrite <= 1'b0;
						/****COMMENTED THIS OUT FOR NOW TO GET SOME OTHER MORE BASIC 
						STUFF WORKING FIRST**/
					//	ALUOP <= 3'b100;
						
						end
						
						
					S2: //Decode and set PC appropriately
						
						/*DSOP,RSOP:
							SOP[3] : pop
							SOP[2] : push
							SOP[1] : write
							SOP[0] : read
						*/
						
						
						begin	
							case(INST[15:12]) 
							
								
									//Add
									4'b0000:
										begin
											ALUOP <= 3'b000;
										end
										
									//Subtract
									4'b0001:
										begin
											ALUOP <= 3'b001;
										end
										
									//Bitwise And
									4'b0010:
										begin
											ALUOP <= 3'b010;
										end
									
									//Bitwise Or
									4'b0011:
										begin
											ALUOP <= 3'b110;
										end
									
									//PopS
									4'b0101:
										begin
											PC <= PC + 1;
											DSOP <= 4'b1001;
										end
										
									//CloneSR1
									4'b0110:
										begin
											//DSOP <= 4'b0110;
											PC <= PC + 1;
											to_sr0 <= from_sr1;
										end
						
									//PushI
									4'b1000:
										begin
											PC <= PC + 1;
											DSOP <= 4'b0110;
											to_sr0 <= {{4{INST[11]}},INST[11:0]};
											to_rs0 <= {{4{INST[11]}},INST[11:0]};
										end
										
									//PopR
									4'b1001:
										begin
											PC <= PC + 1;
											to_rs0 <= from_sr0;
											RSOP <= 4'b0110;
											DSOP <= 4'b1001;											
										end
									
									//PushU
									4'b1010:
										begin
											PC <= PC + 1;
											to_sr0 <= {INST[3:0],12'b0};
											to_rs0 <= {INST[3:0],12'b0};
										end
									
									/*beq, awesome_inst*/
							
									4'b1011, 4'b0111:
										begin
											ALUOP <= 3'b100; //compare
										end
									
									//Return
									4'b1100:
										begin
											PC <= from_rs0;
											RSOP <= 4'b1001;
										end
									
									//Jump
									4'b1101:
										begin
											PC <= from_sr0;
											DSOP <= 4'b1001;
										end
									
									//JumpL
									4'b1110:
										begin
											RSOP <= 4'b0110;
											to_rs0 <= PC + 1;
										end
									
									/*orI*/
									4'b1111:
										begin
											PC <= PC+1;
											to_sr0 <= {4'b0, INST[11:0]} | from_sr0;
											DSOP <= 4'b1001;
										end	
								endcase
						end
					S3: 
						begin		
								case(INST[15:12]) 
									
								/*awesome_inst*/	4'b0111  : PC <= PC + 1;
								
								/*pushI*/			4'b1000,
								/*pushU*/			4'b1010,
								/*orI*/				4'b1111, 
								/*cloneSR1*/		4'b0110	: DSOP <= 4'b0110; //push
								
								
								/*Add*/			  	4'b0000, 
								/*Subtract*/		4'b0001, 
								/*And*/				4'b0010, 
								/*Or*/				4'b0011	:
										begin
											PC <= PC + 1;
											DSOP<= 4'b1001;	//pop
										end
										

									//Ori
									4'b1111:
										begin
									//	PC <= PC + 1;
											DSOP <= 4'b1001;
											//ALUOP <= 3'b110;
										end

									//jumpL
									4'b1110:
										begin
											RSOP <= 4'b0000;
											PC <= from_sr0;
											DSOP <= 4'b1001;
										end
									
								
								endcase
							
							end
							
					S4:
						begin
							case(INST[15:12])
							
							
									/*beq*/
									4'b1011:
																		
										begin
										
										
											if(STATUS[1:0] == 2'b00) begin
												//Throw the from_rs0 value into PC if the top two on the data stack are equal
												PC <= from_rs0;
												//Pop the top address off the return stack regardless
												end
												else PC <= PC + 1;
											
											RSOP <= 4'b1001;
										end
							
									/*awesome_inst*/
									
									4'b0111:
										
										//A > B
										begin
											if(STATUS[1:0] == 2'b10) begin
												sr0_overwrite <= 1;
												to_sr0 <= ALUOUT;
												to_sr1 <= from_sr1; 
											end
											
											
											//A < B
											else if(STATUS[1:0] == 2'b01) begin
												to_sr0 <= from_sr0;
												to_sr1 <= -ALUOUT;
												sr1_overwrite <= 1;
												
												
											end	
											
										//A == B
											else if(STATUS[1:0] == 2'b00) begin
												to_sr0 <= 0;
												sr0_overwrite <= 1;
												to_sr1 <= from_sr1;
											end


											
										end
								//swapTop
								4'b0100:
									begin
										PC <= PC + 1;
										to_sr0 <= from_sr1; //from_sr0 gets sr1
										to_sr1 <= from_sr0;	 //sr1 gets from_sr0
										DSOP <= 4'b0010; //assert write only for overwrite w/o push/pop
									end
								//Ori
								4'b1111:
									begin
										to_sr0 <= ALUOUT;
										DSOP <= 4'b0110;
									end
									
								/*add, sub, and, or*/ 
								4'b0000,4'b0001, 4'b0010, 4'b0011:
									begin
										DSOP <= 4'b0000;
										to_sr0 <= ALUOUT; 	//set writeback data
										sr0_overwrite <= 1; //overwrite sr0
									end
								
								//Awesome Instruction
							endcase
						end
						
				S5: done <= 1'b1;
			
			endcase
		end
	//compute next state	
		always @(current_state, next_state)
			begin
				case(current_state)

					S0:
					//begin
					//if(go)
							next_state <= S1;
						// else next_state <= S5;
						 
					//end
					S1:
					//begin
					
					//if(PC ==  5'd38) 
						//done <= 1;
						
					case (INST[15:12])
					
							
							/*swapTop*/		4'b0100
															: next_state <= S4;
							
							default						: next_state <= S2; 
						endcase
					//end
					S2: case(INST[15:12])
							
						
							/*return*/		4'b1100,
							/*jump*/			4'b1101,
							/*pushI*/		4'b1000, 
							/*popR*/			4'b1001,
							/*popS*/			4'b0101 : next_state <= S1;
							
							
							/*pushU*/		4'b1010, 							
							/*add,*/ 		4'b0000,
							/*sub*/			4'b0001,
							/*and*/ 			4'b0010,
							/*or*/ 			4'b0011,
							/*orI*/ 			4'b1111,
							/*cloneSR1*/	4'b0110,
			
							/*aws_int*/  	4'b0111,
							/*jumpL*/	 	4'b1110,
							/*beq*/ 			4'b1011
															: next_state <= S3;
									
															
							default						: next_state <= S5; //error state
						endcase
						
						 
					S3:
					begin
						
						case(INST[15:12])
						/*awesome_inst*/	4'b0111,
						/*beq*/				4'b1011,
						/*add	*/				4'b0000,
						/*sub	*/				4'b0001,
						/*and	*/				4'b0010,
						/*or	*/				4'b0011 : next_state <= S4;

						/*pushI, pushU, beq */
						default: next_state <= S1;
						endcase

						
					end
					S4: next_state <= S1;	
					
					S5: 
						
							next_state <= S5;
						
						
			
			endcase
		end
		
endmodule
