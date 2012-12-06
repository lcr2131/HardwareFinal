//Name: bench.sv
//Date Created:Saturday October 13, 2012
//Date Modified:

typedef union packed {
   struct packed {
      bit [5:0]  opcode;
      bit [4:0]  rs;
      bit [4:0]  rt;
      bit [15:0] imm;
   } I;

   struct packed {
      bit [5:0]  opcode;
      bit [4:0]  rs;
      bit [4:0]  rt;
      bit [4:0]  rd;
      bit [4:0]  shamt;
      bit [5:0]  funct;
   } R;
} instr;

class transaction;
   bit [31:0] instruction1;
   bit [31:0] instruction2;
   bit 	      reset;
endclass // transaction

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
   function lw(instr op);

   endfunction

   function sw(instr op);

   endfunction

   function bne(instr op);

   endfunction

   function add(instr op);

   endfunction
endclass

class hazards;

endclass

class env;
   int  cycle = 0;
   
   int 	max_transactions = 10000;
   int 	warmup_time      = 2;
   int 	seed             = 1;
   real reset_density    = 0.1;
   int 	generate_add     = 1;
   int 	generate_load    = 0;
   int 	generate_store   = 0;
   int 	generate_branch  = 0;
   int 	generate_raw     = 0;
   int  generate_waw     = 0;
   int 	register_mask    = 7;
   int  address_mask     = 7;
   int  branch_mask      = 7;
   

   bit [4:0][2:0] regsInFlight;
   
   function bit[4:0] chooseRandomReadRegister();
      bit [4:0] r;
      while (1) begin
	 r = $unsigned($random) % 32;
	 r = r & register_mask;

	 // Remove any RAW hazards (R0 is permanently 0, no hazard)
	 if (!generate_raw && r != 0) begin
	    if (r == regsInFlight[0] ||
		r == regsInFlight[1] ||
		r == regsInFlight[2])  begin
	       continue;
	    end
	    else break;
	 end else break;
      end // while (1)
      return r;
   endfunction; // chooseRandomReadRegister

   function bit[4:0] chooseRandomWriteRegister();
      bit [4:0] r;
      
      while (1) begin
	 r = $unsigned($random) % 31 + 1;
	 r = r & register_mask;

	 // Remove any WAW hazards
	 if (!generate_waw) begin
	    if (r == regsInFlight[0] ||
		r == regsInFlight[1] ||
		r == regsInFlight[2])   continue;
	    else break;
	 end else break;
      end

      // Keep track of the registers that could conflict
      regsInFlight[2] = regsInFlight[1];
      regsInFlight[1] = regsInFlight[0];
      regsInFlight[0] = r;
      return r;
   endfunction; // chooseRandomWriteRegister
      
   function bit[31:0] generateRandomInstruction();
      while (1) begin
	 instr op;
	 int opcode = $unsigned($random) % 4;
	 
	 if (opcode == 0 && generate_add) begin
	    op.R.opcode = 6'b000000;
	    op.R.funct = 6'b100000;
	    op.R.shamt = '0;
	    op.R.rs = chooseRandomReadRegister();
	    op.R.rt = chooseRandomReadRegister();
	    op.R.rd = chooseRandomWriteRegister();
	    return op;
	 end
	 else if (opcode == 1 && generate_branch) begin
	    op.I.opcode = 6'b000101;
	    op.I.rs = chooseRandomReadRegister();
	    op.I.rt = chooseRandomReadRegister();
	    op.I.imm = $unsigned($random) & branch_mask;
	    return op;
	 end
	 else if (opcode == 2 && generate_load) begin
	    op.I.opcode = 6'b100011;
	    op.I.rt = chooseRandomWriteRegister();
	    op.I.rs = chooseRandomReadRegister();
	    op.I.imm = $unsigned($random) & address_mask;
	    return op;
	 end
	 else if (opcode == 3 && generate_store) begin
	    op.I.opcode = 6'b101011;
	    op.I.rt = chooseRandomReadRegister();
	    op.I.rs = chooseRandomReadRegister();
	    op.I.imm = $unsigned($random) & address_mask;
	    return op;
	 end
      end
   endfunction; // generateRandomInstr   

   function disassemble(instr op);
      string opcode;
      int    itype = 1;
      
      
      if (op.R.opcode == '0 && op.R.funct == 6'b100000) begin
	 opcode = "ADD";
	 itype = 0;
      end else if (op.I.opcode == 6'b100011)
	opcode = "LW ";
      else if (op.I.opcode == 6'b101011)
	opcode = "SW ";
      else if (op.I.opcode == 6'b000101)
	opcode = "BNE";
      else
	opcode = "???";
      
      if (itype)
	$display("%s   R%d, R%d, %x", opcode, op.I.rs, op.I.rt, op.I.imm);
      else
	$display("%s   R%d, R%d, R%d", opcode, op.R.rd, op.R.rs, op.R.rt);
   endfunction; // disassemble

   
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

	   "REGISTER_MASK": begin
	      chars_returned = $sscanf(value, "%d", register_mask);
	      $display("Register usage masked to %d", register_mask);
	   end  

	   default: begin
	      $display("Never heard of a: %s", param);
              $exit();
	   end
         endcase;	 
      end // End While

      if (!generate_add && !generate_branch &&
          !generate_load && !generate_store) begin
	 $display("No opcodes are enabled for random program generation.");
	 $exit();
      end
   endfunction // configure  

endclass // env

program testbench (processor_interface.bench proc_tb);
   transaction tx;
   test test;
   env env;
   int cycle;

   bit [31:0][31:0] icache;

   task do_cycle;
      env.cycle++;
      cycle = env.cycle;
      tx = new();

      // fetch two instructions and execute
      // compare results
      
   endtask

   initial begin
      test = new();
      env = new();
      env.configure("./src/config.txt");

      // generate a random program and store it in instruction memory
      for (int i = 0; i < 31; i++) begin
	 icache[i] = env.generateRandomInstruction();
	 env.disassemble(icache[i]);
      end
      
      
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
