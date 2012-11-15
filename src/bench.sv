//Author:Donald Pomeroy
//Name: bench.sv
//Date Created:Saturday October 13, 2012
//Date Modified:

class data;
   
endclass // data

class test;
endclass // test

class issue_queue;
   
endclass // issue_queue

class alu;

endclass // alu

class data_memory;

endclass // data_memory

class register;
endclass // register
   

class env;

   int cycle = 0;
   int max_transactions=10000;
   int warmup_time=2;
   int 	seed;
     
   function configure(string filename);
      int file, chars_returned;
      string param, value;
      file = $fopen(filename, "r");
      while(!$feof(file)) begin
	 chars_returned = $fscanf(file, "%s %s", param, value);
	 if ("RANDOM_SEED" == param) begin
            $sscanf(value, "%d", seed);
            $srandom(seed);
	    $display("Random number generator seeded to %d", seed);
         end
         else if("TRANSACTIONS" == param) begin
            $sscanf(value, "%d", max_transactions);
	    $display("Maximum transactions to test: %d", max_transactions);
         end
         else begin
            $display("Never heard of a: %s", param);
            $exit();
         end		 
      end // End While
   endfunction // configure  

endclass // env


/*
class checker;
   function bit int_check_result (int dut_value, int bench_value, bit verbose, string name); 
      bit passed = (dut_value == bench_value);
      if(passed) begin
         if(verbose) $display("%t %s:\tpass %d\n", $realtime, name, dut_value);
      end
      else begin
         $display("%t %s:\tfail", $realtime, name);
         $display("----> dut value:   %d", dut_value);
         $display("----> bench value: %d", bench_value);
         $exit();
      end
      return passed;
   endfunction

   function bit bit_check_result(bit dut_value, bit bench_value, bit verbose, string name);
      bit passed = (dut_value == bench_value);
      if(passed) begin
         if(verbose) $display("%t %s:\tpass %d", $realtime, name, dut_value);
      end
      else begin
         $display("%t %s:\tfail", $realtime, name);
         $display("----> dut value:   %d", dut_value);
         $display("----> bench value: %d", bench_value);
         $exit();
      end
      return passed;
   endfunction
endclass 
*/

program testbench ();
   
   data packet;
   test test;
//   checker check;
   env env;
   int cycle;

   task do_cycle;
          
      env.cycle++;
      
      cycle = env.cycle;
      packet = new();
      packet.randomize();

   endtask

   initial begin
      test = new();
//      check = new();
      packet = new();
      env = new();
      env.configure("config.txt");

      // warm up
      repeat (env.warmup_time) begin
         do_cycle();
      end

      // testing
      repeat (env.max_transactions) begin
         do_cycle();

	 // only check this result if read_enable is set
      end			
   end
   
endprogram 

   
   
   
   
