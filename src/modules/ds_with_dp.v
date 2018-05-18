`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:15:52 02/15/2018 
// Design Name: 
// Module Name:    ds_with_dp 
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
module ds_with_dp(
		
		input wire [3:0] DSOP,
		input wire [15:0] ds_data,
		input wire [2:0] ALUOP,
		input wire clk, async_reset
    );
	 
	 data_processor dp (
		.clk(clk), 
		.async_reset(async_reset), 
		.ALUA(ds.sr0_out), 		//sr0_out from data stack
		.ALUB(ds.sr1_out), 		//sr1_out from  data stack
		.ALUOP(ALUOP), 	
		.ALUOUT(ALUOUT), 	//output 
		.STATUS(STATUS) 	//output
	);
	
				
				/*DSOP,RSOP: 
				SOP[3] : pop
				SOP[2] : push
				SOP[1] : write
				SOP[0] : read
				*/
	
	data_stack ds (
	
		.sr1_overwrite(sr1_overwrite),
		.sr0_in(ds_data),//ds_data from control
		.sr0_out(sr0_out), 	//to control
		.sr1_in(sr1_in), //from control if ever writing to sr1 directly
		.sr1_out(sr1_out),
		.sr127_out(sr127_out),
		.sr127_in(sr127_in),
		.ds_size(ds_size),
		.stack_overflow(stack_overflow),
		.data_write(DSOP[1]),//from control
		.data_read(DSOP[0]), //from  control
		.push(DSOP[2]),//from  control
		.pop(DSOP[3]),//from control
		.clk(clk),
		.async_reset(async_reset)
	);

		


endmodule
