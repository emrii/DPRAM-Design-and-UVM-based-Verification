import uvm_pkg::*;  
`include "uvm_macros.svh"

`include "dpram_seq_item.sv"
`include "dpram_sequence.sv"
`include "dpram_sequencer.sv"
`include "dpram_if.sv"
`include "dpram_driver.sv"
`include "dpram_monitor.sv"
`include "dpram_agent.sv"
`include "dpram_scoreboard.sv"
`include "dpram_env.sv"
`include "dpram_test.sv"
 

module tb_top;
  
  parameter ADDR_WIDTH = 5;
  parameter DATA_WIDTH = 8;
  
  bit clk_A, clk_B;
  
  //set clocks
  initial begin
    clk_A = 1;
    clk_B = 1;
  end
  always #5 clk_A <= ~clk_A;
  always #5 clk_B <= ~clk_B;

   
	 
	// Interface
  dpram_if dut_if(clk_A, clk_B);
  

	// Instantiate the Unit Under Test (UUT)
	dpram_DUT uut (
      .datain_A(dut_if.datain_A), 
		.addr_A(dut_if.addr_A), 
		.wr_enA(dut_if.wr_enA), 
		.enA(dut_if.enA), 
		.rst_A(dut_if.rst_A), 
		.clk_A(clk_A), 
		.dataout_A(dut_if.dataout_A), 
		.datain_B(dut_if.datain_B), 
		.addr_B(dut_if.addr_B), 
		.wr_enB(dut_if.wr_enB), 
		.enB(dut_if.enB), 
		.rst_B(dut_if.rst_B), 
		.clk_B(clk_B), 
		.dataout_B(dut_if.dataout_B)
	);
  
    
	initial begin
      uvm_config_db #(virtual dpram_if)::set(null, "uvm_test_top", "vif", dut_if);
      run_test("dpram_test");		
	end
	
	
	
	initial begin
      $dumpfile("testbench.vcd");
      $dumpvars(1, tb_top);
   end

		
endmodule
