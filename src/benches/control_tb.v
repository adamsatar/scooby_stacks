`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:08:48 02/15/2018
// Design Name:   control
// Module Name:   /home/satara/Documents/csse232/project/Implementation/beta/scooby_reboot/control_tb.v
// Project Name:  scooby_reboot
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: control
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module control_tb;

	// Inputs
	reg clk;
	reg async_reset;
	reg [2:0] STATUS;
	reg [15:0] ALUOUT;
	reg [15:0] sr0;
	reg [15:0] sr1;
	reg [15:0] rs0;
	reg [15:0] mem_data;
	reg [15:0] INST;

	// Outputs
	wire [2:0] ALUOP;
	wire [3:0] DSOP;
	wire [3:0] RSOP;
	wire [15:0] ds_data;
	wire sr1_overwrite;
	wire [15:0] sr1_in;
	wire [15:0] rs_data;

	// Instantiate the Unit Under Test (UUT)
	control uut (
		.clk(clk), 
		.async_reset(async_reset), 
		.STATUS(STATUS), 
		.ALUOUT(ALUOUT), 
		.sr0(sr0), 
		.sr1(sr1), 
		.rs0(rs0), 
		.mem_data(mem_data), 
		.INST(INST), 
		.ALUOP(ALUOP), 
		.DSOP(DSOP), 
		.RSOP(RSOP), 
		.ds_data(ds_data), 
		.sr1_overwrite(sr1_overwrite), 
		.sr1_in(sr1_in), 
		.rs_data(rs_data)
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
		
	initial begin
		// Initialize Inputs
		clk = 0;
		async_reset = 1;
		STATUS = 0;
		ALUOUT = 0;
		sr0 = 0;
		sr1 = 0;
		rs0 = 0;
		mem_data = 0;
		INST = 0;

		// Wait 100 ns for global reset to finish
		#60;
		async_reset = 0;
	
		INST = 16'h8004; #20;
		INST = 16'h8005; #20;
		INST = 16'h0000; #20;
		// Add stimulus here
      	end

endmodule

