class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  //constructor 
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction 
  
  
  uvm_analysis_port#(sequence_item) ahb_port;
  
  virtual intf vif;
  
  semaphore lock = new(1);
  sequence_item pkt;
  
  bit [31:0] haddr;
  bit hwrite;
  bit [1:0] htrans;
  bit [2:0] hsize;
  bit [2:0] hburst;
  
  //build phase
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if (!uvm_config_db#(virtual intf) :: get (this, "", "vif", vif))
      `uvm_fatal("ahb_interface", "ahb_monior cant access interface")
      else 
        `uvm_info("ahb_interface", "ahb_monitor got access of ahb_interface", UVM_MEDIUM)
        
        pkt = sequence_item :: type_id :: create ("pkt");
    ahb_port = new("ahb_port", this);
  endfunction
  
  
  //main phase
  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(get_type_name(), "Main_phase_starting", UVM_NONE)
    
    collect_pkt();
    
    `uvm_info(get_type_name(), "main_phase_ended", UVM_NONE)
  endtask
  
  
  
  task collect_pkt;
    
    haddr = 0;
    hwrite = 0;
    htrans = 0;
    hsize = 0;
    hburst = 0;
    
    forever begin
      lock.get();
      @(posedge vif.clk iff (vif.hready && vif.hresetn));
    
      haddr = vif.haddr;
      hwrite = vif.hwrite;
      htrans = vif.htrans;
      hsize = vif.hsize;
      hburst = vif.hburst;
      
      lock.put();
      @(posedge vif.clk iff vif.hready);
      pkt.hwdata = vif.hwdata;
      pkt.hrdata = vif.hrdata;
      pkt.hready = vif.hready;
      pkt.hresp = vif.hresp;
      pkt.haddr = haddr;
      pkt.hwrite = hwrite;
      pkt.htrans = htrans;
      pkt.hsize = hsize;
      pkt.hburst = hburst;
      
      
      ahb_port.write(pkt);
    end
    
  endtask 
endclass