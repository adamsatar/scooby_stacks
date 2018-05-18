`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   07:20:56 02/15/2018
// Design Name:   ds_with_dp
// Module Name:   /home/satara/Documents/csse232/project/Implementation/beta/scooby_reboot/ds_dp_tb.v
// Project Name:  scooby_reboot
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ds_with_dp
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ds_dp_tb;

	// Inputs
	reg [3:0] DSOP;
	reg [15:0] ds_data;
	reg [2:0] ALUOP;
	reg clk;
	reg async_reset;

	// Instantiate the Unit Under Test (UUT)
	ds_with_dp uut (
		.DSOP(DSOP), 
		.ds_data(ds_data), 
		.ALUOP(ALUOP), 
		.clk(clk), 
		.async_reset(async_reset)
	);
	
	parameter   PERIOD = 20;
	parameter   real DUTY_CYCLE = 0.5;
	parameter   OFFSET = 10;
	
	initial begin
		#OFFSET;
			forever begin
					clk = 1'b0;
					#(PERIOD-(PERIOD*DUTY_CYCLE)) clk = 1'b1;
					#(PERIOD*DUTY_CYCLE);
				end
	end
	
	integer i;
	
	initial begin
		// Initialize Inputs
		DSOP = 0;
		ds_data = 0;
		ALUOP = 0;
		clk = 0;
		async_reset = 1;

		// Wait 100 ns for global reset to finish
		#100;
		async_reset = 0;
        
		// Add stimulus here
		ds_data = 3'd5;
		DSOP = 4'b0110; #20;
		DSOP = 4'b0000; #20;
		DSOP = 4'b0110; #20;
		DSOP = 4'b0000; #20;
		$display("Should have 2 5's on the stack in sr0, and sr1");
		/*DSOP,RSOP: 
				SOP[3] : pop
				SOP[2] : push
				SOP[1] : write
				SOP[0] : read
				
				ALUOP
				3'b000 : add
				3'b001 : sub
				3'b010 : bit and
				3'b110 : bit or


				
				3'b100 : compare
				
				STATUS_int[1:0] = 2'b00  // equal
										2'b01  // A < B
										2'b10  // A > B		
				
				*/
	

	end
      
endmodule

