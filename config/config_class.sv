import uvm_pkg::*;
`include "uvm_macros.svh"

class confi extends uvm_object;
  `uvm_object_utils(confi)
  int noofagents;
  int number;
  uvm_active_passive_enum is_active;
  function new(string name="confi");
    super.new(name);
  endfunction
  
endclass

class sequencer extends uvm_sequencer;
  `uvm_component_utils(sequencer)
  function new(string name="sequencer",uvm_component parent);
    super.new(name,parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
endclass  

class driver extends uvm_driver;
  `uvm_component_utils(driver)
  function new(string name="driver",uvm_component parent);
    super.new(name,parent);
  endfunction
  confi cfi;
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(confi)::get(this,"","confi",cfi);
    $display("%d",cfi.number);
  endfunction
endclass  

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  function new(string name="monitor",uvm_component parent);
    super.new(name,parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
endclass  

class agent extends uvm_agent;
  `uvm_component_utils(agent)
  function new(string name="agent",uvm_component parent);
    super.new(name,parent);
  endfunction
  driver d;
  monitor m;
  sequencer s;
  confi cf;

  uvm_active_passive_enum is_active;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  m=monitor::type_id::create("m",this);
  uvm_config_db#(confi)::get(this,"","confi",cf);
  if(cf.is_active==UVM_ACTIVE)
    begin
      s=sequencer::type_id::create("s",this);
      d=driver::type_id::create("d",this);
    end
  endfunction

endclass  

class agt_top extends uvm_env;
  `uvm_component_utils(agt_top)
  int n;
  agent ag[];
    confi cf;
  function new(string name="env",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(confi)::get(this,"","confi",cf))
      `uvm_fatal("agt_top","check strings its failed")
    $display("the no of agents are %d",n);
    ag=new[cf.noofagents];
    foreach(ag[i])
      ag[i]=agent::type_id::create($sformatf("ag[%0d]",i),this);
  endfunction

endclass

class env extends uvm_env;
  `uvm_component_utils(env)
  agt_top agtp;
  function new(string name="env",uvm_component parent);
    super.new(name,parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agtp=agt_top::type_id::create("agtp",this);
  endfunction
endclass

class test extends uvm_test;
  `uvm_component_utils(test)
  env ev;  
  int n;
  confi cfg;
    function new(string name="test",uvm_component parent);
      super.new(name,parent);
    endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ev=env::type_id::create("ev",this);
    cfg=confi::type_id::create("cfg");
    cfg.noofagents=5;
    cfg.is_active=UVM_PASSIVE;
    uvm_config_db#(int)::get(this,"","int",n);
    $display("The n value is %d",n);
    cfg.number=n;
    uvm_config_db#(confi)::set(this,"*","confi",cfg);
  endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
      super.end_of_elaboration_phase(phase);
    uvm_top.print_topology;
  endfunction
  
endclass

module top;
    int n=7;//interface 

  initial
    begin
      uvm_config_db#(int)::set(null,"*","int",n);

      run_test("test");
    end
endmodule