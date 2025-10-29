`timescale 1ns/1ns
 import uvm_pkg::*;
`include "uvm_macros.svh"
`include "intf.sv"
`include "sequence_item.sv"
`include "ahb_sequence_wr.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "ahb_test_wr.sv"

module tb;
  

  intf ahb_intf();
  
  ahb_slave dut(
    .clk(ahb_intf.clk),
    .hwdata(ahb_intf.hwdata),
    .haddr(ahb_intf.haddr),
    .hsize(ahb_intf.hsize),
    .hburst(ahb_intf.hburst),
    .hresetn(ahb_intf.hresetn),
    .hsel(ahb_intf.hsel),
    .hwrite(ahb_intf.hwrite),
    .htrans(ahb_intf.htrans),
    .hresp(ahb_intf.hresp),
    .hready(ahb_intf.hready),
    .hrdata(ahb_intf.hrdata)
  );
  
  initial begin
    ahb_intf.clk = 0;
  end
  
  always begin
    #10
    ahb_intf.clk = ~ahb_intf.clk;
  end 
  
  initial begin
    ahb_intf.hresetn = 0;
    repeat(1) @(posedge ahb_intf.clk);
    ahb_intf.hresetn = 1;
  end 
  
  initial begin
    uvm_config_db#(virtual intf)::set(null, "*", "vif", tb.ahb_intf);
    run_test("ahb_test_wr");
  end
  
  
  initial begin
    $dumpfile("d.vcd");
    $dumpvars();
  end 
  
endmodule 
  
