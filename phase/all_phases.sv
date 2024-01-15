// Code your testbench here
// or browse Examples
module M;
  
  // Common phases
  function void build_phase;
    static string phase_name = "build_phase";
    $info("Starting %s", phase_name);
    //...
    $info("Finished %s", phase_name);
  endfunction
  
  function void connect_phase;
    static string phase_name = "connect_phase";
    $info("Starting %s", phase_name);
    //...
    $info("Finished %s", phase_name);
  endfunction
  
  function void end_of_elaboration_phase;
    static string phase_name = "end_of_elaboration_phase";
    $info("Starting %s", phase_name);
    //...
    $info("Finished %s", phase_name);
  endfunction
  
  function void start_of_simulation_phase;
    static string phase_name = "start_of_simulation_phase";
    $info("Starting %s", phase_name);
    //...
    $info("Finished %s", phase_name);
  endfunction
  
  // Run-time phases
  task reset_phase;
    static string phase_name = "reset_phase";
    $info("Starting %s", phase_name);
    #10ns;
    $info("Finished %s", phase_name);
  endtask
  
  task configure_phase;
    static string phase_name = "configure_phase";
    $info("Starting %s", phase_name);
    #10ns;
    $info("Finished %s", phase_name);
  endtask
  
  task main_phase;
    static string phase_name = "main_phase";
    $info("Starting %s", phase_name);
    #10ns;
    $info("Finished %s", phase_name);
  endtask
  
  task shutdown_phase;
    static string phase_name = "shutdown_phase";
    $info("Starting %s", phase_name);
    #10ns;
    $info("Finished %s", phase_name);
  endtask
  
  // Core run-time
  task run_phase();
    $info("Run starts");
    fork reset_phase(); join
    fork main_phase(); join
    fork configure_phase(); join
    fork shutdown_phase(); join
    $info("Run exits");
  endtask
  
  // Everything actually starts HERE
  initial begin
    build_phase();
    connect_phase();
    end_of_elaboration_phase();
    start_of_simulation_phase();
    fork
      run_phase();
    join_none
  end
  
  function void extract_phase;
    static string phase_name = "extract_phase";
    $info("Starting %s", phase_name);
    //...
    $info("Finished %s", phase_name);
  endfunction
  
  function void check_phase;
    static string phase_name = "check_phase";
    $info("Starting %s", phase_name);
    //...
    $info("Finished %s", phase_name);
  endfunction
  
  function void report_phase;
    static string phase_name = "report_phase";
    $info("Starting %s", phase_name);
    //...
    $info("Finished %s", phase_name);
  endfunction
  
  function void final_phase;
    static string phase_name = "final_phase";
    $info("Starting %s", phase_name);
    //...
    $info("Finished %s", phase_name);
  endfunction
  
  final begin
    extract_phase();
    check_phase();
    report_phase();
    final_phase();
  end
  
endmodule
