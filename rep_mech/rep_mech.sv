import uvm_pkg::*;
`include "uvm_macros.svh"

class rep_mech extends uvm_sequence_item;
	function new(string name="rep_mech");
		super.new(name);	
	endfunction
	function void display();
		`uvm_info("d","verbo is HIGH",UVM_HIGH);
		`uvm_info("d","verbo is MEDIUM",UVM_MEDIUM);
		`uvm_info("d","verbo is LOW",UVM_LOW);
		`uvm_info("d","verbo is NONE",UVM_NONE);
	endfunction
endclass

rep_mech h;

module t;
	initial
		begin
		h=new("h");
		h.display();
		$display("verb is %d",uvm_top.get_report_verbosity_level);
		uvm_top.set_report_verbosity_level(UVM_LOW);
		//h.set_report_verbosity_level(UVM_LOW);
		h.display();
	end
endmodule
