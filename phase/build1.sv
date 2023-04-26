import uvm_pkg::*;
`include "uvm_macros.svh";

class env extends uvm_env;
`uvm_component_utils(env)
function new(string name="env",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
$display("	I am in buildphase of env");
endfunction
endclass

class test extends uvm_test;
`uvm_component_utils(test)
env ev;
function new(string name="test",uvm_component parent);
	super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
$display("	I am in buildphase of test");
ev=env::type_id::create("ev",this);
endfunction


endclass

module top;
initial
begin
run_test("test"); //this creates instance of test class and calls buildphase
end
endmodule