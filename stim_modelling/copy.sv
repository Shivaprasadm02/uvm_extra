import uvm_pkg::*;
`include "uvm_macros.svh"

class trans extends uvm_sequence_item;
	rand int a;
	string s;
	`uvm_object_utils_begin(trans);
		`uvm_field_int(a,UVM_ALL_ON | UVM_BIN)
		`uvm_field_string(s,UVM_ALL_ON)
	`uvm_object_utils_end
	constraint c{a>5;a<17;}
endclass

trans t1, t2;
module top;
initial
begin
	t1=trans :: type_id::create("t1");
	t2=trans :: type_id::create("t2");
	t1.randomize();
	t1.print(); 
	t2.copy(t1);
	t2.print;
end
endmodule