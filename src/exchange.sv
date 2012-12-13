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
      x.proc_I.opcode = 4'b0100;
      x.proc_I.rs = op.I.rs[3:0];
      x.proc_I.rt = op.I.rt[3:0];
      x.proc_I.imm = op.I.imm;
   end

   else if (op.I.opcode == 6'b100011 ) begin//lw
      x.proc_I.opcode = 4'b0010;
      x.proc_I.rs = op.I.rs[3:0];
      x.proc_I.rt = op.I.rt[3:0];
      x.proc_I.imm = op.I.imm;
   end

   return x;
endfunction
