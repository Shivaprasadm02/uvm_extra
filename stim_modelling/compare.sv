import uvm_pkg::*;
`include "uvm_macros.svh";

class trans extends uvm_sequence_item;
	rand int a;
	string s;
	`uvm_object_utils_begin(trans);
		`uvm_field_int(a,UVM_ALL_ON | UVM_BIN)
		`uvm_field_string(s,UVM_ALL_ON)
	`uvm_object_utils_end
	constraint c{a>5;a<17;}
endclass

trans t1, t2,t3;
module top;
initial
begin
	t1=trans :: type_id::create("t1");
	t2=trans :: type_id::create("t2");
	t1.randomize();
	t1.s="uvm";
	t1.print(); 
	t2.copy(t1);
	t2.print;
	//t3=t1.clone; // error as parent to child is illegal but actually t1 is not parent
	$cast(t3,t1.clone()); //t1-->returns through the parent uvm_object thus $cast needed
	t3.print;
	t3.s="maven";
	t3.print;
	if(t2.compare(t1))
		$display("botha re same");
	else
		$display("both are not same");
	if(t3.compare(t1))
		$display("botha re same");
	else
		$display("both are not same");
end
endmodule
