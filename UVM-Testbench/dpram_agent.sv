//`include "dpram_seq_item.sv"
//`include "dpram_sequence.sv"
//`include "dpram_sequencer.sv"
//`include "dpram_driver.sv"
//`include "dpram_monitor.sv"

class dpram_agent extends uvm_agent;
  
  //utility macro
  `uvm_component_utils(dpram_agent)
  
  //constructor
  function new(string name = "dpram_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //declare components
  dpram_sequencer sqr;
  dpram_driver    dvr;
  dpram_monitor   mon;
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = dpram_monitor::type_id::create("mon", this);
    if(get_is_active() == UVM_ACTIVE) begin
      sqr = dpram_sequencer::type_id::create("sqr", this);
      dvr = dpram_driver::type_id::create("dvr", this);
    end
  endfunction
  
  //connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    mon.ap.connect(ap); //anaysis port
    if (get_is_active()) 
      dvr.seq_item_port.connect(sqr.seq_item_export);
  endfunction
  
endclass
  
