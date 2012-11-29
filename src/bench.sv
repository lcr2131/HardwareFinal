//Author:Donald Pomeroy
//Name: bench.sv
//Date Created:Saturday October 13, 2012
//Date Modified:

class packet;
   bit[31:0] instruction;
endclass // packet

class i_inst;
   bit [5:0] op  	     ;//opcode
   bit [4:0] reg_src	     ;//rs
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
	reg_data[31:0];
endclass // data_memory

class register;
   reg_data[31:0];
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

class hazards

endclass
   
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

program testbench (processor_interface.bench proc_tb);
   packet instruction1;
   packet instruction2;
   i_inst i_type;
   r_inst r_type;
   reg_data data;
   test test;
   env env;
   int cycle;

   task do_cycle;
          
      env.cycle++;
      
      cycle = env.cycle;
      instruction1 = new();
      instruction2 = new();
      
   endtask

   initial begin
      test = new();
      instruction1 = new();
      instruction2 = new();
      
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

   
   
   
   
