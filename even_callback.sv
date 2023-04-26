import uvm_pkg::*;

`include "uvm_macros.svh"

/////////////<--------component1----------->////////////////
class component1 extends uvm_component;

  `uvm_component_utils(component1)
  
  uvm_event ev1,ev3;//handle
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    ev1 = uvm_event_pool::get_global("ev_ab");//creation of event
   // ev3 = uvm_event_pool::get_global("ev_3");//creation of event
   
    `uvm_info(get_type_name(),$sformatf(" waiting for the event trigger"),UVM_LOW)//1
    
    ev1.wait_trigger;
    
    `uvm_info(get_type_name(),$sformatf(" event got triggerd"),UVM_LOW)//2

    phase.drop_objection(this);
  endtask

endclass
/////////////<--------component2----------->////////////////


class component2 extends uvm_component; 
  
  `uvm_component_utils(component2)
  
  uvm_event ev2;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    ev2 = uvm_event_pool::get_global("ev_ab");
    //ev4 = uvm_event_pool::get_global("ev_3");
    
    `uvm_info(get_type_name(),$sformatf(" Before triggering the event"),UVM_LOW)//3
    #10;
    
    ev2.trigger();
    
    `uvm_info(get_type_name(),$sformatf(" After triggering the event"),UVM_LOW)//4

    phase.drop_objection(this);
  endtask

endclass 

/////////////////<---test-->//////////////
class basic_test extends uvm_test;

  `uvm_component_utils(basic_test)
   
  component1 comp1;
  component2 comp2;

  function new(string name = "basic_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    comp1 = component1::type_id::create("comp1", this);
    comp2 = component2::type_id::create("comp2", this);
  endfunction 
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
endclass




/////////<-----Top---->///////

module top;

  initial begin
    run_test("basic_test");  
  end  
  
endmodule