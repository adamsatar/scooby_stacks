`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:		 Adam Satar, Frank Lancaster
//
// Create Date:    16:33:34 01/29/2018
// Design Name:
// Module Name:    shift_cell (with enable and source control)
// Project Name:
// Target Devices:
// Tool versions:
// Description:	This module is a single shift cell with push/pop
//						enable/disable.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module shift_cell(

	input wire [15:0] data_in, //the cell's  data in; 
										//sr0 and sr1 named inputs
										//in data_stack level


	input wire [15:0] data_in_prev, data_in_next,

	input wire data_read,data_write,clk,async_reset,
	
	//just use one signal after working through the logic
	input wire push,pop, //from control
	input wire overwrite,
	
	//input wire [1:0] data_in_prev_source,data_in_next_source,


	output reg [15:0] data_out // the cell's data_out
										//sr0 and sr1 have named outs
										//in data stack level
    );
	 
	 
	 always @(posedge clk or posedge async_reset)
		if (async_reset)
			data_out <= 0;
			
		
	/*	else if (overwrite)
			data_out <= data_in;*/
		
			
		else if (data_write && push)
			data_out <= data_in_prev;
		

		else if(overwrite)
			data_out <= data_in;
		
	/*	else if (data_write)
			data_out <= data_in;*/
			
		else if (data_read && pop)
			data_out <= data_in_next;
	
endmodule
