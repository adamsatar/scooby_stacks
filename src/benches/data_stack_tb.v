`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:		Adam Satar, Frank Lancaster
//
// Create Date:   21:22:03 02/06/2018
// Design Name:   data_stack
// Module Name:   /home/satara/Documents/csse232/scooby_stacks/Implementation/scooby_stacks/data_stack_tb.v
// Project Name:  scooby_stacks
// Target Device:
// Tool versions:
// Description:	
//
// Verilog Test Fixture created by ISE for module: data_stack
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////


module data_stack_tb;

	// Inputs
	reg [15:0] sr127_in;
	reg sr1_overwrite;

	reg [15:0] sr0_in;
	reg [15:0] sr1_in;
	reg data_write;
	reg data_read;
	
	reg push,pop;
	
	reg clk;
	reg async_reset;

	// Outputs
	
	wire [15:0] ds_size;
	wire stack_overflow;
	wire [15:0] sr0_out, sr1_out,sr127_out;

	// Instantiate the Unit Under Test (UUT)
	data_stack uut (
	
		.sr1_overwrite(sr1_overwrite),

		.sr0_in(sr0_in),
		.sr0_out(sr0_out),
		.sr1_in(sr1_in),
		.sr1_out(sr1_out),

		.sr127_out(sr127_out),
		.sr127_in(sr127_in),
		.ds_size(ds_size),
		.stack_overflow(stack_overflow),
		
		.data_write(data_write),
		.data_read(data_read),
		
		.push(push),
		.pop(pop),
		
		.clk(clk),
		.async_reset(async_reset)
	);

integer  i;
	// use this if your design contains sequential logic
	parameter   PERIOD = 20;
	parameter   real DUTY_CYCLE = 0.5;
	parameter   OFFSET = 10;

initial    // Clock process for CLK
		begin
			 #OFFSET;
			 forever
				 begin
						clk = 1'b0;
						#(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
						#(PERIOD*DUTY_CYCLE);
				 end
		end

	initial begin
		// Initialize Inputs
		sr127_in = 0;
		sr0_in = 0;
		sr1_in = 0;
		data_write = 0;
		data_read = 0;
		clk = 0;
		async_reset = 1;
		push = 0; pop = 0;
		sr1_overwrite = 0;

		// Wait 100 ns for global reset to finish
		#100;
		async_reset = 0;
		
		for(i = 0; i < 20; i = i +1) begin
			sr0_in = i; push = 1; data_write = 1; #20;
			push = 0; data_write = 0; #20;
			end
			
		//test read without pop;
		sr0_in = 5;
		push = 1; data_write = 1;
		#20;
		push = 0; data_write = 0;
		#20;
		sr0_in = 10; data_write = 1; //overwrite sr0
		#20;
		
		data_write = 0; #20;
		
		sr0_in = 1; push = 1; data_write = 1; #20;
		push = 0; data_write = 0; #20;
		sr0_in = 2; push = 1; data_write = 1; #20;
		data_write = 0; push = 0; #20; 
		
		sr1_in = 99; 
		#20; 
		sr1_overwrite = 1; push = 1; data_write = 1;#20;
		sr1_overwrite = 0; push = 0;data_write = 0; #20;
		
		//test popping
		for(i = 0; i < 10; i = i + 1) begin
		
		end
		/*for(i = 0; i < 10; i = i +1) begin
		sr0_in = i;
		data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		
		data_read = 0; data_write = 0; push = 0; pop = 1; #20;data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		data_read = 0; data_write = 0; push = 0; pop = 0; #20;data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		data_read = 0; data_write = 0; push = 0; pop = 1; #20;data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		data_read = 0; data_write = 1; push = 1; pop = 0; #20;data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		data_read = 0; data_write = 1; push = 1; pop = 1; #20;data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		data_read = 0; data_write = 1; push = 1; pop = 0; #20;data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		data_read = 0; data_write = 1; push = 1; pop = 1; #20;data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		data_read = 1; data_write = 0; push = 0; pop = 0; #20;data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		data_read = 1; data_write = 0; push = 0; pop = 1; #20;data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		data_read = 1; data_write = 0; push = 0; pop = 0; #20;data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		data_read = 1; data_write = 0; push = 0; pop = 1; #20;data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		data_read = 1; data_write = 1; push = 1; pop = 0; #20;data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		data_read = 1; data_write = 1; push = 1; pop = 1; #20;data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		data_read = 1; data_write = 1; push = 1; pop = 0; #20;data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		data_read = 1; data_write = 1; push = 1; pop = 1; #20;data_read = 0; data_write = 0; push = 0; pop = 0; #20;
		end*/
		
		
		

		
		
		/*
		$display($time, "overwrite sr1, read, and pop");
		sr1_in = 99;
		sr1_overwrite = 1;
		#20;
	
		for(i = 0; i < 5; i = i + 1) begin
				data_read = 1; pop = 1;
			#20;
			data_read = 0; pop = 0;
				#20;
		end
		
		sr1_overwrite = 0;
		
		$display($time, "sr1_overwrite off, write and push");
		for (i = 0; i <10; i = i + 1) begin

			sr0_in =  i+10;
			//sr1_in = 135 - i;
			data_write = 1; push = 1;
			#20;
			data_write = 0; push = 0;#20;			
	   end
		


		#20;
		sr0_in = 99; 
		
		

*/
	end

endmodule
