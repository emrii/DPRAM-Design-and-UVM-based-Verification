class dpram_driver extends uvm_driver#(dpram_seq_item);
  
  //utility macro
  `uvm_component_utils(dpram_driver)
  
  //virtual interface
  virtual dpram_if vif;
  
  //constructor
  function new(string name = "dpram_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dpram_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NO_VIF", {"virtual interface not set for: ", get_full_name(), ".vif"})
    end
  endfunction
  
  //run phase
  virtual task run_phase(uvm_phase phase);
    dpram_seq_item req;
    super.run_phase(phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive(req);
      seq_item_port.item_done();
    end
  endtask
  
  //drive 
  virtual task drive(dpram_seq_item obj);
    vif.dut.enA <= 1;
    vif.dut.enB <= 1;
    fork
      begin
        @(posedge vif.clk_A);
        vif.dut.enA <= obj.enA;
        vif.dut.wr_enA <= obj.wr_enA;
        vif.dut.addr_A <= obj.addr_A;
        vif.dut.datain_A <= obj.datain_A;
        vif.dut.rst_A <= obj.rst_A;
        if (obj.wr_enA == 1)
        obj.dataout_A = vif.dut.dataout_A;
      end
      begin
        @(posedge vif.clk_B);
        vif.dut.enB <= obj.enB;
        vif.dut.wr_enB <= obj.wr_enB;
        vif.dut.addr_B <= obj.addr_B;
        vif.dut.datain_B <= obj.datain_B;
        vif.dut.rst_B <= obj.rst_B;
        if (obj.wr_enA == 1)
        obj.dataout_B = vif.dut.dataout_B;
      end     
    join     
    
  endtask     
  
endclass
