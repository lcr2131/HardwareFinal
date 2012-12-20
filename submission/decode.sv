//Programmer:	Shuying Fan
//Date:		12/14/21012
//Purpose:	For new instructions decoding

module decode
(
	input	[31:0]	new_instr1_in,
	input	[31:0]	new_instr2_in,

	output	logic	[3:0]	ins_1_op,
	output	logic	[3:0]	ins_1_des,
	output	logic	[3:0]	ins_1_s1,
	output	logic	[3:0]	ins_1_s2,
	output	logic	[4:0]	ins_1_ime,

	output	logic	[3:0]	ins_2_op,
	output	logic	[3:0]	ins_2_des,
	output	logic	[3:0]	ins_2_s1,
	output	logic	[3:0]	ins_2_s2,
	output	logic	[4:0]	ins_2_ime
	
);

always_comb
begin
	if (new_instr1_in[31:26] == 'b000000)
		ins_1_op = 'b1000;
	else if (new_instr1_in[31:26] == 'b100011)
		ins_1_op = 'b0100;
	else if (new_instr1_in[31:26] == 'b101011)
		ins_1_op = 'b0010;
	else
		ins_1_op = 'b0001;
end


always_comb
begin
//	ins_1_op = new_instr1_in[31:26];
	if (ins_1_op == 'b1000)		//add
	begin
		ins_1_des = new_instr1_in[25:22];
		ins_1_s1  = new_instr1_in[21:18];
		ins_1_s2  = new_instr1_in[17:14];
		ins_1_ime = 'd0;
	end
	else if (ins_1_op == 'b0100)		//load. one source
	begin
		ins_1_des = new_instr1_in[25:22];
		ins_1_s1  = new_instr1_in[21:18];
		ins_1_s2  = 'd0;
		ins_1_ime = new_instr1_in[13:9];
	end
	else 				//store or branch. no destination register
	begin
		ins_1_des = 'd0;
		ins_1_s1  = new_instr1_in[21:18];
		ins_1_s2  = new_instr1_in[17:14];
		ins_1_ime = new_instr1_in[13:9];
	end
end



always_comb
begin
	if (new_instr2_in[31:26] == 'b000000)
		ins_2_op = 'b1000;
	else if (new_instr2_in[31:26] == 'b100011)
		ins_2_op = 'b0100;
	else if (new_instr2_in[31:26] == 'b101011)
		ins_2_op = 'b0010;
	else
		ins_2_op = 'b0001;
end


always_comb
begin
//	ins_2_op = new_instr2_in[31:26];
	if (ins_2_op == 'b1000)		//add
	begin
		ins_2_des = new_instr2_in[25:22];
		ins_2_s1  = new_instr2_in[21:18];
		ins_2_s2  = new_instr2_in[17:14];
		ins_2_ime = 'd0;
	end
	else if (ins_2_op == 'b0100)		//load. one source
	begin
		ins_2_des = new_instr2_in[25:22];
		ins_2_s1  = new_instr2_in[21:18];
		ins_2_s2  = 'd0;
		ins_2_ime = new_instr2_in[13:9];
	end
	else 				//store or branch. no destination register
	begin
		ins_2_des = 'd0;
		ins_2_s1  = new_instr2_in[21:18];
		ins_2_s2  = new_instr2_in[17:14];
		ins_2_ime = new_instr2_in[13:9];
	end
end



endmodule

