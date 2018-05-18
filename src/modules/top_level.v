`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:			Adam Satar
//
// Create Date:    17:37:53 02/07/2018
// Design Name:
// Module Name:    top_level
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
`include "data_stack.v"
`include "register_stack.v"
module top_level(	
input clk, async_reset,

//input done,
output reg go,
input [15:0] userInput,
output [15:0] answer


	 );
	 
	 wire sr1_overwrite, sr0_overwrite, inst_mem_write_en,data_mem_write_enable;
	 
	 wire [15:0] sr0_in,sr0_out,sr1_in,sr1_out,ALUOUT, INST,
					 rs0_out,rs0_in, sr127_in, sr127_out;
	 wire [2:0] STATUS, ALUOP;
	 
	 wire [9:0] PC, data_mem_ptr;
	 
	 wire data_stack_overflow, return_stack_overflow;
	 
	 wire [3:0]  DSOP,RSOP;
	 
	// wire done;
	 
	 //wire rx,tx;
	 
	// wire transmit; //from control to uart for transmitting result

	 
	 //assign stack_output = sr0_out;
	 
	 
	//	uart_test(.clk(clk),.reset(async_reset),.rx(rx),.tx(tx));
	
	

	  control control (
		.clk(clk), 
		.async_reset(async_reset), 
		.STATUS(STATUS), //input from data_processor
		.from_sr0(sr0_out), //input from data_stack
		.from_sr1(sr1_out), //input from  data_stack
		
		.input_data(userInput),
		
		.output_data(stack_output),
	
		.go(go),
		//.done(done),
		
		.data_stack_overflow(data_stack_overflow),
		.return_stack_overflow(return_stack_overflow),
		.PC(PC), //connect to memory ptr 
		
		.data_mem_ptr(data_mem_ptr),
		
		.data_mem_write_en(data_mem_write_en),
		.inst_mem_write_en(inst_mem_write_en), //currently never write to instruction mem
		
		//.data_mem_write(), //for when hooking up data stack overflow to mem
		
		.from_rs0(rs0_out), //input from return_stack
		 
		 .to_sr1(sr1_in), //sr1_in is input to data stack sr1; sr1 is from data stack to control
		 
		.sr0_overwrite(sr0_overwrite),
		
		.sr1_overwrite(sr1_overwrite),
		
		.INST(INST), //for testing
		.ALUOUT(ALUOUT),
		.ALUOP(ALUOP), 	//output to data  processor
		.DSOP(DSOP), 		//data stack control bits
		.RSOP(RSOP), 		//return stack control bits
		.to_sr0(sr0_in), //output (data to send to sr0)
		.to_rs0(rs0_in) //output (data to send to rs0)
	);
	 
 
	 	data_processor dp (
		.clk(clk), 
		.async_reset(async_reset), 
		.ALUA(sr0_out), 		//sr0_out from data stack
		.ALUB(sr1_out), 		//sr1_out from  data stack
		.ALUOP(ALUOP), 	//input from control
		.ALUOUT(ALUOUT), 	//output 
		.STATUS(STATUS) 	//output to control
	);
	
				
				/*DSOP,RSOP: 
				SOP[3] : pop
				SOP[2] : push
				SOP[1] : write
				SOP[0] : read
				*/
	
	data_stack data_stack (
	
		.sr1_overwrite(sr1_overwrite),
		
		.sr0_overwrite(sr0_overwrite),
		
		.sr0_in(sr0_in),//ds_data from control
		.sr0_out(sr0_out), 	//to control
		.sr1_in(sr1_in), //from control if ever writing to sr1 directly
		
		.sr1_out(sr1_out), //output from datastack to control sr1 input
		.sr127_out(sr127_out),
		.sr127_in(sr127_in),
		.ds_size(ds_size),
		.stack_overflow(data_stack_overflow),
	//	.DSOP(control.DSOP),
		.data_write(DSOP[1]),//from control
		.data_read(DSOP[0]), //from  control
		.push(DSOP[2]),//from  control
		.pop(DSOP[3]),//from control
		.clk(clk),
		.async_reset(async_reset)
	);
	

	
 register_stack return_stack(
 
		//.reg1_overwrite(),
		.reg0_in(rs0_in),
		.reg0_out(rs0_out), 	
		.reg1_in(), 
		.reg1_out(), 
		.reg127_out(),
		.reg127_in(),
		.size(size),
		.stack_overflow(return_stack_overflow),
		//.SOP(RSOP),
		.data_write(RSOP[1]), //from control
		.data_read(RSOP[0]),  //from control
		.push(RSOP[2]),//from  control
		.pop(RSOP[3]),//from control
		.clk(clk),
		.async_reset(async_reset)
 
 
 );

	

		mem_stack inst_mem(.clka(clk),
                   .wea(inst_mem_write_en),        
                   .addra(PC),       
						 
                   .dina(),
                   .douta(INST),
              
						 .rsta(async_reset)
                   );
						 
						 
						 //data_stack overflow mem

      mem_stack data_mem(.clka(clk),
                   .wea(data_mem_write_en),        
                   .addra(data_mem_ptr),       
						 
                   .dina(sr127_out),
                   .douta(sr127_in),
              
						 .rsta(async_reset)
                   );
						 
		assign answer = sr1_out;

always @(posedge clk or posedge async_reset)
  begin
	if(async_reset)
		go <= 1;
		
		if(PC == 38) 
		begin
		$display("answer is %d",answer);
		$display("relPrime(%d)",userInput);
		$finish;
			end
	/*if(done) begin
		go <= 0;
		
		$finish;
	end*/
		
	
  end



endmodule
