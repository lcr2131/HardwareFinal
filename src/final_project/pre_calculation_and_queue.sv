//Programmer:	Tong Zhang
//Date:		12/11/2012
//Purpose:	Connection of module instructionqueue, shift_amount, entry_select and new_ins_addr_calculation

module pre_calculation_and_queue #(parameter des = 'd4, source1 = 'd4, source2 = 'd4, immediate = 'd5,
				branch_id = 'd3, total_in = 4 + des + source1 + source2,
				total_out = total_in + branch_id + 'd1 + immediate )
(
	input clk,
	input rst,

	input ins_in_1,	
	input ins_in_2,	
	input ins_in_3,	
	input ins_in_4,

//	input ins_back_1,	
//	input ins_back_2,	
//	input ins_back_3,	
//	input ins_back_4,

	input ins_new_1_vld,
	input ins_new_2_vld,

	input	flush_en,
	input	[2:0]	flush_id,
//	input	ins_new_en,

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


	output	reg	entry_full,
	output	reg	entry_empty,
	output	reg	branch_full,

	output	reg			out_1_vld,
	output	reg	[des-1:0]	out_1_des,
	output	reg	[source1-1:0]	out_1_s1,
	output	reg	[source2-1:0]	out_1_s2,
	output	reg	[3:0]		out_1_op,
	output	reg	[branch_id-1:0]	out_1_branch,
	output	reg	[immediate-1:0]	out_1_ime,

	output	reg			out_2_vld,
	output	reg	[des-1:0]	out_2_des,
	output	reg	[source1-1:0]	out_2_s1,
	output	reg	[source2-1:0]	out_2_s2,
	output	reg	[3:0]		out_2_op,
	output	reg	[branch_id-1:0]	out_2_branch,
	output	reg	[immediate-1:0]	out_2_ime,

	output	reg			out_3_vld,
	output	reg	[des-1:0]	out_3_des,
	output	reg	[source1-1:0]	out_3_s1,
	output	reg	[source2-1:0]	out_3_s2,
	output	reg	[3:0]		out_3_op,
	output	reg	[branch_id-1:0]	out_3_branch,
	output	reg	[immediate-1:0]	out_3_ime,

	output	reg			out_4_vld,
	output	reg	[des-1:0]	out_4_des,
	output	reg	[source1-1:0]	out_4_s1,
	output	reg	[source2-1:0]	out_4_s2,
	output	reg	[3:0]		out_4_op,
	output	reg	[branch_id-1:0]	out_4_branch,
	output	reg	[immediate-1:0]	out_4_ime

);


	logic [2:0]	index_out_1;
	logic [2:0]	index_out_2;
	logic [2:0]	index_out_3;
	logic [2:0]	index_out_4;

	logic [2:0]	shift_entry1;
	logic [2:0]	shift_entry2;
	logic [2:0]	shift_entry3;
	logic [2:0]	shift_entry_rest;

	logic	[3:0] ins_new_1_addr;
	logic	[3:0] ins_new_2_addr;


entry_select	entry_select1
(
	.ins_in_1,		
	.ins_in_2,	 
	.ins_in_3,	
	.ins_in_4,	
	
	.index_out_1,
	.index_out_2,
	.index_out_3,
	.index_out_4
);


shift_amount	shift_amount1
(
	.ins_in_1,		
	.ins_in_2,	 
	.ins_in_3,	
	.ins_in_4,	

	.shift_entry1,	
	.shift_entry2,
	.shift_entry3,
	.shift_entry_rest
);

new_ins_addr_calculation	new_ins_addr_calculation1
(
	.clk,
	.rst,

	.ins_in_1,		
	.ins_in_2,	 
	.ins_in_3,	
	.ins_in_4,	

//	.ins_back_1,	
//	.ins_back_2,	
//	.ins_back_3,	
//	.ins_back_4,

	.ins_new_1_vld,
	.ins_new_2_vld,

	.ins_new_1_addr,
	.ins_new_2_addr
);

instruction_queue 	instruction_queue1
(
	.clk,
	.rst,
	
	.entry_in_1(index_out_1),
	.entry_in_2(index_out_2),
	.entry_in_3(index_out_3),
	.entry_in_4(index_out_4),
	
	.shift_entry1,
	.shift_entry2,
	.shift_entry3,
	.shift_entry_rest,	

//	.ins_new_en,
	.ins_new_1_vld,
	.ins_new_2_vld,
	.ins_new_1_addr,
	.ins_new_2_addr,

	.flush_en,
	.flush_id,

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
