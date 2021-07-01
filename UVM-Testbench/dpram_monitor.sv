class dpram_monitor extends uvm_monitor;
  
  //utility macro
  `uvm_component_utils(dpram_monitor)
  
  //constructor
  function new(string name = "uvm_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //virtual interface declaration
  virtual dpram_if vif;
  
  //analysis port declaration
  uvm_analysis_port#(dpram_seq_item) ap;
  
  //build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    if(!uvm_config_db#(virtual dpram_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NO_VIF", {"virtual interface not set for: ", get_full_name(), ".vif"})
    end
  endfunction
  
  //run_phase
  virtual task run_phase(uvm_phase phase);
    dpram_seq_item rsp_collected = dpram_seq_item::type_id::create("rsp_collected", this);
    forever fork
      begin
        @(posedge vif.clkA);
        if (!vif.tb.enA && !vif.tb.rst_A) begin
          rsp_collected.enA = vif.tb.enA;
          rsp_collected.wr_enA = vif.tb.wr_enA;
          rsp_collected.addr_A = vif.tb.addr_A;
          if (vif.tb.wr_enA)
            rsp_collected.datain_A = vif.tb.datain_A;
          if (!vif.tb.wr_enA)
            rsp_collected.dataout_A = vif.dut.dataout_A; 
        end
      end
      begin
        @(posedge vif.clkB);
        if (!vif.tb.enB && !vif.tb.rst_B) begin
          rsp_collected.enB = vif.tb.enB;
          rsp_collected.wr_enB = vif.tb.wr_enB;
          rsp_collected.addr_B = vif.tb.addr_B;
          if (vif.tb.wr_enB)
            rsp_collected.datain_B = vif.tb.datain_B;
          if (!vif.tb.wr_enB)
            rsp_collected.dataout_B = vif.dut.dataout_B; 
        end
      end   
    join  
  endtask
  
endclass
