class ahb_test_wr extends uvm_test;
  `uvm_component_utils(ahb_test_wr)

  //Randomize sequence of ahb single rd/wr burst
  ahb_sequence_wr ahb_wr;
  env ahb_env;

  // =============================
  // Constructor Method
  // =============================
  function new(string name="ahb_test_wr", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  // =============================
  // Build Phase Method
  // =============================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // ahb sequence class instance
    ahb_wr = ahb_sequence_wr::type_id::create("ahb_wr");
    ahb_env = env::type_id::create("ahb_env", this);
  endfunction

  // =============================
  // Main Phase Method
  // =============================
  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(get_type_name(), "Starting main_phase.. ", UVM_NONE)
     
    ahb_wr.start(ahb_env.ahb_agent.ahb_sequencer);
     
  endtask // main_phase
endclass
