interface intf;
  logic clk;
  logic [31:0] hwdata;
  logic [31:0] haddr; 
  logic [2:0] hsize;
  logic [2:0] hburst;
  logic hresetn;
  logic hsel;
  logic hwrite;
  logic [1:0] htrans;
  logic hresp;
  logic hready;
  logic [31:0] hrdata;
  
endinterface 