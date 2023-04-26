import uvm_pkg::*;
`include "uvm_macros.svh";

//component class
class mycomp extends uvm_component;
`uvm_component_utils(mycomp)
function new(string name="mycomp", uvm_component parent);
	super.new(name, parent);
endfunction
endclass

//uvm_driver class
class mydrv extends uvm_driver;
`uvm_component_utils(mydrv)
function new(string name="mydrv", uvm_component parent);
	super.new(name,parent);
endfunction
endclass

//object type classs
class trans extends uvm_object;
`uvm_object_utils(trans)
function new(string name="trans");
	super.new(name);
endfunction
endclass

module top;
initial
begin
factory.print();
end
endmodule
