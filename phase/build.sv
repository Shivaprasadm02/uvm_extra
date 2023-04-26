import uvm_pkg::*;
`include "uvm_macros.svh";

class test extends uvm_test;
`uvm_component_utils(test)
function new(string name="test",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
$display("	I am in buildphase of test");
endfunction
endclass

module top;
initial
begin
run_test("test");
end
endmodule