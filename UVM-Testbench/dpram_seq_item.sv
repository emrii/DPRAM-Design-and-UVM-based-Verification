class dpram_seq_item extends uvm_sequence_item; 
  
  parameter ADDR_WIDTH = 5;
  parameter DATA_WIDTH = 8;

  //data fields
  rand bit [DATA_WIDTH-1:0] datain_A;
  rand bit [ADDR_WIDTH-1:0] addr_A;
  rand bit                    wr_enA;                      //LOW=READ,HIGH=WRITE
  rand bit                    enA;                         //ACTIVE LOW
  rand bit [DATA_WIDTH-1:0] datain_B;
  rand bit [ADDR_WIDTH-1:0] addr_B;
  rand bit                    wr_enB;                      //LOW=READ,HIGH=WRITE
  rand bit                    enB;                         //ACTIVE LOW
       logic [DATA_WIDTH-1:0] dataout_A;
       logic [DATA_WIDTH-1:0] dataout_B;
  
  //utility macros
  `uvm_object_utils_begin(dpram_seq_item)
   `uvm_field_int(datain_A, UVM_DEFAULT)
   `uvm_field_int(addr_A, UVM_DEFAULT) 
   `uvm_field_int(wr_enA, UVM_DEFAULT) 
   `uvm_field_int(enA, UVM_DEFAULT) 
   `uvm_field_int(datain_B, UVM_DEFAULT) 
   `uvm_field_int(addr_B, UVM_DEFAULT) 
   `uvm_field_int(wr_enB, UVM_DEFAULT) 
   `uvm_field_int(enB, UVM_DEFAULT) 
  `uvm_object_utils_end
  
  //constructor
  function new (string name = "dpram_seq_item");
    super.new(name);
  endfunction
  
  //constraint 1: both ports can not write to same address space simultaneously, or read on one port and erite through another port, only simultaneous reads allowed
  constraint address_collision {
    if (enA && enB && (wr_enA || wr_enB))
      addr_A != addr_B;
  }
  
endclass
  
  
  
