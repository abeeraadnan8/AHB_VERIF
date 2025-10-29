class driver extends uvm_driver #(sequence_item);
  `uvm_component_utils(driver)
  
  virtual intf vif;
  sequence_item req, rsp;
  semaphore phase_lock = new(1);
  
  //constructor
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction 
  
  
  //build_phase
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    req = sequence_item :: type_id :: create("req");
    rsp = sequence_item :: type_id :: create("rsp");
    
    if (!uvm_config_db #(virtual intf) :: get (this, "", "vif", vif))
                                               `uvm_fatal("interface", "no interface found")
                                               
                                               
  endfunction
  
  //main phase
  
  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(get_type_name(), "main_phase_starting", UVM_NONE)
    
    @(posedge vif.clk iff vif.hresetn)
    drive_item();
    
    
    `uvm_info(get_type_name(), "Main_phase_ended", UVM_NONE)
  endtask
  
  
  task automatic drive_item();
    forever begin
      phase_lock.get();
      seq_item_port.get(req);
      
      vif.haddr <= req.haddr;
      vif.hwrite <= req.hwrite;
      vif.hsize <= req.hsize;
      vif.hsel <= 1'b1;
      vif.hburst <= req.hburst;
      vif.htrans <= req.htrans;
      
      @(posedge vif.clk);
      while(vif.hready != 1) begin
        @(posedge vif.clk);
      end 
      
      phase_lock.put();
      
      if(req.hwrite) begin
        vif.hwdata <= req.hwdata;
        
        while (vif.hready != 1) begin
          @(posedge vif.clk);
        end 
      end 
      else begin
        vif.hwdata <= 0;
        while(vif.hready != 1) begin
          @(posedge vif.clk);
        end 
        rsp.hrdata <= vif.hrdata;
      end 
      rsp.hresp <= vif.hresp;
      
    end 
    
    `uvm_info(get_type_name(), "Driving signals to DUT", UVM_MEDIUM)
  endtask
    
    endclass