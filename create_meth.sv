import uvm_pkg::*;
`include "uvm_macros.svh";

class trans extends uvm_transaction;
`uvm_object_utils(trans)
function new(string name="trans");
	super.new(name);
endfunction
rand int a;
constraint c{a>5;a<17;}
endclass

trans t;

module top;
initial
begin
factory.print();
//t=trans::type_id::create("t");
t=new("t");
repeat(5)
begin
t.randomize;
$display("%d",t.a);
end
end
endmodule
