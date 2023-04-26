`include "uvm_macros.svh"
import uvm_pkg::*;
int a;


//////////////<----Call back class--->/////////////
class driver_cb extends uvm_callback;
  `uvm_object_utils(driver_cb)
  
  function new(string name = "driver_cb");
    super.new(name);
  endfunction
  
  virtual task modify_pkt();
  endtask
endclass

class derived_cb extends driver_cb;
  `uvm_object_utils(derived_cb)
  
  function new(string name = "derived_cb");
    super.new(name);
  endfunction
  
  task modify_pkt; // callback method implementation
    `uvm_info(get_full_name(),"Inside modify_pkt method: Injecting error pkt",UVM_LOW);
    std::randomize(a) with {a==7;};
  endtask
endclass
///////////////<---Driver--->///////////
class driver extends uvm_component;
  `uvm_component_utils(driver)
  `uvm_register_cb(driver,driver_cb) // callback registration
  
  function new(string name = "driver", uvm_component parent = null);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase); 
    super.run_phase(phase);
    drive();
    `uvm_do_callbacks(driver,driver_cb,modify_pkt()); // callback hook
    `uvm_info(get_full_name(),$sformatf("Driven pkt is %d", a),UVM_LOW);
  endtask
  
  task drive();
    `uvm_info(get_full_name(),"Inside drive method",UVM_LOW);
    std::randomize(a) with {a == 5;};
  endtask
endclass

////////////////<--ENVIRONMENT-->//////////
class env extends uvm_env;
  driver drv;
  `uvm_component_utils(env)
  
  function new(string name = "env", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    $display("In build of env");
    drv = driver::type_id::create("drv", this);
    super.build_phase(phase);
  endfunction
endclass

////////////////////<--TEST-->////////////

class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  env env_o;
  
  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    $display("In build of base test");
    env_o = env::type_id::create("env_o", this);
    super.build_phase(phase);
  endfunction
endclass

class err_test extends base_test;
  derived_cb drvd_cb;
  `uvm_component_utils(err_test)
  
  function new(string name = "err_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   drvd_cb = derived_cb::type_id::create("drvd_cb");
   uvm_callbacks#(driver,derived_cb)::add(env_o.drv,drvd_cb);
  endfunction
endclass
/////////////<--TOP-->////////////
module tb_top;
  initial begin
    run_test("err_test");
  end
endmodule