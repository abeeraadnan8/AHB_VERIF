class sequence_item extends uvm_sequence_item;
  `uvm_object_utils(sequence_item)
  
  
  // --------------------------------------------------
  // AHB Transaction Fields
  // --------------------------------------------------
  
  rand bit [31:0] hwdata;
  rand bit [31:0] haddr;
  rand bit [1:0] htrans;
  bit [2:0] hsize;
  bit [2:0] hburst;
  bit hsel;
  bit hwrite;
  bit [31:0] hrdata;
  bit hready;
  bit hresp;
  //constructor
  
  function new(string name = "sequence_item");
    super.new(name);
  endfunction
  
  
endclass