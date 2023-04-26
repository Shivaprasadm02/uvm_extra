import uvm_pkg::*;
`include "uvm_macros.svh";

class trans extends uvm_sequence_item;
`uvm_object_utils(trans)
function new(string name="trans");
	super.new(name);
endfunction
rand int a;
constraint c{a>5;a<17;}
endclass

class extrans extends trans;
`uvm_object_utils(extrans)
function new(string name="extrans");
	super.new(name);
endfunction
constraint c{a==20;}
endclass

trans t;

module top;
initial
begin
factory.print();
factory.set_type_override_by_type(trans::get_type(), extrans::get_type());
t=trans::type_id::create("t");
factory.print();
repeat(5)
begin
t.randomize;
$display("%d",t.a);
end
end
endmodule
