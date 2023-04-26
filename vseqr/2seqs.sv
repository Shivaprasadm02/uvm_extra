`include "uvm_macros.svh"
import uvm_pkg::*;
///////////<--Transaction class-->//////////////
 
class transaction extends uvm_sequence_item;
  rand bit [3:0] a;
`uvm_object_utils(transaction)
 
  function new( string name = "transaction");
  super.new(name);
  endfunction
 
 
endclass

////////////////////<<--sequencer-->>//////////////

class sequencer extends uvm_sequencer#(transaction);
  `uvm_component_utils(sequencer);

  function new(string name="sequencer",uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass

////////////////<--sequence1-->//////////////////////////////////////
 
class sequence1 extends uvm_sequence#(transaction);
  `uvm_object_utils(sequence1)
 
  function new( string name = "seq1");
  super.new(name);
  endfunction
 
 virtual task body();
   `uvm_info($sformatf("time %0d",$time), "SEQ1 Started" , UVM_NONE); //this 
    req = transaction::type_id::create("req");
    start_item(req);
    req.randomize();
    finish_item(req);
   `uvm_info("SEQ1", "SEQ1 Ended" , UVM_NONE); //this
endtask
  
endclass

////////////////<--sequence2-->//////////////////////////////////////
 
class sequence2 extends uvm_sequence#(transaction);
  `uvm_object_utils(sequence2)
 
  function new( string name = "seq2");
  super.new(name);
  endfunction
 
 virtual task body();
   `uvm_info("SEQ2", "SEQ2 Started" , UVM_NONE); //this 
    req = transaction::type_id::create("req");
    start_item(req);
    req.randomize();
    finish_item(req);
   `uvm_info("SEQ2", "SEQ2 Ended" , UVM_NONE); //this
  endtask
  
endclass
 
///////////////////////<--driver--> /////////////////////////////////////////////
 
class driver extends uvm_driver#(transaction);
`uvm_component_utils(driver)
 
 
function new( string name = "driver", uvm_component parent);
super.new(name,parent);
endfunction
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    req = transaction::type_id::create("req");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    forever 
  begin
      seq_item_port.get_next_item(req);
       $display("In driver%d",req.a);
      seq_item_port.item_done();
      end    
  endtask
 
 
endclass


//////////////////<--Agent-->////////////////////////////////
 
class agent extends uvm_agent;
  `uvm_component_utils(agent)
 
  function new(input string name = "AGENT", uvm_component parent);
    super.new(name,parent);
  endfunction
 
driver d;
sequencer s;
 
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
d = driver::type_id::create("d",this);
s = sequencer::type_id::create("s",this);
endfunction
 
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
d.seq_item_port.connect(s.seq_item_export);
endfunction

endclass

 
///////////////////////////<--Environment--> //////////////////////////////////////////////
 
class env extends uvm_env;
`uvm_component_utils(env)
 
function new( string name = "env", uvm_component parent);
super.new(name,parent);
endfunction
 
agent a;
 
virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
    a = agent::type_id::create("a",this);
endfunction
 
endclass
 
///////////////////////<--Test-->////////////////////////////////////////
 
class test extends uvm_test;
`uvm_component_utils(test)
 
function new( string name = "test", uvm_component parent);
super.new(name,parent);
endfunction
sequence1 s1;
sequence2 s2;
env e;
 
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      e = env::type_id::create("e",this);
      s1=sequence1::type_id::create("s1");
	  s2=sequence2::type_id::create("s2");
    endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
 
    virtual task run_phase(uvm_phase phase);
 
    phase.raise_objection(this);
	e.a.s.set_arbitration(SEQ_ARB_FIFO);
	fork
      
	  repeat(5) s1.start(e.a.s);
	  repeat(5) s2.start(e.a.s);
	join
      
    phase.drop_objection(this);
    endtask
  
  
endclass
 
///////////////////<--Top-->/////////////////////////////////////
module top;
 
 
initial begin
  run_test("test");
end
 
endmodule
