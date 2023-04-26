import uvm_pkg::*;
`include "uvm_macros.svh";

class producer extends uvm_component;
	`uvm_component_utils(producer);
	uvm_analysis_port #(int) an_port;
	int data=20;

	function new(string name="producer",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		an_port=new("an_port",this);
		$display("buildphase of producer");
	endfunction
	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			an_port.write(data);
			$display("sent data is %d",data);
		phase.drop_objection(this);
	endtask
endclass

class consumer1 extends uvm_component;
	`uvm_component_utils(consumer1)
	uvm_blocking_get_port #(int) get_port;
	uvm_tlm_analysis_fifo #(int) f;
	int data;

	function new(string name="consumer1",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		get_port=new("get_port",this);
		f=new("f",this);
		$display("buildphase of consumer");
	endfunction
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			get_port.get(data);
			$display("c1 got data %d",data);
		phase.drop_objection(this);
	endtask

endclass

class consumer2 extends uvm_component;
	`uvm_component_utils(consumer2)
	uvm_analysis_imp #(int,consumer2) an_imp;
	int data;

	function new(string name="consumer2",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		an_imp=new("an_imp",this);
		$display("buildphase of consumer");
	endfunction

	function void write(int data);
		$display("c2 got data %d",data);
	endfunction
endclass

class env extends uvm_component;
	`uvm_component_utils(env)
		producer p;
		consumer1 c1;
		consumer2 c2;

	function new(string name="env",uvm_component parent);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		p=producer::type_id::create("p",this);
		c1=consumer1::type_id::create("c1",this);
		c2=consumer2::type_id::create("c2",this);
		$display("buildphase of env");
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		p.an_port.connect(c1.f.analysis_export);
		c1.get_port.connect(c1.f.get_peek_export);
		p.an_port.connect(c2.an_imp);
	endfunction

	virtual function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction

endclass	

module top;
	initial
		begin
			run_test("env");
		end
endmodule