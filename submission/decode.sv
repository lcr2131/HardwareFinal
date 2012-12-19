//Programmer:	Shuying Fan
//Date:		12/14/21012
//Purpose:	For new instructions decoding

module decode(decode_interface.decode_dut d);

   always_comb
     begin
	if (d.new_instr1_in[31:26] == 'b000000)
	  d.ins_1_op = 'b1000;
	else if (d.new_instr1_in[31:26] == 'b100011)
	  d.ins_1_op = 'b0100;
	else if (d.new_instr1_in[31:26] == 'b101011)
	  d.ins_1_op = 'b0010;
	else
	  d.ins_1_op = 'b0001;
     end


   always_comb
     begin
	//	ins_1_op = new_instr1_in[31:26];
	if (d.ins_1_op == 'b1000)		//add
	  begin
	     d.ins_1_des = d.new_instr1_in[25:22];
	     d.ins_1_s1  = d.new_instr1_in[21:18];
	     d.ins_1_s2  = d.new_instr1_in[17:14];
	     d.ins_1_ime = 'd0;
	  end
	else if (d.ins_1_op == 'b0100)		//load. one source
	  begin
	     d.ins_1_des = d.new_instr1_in[25:22];
	     d.ins_1_s1  = d.new_instr1_in[21:18];
	     d.ins_1_s2  = 'd0;
	     d.ins_1_ime = d.new_instr1_in[13:9];
	  end
	else 				//store or branch. no destination register
	  begin
	     d.ins_1_des = 'd0;
	     d.ins_1_s1  = d.new_instr1_in[21:18];
	     d.ins_1_s2  = d.new_instr1_in[17:14];
	     d.ins_1_ime = d.new_instr1_in[13:9];
	  end
     end



   always_comb
     begin
	if (d.new_instr2_in[31:26] == 'b000000)
	  d.ins_2_op = 'b1000;
	else if (d.new_instr2_in[31:26] == 'b100011)
	  d.ins_2_op = 'b0100;
	else if (d.new_instr2_in[31:26] == 'b101011)
	  d.ins_2_op = 'b0010;
	else
	  d.ins_2_op = 'b0001;
     end


   always_comb
     begin
	//	ins_2_op = new_instr2_in[31:26];
	if (d.ins_2_op == 'b1000)		//add
	  begin
	     d.ins_2_des = d.new_instr2_in[25:22];
	     d.ins_2_s1  = d.new_instr2_in[21:18];
	     d.ins_2_s2  = d.new_instr2_in[17:14];
	     d.ins_2_ime = 'd0;
	  end
	else if (d.ins_2_op == 'b0100)		//load. one source
	  begin
	     d.ins_2_des = d.new_instr2_in[25:22];
	     d.ins_2_s1  = d.new_instr2_in[21:18];
	     d.ins_2_s2  = 'd0;
	     d.ins_2_ime = d.new_instr2_in[13:9];
	  end
	else 				//store or branch. no destination register
	  begin
	     d.ins_2_des = 'd0;
	     d.ins_2_s1  = d.new_instr2_in[21:18];
	     d.ins_2_s2  = d.new_instr2_in[17:14];
	     d.ins_2_ime = d.new_instr2_in[13:9];
	  end
     end



endmodule

