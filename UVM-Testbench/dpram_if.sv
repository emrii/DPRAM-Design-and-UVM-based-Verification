interface dpram_if(input bit clk_A, input bit clk_B);

    parameter ADDR_WIDTH = 5;
    parameter DATA_WIDTH = 8;
  
     //port A
	logic [DATA_WIDTH-1:0] datain_A;
    logic [ADDR_WIDTH-1:0] addr_A;
    logic wr_enA;                      //LOW=READ,HIGH=WRITE
    logic enA;                         //ACTIVE LOW
    logic rst_A;                       //ACTIVE HIGH
    logic [DATA_WIDTH-1:0] dataout_A;
	 //port B
    logic [DATA_WIDTH-1:0] datain_B;
    logic [ADDR_WIDTH-1:0] addr_B;
    logic wr_enB;                      //LOW=READ,HIGH=WRITE
    logic enB;                         //ACTIVE LOW
    logic rst_B;                       //ACTIVE HIGH
    logic [DATA_WIDTH-1:0] dataout_B;
  
  modport dut (input datain_A, addr_A, wr_enA, enA, rst_A, datain_B, addr_B, wr_enB, enB, rst_B, output dataout_A, dataout_B);
  
  modport tb (output datain_A, addr_A, wr_enA, enA, rst_A, datain_B, addr_B, wr_enB, enB, rst_B, input dataout_A, dataout_B);	
  
endinterface
