class dpram_sequence extends uvm_sequence#(dpram_seq_item);  
  
  //utility macros
  `uvm_object_utils(dpram_sequence)
  
  //constructor
  function new (string name = "dpram_sequence");
    super.new(name);
  endfunction
  
  
  
  //`uvm_declare_p_sequencer(dpram_sequencer)  //replace dpram_sequencer with sqr
  
  dpram_seq_item req;
  
  //declare, create, randomize and send sequence item to driver
  virtual task body();
    req = dpram_seq_item::type_id::create("req");  
    repeat(5) begin
      start_item(req);
      assert(req.randomize());
      finish_item(req);
    end
  endtask
  
endclass

//create read and write sequences later on using macro `uvm_do_with and constrain the wr_en values accordingly
      
  
