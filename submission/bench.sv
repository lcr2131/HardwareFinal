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

parameter DATA_MEM_SIZE = 32;
typedef bit [31:0][DATA_MEM_SIZE-1:0] data_memory;
typedef bit [31:0] register;

class processor;
   register [15:0] regs;
   register pc;
   data_memory mem;
   int 		   commit_count; // How many instructions completed this cycle
   int 		   waiting;
   int 		   mem_valid;  // An input that comes from the data memory
   

   parameter ISSUE_QUEUE_SIZE = 16;
   parameter BRANCH_ID_LIMIT = 8;
   parameter WRITE_BUFFER_SIZE = 32;    

   typedef struct  {
      bit [4:0]    dest;  // destination register   
      bit [2:0]    bid;   // branch id
      bit [31:0]   data1; // for ALU
      bit [31:0]   data2; // for ALU
      int 	   mem;   // 1=write, 2=read, 0=no mem
      instr       op;
   } decoded_t;

   typedef decoded_t decoded_a[3:0];
   
   typedef struct  {
      bit [31:0]   addr;
      bit [31:0]   data;
      bit [4:0]    dest;  // Register to write to (for a mem read)
      int 	   mem;   // 2=read memory, 1=write memory
      bit [2:0]    bid;
   } datamem_packet;
   
   decoded_t       issue_queue[$];
   decoded_t       write_buffer[$];
   int             next_branch_id; 		  
   int 		   scoreboard[15:0];
   int 		   flush;
   register        branch_addr;// when flushing/branching
   bit [2:0] 	   branch_id;  // when flushing

   // Registers between stages
   decoded_a stage12;
   decoded_a stage23;
   datamem_packet stage34;
   datamem_packet stage4_commit;

   function void compare(processor other);
      int 	   good = 1;
      for (int i = 0; i < 16; i++) begin
	 if (regs[i] != other.regs[i]) begin
	    $display("Mismatch R%0d (%x != %x)", i, regs[i], other.regs[i]);
	    good = 0;
	 end
      end
      for (int i = 0; i < DATA_MEM_SIZE; i++) begin
	 if (mem[i] != other.mem[i]) begin
	    $display("Mismatch mem[%0x] (%x != %x)", i, mem[i], other.mem[i]);
	    good = 0;
	 end
      end
      if (!good) $exit();
   endfunction

   function void reset();
      issue_queue = { };
      write_buffer = { };
      next_branch_id = 0;
      flush = 0;
      branch_addr = 0;
      branch_id = 0;
      pc = 0;
      waiting = 0;
      commit_count = 0;
      for (int i = 0; i < 16; i++) regs[i] = i;
      for (int i = 0; i < 16; i++) scoreboard[i] = 0;
   endfunction; // reset
   
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
      regs[0] 	   = 0;
   endfunction // commit

   function decoded_a stage1(instr i1, instr i2);
      decoded_a chosen;
      int 			  j = 0;
      int 			  good = 0;
      decoded_t op1, op2;
      int 			  rd[3:0], rs[3:0], rt[3:0];

      if (flush) begin
	 for (int i = 0; i < issue_queue.size(); i++) begin
	    if (issue_queue[i].bid >= branch_id)
	      issue_queue.delete(i--);
	 end
	 pc = branch_addr;
	 return chosen;
      end

      if (issue_queue.size() >= ISSUE_QUEUE_SIZE ||
	  write_buffer.size() >= WRITE_BUFFER_SIZE - 4 ||
	  next_branch_id >= BRANCH_ID_LIMIT - 2) begin
	 waiting = 1;
      end

      if (waiting) begin
	 if (issue_queue.size() == 0 &&
	     write_buffer.size() == 0) begin
	    next_branch_id = 0;
	    waiting = 0;
	 end
      end
      
      if (!waiting) begin
	 // Instruction decode
	 if (i1.I.opcode == 6'b000101)
	   next_branch_id = next_branch_id + 1;
	 if (i1.R.opcode == '0 && i1.R.funct == 6'b100000)
	   i1.R.opcode = 6'b100000;	 
	 op1.bid = next_branch_id;
	 
	 if (i2.I.opcode == 6'b000101)
	   next_branch_id = next_branch_id + 1;
	 if (i2.R.opcode == '0 && i2.R.funct == 6'b100000)
	   i2.R.opcode = 6'b100000;
	 op2.bid = next_branch_id;
	 
	 op1.op = i1;
	 op2.op = i2;

	 // Add to queue and advance
	 if (i1 != '0) begin
	    issue_queue = {issue_queue, op1};
	    pc = pc + 4;
	 end
	 if (i2 != '0) begin
	    issue_queue = {issue_queue, op2};
	    pc = pc + 4;
	 end
      end
      
      // Choose up to four instructions to issue by checking for hazards
      for (int i = 0; i < issue_queue.size(); i++) begin
	 int d, s, t;
	 decoded_t q = issue_queue[i];
	 
	 if (q.op.R.opcode == 6'b100000) begin
	    d = q.op.R.rd;
	    s = q.op.R.rs;
	    t = q.op.R.rt;
	 end
	 else if (q.op.I.opcode == 6'b100011) begin
	    d = q.op.I.rt;
	    s = q.op.I.rs;
	    t = 0;
	 end
	 else if (q.op.I.opcode == 6'b101011) begin
	    d = 0;
	    s = q.op.I.rs;
	    t = q.op.I.rt;
	 end
	 else if (q.op.I.opcode == 6'b000101) begin
	    d = 0;
	    s = q.op.I.rs;
	    t = q.op.I.rt;
	 end
	 
	 good = tryIssue(d, s, t);

	 // The instruction has been selected for issuing
	 if (good) begin
	    q.data1 = i; // Remember which queue entry to remove
	    rd[j] = d;
	    rs[j] = s;
	    rt[j] = t;
	    chosen[j++] = q;
	 end

	 if (j == 4) break;
      end // for (int i = 0; i < issue_queue.size(); i++)

      // Clean up the selection: only one load/store
      good = 1;
      for (int i = 0; i < 4; i++) begin
	 if (chosen[i].op.I.opcode == 6'b101011 ||
	     chosen[i].op.I.opcode == 6'b100011) begin
	    if (!good) begin
	       chosen[i].op = '0;
	       rd[i] = 0;
	       rs[i] = 0;
	       rt[i] = 0;
	    end else good = 0;
	 end
      end

      // Remove instructions that have hazards among the four chosen
      // Also remove branches after a branch that is not valid
      good = 1;
      for (int i = 1; i < 4; i++) begin
	 if (hazard(rd, rs, rt, i) ||
	     (!good && chosen[i].op.I.opcode == 6'b000101)) begin
	    if (chosen[i].op.I.opcode == 6'b000101) good = 0;
	    chosen[i].op = '0;
	    rd[i] = 0;
	    rs[i] = 0;
	    rt[i] = 0;
	 end
      end
      
      // Remove selected entries from the issue queue and update scoreboard
      j = 0; // Count how many removals to adjust index
      for (int i = 0; i < 4; i++) begin
	 if (chosen[i].op.I.opcode) begin
	    issue_queue.delete(chosen[i].data1 - j++);
	    if (rd[i]) scoreboard[rd[i]] = 1;
	 end
      end

      $display("%x %x %x %x", chosen[0].op.R.opcode, chosen[1].op.R.opcode,
	       chosen[2].op.R.opcode, chosen[3].op.R.opcode);
      
      return chosen;
   endfunction // stage1
   
   function tryIssue(bit[4:0] write, bit[4:0] read1, bit[4:0] read2);
      if (write && scoreboard[write]) return 0;
      if (read1 && scoreboard[read1]) return 0;
      if (read2 && scoreboard[read2]) return 0;
      return 1;
   endfunction // tryIssue

   function int hazard(int d[3:0], int s[3:0], int t[3:0], int j);
      // RAW/WAW
      for (int i = 0; i < j; i++) begin
	 if ((d[j] && d[j] == d[i]) ||
	     (s[j] && s[j] == d[i]) ||
	     (t[j] && t[j] == d[i]))
	   return 1;
      end

      // WAR
      for (int i = 0; i < j; i++) begin
	 if ((s[i] && s[i] == d[j]) ||
	     (t[i] && t[i] == d[j]))
	   return 1;
      end
      
      return 0;
   endfunction; // hazard
   

   function decoded_a stage2(decoded_a ops);
      if (flush) flush--;
      
      // Read registers
      for (int i = 0; i < 4; i++) begin
	 if (ops[i].op.R.opcode == 6'b100000) begin
	    ops[i].data1 = regs[ops[i].op.R.rs];
	    ops[i].data2 = regs[ops[i].op.R.rt];
	    ops[i].dest = ops[i].op.R.rd;
	    ops[i].mem = 0;
	 end
	 if (ops[i].op.I.opcode == 6'b101011) begin
	    ops[i].data1 = regs[ops[i].op.I.rs];
	    ops[i].data2 = ops[i].op.I.imm;
	    ops[i].dest = ops[i].op.I.rt;
	    ops[i].mem = 1;
	 end
	 else if (ops[i].op.I.opcode == 6'b100011) begin
	    ops[i].data1 = regs[ops[i].op.I.rs];
	    ops[i].data2 = ops[i].op.I.imm;
	    ops[i].dest = ops[i].op.I.rt;
	    ops[i].mem = 2;
	 end
	 else if (ops[i].op.I.opcode == 6'b000101) begin
	    ops[i].mem = 0;
	    if (regs[ops[i].op.I.rs] != regs[ops[i].op.I.rt]) begin
	       // A branch is taken (misprediction)
	       if (!flush || ops[i].bid < branch_id) begin
		  flush = 3;
		  branch_addr = ops[i].op.I.imm * 4;
		  branch_id = ops[i].bid;
	       end
	    end
	 end
      end
      return ops;
   endfunction // stage2

   function datamem_packet stage3(decoded_a ops);
      int r = 3, m = 1; // Commit up to 3 register writes and one memory access
      datamem_packet ret;

      for (int i = 0; i < 4; i++) begin
	 // ALUs
	 ops[i].data1 = ops[i].data1 + ops[i].data2;
	 
	 // Write buffer
	 if (ops[i].op.I.opcode) write_buffer = {write_buffer, ops[i]};
      end

      // Clean out the buffer if there is a flush
      if (flush) begin
	 for (int i = 0; i < write_buffer.size(); i++) begin
	    if (write_buffer[i].bid >= branch_id) begin
	       if (write_buffer[i].op.I.opcode == 6'b100011 ||
		   write_buffer[i].op.R.opcode == 6'b100000) begin
		  scoreboard[write_buffer[i].dest] = 0;
	       end
	       else if (write_buffer[i].op.I.opcode == 6'b000101 &&
			write_buffer[i].bid == branch_id) begin
		  commit_count++;
	       end
	       write_buffer.delete(i--);
	    end
	 end
      end
      
      // Commit register writes and pass along a memory access
      for (int i = 0; i < write_buffer.size(); i++) begin
	 decoded_t op = write_buffer[i];
	 if (op.op.I.opcode == 6'b000101) begin
	    commit_count++;
	    write_buffer.delete(i--);
	 end
	 else if (r && op.mem == 0) begin
	    if (op.dest) regs[op.dest] = op.data1;
	    scoreboard[op.dest] = 0;
	    r--;
	    commit_count++;
	    write_buffer.delete(i--);
	 end
	 else if (m && op.mem != 0) begin
	    ret.addr = op.data1;
	    ret.dest = op.dest;
	    ret.data = regs[op.dest];
	    ret.mem = op.mem;
	    m--;
	    
	    if (mem_valid) write_buffer.delete(i--);
	 end
      end // for (int i = 0; i < write_buffer.size(); i++)
      return ret;
   endfunction; // stage3

   // Memory access
   function bit[32:0] stage4(datamem_packet d);
      //      if (stage4_commit.dest) begin
      // Write the result that was read last cycle
      //	 regs[stage4_commit.dest] = stage4_commit.data;
      //	 scoreboard[stage4_commit.dest] = 0;
      //	 commit_count++;
      //	 stage4_commit.dest = 0;
      //      end
      
      if (d.mem == 1) begin
	 writemem(d.addr, d.data);
	 if (mem_valid)
	   commit_count++;
      end
      else if (d.mem == 2) begin
	 //	 int result = readmem(d.addr);
	 //	 if (mem_valid) begin
	 //	    stage4_commit.dest = d.dest;
	 //	    stage4_commit.data = result;	    
	 //	    if (!d.dest) commit_count++;

	 int result = readmem(d.addr);
	 if (mem_valid) begin
	    if (d.dest) regs[d.dest] = result;
	    scoreboard[d.dest] = 0;
	    commit_count++;
	 end	 
      end
   endfunction; // stage4

   // Executes one clock cycle of pipelined execution
   function int cycle(int rst, instr in1, instr in2, int mem_done);
      int data;
      mem_valid = mem_done;
      if (rst) reset();
      else begin
	 data = stage4(stage34);
	 stage34 = stage3(stage23);
	 stage23 = stage2(stage12);
	 stage12 = stage1(in1, in2);
      end
      return data;
   endfunction; // cycle
   
   
   function void lw(instr op);
      // $rt <- mem(imm + $rs)
      regs[op.I.rt] = readmem(op.I.imm + regs[op.I.rs]);
   endfunction

   function void sw(instr op);
      // mem(imm + $rs) <- $rt
      writemem(op.I.imm + regs[op.I.rs], regs[op.I.rt]);
   endfunction

   function void bne(instr op);
      // pc <- imm (only if $rs != $rt), not standard MIPS
      if (regs[op.I.rs] != regs[op.I.rt]) begin
	 pc = op.I.imm * 4;
      end
   endfunction

   function void add(instr op);
      // $rd <- $rs + $rt
      regs[op.R.rd] = regs[op.R.rs] + regs[op.R.rt];
   endfunction // add

   function bit[31:0] readmem(bit[31:0] addr);
      if (addr / 4 < DATA_MEM_SIZE)
	return mem[addr / 4];
      else return 0;
   endfunction; // readmem

   function void writemem(bit[31:0] addr, bit[31:0] data);
      if (addr / 4 < DATA_MEM_SIZE)
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
   int 	max_transactions    = 10000;
   int 	warmup_time         = 2;
   int 	seed                = 1;
   int  check_model         = 0;
   

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

   int 	run_full = 0;
   int 	run_decode = 0;
   int 	run_precque = 0;
   int 	run_allcheck = 0;
   int 	run_register = 0;
   int 	run_swap = 0;
   int 	run_buffer = 0;

   // Other simulation parameters
   real reset_density           = 0.1;
   int  worst_memory_delay      = 0;
   int  worst_instruction_delay = 0;


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

	   "ICACHE_DELAY": begin
	      chars_returned = $sscanf(value, "%d", worst_instruction_delay);
	      $display("Worst instruction delay: %d", worst_instruction_delay);
	   end

	   "MEMORY_DELAY": begin
	      chars_returned = $sscanf(value, "%d", worst_memory_delay);
	      $display("Worst data memory delay: %d", worst_memory_delay);
	   end

	   "CHECK_MODEL": begin
	      chars_returned = $sscanf(value, "%d", check_model);
	      $display("%s validate pipelined verification model",
		       check_model ? "Will" : "Won't");
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

program testbench (
		   decode_interface.decode_bench decode_tb,
		   pre_calculation_and_queue_interface.pre_calculation_and_queue_bench pre_calculation_and_queue_tb,
		   all_checker_interface.all_checker_bench all_checker_tb,
		   ins_swap_interface.ins_swap_bench ins_swap_tb,
		   register_file_interface.register_file_bench register_file_tb,
		   top_issue_stage_interface.top_issue_stage_bench top_issue_stage_tb
		   );
   //pc_ctrl,branch_ctrl,branch_delay,top_buffer_stage
   transaction tx;
   processor golden_result;
   processor pipelined_result;
   env env;
   int cycle;

   parameter ICACHE_SIZE = 32;
   bit [31:0][ICACHE_SIZE-1:0] icache;

   function int fetch(int addr);
      return icache[(addr / 4) % ICACHE_SIZE];
   endfunction // fetch
   
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

   covergroup COVbranch;
   endgroup // COVbranch
   
   COVtrans ct;
   COVreg cr;
   COVbranch cb;
   
   task do_initialize;
      env.cycle++;
      cycle = env.cycle;
      tx = new();
   endtask

   task do_cycle;
      env.cycle++;
      cycle = env.cycle;
      tx = new();

      tx.instruction1 = icache[golden_result.pc/4]; // should come from dut not golden result
      tx.exchange_all();
      pipelined_result.cycle(0, fetch(pipelined_result.pc),
		 	     fetch(pipelined_result.pc+4), 1);
      
      ct.sample();
      cr.sample();
      
   endtask // do_cycle

   task do_model_validation;
      env.cycle++;
      cycle = env.cycle;

      while (pipelined_result.pc < 28)
	pipelined_result.cycle(0, fetch(pipelined_result.pc),
			       fetch(pipelined_result.pc+4), 1);
      repeat(16) pipelined_result.cycle(0, 0, 0, 1);
      while (golden_result.pc < 32) begin
	 env.disassemble(fetch(golden_result.pc));
	 golden_result.commit(fetch(golden_result.pc));
      end
      
      +
      /*      while (golden_result.pc < 32) begin
       pipelined_result.commit_count = 0;
       pipelined_result.cycle(0, fetch(pipelined_result.pc),
       fetch(pipelined_result.pc+4), 1);
       repeat(16) pipelined_result.cycle(0,0,0,1);
       while (pipelined_result.commit_count--)
       golden_result.commit(fetch(golden_result.pc));
       golden_result.compare(pipelined_result);
      end*/
      
      golden_result.compare(pipelined_result);
      $display("Good");
   endtask // do_model_validation      

   /*   task do_decode;
    env.cycle++;
    cycle = env.cycle;
    tx = new();

    tx.instruction1 = icache[golden_result.pc/4];
    tx.exchange_all();
    env.disassemble(icache[golden_result.pc/4]);
    golden_result.commit(icache[golden_result.pc/4]);

    ct.sample();
    cr.sample();

    decode_tb.decode_cb.new_instr1_in <= tx.instruction1;
    decode_tb.decode_cb.new_instr2_in <= tx.instruction2;
    decode_tb.ins_1_op  ;  
    decode_tb.ins_1_des ;
    decode_tb.ins_1_s1  ;
    decode_tb.ins_1_s2  ;
    decode_tb.ins_1_ime ;

    @(decode_tb.decode_cb);
    
   endtask // do_decode     
    
    task do_full;
    //TODO Write the rest of the task.  Maybe include these tasks in a class
    
    
    //TODO Replace these with stages?
    task do_preque;
 endtask
    task do_acheck;
 endtask
    task do_swap;
 endtask
    task do_register;
 endtask
    task do_alu;
 endtask
    task do_buffer;
 endtask
    */   
   initial begin
      golden_result = new();
      pipelined_result = new();
      env = new();
      env.configure("./src/config.txt");
      ct = new();
      cr = new();

      golden_result.reset();
      pipelined_result.reset();
      
      
      // generate a random program and store it in instruction memory
      for (int i = 0; i < ICACHE_SIZE; i++) begin
	 icache[i] = env.generateRandomInstruction();
	 env.disassemble(icache[i]);	 
      end
      $display("-----Program Generated-----");
      

      // spice things up with some random memory
      for (int i = 0; i < 31; i++) begin
	 golden_result.mem[i] = env.rng.mask(32'hfffffffc);
	 pipelined_result.mem[i] = golden_result.mem[i];
      end
      
      repeat (env.warmup_time) begin
         do_initialize();
      end
      
      if (env.check_model)
	do_model_validation();

      // testing
      repeat (env.max_transactions) begin
	 do_cycle();
      end

   end
   
endprogram 
