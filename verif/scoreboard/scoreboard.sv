class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  
  uvm_analysis_imp#(sequence_item, scoreboard) scb_port;
  
  int unsigned read_match_count;
  int unsigned read_mismatch_count;
  int unsigned write_match_count;
  int unsigned write_mismatch_count;
  
    sequence_item exp_queue[$];
    sequence_item expdata;

  
  function new(string name = "scorebaord", uvm_component parent = null);
    super.new(name, parent);
  endfunction 
  
   virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     scb_port = new("scb_port",this);
   endfunction 

  
  // --------------------------
  // Write: Called automatically
  // when monitor sends a transaction
  // --------------------------
  function void write(sequence_item tr);
    exp_queue.push_back(tr);
  endfunction
  
   // --------------------------
  // Run Phase
  // --------------------------
  virtual task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Scoreboard Started", UVM_LOW)

    forever begin
      wait (exp_queue.size() > 0);
      expdata = exp_queue.pop_front();
      if (expdata.htrans > 1) begin
        if (expdata.hwrite) begin
          if (^expdata.hwdata !== 1'bx && ^expdata.hwdata !== 1'bz) begin
          write_match_count++;
          `uvm_info("AHB_WRITE_SUCCESSFUL",
                    $sformatf("WRITE @0x%0h <= 0x%0h",
                              expdata.haddr, expdata.hwdata),
                    UVM_MEDIUM)
        end 
        else begin
          write_mismatch_count++;
          `uvm_error("AHB_WRITE_FAIL",
                     $sformatf("WRITE CONTAINS INVALID DATA @0x%0h <= 0x%0h",
                               expdata.haddr, expdata.hwdata))
        end 
      end
      else begin 
        if (^expdata.hrdata !== 1'bx && ^expdata.hrdata !== 1'bz) begin
          read_match_count++;
          `uvm_info("AHB_READ_SUCCESSFUL",
                    $sformatf("READ @0x%0h <= 0x%0h",
                              expdata.haddr, expdata.hrdata),
                    UVM_MEDIUM)
        end 
        else begin
          read_mismatch_count++;
          `uvm_error("AHB_READ_FAIL",
                     $sformatf("READ CONTAINS INVALID DATA @0x%0h <= 0x%0h",
                               expdata.haddr, expdata.hrdata))
        end 
      end
      end

    end 
        endtask 
    
    
  // -----------------------------------------------------------------
  // Final Phase Summary
  // -----------------------------------------------------------------
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info("SCOREBOARD_SUMMARY",
              $sformatf("Total Matches: %0d | Total Mismatches: %0d\nRead Matches: %0d | Read Mismatches: %0d\nWrite Matches: %0d | Write Mismatches: %0d",
                        read_match_count + write_match_count,
                        read_mismatch_count + write_mismatch_count,
                        read_match_count, read_mismatch_count,
                        write_match_count, write_mismatch_count),
              UVM_NONE)
  endfunction
    
  
endclass