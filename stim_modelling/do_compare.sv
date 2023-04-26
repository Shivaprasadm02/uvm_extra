import uvm_pkg::*;
`include "uvm_macros.svh";

class trans extends uvm_sequence_item;
	rand int a;
	string s;
	`uvm_object_utils(trans);	
	constraint c{a>5;a<17;}
	
	function void do_print(uvm_printer printer);
	 printer.print_field("a",a,32,UVM_HEX);
	printer.print_string("s",s);
	endfunction

	function void do_copy(uvm_object rhs);
	 trans t;
	 $cast(t,rhs);
	 this.a=t.a;
	 this.s=t.s;
	endfunction

	function new(string name="trans");
		super.new(name);
	endfunction

	function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	 trans t;
	 $cast(t,rhs);
	 return 
		 this.a==t.a && this.s==t.s;
	endfunction
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
	t2.print(); 
	if(t2.compare(t1))
		$display("same");
	else
		$display("not same");
end
endmodule
