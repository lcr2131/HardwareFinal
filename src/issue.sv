//Author: Leonard Robinson
//Modified: December 11, 2012
//Issue queue Draft

class issue_queue;

   issue_queue[$] = {};

   //Allocate up to four instructions to the issue queue at one time
   function allocate ();
      issue_queue.insert();
      issue_queue.push_front();
      issue_queue.push_back();
      
   endfunction //

   //Deallocate up to four instructions
   function deallocate ();
      issue_queue.delete();
      issue_queue.pop_front();
      issue_queu.pop_back();
      
   endfunction //

   //Removed a bunch of instructions at one time
   //Occurs when branches are predicted
   function flush ();
   endfunction //

   //Move instructions around in the queue
   function shift ();
   endfunction //   
    
   //TODO
   //Branch handling simulations
   //Simulate Valid functionality
   //Source Destination Handling
   
   //all_checker.sv
   //Checks everything -- branches, load store

   
endclass // issue_queue
