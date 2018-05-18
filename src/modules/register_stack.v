`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:42:59 02/17/2018 
// Design Name: 
// Module Name:    register_stack 
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
module register_stack (




	input wire[15:0] reg0_in,reg1_in, reg127_in,
	//reg1_in, //from outside this module
	
	 //to send to other modules
																//like data_processor for example
																//reg127_out will only go to memory for now
	//input wire [3:0] SOP, //from control
		//encode read,write,push,pop
	
	input wire data_write,data_read, //from contol
	
	input wire clk,async_reset,
	
	input push,pop, //from control


	
	input wire reg1_overwrite,
	
	input wire reg0_src, //from  control
	
	//data_stack 
	input wire write_data, //from outside this module
   output wire [15:0] reg0_out,reg1_out,reg127_out,


	
	//data_stack control 
	output reg [15:0] size,
	output reg stack_overflow,

	input wire write_destination //reg0 or reg1

	);

	/*parameter N = 128 = number of registers in data_stack*/
	wire [(128*16)-1: 0] data_bus;
	
	//wire [(128*16)-1:0] data_in_bus;
	


	generate begin
	genvar  i;


		shift_cell reg0(
		.data_in(reg0_in), //input from  outside this module 
		.data_in_prev(reg0_in), 
		.data_in_next(data_bus[31:16]), 
		.data_read(data_read), 
		.data_write(data_write), 
		.clk(clk), 
		.async_reset(async_reset), 
		.push(push), 
		.pop(pop), 
	   .data_out(data_bus[15:0])
		
		
		
	);
	

	//assign reg0_out = data_bus[15:0];
	


		shift_cell reg1(
		.data_in(reg1_in), //input from outside this module
		.data_in_prev(reg0_out), 
		//.data_in_prev(data_bus[15:0]),
		.data_in_next(data_bus[47:32]), //this should be
																//the data_out of the  first
																//cell in the generate block
																// aka reg2_out
		.data_read(data_read), 
		.data_write(data_write), 
		.clk(clk), 
		.async_reset(async_reset), 
		.push(push), 
		.pop(pop), 
		.data_out(data_bus[31:16]),
		
		
		.overwrite(reg1_overwrite)
		
		
	);
	

	
	

		for (i = 2; i < 128-1; i = i + 1)
		
			begin: make_stack
			shift_cell regs(.data_out(data_bus[i*16+15:i*16]),
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

	shift_cell reg127(.data_out(data_bus[127*16+15:127*16]),

						 
						 .data_in_prev(data_bus[126*16+15:126*16]),
						 .data_in_next(reg127_in),
						 
		
						 
						 .data_write(data_write),.data_read(data_read),
						 .pop(pop),
						 .push(push),
						 
						 .overwrite(0),
						 
						 .clk(clk),
						 .async_reset(async_reset));

		end
		
		//named wire for easy access to reg127_out without having to
		//index the data_bus
		
		assign reg0_out = data_bus[15:0];
		assign reg1_out = data_bus[31:16];
		assign reg127_out = data_bus[127*16+15:127*16];

	endgenerate
	
	always @(posedge clk or posedge async_reset)
		begin
		 if (async_reset) begin
		  size <= 0;
		  stack_overflow <=0;
		 end
		 


		else if(size >= 127 && (data_write && push) )
			stack_overflow <= 1;
	

		else if(size < 128 && (data_read && pop))
			begin
				if (data_read && pop)
					begin
					size <= size - 1;
					end
				stack_overflow <= 0;
			end

		/*else if (data_read && pop)
			ds_size <= ds_size - 1;*/
		
		else if (data_write && push )
			size <= size + 1;


			


		end
	endmodule

