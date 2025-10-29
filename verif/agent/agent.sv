class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  
  function new(string name= "agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  monitor ahb_monitor;
  driver ahb_driver;
  uvm_sequencer#(sequence_item) ahb_sequencer;
  
  //build phase
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    ahb_monitor = monitor :: type_id :: create ("ahb_monitor", this);
    ahb_driver = driver :: type_id :: create ("ahb_driver", this);
    ahb_sequencer = uvm_sequencer#(sequence_item) :: type_id :: create("ahb_sequencer", this);
  endfunction 
  
  
  
  
  //connect phase
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    ahb_driver.seq_item_port.connect(ahb_sequencer.seq_item_export);
  endfunction
  
endclass