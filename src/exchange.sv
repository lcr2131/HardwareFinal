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
   bit [2:0] bid; //Branch ID
   bit [15:0] imm; 
} proc_I;//new ones
   
   struct     packed{
   bit 	      valid; 
   bit [3:0]  opcode;
   bit [3:0]  rs;
   bit [3:0]  rt;
   bit [3:0]  rd;
   bit [2:0]  bid;
   bit [11:0] remaining;//these don't matter
   
} proc_R;
   
} instr;

function bit[31:0]  exchange(instr op);//new ones drop MSB for regs
	if (op.R.opcode = 6'b000000 ) begin//add
  		op.proc_R.opcode = 4'b1000;
		op.proc_R.rs = op.R.rs[3:0];
		op.proc_R.rt = op.R.rt[3:0];
		op.proc_R.rd = op.R.rd[3:0];
		return op;
	end   
	
	if (op.I.opcode = 6'b000101 ) begin//bne
		op.proc_I.opcode = 4'b0001;
		op.proc_I.rs = op.I.rs[3:0];
		op.proc_I.rt = op.I.rt[3:0];
		op.proc_I.imm = op.I.imm;
		return op
	end
	
	if (op.I.opcode = 6'b101011 ) begin//sw
		op.proc_I.opcode = 4'b0100;
		op.proc_I.rs = op.I.rs[3:0];
		op.proc_I.rt = op.I.rt[3:0];
		op.proc_I.imm = op.I.imm;
		return op
	end

	if (op.I.opcode = 6'b100011 ) begin//lw
		op.proc_I.opcode = 4'b0010;
		op.proc_I.rs = op.I.rs[3:0];
		op.proc_I.rt = op.I.rt[3:0];
		op.proc_I.imm = op.I.imm;
		return op
	end

endfunction // generateRandomInstruction
