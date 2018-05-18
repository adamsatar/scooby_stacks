`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:		 Adam Satar, Frank Lancaster, August Dailey,
//						 Will McEvoy, Adam Czyzewski
//
// Create Date:    11:53:50 02/05/2018
// Design Name:
// Module Name:    data_stack
// Project Name:	 scooby_stacks
// Target Devices: Spartan3E XC3S500E
// Tool versions:
// Description:	A stack of 128 registers.
//						Asserting data_write pushes input onto the stack.
//						Asserting data_read pops output of the stack.
//						Shifting up/down is automated.
//						sr127 is connected to memory for overflow.	
//						
//						The heart of scooby_stacks. This module is an array of
//						128 shift_cells with shift enable/disable.				
//
// Dependencies:	shift_cell.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module data_stack (




	input wire[15:0] sr0_in,sr1_in, sr127_in,
	//sr1_in, //from outside this module
	
	 //to send to other modules
																//like data_processor for example
																//sr127_out will only go to memory for now
	//input wire [3:0] DSOP, //from control
		//encode read,write,push,pop
	
	input wire data_write,data_read, //from contol
	
	input wire clk,async_reset,
	
	input push,pop, //from control


	
	input wire sr0_overwrite, sr1_overwrite,
	
	//input wire sr0_src, //from  control
	
	//data_stack 
	//input wire write_data, //from outside this module
   output wire [15:0] sr0_out,sr1_out,sr127_out,


	
	//data_stack control 
	output reg [15:0] ds_size,
	output reg stack_overflow

	//input wire write_destination //sr0 or sr1

	

	);

	/*parameter N = 128 = number of registers in data_stack*/
	wire [(128*16)-1: 0] data_bus;
	
	//wire [(128*16)-1:0] data_in_bus;
	


	generate begin
	genvar  i;


		shift_cell sr0(
		.data_in(sr0_in), //input from  outside this module 
		.data_in_prev(sr0_in), 
		.data_in_next(data_bus[31:16]), 
		.data_read(data_read), 
		.data_write(data_write), 
		.clk(clk), 
		.async_reset(async_reset), 
		.push(push), 
		.pop(pop), 
	   .data_out(data_bus[15:0]),
		.overwrite(sr0_overwrite)
		
		
		
	);
	

	//assign sr0_out = data_bus[15:0];
	


		shift_cell sr1(
		.data_in(sr1_in), //input from outside this module
		.data_in_prev(sr0_out), 
		//.data_in_prev(data_bus[15:0]),
		.data_in_next(data_bus[47:32]), //this should be
																//the data_out of the  first
																//cell in the generate block
																// aka sr2_out
		.data_read(data_read), 
		.data_write(data_write), 
		.clk(clk), 
		.async_reset(async_reset), 
		.push(push), 
		.pop(pop), 
		.data_out(data_bus[31:16]),
		
		
		.overwrite(sr1_overwrite)
		
		
	);
	

	
	

		for (i = 2; i < 128-1; i = i + 1)
		
			begin: make_stack
			shift_cell sr(.data_out(data_bus[i*16+15:i*16]),
							.data_in(0),
							.data_in_prev(data_bus[(i-1)*16 + 15:(i-1)*16]),
							.data_in_next(data_bus[(i+1)*16 + 15:(i+1)*16]),
							.data_write(data_write),
							.data_read(data_read),
														.pop(pop),
							.push(push),
	
							.clk(clk),
							.async_reset(async_reset),
							
							.overwrite(0)
	);
			end

	shift_cell sr127(.data_out(data_bus[127*16+15:127*16]),

						 
						 .data_in_prev(data_bus[126*16+15:126*16]),
						 .data_in_next(sr127_in),
						 
						 .data_write(data_write),.data_read(data_read),
						 .pop(pop),
						 .push(push),
						 
						.overwrite(0),
						 
						 .clk(clk),.async_reset(async_reset));

		end
		
		//named wire for easy access to sr127_out without having to
		//index the data_bus
		
		assign sr0_out = data_bus[15:0];
		assign sr1_out = data_bus[31:16];
		assign sr127_out = data_bus[127*16+15:127*16];

	endgenerate
	
	always @(posedge clk or posedge async_reset)
		begin
		 if (async_reset) begin
		  ds_size <= 0;
		  stack_overflow <=0;
		 end
		 


		else if(ds_size >= 127 && (data_write && push) )
			stack_overflow <= 1;
	

		else if(ds_size < 128 && (data_read && pop))
			begin
			
				 if (data_read && pop)
					begin
					ds_size <= ds_size - 1;
					end
				stack_overflow <= 0;
			end

		/*else if (data_read && pop)
			ds_size <= ds_size - 1;*/
		
		else if (data_write && push )
			ds_size <= ds_size + 1;

		end
	endmodule
