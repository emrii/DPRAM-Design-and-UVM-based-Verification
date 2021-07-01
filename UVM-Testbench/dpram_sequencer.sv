//no additional functionality/ports required

class dpram_sequencer extends uvm_sequencer#(dpram_seq_item);

  `uvm_component_utils(dpram_sequencer) 

  //constructor
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
