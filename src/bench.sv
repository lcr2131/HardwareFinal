//Author:Donald Pomeroy
//Name: bench.sv
//Date Created:Saturday October 13, 2012
//Date Modified:

class transaction;
   bit [31:0] instruction1;
   bit [31:0] instruction2;
   bit 	      reset;
endclass // transaction

class i_inst;
   bit [5:0] op;//opcode
   bit [4:0] reg_src;//rs
   bit [4:0] reg_des;//rt
   bit [15:0] immediate ;//imm
   
endclass // i_inst

class r_inst;
   bit [5:0]  op	;//Op_code
   bit [4:0]  reg_src1	;//rs
   bit [4:0]  reg_src2	;//rt
   bit [4:0]  reg_dest	;//rd
   bit [4:0]  shamt     ;//shamt
   bit [5:0]  funct     ;//funct
endclass // r_inst

class reg_data;
   bit [31:0] data;
   
endclass // reg_data

class test;   
endclass // test

class issue_queue;
endclass // issue_queue

class alu;
endclass // alu

class data_memory;
   bit [31:0] reg_data;
   
endclass // data_memory

class register;
   bit [31:0] reg_data;
endclass // register

class ops;
   function lw(i_inst instr);

   endfunction

   function sw(i_inst instr);

   endfunction

   function bne(i_inst instr);

   endfunction

   function add(r_inst instr);

   endfunction
endclass

class hazards;

endclass

class env;
   int 	      cycle = 0;
   
   int 	      max_transactions = 10000;
   int 	      warmup_time      = 2;
   int 	      seed             = 1;
   real       reset_density    = 0.1;
   int 	      generate_add     = 1;
   int 	      generate_load    = 0;
   int 	      generate_store   = 0;
   int 	      generate_branch  = 0;
   int 	      generate_raw     = 0;   
   
   function configure(string filename);
      int     file, chars_returned;
      string  param, value;
      file = $fopen(filename, "r");
      while(!$feof(file)) begin
	 chars_returned = $fscanf(file, "%s %s", param, value);
	 case (param)
	   "RANDOM_SEED": begin
              chars_returned = $sscanf(value, "%d", seed);
              $srandom(seed);
	      $display("Random number generator seeded to %d", seed);
	   end
	   
           "TRANSACTIONS": begin
              chars_returned = $sscanf(value, "%d", max_transactions);
	      $display("Maximum transactions to test: %d", max_transactions);
	   end
	   
	   "RESET_DENSITY": begin
              chars_returned = $sscanf(value, "%f", reset_density);
              $display("Reset density: %f", reset_density);
	   end
	   
           "GENERATE_ADD": begin
              chars_returned = $sscanf(value, "%d", generate_add);
	      $display("Add opcode %s be generated",
		       generate_add ? "will" : "won't");
	   end
	   
           "GENERATE_LOAD": begin
              chars_returned = $sscanf(value, "%d", generate_load);
	      $display("Load opcode %s be generated",
		       generate_load ? "will" : "won't");
	   end
	   
	   "GENERATE_STORE": begin
              chars_returned = $sscanf(value, "%d", generate_store);
	      $display("Store opcode %s be generated",
		       generate_store ? "will" : "won't");
	   end
	   
	   "GENERATE_BRANCH": begin
              chars_returned = $sscanf(value, "%d", generate_branch);
	      $display("Branch opcode %s be generated",
		       generate_branch ? "will" : "won't");
	   end

	   "GENERATE_RAW": begin
              chars_returned = $sscanf(value, "%d", generate_raw);
	      $display("Read-after-write hazards %s be generated",
		       generate_raw ? "will" : "won't");
	      end

	   default: begin
	      $display("Never heard of a: %s", param);
              $exit();
	   end
         endcase;	 
      end // End While
   endfunction // configure  

endclass // env

program testbench (processor_interface.bench proc_tb);
   transaction tx;
   test test;
   env env;
   int cycle;

   task do_cycle;
      env.cycle++;
      cycle = env.cycle;
      tx = new();
   endtask

   initial begin
      test = new();
      env = new();
      env.configure("./src/config.txt");

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
