//Programmer:	Tong Zhang
//Date:		12/11/2012
//Purpose:	Top module for stage 1, connecting pre_calculation_and_queue, all_checker and ins_swap


module top_issue_stage #(parameter des = 'd4, source1 = 'd4, source2 = 'd4, immediate = 'd4,
				branch_id = 'd3, total_in = 4 + des + source1 + source2,
				total_out = total_in + branch_id + 'd1 + immediate, 
				reg_num = 'd16)
(
	input clk,
	input rst,

	input ins_back_1,	
	input ins_back_2,	
	input ins_back_3,	
	input ins_back_4,
	input	[des-1 : 0]	ins_back_1_des,
	input	[des-1 : 0]	ins_back_2_des,
	input	[des-1 : 0]	ins_back_3_des,
	input	[des-1 : 0]	ins_back_4_des,

	input ins_new_1_vld,
	input ins_new_2_vld,

	input	flush_en,
	input	[2:0]	flush_id,
	input	ins_new_en,
	input	[reg_num-1:0]	flush_reg,

	input	[des-1:0]	ins_1_des,
	input	[source1-1:0]	ins_1_s1,
	input	[source2-1:0]	ins_1_s2,
	input	[3:0]		ins_1_op,
	input	[immediate-1:0]	ins_1_ime,

	input	[des-1:0]	ins_2_des,
	input	[source1-1:0]	ins_2_s1,
	input	[source2-1:0]	ins_2_s2,
	input	[3:0]		ins_2_op,
	input	[immediate-1:0]	ins_2_ime,

	output	logic	entry_full,
	output	logic	entry_empty,
	output	logic	branch_full,

	output	logic			out_1_vld,
	output	logic	[des-1:0]	out_1_des,
	output	logic	[source1-1:0]	out_1_s1,
	output	logic	[source2-1:0]	out_1_s2,
	output	logic	[3:0]		out_1_op,
	output	logic	[branch_id-1:0]	out_1_branch,
	output	logic	[immediate-1:0]	out_1_ime,

	output	logic			out_2_vld,
	output	logic	[des-1:0]	out_2_des,
	output	logic	[source1-1:0]	out_2_s1,
	output	logic	[source2-1:0]	out_2_s2,
	output	logic	[3:0]		out_2_op,
	output	logic	[branch_id-1:0]	out_2_branch,
	output	logic	[immediate-1:0]	out_2_ime,

	output	logic			out_3_vld,
	output	logic	[des-1:0]	out_3_des,
	output	logic	[source1-1:0]	out_3_s1,
	output	logic	[source2-1:0]	out_3_s2,
	output	logic	[3:0]		out_3_op,
	output	logic	[branch_id-1:0]	out_3_branch,
	output	logic	[immediate-1:0]	out_3_ime,

	output	logic			out_4_vld,
	output	logic	[des-1:0]	out_4_des,
	output	logic	[source1-1:0]	out_4_s1,
	output	logic	[source2-1:0]	out_4_s2,
	output	logic	[3:0]		out_4_op,
	output	logic	[branch_id-1:0]	out_4_branch,
	output	logic	[immediate-1:0]	out_4_ime

);

	logic ins_in_1;
	logic ins_in_2;	
	logic ins_in_3;	
	logic ins_in_4;

	logic				in_1_vld;
	logic		[des-1:0]	in_1_des;
	logic		[source1-1:0]	in_1_s1;
	logic		[source2-1:0]	in_1_s2;
	logic		[3:0]		in_1_op;
	logic		[branch_id-1:0]	in_1_branch;
	logic		[immediate-1:0]	in_1_ime;

	logic				in_2_vld;
	logic		[des-1:0]	in_2_des;
	logic		[source1-1:0]	in_2_s1;
	logic		[source2-1:0]	in_2_s2;
	logic		[3:0]		in_2_op;
	logic		[branch_id-1:0]	in_2_branch;
	logic		[immediate-1:0]	in_2_ime;

	logic				in_3_vld;
	logic		[des-1:0]	in_3_des;
	logic		[source1-1:0]	in_3_s1;
	logic		[source2-1:0]	in_3_s2;
	logic		[3:0]		in_3_op;
	logic		[branch_id-1:0]	in_3_branch;
	logic		[immediate-1:0]	in_3_ime;

	logic				in_4_vld;
	logic		[des-1:0]	in_4_des;
	logic		[source1-1:0]	in_4_s1;
	logic		[source2-1:0]	in_4_s2;
	logic		[3:0]		in_4_op;
	logic		[branch_id-1:0]	in_4_branch;
	logic		[immediate-1:0]	in_4_ime;

	logic 	ins1_swap;
	logic	ins2_swap;
	logic	ins3_swap;
	logic	ins4_swap;



pre_calculation_and_queue	pre_calculation_and_queue1
(
	.clk,
	.rst,

	.ins_in_1,	
	.ins_in_2,	
	.ins_in_3,	
	.ins_in_4,

	.ins_back_1,	
	.ins_back_2,	
	.ins_back_3,	
	.ins_back_4,

	.ins_new_1_vld,
	.ins_new_2_vld,

	.flush_en,
	.flush_id,
	.ins_new_en,

	.ins_1_des,
	.ins_1_s1,
	.ins_1_s2,
	.ins_1_op,
	.ins_1_ime,

	.ins_2_des,
	.ins_2_s1,
	.ins_2_s2,
	.ins_2_op,
	.ins_2_ime,

	.entry_full,
	.entry_empty,
	.branch_full,

	.out_1_vld(in_1_vld),
	.out_1_des(in_1_des),
	.out_1_s1(in_1_s1),
	.out_1_s2(in_1_s2),
	.out_1_op(in_1_op),
	.out_1_branch(in_1_branch),
	.out_1_ime(in_1_ime),

	.out_2_vld(in_2_vld),
	.out_2_des(in_2_des),
	.out_2_s1(in_2_s1),
	.out_2_s2(in_2_s2),
	.out_2_op(in_2_op),
	.out_2_branch(in_2_branch),
	.out_2_ime(in_2_ime),

	.out_3_vld(in_3_vld),
	.out_3_des(in_3_des),
	.out_3_s1(in_3_s1),
	.out_3_s2(in_3_s2),
	.out_3_op(in_3_op),
	.out_3_branch(in_3_branch),
	.out_3_ime(in_3_ime),

	.out_4_vld(in_4_vld),
	.out_4_des(in_4_des),
	.out_4_s1(in_4_s1),
	.out_4_s2(in_4_s2),
	.out_4_op(in_4_op),
	.out_4_branch(in_4_branch),
	.out_4_ime(in_4_ime)

);

all_checker	all_checker1
(
	.clk,
	.rst,

	.flush_en,
	.flush_reg,

	.ins_in_1_vld(in_1_vld),
	.ins_in_1_des(in_1_des),
	.ins_in_1_source1(in_1_s1),
	.ins_in_1_source2(in_1_s2),
	.op1(in_1_op),

	.ins_in_2_vld(in_2_vld),
	.ins_in_2_des(in_2_des),
	.ins_in_2_source1(in_2_s1),
	.ins_in_2_source2(in_2_s2),
	.op2(in_2_op),

	.ins_in_3_vld(in_3_vld),
	.ins_in_3_des(in_3_des),
	.ins_in_3_source1(in_3_s1),
	.ins_in_3_source2(in_3_s2),
	.op3(in_3_op),

	.ins_in_4_vld(in_4_vld),
	.ins_in_4_des(in_4_des),
	.ins_in_4_source1(in_4_s1),
	.ins_in_4_source2(in_4_s2),
	.op4(in_4_op),

	.ins_final_1_vld(ins_in_1),
	.ins_final_2_vld(ins_in_2),
	.ins_final_3_vld(ins_in_3),
	.ins_final_4_vld(ins_in_4),

	.ins_back_1_vld(ins_back_1),
	.ins_back_1_des,
	.ins_back_2_vld(ins_back_2),
	.ins_back_2_des,
	.ins_back_3_vld(ins_back_3),
	.ins_back_3_des,
	.ins_back_4_vld(ins_back_4),
	.ins_back_4_des,

	.ins1_swap,
	.ins2_swap,
	.ins3_swap,
	.ins4_swap,

	.ins1_out(ins_in_1),
	.ins2_out(ins_in_2),
	.ins3_out(ins_in_3),
	.ins4_out(ins_in_4)
);

ins_swap	ins_swap1
(
	.ins1_swap,
	.ins2_swap,
	.ins3_swap,
	.ins4_swap,

	.in_1_vld,
	.in_1_des,
	.in_1_s1,
	.in_1_s2,
	.in_1_op,
	.in_1_branch,
	.in_1_ime,

	.in_2_vld,
	.in_2_des,
	.in_2_s1,
	.in_2_s2,
	.in_2_op,
	.in_2_branch,
	.in_2_ime,

	.in_3_vld,
	.in_3_des,
	.in_3_s1,
	.in_3_s2,
	.in_3_op,
	.in_3_branch,
	.in_3_ime,

	.in_4_vld,
	.in_4_des,
	.in_4_s1,
	.in_4_s2,
	.in_4_op,
	.in_4_branch,
	.in_4_ime,

	.out_1_vld,
	.out_1_des,
	.out_1_s1,
	.out_1_s2,
	.out_1_op,
	.out_1_branch,
	.out_1_ime,

	.out_2_vld,
	.out_2_des,
	.out_2_s1,
	.out_2_s2,
	.out_2_op,
	.out_2_branch,
	.out_2_ime,

	.out_3_vld,
	.out_3_des,
	.out_3_s1,
	.out_3_s2,
	.out_3_op,
	.out_3_branch,
	.out_3_ime,

	.out_4_vld,
	.out_4_des,
	.out_4_s1,
	.out_4_s2,
	.out_4_op,
	.out_4_branch,
	.out_4_ime

);





endmodule
