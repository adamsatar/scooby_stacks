`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:42:48 02/10/2018
// Design Name:   shift_cell
// Module Name:   /home/satara/Documents/csse232/project/Implementation/beta/scooby_reboot/shift_cell_tb.v
// Project Name:  scooby_stacks
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: shift_cell
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module shift_cell_tb;

	// Inputs
	reg [15:0] data_in;
	reg [15:0] data_in_prev;
	reg [15:0] data_in_next;
	reg data_read;
	reg data_write;
	reg clk;
	reg async_reset;
	reg push;
	reg pop;

	// Outputs
	wire [15:0] data_out;


	
	shift_cell sr0_uut(
		.data_in(data_in), 
		.data_in_prev(sr0_uut.data_in), 
		.data_in_next(sr1_uut.data_out), 
		.data_read(data_read), 
		.data_write(data_write), 
		.clk(clk), 
		.async_reset(async_reset), 
		.push(push), 
		.pop(pop), 
		.data_out(data_out)
	);
	
	
	shift_cell sr1_uut(
		.data_in(data_in),
		.data_in_prev(sr0_uut.data_out), 
		.data_in_next(data_in_next), 
		.data_read(data_read), 
		.data_write(data_write), 
		.clk(clk), 
		.async_reset(async_reset), 
		.push(push), 
		.pop(pop), 
		.data_out(data_out)
	);
	
	
		shift_cell sr2_uut(
		.data_in(data_in),
		.data_in_prev(sr1_uut.data_out), 
		.data_in_next(data_in_next), 
		.data_read(data_read), 
		.data_write(data_write), 
		.clk(clk), 
		.async_reset(async_reset), 
		.push(push), 
		.pop(pop), 
		.data_out(data_out)
	);
	
	
	
	
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

	integer i,j;

	initial begin
		// Initialize Inputs
		data_in = 999999;
		data_in_prev = 0;
		data_in_next = 0;
		data_read = 0;
		data_write = 0;
		async_reset = 1;
		clk=0;
		push = 0;
		pop = 0;

		// Wait 100 ns for global reset to finish
		#100;
      async_reset = 0;  
		// Add stimulus here
		
		//write without pop (aka overwrite);
		$display($time, ": Push 0 - 10");
		for (i = 0; i <= 100; i = i + 1) begin
			data_in = i;
			data_write = 1; push = 1; #20;
			data_write = 0; push = 0; #20;
		end
		$display($time, " Read only x 2");
		data_read = 1; pop = 0; #20;
		data_read = 0; pop = 0; #20;
		data_read = 1; pop = 0; #20;
		
		$display($time, " Read and pop x2");
		data_read = 1; pop = 1; #20;
		data_read = 0; pop = 0; #20;
		data_read = 1; pop = 1; #20;
		data_read = 0; pop = 0; #20;
		$display($time, ": Read only, Read Only,  read and pop.");
		/*for(j = 0; j < 5; j = j +1) begin
					data_read = 1; pop = 0;#20;
					data_read = 0; pop = 0;#20;
					data_read = 1; pop = 9; #20;
					
					data_read = 1; pop = 1;#20;
					data_read = 0; pop = 1;#20;
		end
*/
   end 
endmodule

