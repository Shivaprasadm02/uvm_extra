import uvm_pkg::*;
`include "uvm_macros.svh"

class rep_mech extends uvm_sequence_item;
	function new(string name="rep_mech");
		super.new(name);	
	endfunction
	function void display();
		`uvm_info("d","verbo is HIGH",UVM_HIGH);
		`uvm_info("d","verbo is NONE",UVM_NONE);
		`uvm_warning("n","verbo is NONE");
		`uvm_error("n","verbo is NONE");
		`uvm_fatal("n","verbo is NONE");
	endfunction
endclass

rep_mech h;

module t;
	initial
		begin
		h=new("h");
		h.display;
		uvm_top.set_report_verbosity_level(UVM_LOW);
		h.display();
		uvm_top.set_report_id_verbosity("n",UVM_HIGH);
	end
endmodule
