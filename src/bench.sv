//Name: bench.sv
//Date Created:Saturday October 13, 2012

typedef union packed {
   struct     packed {
   bit [5:0]  opcode;
   bit [4:0]  rs;
   bit [4:0]  rt;
   bit [15:0] imm;
} I;

   struct     packed {
   bit [5:0]  opcode;
   bit [4:0]  rs;
   bit [4:0]  rt;
   bit [4:0]  rd;
   bit [4:0]  shamt;
   bit [5:0]  funct;
} R;

   struct     packed {
   bit        valid; 
   bit [3:0]  opcode;
   bit [2:0]  bid;   // Branch ID
   bit [3:0]  rs;
   bit [3:0]  rt;
   bit [15:0] imm; 
} proc_I;
   
   struct     packed {
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
   instr instruction1;
   instr instruction2;
   instr proc_instruction1;
   instr proc_instruction2;
   
   bit 	      reset;
   
   function bit[31:0]  exchange(instr op);//new ones drop MSB for regs
      instr x;   
      if (op.R.opcode == 6'b000000 && op.R.funct == 6'b100000) begin//add
	 x.proc_R.opcode = 4'b1000;
	 x.proc_R.rs = op.R.rs[3:0];
	 x.proc_R.rt = op.R.rt[3:0];
	 x.proc_R.rd = op.R.rd[3:0];   
      end   
      
      else if (op.I.opcode == 6'b000101 ) begin//bne
	 x.proc_I.opcode = 4'b0001;
	 x.proc_I.rs = op.I.rs[3:0];
	 x.proc_I.rt = op.I.rt[3:0];
	 x.proc_I.imm = op.I.imm;		
      end
      
      else if (op.I.opcode == 6'b101011 ) begin//sw
	 x.proc_I.opcode = 4'b0010;
	 x.proc_I.rs = op.I.rs[3:0];
	 x.proc_I.rt = op.I.rt[3:0];
	 x.proc_I.imm = op.I.imm;
      end

      else if (op.I.opcode == 6'b100011 ) begin//lw
	 x.proc_I.opcode = 4'b0100;
	 x.proc_I.rs = op.I.rs[3:0];
	 x.proc_I.rt = op.I.rt[3:0];
	 x.proc_I.imm = op.I.imm;
      end

      return x;

   endfunction // exchange
   
   function void exchange_all();
      this.proc_instruction1 = exchange(instruction1);
      this.proc_instruction2 = exchange(instruction2);  
   endfunction // exchange_all

endclass // transaction

typedef bit [31:0][63:0] data_memory;
typedef bit [31:0] register;

//TODO
//Include issue queue?  
class processor;
   register [15:0] regs;
   register pc;
   data_memory mem;

   instr issue_queue[$];
   instr write_buffer[$];
   int 		   regsInFlight[15:0];
   

   // This is the simple verifier that does not simulate pipeline stages or
   // out-of-order execution.  Use it to test the processor as a blackbox.
   function void commit(instr op);
      pc = pc + 4;
      
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
   endfunction // commit

   function instr[3:0] stage1(instr in1, instr in2,
			      int flush, bit[31:0] branch_addr);
      instr[3:0] chosen;
      int 			  j = 0;
      int 			  good = 0;
      int 			  ls_used = 0; // only one load/store
	        
      if (issue_queue.size() < 6) begin  // How big is the issue queue?
	 issue_queue = {issue_queue, in1, in2};
	 pc = pc + 4;
      end
      if (flush)
	pc = branch_addr;
      
      // Choose up to four instructions to issue by checking for hazards
      for (int i = 0; i < issue_queue.size(); i++) begin
	 instr op = issue_queue[i];
	 
	 if (j != 0 && op.R.opcode == '0 && op.R.funct == 6'b100000)
	   good = tryIssue(op.R.rd, op.R.rs, op.R.rt);	    
	 else if (j == 0 && op.I.opcode == 6'b100011) begin
	    good = tryIssue(op.I.rt, op.I.rs, 0);
	    ls_used = 1;
	 end
	 else if (j == 0 && op.I.opcode == 6'b101011) begin
	    good = tryIssue(0, op.I.rs, op.I.rt);
	    ls_used = 1;
	 end
	 else if (j != 0 && op.I.opcode == 6'b000101)
	   good = tryIssue(0, op.I.rs, op.I.rt);

	 if (good) begin
	    if (j == 0) i = 0; // Restart the loop
	    chosen[j++] = op;
	    issue_queue.delete(i--);
	 end

	 if (j == 4) break;
      end // for (int i = 0; i < issue_queue.size(); i++)

      return chosen;
   endfunction // stage1
   
   function tryIssue(bit[4:0] write, bit[4:0] read1, bit[4:0] read2);
      if (write && regsInFlight[write]) return 0;
      if (read1 && regsInFlight[read1]) return 0;
      if (read2 && regsInFlight[read2]) return 0;
      
      if (write) regsInFlight[write] = 1;
//      if (read1) regsInFlight[read1] = 1;
//      if (read2) regsInFlight[read2] = 1;
      return 1;
   endfunction // tryIssue

   typedef struct {
      bit [4:0]   dest;  // destination register   
      bit [2:0]   bid;   // branch id
      bit [31:0]  data1; // for ALU
      bit [31:0]  data2; // for ALU
      int 	  mem;   // 1=write to mem, 2=read, 0=no mem
   } decoded [3:0];
      
   
   function decoded stage2(instr[3:0] ops);
      decoded ret;
      
      // Read registers
      for (int i = 0; i < 3; i++) begin
	 // TODO: picking the branch-id
	 
	 if (ops[i].R.opcode == '0 && ops[i].R.funct == 6'b100000) begin
	    ret[i].data1 = regs[ops[i].R.rs];
	    ret[i].data2 = regs[ops[i].R.rt];
	    ret[i].mem = 0;
	 end
	 if (ops[i].I.opcode == 6'b101011) begin
	    ret[i].data1 = regs[ops[i].I.rs];
	    ret[i].data2 = regs[ops[i].I.imm];
	    ret[i].mem = 1;
	 end
	 else if (ops[i].I.opcode == 6'b100011) begin
	    ret[i].data1 = regs[ops[i].I.rs];
	    ret[i].data2 = regs[ops[i].I.imm];
	    ret[i].mem = 2;
	 end
	 else if (ops[i].I.opcode == 6'b000101) begin
	    // Compute branches
	    if (regs[ops[i].I.rs] != regs[ops[i].I.rt]) begin
	       // TODO: handle the branch
	    end
	 end
      end
      return ret;
   endfunction // stage2

   function stage3(decoded ops);
      for (int i = 0; i < 3; i++) begin
	 // ALUs
	 ops[i].data1 = ops[i].data1 + ops[i].data2;
      
	 // TODO: Write buffer
      end
   endfunction; // stage3


   function stage4();
      // Data memory
   endfunction; // stage4

   // Executes one clock cycle of pipelined execution
   function cycle();
      //      stage1();
      //      stage2();
      //      stage3();
      //      stage4();     
   endfunction; // cycle
   
   
   
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

   //Stage Implementation Parameters -- Functions not implemented

   int run_full = 0;
   int run_decode = 0;
   int run_precque = 0;
   int run_allcheck = 0;
   int run_register = 0;
   int run_swap = 0;
   int run_buffer = 0;

   // Other simulation parameters
   real reset_density               = 0.1;
   int  worstDataMemoryDelay        = 0;
   int  worstInstructionMemoryDelay = 0;


   // Random Program Generation
   parameter hazardDepth = 3;
   bit [4:0][hazardDepth:0] regsInFlight;
   
   function bit[4:0] chooseRandomReadRegister();
      bit [4:0] 	    r;
      int 		    done = 0;
      
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

	   "RUN_FULL": begin
	      chars_returned = $sscanf(value, "%x", run_full);
	      $display("Running Full Pipeline %X", run_full);
	   end

	   "RUN_DECODE": begin
	      chars_returned = $sscanf(value, "%x", run_decode);
	      $display("Running Decode Stage %X", run_decode);
	   end

	   "RUN_PREQUE": begin
	      chars_returned = $sscanf(value, "%x", run_precque);
	      $display("Running Full Pipeline %X", run_precque);
	   end

	   "RUN_ACHECK": begin
	      chars_returned = $sscanf(value, "%x", run_allcheck);
	      $display("Running Full Pipeline %X", run_allcheck);
	   end

	   "RUN_REGISTER": begin
	      chars_returned = $sscanf(value, "%x", run_register);
	      $display("Running Full Pipeline %X", run_register);
	   end

	   "RUN_SWAP": begin
	      chars_returned = $sscanf(value, "%x", run_swap);
	      $display("Running Full Pipeline %X", run_swap);
	   end

	   default: begin
	      $display("Never heard of a: %s", param);
              //$exit();
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
   processor golden_result;
   env env;
   int cycle;

   parameter ICACHE_SIZE = 32;
   bit [31:0][ICACHE_SIZE-1:0] icache;

   
   covergroup COVtrans;
      MIPSinstructions : coverpoint tx.instruction1.I.opcode
	{
	 bins add = {0};
	 bins bne = {5};
	 bins lw = {35};
	 bins sw  = {43};
	 bins failures = default;
      }
      PROCinstructions : coverpoint tx.proc_instruction1.proc_I.opcode
	{
	 bins add = {8};
	 bins bne = {1};
	 bins lw = {4};
	 bins sw  = {2};
	 bins failures = default;
      }

      
   endgroup // COVtrans

   covergroup COVreg;
      MIPSrs : coverpoint tx.instruction1.I.rs;
      MIPSrt : coverpoint tx.instruction1.I.rt;
      MIPSrd : coverpoint tx.instruction1.R.rd;
      
      PROCrs : coverpoint tx.proc_instruction1.I.rs;
      PROCrt : coverpoint tx.proc_instruction1.I.rt;
      PROCrd : coverpoint tx.proc_instruction1.R.rd;
      
   endgroup // COVregis

   covergroup COVbranch;endgroup // COVbranch
   
   
   
   COVtrans ct;
   COVreg cr;
   COVbranch cb;
   

   
   task check_finish;
      if (golden_result.pc / 4 >= ICACHE_SIZE) begin
	 $display("Execution has reached the end of instruction memory.");
	 $exit();
      end
   endtask // check_finish 
   
   task do_initialize;
      env.cycle++;
      cycle = env.cycle;
      tx = new();
      env.disassemble(icache[golden_result.pc / 4]);
      golden_result.commit(icache[golden_result.pc / 4]);
      
   endtask

   task do_cycle;
      env.cycle++;
      cycle = env.cycle;
      tx = new();

      tx.instruction1 = icache[golden_result.pc/4];
      tx.exchange_all();
      env.disassemble(icache[golden_result.pc / 4]);
      golden_result.commit(icache[golden_result.pc / 4]);

      ct.sample();
      cr.sample();
 
      
   endtask // do_cycle
   
   task do_full;
      //TODO Write the rest of the task.  Maybe include these tasks in a class
      
   endtask // do_full
   
//TODO Replace these with stages?
task do_decode;endtask
task do_preque;endtask
task do_acheck;endtask
task do_swap;endtask
task do_register;endtask
task do_alu;endtask
task do_buffer;endtask
   
   initial begin
      golden_result = new();
      env = new();
      env.configure("./src/config.txt");
      ct = new();
      cr = new();
      
      
      // generate a random program and store it in instruction memory
      for (int i = 0; i < ICACHE_SIZE; i++) begin
	 icache[i] = env.generateRandomInstruction();
	 // env.disassemble(icache[i]);
      end

      // spice things up with some random memory
      for (int i = 0; i < 31; i++)
	golden_result.mem[i] = env.rng.mask(32'hfffffffc); 

      
      repeat (env.warmup_time) begin
         do_initialize();
      end
      
      // testing
      repeat (env.max_transactions) begin
	 check_finish();
	 do_cycle();

      end			
   end
   
endprogram 
