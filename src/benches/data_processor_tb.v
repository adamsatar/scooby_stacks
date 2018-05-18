`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:		Frank Lancaster
//
// Create Date:   11:41:05 02/10/2018
// Design Name:   data_processor
// Module Name:   /home/satara/Documents/csse232/project/Implementation/beta/scooby_reboot/data_processor_tb.v
// Project Name:  scooby_reboot
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: data_processor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module data_processor_tb;

	// Inputs
	reg clk;
	reg async_reset;
	reg [15:0] ALUA;
	reg [15:0] ALUB;
	reg [2:0] ALUOP;

	// Outputs
	wire [15:0] ALUOUT;
	wire [2:0] STATUS;

	// Instantiate the Unit Under Test (UUT)
	data_processor uut (
		.clk(clk), 
		.async_reset(async_reset), 
		.ALUA(ALUA), 
		.ALUB(ALUB), 
		.ALUOP(ALUOP), 
		.ALUOUT(ALUOUT), 
		.STATUS(STATUS)
	);

	// Clock process for clk
	
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
		async_reset = 0;
		ALUA = 0;
		ALUB = 0;
		ALUOP = 0;

		async_reset = 1;
		#25;
		async_reset = 0;
      #25;
		 
		//I'm not sure why this stuff isn't working. Look at the overflow detection in data_processor.v. I'm going to
		//smash a keyboard if I have to keep working on this right now - F
		// Test 1
		ALUA = 1'd1;
		ALUB = 2'd2;
		ALUOP = 000;
		#25;
		
		$display(ALUA);
		$display(ALUB);
		$display(STATUS[2]);
		if(ALUOUT == 2'd3)
			begin
			$display("Passed the add test, 1/8");
			end
		
		async_reset = 1;
		#25;
		async_reset = 0;
		#25;
        
		 
		// Test 2
		ALUA = 16'b0111111111111111;
		ALUB = 16'b0111111111111111;
		
		ALUOP = 000;
		#25;
		
		$display(STATUS[2]);
		if(STATUS[2] == 1'd1)
			begin
			$display("Passed the overflow test, 2/8");
			end
		
	   
		// Test 3
		ALUA = 16'b0000000000000011;
		ALUB = 16'b0000000000000011;
		
		ALUOP = 001;
		#25;
		
		$display(STATUS[2]);
		if(ALUOUT == 0)
			begin
			$display("Passed the first subtraction test, 3/8");
			end
		
		
		// Test 4
		ALUA = 16'b0000000000000011;
		ALUB = 16'b0000000000000111;
		
		ALUOP = 001;
		#25;
		
		$display(STATUS[2]);
		if(ALUOUT == 16'b1111111111111100)			  
			begin
			$display("Passed the second subtraction test, 4/8");
			end
		
		// Test 5
		ALUA = 16'b0000000000000011;
		ALUB = 16'b1111111111111001;
		
		ALUOP = 001;
		#25;
		
		$display(STATUS[2]);
		if(ALUOUT == 10)
			begin
			$display("Passed the third subtraction test, 5/8");
			end
		
		// Test 6
		ALUA = 16'b0000000000000011;
		ALUB = 16'b1110011111111001;
		
		ALUOP = 010;
		#25;
		
		$display(STATUS[2]);
		if(ALUOUT == 16'b0000000000000001)
			begin
			$display("Passed the fisrt bit and test, 6/8");
			end
		
		// Test 7
		ALUA = 16'b1110000000000011;
		ALUB = 16'b1110011111111001;
		
		ALUOP = 010;
		#25;
		
		$display(STATUS[2]);
		if(ALUOUT == 16'b1110000000000001)
			begin
			$display("Passed the second bit and test, 7/8");
			end
		
		// Test 8
		ALUA = 16'b0000000000000011;
		ALUB = 16'b1110011111111001;
		
		ALUOP = 011;
		#25;
		
		$display(STATUS[2]);
		if(ALUOUT == 16'b1110011111111011)
			begin
			$display("Passed the bit or test, 8/8");
			end
		
	end
      
endmodule

