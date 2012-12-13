//Name: bench.sv
//Date Created:Saturday October 13, 2012

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

   struct packed {
      bit        valid; 
      bit [3:0]  opcode;
      bit [2:0]  bid;   // Branch ID
      bit [3:0]  rs;
      bit [3:0]  rt;
      bit [15:0] imm; 
   } proc_I;
   
   struct packed {
      bit        valid; 
      bit [3:0]  opcode;
      bit [2:0]  bid;
      bit [3:0]  rs;
      bit [3:0]  rt;
      bit [3:0]  rd;
      bit [11:0] remaining;//these don't matter
   } proc_R;
} instr;

class transaction;
   bit [31:0] instruction1;
   bit [31:0] instruction2;
   bit [31:0] instruction3;
   bit [31:0] instruction4;
   bit 	      reset;
endclass // transaction

class reg_data;
   bit [31:0] data;
endclass // reg_data

class issue_queue;
endclass // issue_queue


class all_checker; //Happens after issue, checks for everything
endclass // all_checker


class alu;
endclass // alu

typedef bit [31:0][63:0] data_memory;
typedef bit [31:0] register;

//TODO
//Include issue queue?  
class processor;
   register [15:0] regs;
   register pc;
   data_memory mem;

   function void commit(instr op);
      pc = pc + 1;
      
      if (op.R.opcode == '0 && op.R.funct == 6'b100000)
	add(op);
      else if (op.I.opcode == 6'b100011)
	lw(op);
      else if (op.I.opcode == 6'b101011)
	sw(op);
      else if (op.I.opcode == 6'b000101)
	bne(op);
      else
	$display("Undefined opcode");
      regs[0] = 0;
   endfunction
   
   function void lw(instr op);
      // $rt <- mem(imm + $rs)
      regs[op.I.rt] = readmem(op.I.imm + regs[op.I.rs]);
      $display("%x", regs[op.I.rt]);
   endfunction

   function void sw(instr op);
      // mem(imm + $rs) <- $rt
      writemem(op.I.imm + regs[op.I.rs], regs[op.I.rt]);
      $display("%x", regs[op.I.rt]);
   endfunction

   function void bne(instr op);
      // pc <- imm (only if $rs != $rt)
      if (regs[op.I.rs] != regs[op.I.rt]) begin
	 $display("Branch taken");
	 pc = pc + { {16{op.I.imm[15]}}, op.I.imm[15:0]};
      end else $display("Not taken");
   endfunction

   function void add(instr op);
      // $rd <- $rs + $rt
      regs[op.R.rd] = regs[op.R.rs] + regs[op.R.rt];
      $display("%x", regs[op.R.rd]);
   endfunction // add

   function bit[31:0] readmem(bit[31:0] addr);
      // Addresses must be aligned to 4 bytes
      if (addr & 32'h00000003) begin
	 $display("Bad memory read from %x at %x", addr, pc - 4);
	 $exit();
      end
      
      return mem[addr / 4];
   endfunction; // readmem

   function void writemem(bit[31:0] addr, bit[31:0] data);
      // Addresses must be aligned to 4 bytes
      if (addr & 32'h00000003) begin
	 $display("Bad memory write to %x at %x", addr, pc - 4);
	 $exit();
      end
      mem[addr / 4] = data;
   endfunction; // writemem   
endclass


// Random Number Generator
// (must be used instead of the built-in $random function to have control
// over the seed value)
class randgen;
   rand bit [31:0] r;
   
   // A non-negative number less than upper
   function bit [31:0] range(int upper);
      this.randomize();
      return r % upper;
   endfunction // range

   // A number with some bits masked out
   function bit [31:0] mask(bit[31:0] bitmask);
      this.randomize();
      return r & bitmask;
   endfunction // masked

   // Random zero/one for if-statements
   function int cointoss();
      this.randomize();
      return r & 1;
   endfunction // cointoss
endclass

class env;
   int  cycle = 0;
   randgen rng = new();

   // Basic simulation parameters
   int 	max_transactions = 10000;
   int 	warmup_time      = 2;
   int 	seed             = 1;

   // Random program generation parameters
   int 	generate_add     = 1;
   int 	generate_load    = 0;
   int 	generate_store   = 0;
   int 	generate_branch  = 0;
   int 	generate_raw     = 0;
   int  generate_waw     = 0;
   int 	register_mask    = 7;
   int  address_mask     = 7;
   int  branch_mask      = 7;

   // Other simulation parameters
   real reset_density               = 0.1;
   int  worstDataMemoryDelay        = 0;
   int  worstInstructionMemoryDelay = 0;


   // Random Program Generation
   parameter hazardDepth = 3;
   bit [4:0][hazardDepth:0] regsInFlight;
   
   function bit[4:0] chooseRandomReadRegister();
      bit [4:0] r;
      int 	done = 0;
      
      while (!done) begin
	 r = rng.mask(register_mask);

	 // Remove any RAW hazards (R0 is permanently 0, no hazard)
	 if (!generate_raw && r != 0) begin
	    done = 1;
	    for (int i = 0; i < hazardDepth; i++)
	      if (r == regsInFlight[i]) done = 0;
	 end else done = 1;
      end // while
      return r;
   endfunction; // chooseRandomReadRegister

   function bit[4:0] chooseRandomWriteRegister();
      bit [4:0] r;
      int 	done = 0;
      
      while (!done) begin
	 r = rng.mask(register_mask);

	 // Remove any WAW hazards (R0 has no hazards)
	 if (!generate_waw && r != 0) begin
	    done = 1;
	    for (int i = 0; i < hazardDepth; i++)
	      if (r == regsInFlight[i]) done = 0;
	 end else done = 1;
      end

      // Keep track of the registers that could conflict
      for (int i = hazardDepth - 1; i > 0; i--)
	regsInFlight[i] = regsInFlight[i-1];
      regsInFlight[0] = r;

      return r;
   endfunction; // chooseRandomWriteRegister
      
   function bit[31:0] generateRandomInstruction();
      while (1) begin
	 instr op;
	 int opcode = rng.range(4);
	 
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
	    op.I.imm = rng.mask(branch_mask);
	    if (rng.cointoss()) op.I.imm = -op.I.imm;
	    return op;
	 end
	 else if (opcode == 2 && generate_load) begin
	    op.I.opcode = 6'b100011;
	    op.I.rt = chooseRandomWriteRegister();
	    op.I.rs = chooseRandomReadRegister();
	    op.I.imm = rng.mask(address_mask);
	    return op;
	 end
	 else if (opcode == 3 && generate_store) begin
	    op.I.opcode = 6'b101011;
	    op.I.rt = chooseRandomReadRegister();
	    op.I.rs = chooseRandomReadRegister();
	    op.I.imm = rng.mask(address_mask);
	    return op;
	 end
      end
   endfunction; // generateRandomInstr   

   // Displays a binary MIPS instruction in human-readable text
   function disassemble(instr op);
      string opcode, fmt;
      int    itype = 1;      
      
      if (op.R.opcode == '0 && op.R.funct == 6'b100000) begin
	 opcode = "ADD";
	 fmt = "%s R%0d, R%0d, R%0d";
	 itype = 0;
      end else if (op.I.opcode == 6'b100011) begin
	 opcode = "LW ";
	 fmt = "%s R%0d, R%0d(%x)";
      end else if (op.I.opcode == 6'b101011) begin
	 opcode = "SW ";
	 fmt = "%s R%0d, R%0d(%x)";
      end else if (op.I.opcode == 6'b000101) begin
	 opcode = "BNE";
	 fmt = "%s R%0d, R%0d, %x";
      end else
	opcode = "???";
      
      if (itype)
	$display(fmt, opcode, op.I.rt, op.I.rs, op.I.imm);
      else
	$display(fmt, opcode, op.R.rd, op.R.rs, op.R.rt);
   endfunction; // disassemble

   // Read all options from separate file
   function configure(string filename);
      int     file, chars_returned;
      string  param, value;
      file = $fopen(filename, "r");
      while(!$feof(file)) begin
	 chars_returned = $fscanf(file, "%s %s", param, value);
	 case (param)
	   "RANDOM_SEED": begin
              chars_returned = $sscanf(value, "%d", seed);
              $srandom(seed, rng);
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

	   "GENERATE_WAW": begin
              chars_returned = $sscanf(value, "%d", generate_waw);
	      $display("Write-after-write hazards %s be generated",
		       generate_waw ? "will" : "won't");
	   end

	   "REGISTER_MASK": begin
	      chars_returned = $sscanf(value, "%x", register_mask);
	      $display("Register usage masked to %X", register_mask);
	   end

	   "ADDRESS_MASK": begin
	      chars_returned = $sscanf(value, "%x", address_mask);
	      $display("Mem addr imm masked to %X", address_mask);
	   end

	   "BRANCH_MASK": begin
	      chars_returned = $sscanf(value, "%x", branch_mask);
	      $display("Branch addr imm masked to %X", branch_mask);
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

program testbench (all_checker_interface.all_checker_bench all_checker_tb);
   transaction tx;
   processor golden_result;
   env env;
   int cycle;

   bit [31:0][31:0] icache;

   task do_cycle;
      env.cycle++;
      cycle = env.cycle;
      tx = new();

      if (golden_result.pc > 31) begin
	 $display("Execution has reached the end of instruction memory.");
	 $exit();
      end
	
      env.disassemble(icache[golden_result.pc]);
      golden_result.commit(icache[golden_result.pc]);
      
      // fetch four instructions and execute
      //Issue Queue
      // compare results

      all_checker_tb.all_checker_cb.rst <= tx.reset;
            
   endtask

   initial begin
      golden_result = new();
      env = new();
      env.configure("./src/config.txt");

      // generate a random program and store it in instruction memory
      for (int i = 0; i < 31; i++) begin
	 icache[i] = env.generateRandomInstruction();
	 // env.disassemble(icache[i]);
      end

      // spice things up with some random memory
      for (int i = 0; i < 31; i++)
	golden_result.mem[i] = env.rng.mask(32'hfffffffc); 

      
      repeat (env.warmup_time) begin
         do_cycle();
      end
      
      // testing
      repeat (env.max_transactions) begin
         do_cycle();

      end			
   end
   
endprogram 