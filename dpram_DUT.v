module dpram_DUT(datain_A, addr_A, wr_enA, enA, rst_A, clk_A, dataout_A, datain_B, addr_B, wr_enB, enB, rst_B, clk_B, dataout_B
    );
	 
	 parameter ADDR_WIDTH = 5;
	 parameter DATA_WIDTH = 8;
  
     integer i;
     integer limit = 2**ADDR_WIDTH;
  
	 
	 //port A
	input [DATA_WIDTH-1:0] datain_A;
    input [ADDR_WIDTH-1:0] addr_A;
    input wr_enA;                      //LOW=READ,HIGH=WRITE
    input enA;                         //ACTIVE LOW
    input rst_A;                       //ACTIVE HIGH
    input clk_A;
    output reg [DATA_WIDTH-1:0] dataout_A;
	 //port B
    input [DATA_WIDTH-1:0] datain_B;
    input [ADDR_WIDTH-1:0] addr_B;
    input wr_enB;                      //LOW=READ,HIGH=WRITE
    input enB;                         //ACTIVE LOW
    input rst_B;                       //ACTIVE HIGH
    input clk_B;
    output reg [DATA_WIDTH-1:0] dataout_B;
	 
	 reg [DATA_WIDTH-1:0] DPRAM [(2**ADDR_WIDTH)-1:0];
  
   //at master reset refresh memory to all ones
    always @(rst_A && rst_B) 
      for(int i=0;i<2**ADDR_WIDTH;i++) DPRAM[i]= '1;
      
	 always @ (posedge rst_A)
	  begin
	   dataout_A <= 'bx;
     end
		
	 always @ (posedge clk_A)
	  begin
	   if (!enA)
	    begin
		  if (!wr_enA) //READ 
			 dataout_A <= DPRAM[addr_A];
		  else begin //WRITE
		    DPRAM[addr_A] <= datain_A;
			 dataout_A <= 'bx; end
		 end
	  end	 
			
    always @ (posedge rst_B)
	  begin
	   dataout_B <= 'bx;
	  end
		
	 always @ (posedge clk_B)
	  begin
	   if (!enB) 
	    begin
		  if (!wr_enB) //READ 
			 dataout_B <= DPRAM[addr_B];
		  else begin //WRITE
		     DPRAM[addr_B] <= datain_B;
			  dataout_B <= 'bx; end
		 end
	  end	 
		
endmodule
