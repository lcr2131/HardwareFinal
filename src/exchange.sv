//Author:Leonard Robinson

typedef union packed {
   struct     packed {
   bit [5:0]  opcode;//(4 bit opcode now)
   bit [4:0]  rs; //(src& dest, 4 bits) 
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
   
   struct     packed{
   bit 	      valid	      ; 
   bit [3:0]  opcode;
   bit [3:0]  rs;
   bit [3:0]  rt;
   // bit [] bid; Branch ID
   bit [18:0] imm; 
} proc_I;
   
   struct     packed{
   bit 	      valid; 
   bit [3:0]  opcode;
   bit [3:0]  rs;
   bit [3:0]  rt;
   bit [3:0]  rd;
   bit [2:0]  bid;
   bit [4:0] shamt;
   bit [5:0]  funct;
} proc_R;
   
} instr;

function bit[31:0]  exchange(instr op);
 if (op.R.opcode = 6'b000000 ) begin
    op.proc_R.valid = 1'b0;
    op.proc_R.opcode = 4'b1000;
    op.proc_R.funct = 6'b100000;
    op.proc_R.shamt = '0;
    op.proc_R.rs = chooseRandomReadRegister();
    op.proc_R.rt = chooseRandomReadRegister();
    op.proc_R.rd = chooseRandomWriteRegister();
    return op;
 end
	 else if (op.proc_R.opcode = 6'b000000) begin
	    op.I.opcode = 6'b000101;
	    op.I.rs = chooseRandomReadRegister();
	    op.I.rt = chooseRandomReadRegister();
	    op.I.imm = $unsigned($random) & branch_mask;
	    if ($unsigned($random) % 2) op.I.imm = -op.I.imm;
	    return op;
	 end
	 else if (op.proc_R.opcode = 6'b000000) begin
	    op.I.opcode = 6'b100011;
	    op.I.rt = chooseRandomWriteRegister();
	    op.I.rs = chooseRandomReadRegister();
	    op.I.imm = $unsigned($random) & address_mask;
//	    if ($unsigned($random) % 2) op.I.imm = -op.I.imm;
	    return op;
	 end
	 else if (op.proc_R.opcode = 6'b000000) begin
	    op.I.opcode = 6'b101011;
	    op.I.rt = chooseRandomReadRegister();
	    op.I.rs = chooseRandomReadRegister();
	    op.I.imm = $unsigned($random) & address_mask;
//	    if ($unsigned($random) % 2) op.I.imm = -op.I.imm;
	    return op;
	 end
      end
   
endfunction // generateRandomInstruction
