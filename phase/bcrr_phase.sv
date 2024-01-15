import uvm_pkg::*;
`include "uvm_macros.svh"
class grandchild extends uvm_component;
`uvm_component_utils(grandchild)   
   function new(string name, uvm_component parent);
      super.new(name,parent);
      `uvm_info("new", "constructor",0);
   endfunction
   function void build_phase(uvm_phase phase);
      `uvm_info("build", "phase",0);
   endfunction 
   function void connect_phase(uvm_phase phase);
      `uvm_info("connect", "phase",0);
   endfunction 
   task run_phase(uvm_phase phase);
      `uvm_info("run", "phase",0);
   endtask 
   function void report_phase(uvm_phase phase);
      `uvm_info("report", "phase",0);
   endfunction 
endclass 
class child extends uvm_component;
   grandchild gc1,gc2;
   function new(string name, uvm_component parent);
      super.new(name,parent);
      `uvm_info("new", "constructor",0);
   endfunction
   function void build_phase(uvm_phase phase);
      `uvm_info("build", "phase",0);
      gc1 = grandchild::type_id::create("gc1",this);
      `uvm_info("build", "created gc1",0);
      gc2 = grandchild::type_id::create("gc2",this);
      `uvm_info("build", "created gc2",0);
   endfunction
   function void connect_phase(uvm_phase phase);
      `uvm_info("connect", "phase",0);
   endfunction
   task run_phase(uvm_phase phase);
      `uvm_info("run", "phase",0);
   endtask 
   function void report_phase(uvm_phase phase);
      `uvm_info("report", "phase",0);
   endfunction 
endclass
class env extends uvm_env;
   `uvm_component_utils(env)
   child c1,c2;
   function new(string name, uvm_component parent);
      super.new(name,parent);
      `uvm_info("new", "constructor",0);
   endfunction
   function void build_phase(uvm_phase phase);
      `uvm_info("build", "phase",0);
      c1 = new("c1",this);
      c2 = new("c2",this);
   endfunction
   function void connect_phase(uvm_phase phase);
      `uvm_info("connect", "phase",0);
   endfunction
   task run_phase(uvm_phase phase);
      `uvm_info("run", "phase",0);
   endtask
   function void report_phase(uvm_phase phase);
      `uvm_info("report", "phase",0);
   endfunction 
endclass : env
class test extends uvm_test;
   `uvm_component_utils(test);
   function new(string name, uvm_component parent);
      super.new(name,parent);
      `uvm_info("new", "constructor",0);
   endfunction
   env e;
   function void build_phase(uvm_phase phase);
      `uvm_info("build", "phase",0);
      e = new("e",this);
   endfunction
   function void report_phase(uvm_phase phase);
      uvm_component tmp=uvm_top.find("uvm_test_top.e");
      env e;
      $cast(e,uvm_top.find("uvm_test_top.e"));
      `uvm_info("report", "phase",0)
      e.print();
   endfunction // report_phase
endclass   
module top;
   env e2;
   initial begin
      e2 =new("e2",null);
      run_test("test");
   end
endmodule
