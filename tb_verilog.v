module tb_v;

   parameter ADDR_WIDTH = 5;
   parameter DATA_WIDTH = 8;
	 
	// Inputs
    reg [DATA_WIDTH-1:0] datain_A;
    reg [ADDR_WIDTH-1:0] addr_A;
    reg wr_enA;
	reg enA;
	reg rst_A;
	reg clk_A;
    reg [DATA_WIDTH-1:0] datain_B;
    reg [ADDR_WIDTH-1:0] addr_B;
	reg wr_enB;
	reg enB;
	reg rst_B;
	reg clk_B;

	// Outputs
    wire [DATA_WIDTH-1:0] dataout_A;
    wire [DATA_WIDTH-1:0] dataout_B;
  
    integer i;
    integer limit = 2**ADDR_WIDTH;
  
	// Instantiate the Unit Under Test (UUT)
	dpram_DUT uut (
		.datain_A(datain_A), 
		.addr_A(addr_A), 
		.wr_enA(wr_enA), 
		.enA(enA), 
		.rst_A(rst_A), 
		.clk_A(clk_A), 
		.dataout_A(dataout_A), 
		.datain_B(datain_B), 
		.addr_B(addr_B), 
		.wr_enB(wr_enB), 
		.enB(enB), 
		.rst_B(rst_B), 
		.clk_B(clk_B), 
		.dataout_B(dataout_B)
	);
  
    always begin   //clocks multiple domain
	   #3 clk_A = ~clk_A;
	   #2 clk_B = ~clk_B;
    end

	initial begin
		// Initialize Inputs
		datain_A = 0;
		addr_A = 0;
		wr_enA = 0;
		enA = 1;
		rst_A = 1;
		clk_A = 0;
		datain_B = 0;
		addr_B = 0;
		wr_enB = 1;
		enB = 1;
		rst_B = 1;
		clk_B = 0;
		
		#5
      rst_A = 0;
      rst_B = 0;
      
      
        //initialise DPRAM with stored values
      #5 enA = 0;
      wr_enA = 1;
      for(i = 0; i<limit; i=i+1) begin
        addr_A = i;   
        datain_A = i;
        #10;
      end
      #1 enA = 1;
      
		
		// Wait 100 ns for global reset to finish
		#100;
      enA = 0;//Port A enabled
      wr_enA = 0; //read
      #0 addr_A = 5'b00111;
		#1 enB = 0; //Port B enabled
      wr_enB = 0;
      #0 addr_B = 5'b11000;
		#10 wr_enA = 1;
		addr_A = 5'b10101;
		datain_A = 8'b11110000;
		#10 wr_enB = 1;
		addr_B = 5'b01010;
		datain_B = 8'b11111000;
		#100 $finish;	
      		
		
	end
	
	
	
	initial begin
      $monitor($time, "datain_A = %b,   addr_A = %b,	wr_enA = %b,	dataout_A = %b,    datain_B = %b,		addr_B = %b,		wr_enB = %b,    dataout_B = %b", datain_A, addr_A, wr_enA, dataout_A, datain_B, addr_B, wr_enB, dataout_B);
		$dumpfile("testbench.vcd");
      $dumpvars(1, tb_v);
   end

		
endmodule
