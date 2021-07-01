//`include "dpram_env.sv"
//`include "dpram_sequence.sv"

class dpram_base_test extends uvm_test;
  
  //utility macros
  `uvm_component_utils(dpram_base_test)
  
  //constructor
  function new(string name = "dpram_base_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction 
  
  //declare components
  dpram_env env;
  dpram_sequence seq;
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = dpram_env::type_id::create("env", this);
    seq = dpram_seqeunce::type_id::create("seq", this);
  endfunction
  
  //end of elaboration phase
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction
  
  //run phase
  virtual task run_phase(uvm_phase phase);
    //dpram_sequence seq;
    //seq = dpram_seqeunce::type_id::create("seq", this);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq.start(env.agent.sqr);
    phase.drop_objection(phase);
  endtask
  
  //report phase DOUBT
  function void report_phase(uvm_phase phase);
   uvm_report_server svr;
   super.report_phase(phase);
   
   svr = uvm_report_server::get_server();
   if(svr.get_severity_count(UVM_FATAL)+svr.get_severity_count(UVM_ERROR)>0) begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----            TEST FAIL          ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
    else begin
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
     `uvm_info(get_type_name(), "----           TEST PASS           ----", UVM_NONE)
     `uvm_info(get_type_name(), "---------------------------------------", UVM_NONE)
    end
  endfunction 
  
endclass
  
