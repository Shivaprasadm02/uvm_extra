import uvm_pkg::*;
`include "uvm_macros.svh";
class producer extends uvm_component;
	`uvm_component_utils(producer);
	uvm_blocking_get_imp #(int,producer) get_imp;
	function new(string name="producer",uvm_component parent);
		super.new(name,parent);
	endfunction
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		get_imp=new("put_imp",this);
		$display("build phase of producer");
	endfunction
	int data=20;
	task get(output int d);
		d=data;
		//$display("data is %d",d);
	endtask
endclass

class consumer extends uvm_component;
	`uvm_component_utils(consumer);
	uvm_blocking_get_port #(int) get_port;
	function new(string name="consumer",uvm_component parent);
		super.new(name,parent);
	endfunction
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		get_port=new("get_port",this);
		$display("buildphase of consumer");
	endfunction
	int data;
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			get_port.get(data);
		$display("data is %d",data);
		phase.drop_objection(this);
	endtask
endclass

class env extends uvm_component;
	`uvm_component_utils(env)
	function new(string name="env",uvm_component parent);
		super.new(name,parent);
	endfunction
	producer p;
	consumer c;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		p=producer::type_id::create("p",this);
		c=consumer::type_id::create("c",this);
		$display("buildphase of env");
	endfunction
	virtual function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		c.get_port.connect(p.get_imp);
	endfunction
endclass

module top;
	initial
		begin
			run_test("env");
		end
endmodule
