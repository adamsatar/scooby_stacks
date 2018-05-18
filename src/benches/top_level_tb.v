`timescale 1ms / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:25:24 02/15/2018
// Design Name:   top_level
// Module Name:   C:/Users/lancasfe/Documents/232 Project/Implementation/beta/scooby_reboot/top_level_tb.v
// Project Name:  scooby_reboot
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_level
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module top_level_tb;

	// Inputs
	reg clk;
	reg async_reset;
	reg [15:0] userInput;

	

	// Instantiate the Unit Under Test (UUT)
	top_level uut (
		.clk(clk), 
		.async_reset(async_reset),
		//.stack_output(stack_ouput),
		.userInput(userInput)
	);


parameter   PERIOD = 8;
	parameter   real DUTY_CYCLE = 0.5;
	parameter   OFFSET = 10;
	
	initial begin
	async_reset  = 1;
	
	userInput = 5040;
	
		#OFFSET;
	async_reset = 0;
			forever begin
					clk = 1'b0;
					#(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
					#(PERIOD*DUTY_CYCLE);
				end
	end
	
	
	
endmodule

