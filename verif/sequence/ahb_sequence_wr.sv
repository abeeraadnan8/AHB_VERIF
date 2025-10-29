class ahb_sequence_wr extends uvm_sequence#(sequence_item);
  `uvm_object_utils(ahb_sequence_wr)
  
  
  sequence_item ahb_item, rsp;
  uvm_event in_scb_evnt;
  
  //constructor
  
  function new(string name = "ahb_sequence_wr");
    super.new(name);
  endfunction 
  

  //body
  
  virtual task body();
    `uvm_info(get_type_name(), "Starting body task", UVM_NONE)
      in_scb_evnt = uvm_event_pool::get_global("in_scb_evnt");
    
    repeat(100) begin
      
      ahb_item = sequence_item :: type_id :: create("ahb_item");
      rsp = sequence_item :: type_id :: create("rsp");
      
      start_item(ahb_item);
      
      assert (ahb_item.randomize() with {
        hsize == 2'b00;
        hburst == 3'd0;
        htrans == 2'b10;
      }) else
        `uvm_error(get_type_name(), "randomizaton failed for ahb_item")
                   
                   
                   ahb_item.haddr = $urandom_range(4095, 8193) & ~ ((1 << 2'b00) - 1);
                   ahb_item.hwrite = 1;
                   
                   finish_item(ahb_item);
                   
     `uvm_info(get_type_name(), $sformatf(
        "Transaction sent => ADDR: 0x%0h, WRITE: %0b, SIZE: %0d, BURST: %0d, TRANS: %0b",
        ahb_item.haddr, ahb_item.hwrite, ahb_item.hsize, ahb_item.hburst, ahb_item.htrans
      ), UVM_LOW)
                   end 
     in_scb_evnt.trigger();
    
                   
                   `uvm_info(get_type_name(), "Ending body task", UVM_MEDIUM)
                  
  endtask 
                   
endclass