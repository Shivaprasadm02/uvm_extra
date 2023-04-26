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
////////////////<--Wr_sequence-->//////////////////////////////////////
 
class wr_sequence extends uvm_sequence#(transaction);
  `uvm_object_utils(wr_sequence)
 
 
  function new( string name = "seq1");
  super.new(name);
  endfunction
 
 virtual task body();
   `uvm_info("SEQ1", "SEQ1 Started" , UVM_NONE); //this 
    req = transaction::type_id::create("req");
  repeat(5)
  begin
    start_item(req);
    req.randomize();
    finish_item(req);
  end
   `uvm_info("SEQ1", "SEQ1 Ended" , UVM_NONE); //this
endtask
  
  
endclass
///////////////////<--Read_sequence-->/////////////////////////////////////////////
 
 
class rd_sequence extends uvm_sequence#(transaction);
  `uvm_object_utils(rd_sequence)
 
 
  function new(input string name = "rd_sequence");
  super.new(name);
  endfunction
 
  
  virtual task body();
    `uvm_info("rd_sequene", "read sequence Started" , UVM_NONE); 
    req = transaction::type_id::create("req");
  repeat(6)
  begin
    start_item(req);
    req.randomize();
    finish_item(req);
  end
  
    `uvm_info("rd_sequence", "read sequence  Ended" , UVM_NONE); 
  endtask
  
  
endclass
 
 
///////////////////////<--Write_driver--> /////////////////////////////////////////////
 
class wr_driver extends uvm_driver#(transaction);
`uvm_component_utils(wr_driver)
 
 
function new( string name = "wr_driver", uvm_component parent);
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
    $display("In write driver%d",req.a);
      seq_item_port.item_done();
      end    
  endtask
 
 
endclass
///////////////////////<--Read_driver-->/////////////////////////////////////////////

class rd_driver extends uvm_driver#(transaction);
`uvm_component_utils(rd_driver)
 
 
function new( string name = "rd_driver", uvm_component parent);
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
    $display("In read driver %d",req.a);
      seq_item_port.item_done();
      end    
  endtask
 
 
endclass
 
//////////////////////<--Wr_Sequencer--> /////////////////////////////////////
class wr_sequencer extends uvm_sequencer#(transaction);
  `uvm_component_utils(wr_sequencer);

  function new(string name="sequencer",uvm_component parent);
    super.new(name,parent);
  endfunction
endclass
/////////////////////<--Rd_sequencer-->//////////////////////////////
class rd_sequencer extends uvm_sequencer#(transaction);
  `uvm_component_utils(rd_sequencer);

  function new(string name="sequencer",uvm_component parent);
    super.new(name,parent);
  endfunction
endclass
/////////////////<--Virtual Sequencer-->//////////////
class v_sequencer extends uvm_sequencer#(uvm_sequence_item);
  `uvm_component_utils(v_sequencer)
function new(string name="v_sequencer",uvm_component parent);
  super.new(name,parent);
endfunction
wr_sequencer wrsqr;
rd_sequencer rdsqr;
endclass
//////////////////<--Wr_Agent-->////////////////////////////////
 
class wr_agent extends uvm_agent;
  `uvm_component_utils(wr_agent)
 
  function new(input string name = "AGENT", uvm_component parent);
    super.new(name,parent);
  endfunction
 
wr_driver wrd;
wr_sequencer wrs;
 
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
wrd = wr_driver::type_id::create("wrd",this);
wrs = wr_sequencer::type_id::create("wrs",this);
endfunction
 
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
wrd.seq_item_port.connect(wrs.seq_item_export);
endfunction
endclass
//////////////////////<--Read agent-->/////////////////////////
class rd_agent extends uvm_agent;
  `uvm_component_utils(rd_agent)
 
  function new(input string name = "AGENT", uvm_component parent);
    super.new(name,parent);
  endfunction
 
rd_driver rdd;
rd_sequencer rds;
 
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
rdd = rd_driver::type_id::create("rdd",this);
rds = rd_sequencer::type_id::create("rds",this);
endfunction
 
virtual function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
rdd.seq_item_port.connect(rds.seq_item_export);
endfunction
endclass
 
///////////////////////////<--Environment--> //////////////////////////////////////////////
 
class env extends uvm_env;
`uvm_component_utils(env)
 
function new( string name = "env", uvm_component parent);
super.new(name,parent);
endfunction
 
wr_agent wagt;
rd_agent ragt;
v_sequencer vseqr;
 
virtual function void build_phase(uvm_phase phase);
  super.build_phase(phase);
    wagt = wr_agent::type_id::create("wagt",this);
    ragt = rd_agent::type_id::create("ragt",this);
  vseqr=v_sequencer::type_id::create("vseqr",this);
endfunction
virtual function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vseqr.wrsqr=wagt.wrs;
  vseqr.rdsqr=ragt.rds;
  
endfunction
 
endclass
class v_sequence extends uvm_sequence#(uvm_sequence_item);
  `uvm_object_utils(v_sequence)
  
  wr_sequencer wrsr;//write sequencer
  rd_sequencer rdsr;//read sequencer
  wr_sequence wrs;
  rd_sequence rds;
  v_sequencer vsrq;
  function new(string name="v_sequence");
    super.new(name);
  endfunction
  task body();
  wrs=wr_sequence::type_id::create("wrs");
  rds=rd_sequence::type_id::create("rds");
  $cast(vsrq,m_sequencer);//m_sequencer=e.vseqr
  wrsr=vsrq.wrsqr;
  rdsr=vsrq.rdsqr;

  wrs.start(wrsr);//start write sequence on write sequncer
  rds.start(rdsr);//start read sequence on read sequencer

  endtask


endclass
 
///////////////////////<--Test-->////////////////////////////////////////
 
class test extends uvm_test;
`uvm_component_utils(test)
 
function new( string name = "test", uvm_component parent);
super.new(name,parent);
endfunction
v_sequence vseq;
env e;
 
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      e = env::type_id::create("e",this);
      vseq=v_sequence::type_id::create("vseq");

    endfunction

  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();

  endfunction
 
    virtual task run_phase(uvm_phase phase);
 
    phase.raise_objection(this);
      vseq.start(e.vseqr);
      
    phase.drop_objection(this);
    endtask
  
  
endclass
 
///////////////////<--Top-->/////////////////////////////////////
module top;
 
 
initial begin
  run_test("test");
end
 
endmodule