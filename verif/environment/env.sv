class env extends uvm_env;
  `uvm_component_utils(env)
  
  int WATCH_DOG;
  uvm_event event_trig;
  
  
  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  
  agent ahb_agent;
  scoreboard ahb_scoreboard;
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    ahb_agent = agent :: type_id :: create ("ahb_agent", this);
    ahb_scoreboard = scoreboard :: type_id :: create ("ahb_scoreboard", this);
    event_trig = uvm_event_pool::get_global("in_scb_evnt");

    
  endfunction 
  
  
  //connect phase
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    ahb_agent.ahb_monitor.ahb_port.connect(ahb_scoreboard.scb_port);
  endfunction 
  
  
  virtual task main_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("env", "Starting main_phase.. ", UVM_MEDIUM)
    super.main_phase(phase);

    // initialize watch dog timer value
    WATCH_DOG=1000ms;
     
    // fork join_any
    fork 
      begin
      `uvm_info("env", "Starting WATCH_DOG.. ", UVM_MEDIUM)
      
       #WATCH_DOG
      `uvm_info("env", "Starting WATCH_DOG Done .. ", UVM_MEDIUM)
       `uvm_fatal("env", "WATCH_DOG Timer Expired ")
      end 
      begin 
        `uvm_info("env", "wait for uvm_event .. ", UVM_MEDIUM)
         event_trig.wait_trigger();
        `uvm_info("env", "scoreboard event triggered.. ", UVM_MEDIUM)
      end 
    join_any
    
    phase.drop_objection(this);
    
  endtask // main_phase
  
  
endclass