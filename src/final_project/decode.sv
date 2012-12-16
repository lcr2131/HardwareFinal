//Programmer:	Shuying Fan
//Date:		12/14/21012
//Purpose:	For new instructions decoding

module decode(decode_interface.decode_dut d);

always_comb
begin
	d.ins_1_op = d.new_instr1_in[31:28];
	if (d.ins_1_op == 'b1000)		//add
	begin
		d.ins_1_des = d.new_instr1_in[27:24];
		d.ins_1_s1  = d.new_instr1_in[23:20];
		d.ins_1_s2  = d.new_instr1_in[19:16];
		d.ins_1_ime = 'd0;
	end
	else if (d.ins_1_op == 'b0100)		//load. one source
	begin
		d.ins_1_des = d.new_instr1_in[27:24];
		d.ins_1_s1  = d.new_instr1_in[23:20];
		d.ins_1_s2  = 'd0;
		d.ins_1_ime = d.new_instr1_in[15:11];
	end
	else 				//store or branch. no destination register
	begin
		d.ins_1_des = 'd0;
		d.ins_1_s1  = d.new_instr1_in[23:20];
		d.ins_1_s2  = d.new_instr1_in[19:16];
		d.ins_1_ime = d.new_instr1_in[15:11];
	end


end


always_comb
begin
	d.ins_2_op = d.new_instr2_in[31:28];
	if (d.ins_2_op == 'b1000)		//add
	begin
		d.ins_2_des = d.new_instr2_in[27:24];
		d.ins_2_s1  = d.new_instr2_in[23:20];
		d.ins_2_s2  = d.new_instr2_in[19:16];
		d.ins_2_ime = 'd0;
	end
	else if (d.ins_2_op == 'b0100)		//load. one source
	begin
		d.ins_2_des = d.new_instr2_in[27:24];
		d.ins_2_s1  = d.new_instr2_in[23:20];
		d.ins_2_s2  = 'd0;
		d.ins_2_ime = d.new_instr2_in[15:11];
	end
	else 				//store or branch. no destination register
	begin
		d.ins_2_des = 'd0;
		d.ins_2_s1  = d.new_instr2_in[23:20];
		d.ins_2_s2  = d.new_instr2_in[19:16];
		d.ins_2_ime = d.new_instr2_in[15:11];
	end


end



endmodule

