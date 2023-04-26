import uvm_pkg::*;
`include "uvm_macros.svh"

module top;
  uvm_event ev; //declaring eveny 
  
  initial begin
    ev = new(); //Creating the event
    
    fork
      //process-1, triggers the event
      begin
        #40;
        $display($time," Triggering The Event");//1
        ev.trigger;//triggering the event
      end
      
      //process-2, wait for the event to trigger
      begin
        $display($time," Waiting for the Event to trigger");//2
        ev.wait_trigger;//waiting 
        $display($time," Event triggered");//3
      end
    join
  end
endmodule