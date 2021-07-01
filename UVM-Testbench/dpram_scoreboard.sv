parameter ADDR_WIDTH = 5;
parameter DATA_WIDTH = 8;

class dpram_scoreboard extends uvm_scoreboard;
  
  //utility macro
  `uvm_component_utils(dpram_scoreboard)
  
  //scoreboard memory for reference model
  bit [DATA_WIDTH-1:0] ref_mem [(2**ADDR_WIDTH)-1:0];
  
  //queue for received packets
  dpram_seq_item pkt_queue[$];   
  
  //constructor
  function new (string name = "dpram_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  //port declaration
  uvm_analysis_imp#(dpram_seq_item, dpram_scoreboard) ap_imp;
  
  //build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap_imp = new("ap_imp", this);
    foreach(ref_mem[i]) 
      ref_mem[i] = '1;
  endfunction
  
  //write imp for TLM
  virtual function void write (dpram_seq_item item);
    pkt_queue.push_back(item);
  endfunction
  
  //run phase
  virtual task run_phase(uvm_phase phase);
    dpram_seq_item obj;
    wait(pkt_queue.size()>0);
    obj = pkt_queue.pop_front();
    //PORT A
    if (obj.wr_enA) begin
      //write
      ref_mem[obj.addr_A] = obj.datain_A;
      `uvm_info("RECEIVED OBJ BEING WRITTEN", $sformat("Addr_A: %h, Datain_A: %b", obj.addr_A, obj.datain_A), UVM_LOW)
    end
    else begin
      //read
      if (ref_mem[obj.addr_A] == obj.dataout_A) begin
        //read successful
        `uvm_info(get_type_name(), $sformat("READ successful"), UVM_LOW);
        `uvm_info(get_type_name(), $sformat("Addr_A: %h, Data_read = %b, Expected_Data = %b", obj.addr_A, obj.dataout_A, ref_mem[obj.addr_A]), UVM_LOW)
      end
      else begin
        //read failed
        `uvm_error(get_type_name(), $sformat("READ failed"))
        `uvm_info(get_type_name(), $sformat("Addr_A: %h, Data_read = %b, Expected_Data = %b", obj.addr_A, obj.dataout_A, ref_mem[obj.addr_A]), UVM_LOW)
      end
    end
    //PORT B
    if (obj.wr_enB) begin
      //write
      ref_mem[obj.addr_B] = obj.datain_B;
      `uvm_info("RECEIVED OBJ BEING WRITTEN", $sformat("Addr_B: %h, Datain_B: %b", obj.addr_B, obj.datain_B), UVM_LOW)
    end
    else begin
      //read
      if (ref_mem[obj.addr_B] == obj.dataout_B) begin
        //read successful
        `uvm_info(get_type_name(), $sformat("READ successful"), UVM_LOW);
        `uvm_info(get_type_name(), $sformat("Addr_B: %h, Data_read = %b, Expected_Data = %b", obj.addr_B, obj.dataout_B, ref_mem[obj.addr_B]), UVM_LOW)
      end
      else begin
        //read failed
        `uvm_error(get_type_name(), $sformat("READ failed"))
        `uvm_info(get_type_name(), $sformat("Addr_B: %h, Data_read = %b, Expected_Data = %b", obj.addr_B, obj.dataout_B, ref_mem[obj.addr_B]), UVM_LOW)
      end
    end
  
  endtask
      
    
