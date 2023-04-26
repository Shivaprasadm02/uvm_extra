import uvm_pkg::*;
`include "uvm_macros.svh";

class sequencer extends uvm_agent;
	`uvm_component_utils(sequencer);
	function new(string name="sequencer", uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
endclass
class driver extends uvm_agent;
	`uvm_component_utils(driver);
	function new(string name="driver", uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
endclass
class monitor extends uvm_agent;
	`uvm_component_utils(monitor);
	function new(string name="monitor", uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
endclass
class agent extends uvm_agent;
	`uvm_component_utils(agent);
	sequencer s;
	driver d;
	monitor m;
	uvm_active_passive_enum is_active;
	function new(string name="agent", uvm_component parent);
		super.new(name,parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m=monitor::type_id::create("m",this);
	uvm_config_db #(uvm_active_passive_enum)::get(this," ","isactive",is_active);
	$display("active value is %d",is_active);
	if(is_active)
		begin
		s=sequencer::type_id::create("s",this);
		d=driver::type_id::create("d",this);
		end
	endfunction
endclass

class agt_top extends uvm_env;
	`uvm_component_utils(agt_top);
	agent ag[];
	int n;

	function new(string name="agt_top", uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(int)::get(this,"","int",n))
			`uvm_fatal("agt_top","check string its failed");
	$display("no of agents is %d",n);
		ag=new[n];
		foreach(ag[i])
			ag[i]=agent::type_id::create($sformatf("ag[%0d]",i),this);
	endfunction
endclass

class env extends uvm_env;
	`uvm_component_utils(env);
	agt_top agtp;

	function new(string name="env", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agtp=agt_top::type_id::create("agtp",this);
	endfunction
endclass

class test extends uvm_test;

	`uvm_component_utils(test);
	env ev;
//typedef enum{UVM_PASSIVE,UVM_ACTIVE} is_active;
	
	uvm_active_passive_enum is_active=UVM_ACTIVE; //is_active is a variable of type enum 
	int no_of_agents=3;

	function new(string name="test", uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ev=env::type_id::create("ev",this);
		uvm_config_db #(int)::set(this,"ev.agtp","int",no_of_agents);
		uvm_config_db #(uvm_active_passive_enum)::set(this,"*.ag*","isactive",is_active);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology;
	endfunction

endclass

module top;
initial
	begin
		run_test("test");
	end

endmodule