module snake(start, master_clk, DAC_clk, VGA_R, VGA_G, VGA_B, VGA_hSync, VGA_vSync, blank_n,x,y,z,w,h ,seg1,seg2);
	
	input master_clk, x,y,z,w,h; 
	output reg [3:0]VGA_R, VGA_G, VGA_B;
   
	output VGA_hSync, VGA_vSync, DAC_clk, blank_n; 
	wire [9:0] xCount; 
	wire [9:0] yCount; 
	wire displayArea; 
	wire VGA_clk;
	wire R;
	wire G;
	wire B;
	wire snakeHead,snakeBody ;
	wire  game_over;
	reg  border; 
	wire apple ;

	output wire [0:6]seg1;
	output wire [0:6]seg2;
	input start;

	wire update;
	collision col(snakeBody,snakeHead,border,game_over,VGA_clk,update,start,xCount,yCount,x,y,z,w,h,apple,seg1,seg2);
	VGA_Controller VGA(VGA_clk, xCount, yCount, displayArea, VGA_hSync, VGA_vSync, blank_n);
	Clks_Generator CLKs(master_clk, update,VGA_clk);
	
	assign DAC_clk = VGA_clk;
	
	

	
	always @(posedge VGA_clk) 
	begin
		border <= (((xCount >= 0) && (xCount < 31) || (xCount >= 610) && (xCount < 641)) || ((yCount >= 0) && (yCount < 31) || (yCount >= 450) && (yCount < 481)));
	end


							
	assign R = (displayArea && ( apple || game_over || snakeHead));
	assign G = (displayArea && ((snakeBody || snakeHead || border)&& ~game_over));
	assign B = (blank_n && (~game_over || snakeHead));
	always@(posedge VGA_clk)
	begin
		VGA_R = {4{R}};
		VGA_G = {4{G}};
		VGA_B = {4{B}};
	end 

endmodule
