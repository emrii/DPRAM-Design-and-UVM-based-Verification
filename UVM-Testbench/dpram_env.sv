//`include "dpram_agent.sv"
//`include "dpram_scoreboard.sv"

class dpram_env extends uvm_env;
  
  //utility macros
  `uvm_component_utils(dpram_env)
  
  //constructor
  function new (string name = "dpram_env", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //declare verif components
  dpram_agent      agent;
  dpram_scoreboard scbrd;
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = dpram_agent::type_id::create("agent", this);
    scbrd = dpram_scoreboard::type_id::create("scbrd", this);
  endfunction
  
  //connect phase
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.mon.ap.connect(scb.ap_imp);
  endfunction
  
endclass
    
