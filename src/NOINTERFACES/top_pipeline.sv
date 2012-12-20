//Programmer:	Shuying Fan
//Date:		12/16/12
//Purpose:	Top module for the entire pipeline design.
//


module top_pipeline	#(parameter des = 'd4, source1 = 'd4, source2 = 'd4,immediate = 'd5,
				branch_id = 'd3, total_in = 4 + des + source1 + source2,
				total_out = total_in + branch_id + 'd1 + immediate, 
				reg_num = 'd16, register_width = 'd32)

(
	input clk,
	input rst,

	input [31:0] new_instr1_in,
	input [31:0] new_instr2_in,

	input	mem_in_done,
	input	[register_width-1:0]	load_data,

	input ins_new_1_vld,
	input ins_new_2_vld,

	output	reg	[register_width-1:0]	out_1_mem_addr,
	output	reg	[register_width-1:0]	out_1_mem_data,

	output	reg			out_load_flag,
	output	reg			out_store_flag,
	output reg [4:0]	pc

);

//internal inputs of stage1
	logic			flush_en;	//outputs of branch_ctrl
	logic	[2:0]		flush_id;	
	logic	[4:0]		flush_addr;

	logic	[reg_num-1:0]	flush_reg;	//output of buffer

	logic	ins_back_1_vld;			//outputs of write back, also used in register file
	logic	[des-1 : 0]	ins_back_1_des;
	logic	ins_back_2_vld;
	logic	[des-1 : 0]	ins_back_2_des;
	logic	ins_back_3_vld;
	logic	[des-1 : 0]	ins_back_3_des;
	logic	ins_back_4_vld;
	logic	[des-1 : 0]	ins_back_4_des;

//internal outputs of stage1

	logic	iq_full;
	logic	iq_empty;
	logic	branch_full;

	logic			iq_out_1_vld;
	logic	[des-1:0]	iq_out_1_des;
	logic	[source1-1:0]	iq_out_1_s1;
	logic	[source2-1:0]	iq_out_1_s2;
	logic	[3:0]		iq_out_1_op;
	logic	[branch_id-1:0]	iq_out_1_bid;
	logic	[immediate-1:0]	iq_out_1_ime;

	logic			iq_out_2_vld;
	logic	[des-1:0]	iq_out_2_des;
	logic	[source1-1:0]	iq_out_2_s1;
	logic	[source2-1:0]	iq_out_2_s2;
	logic	[3:0]		iq_out_2_op;
	logic	[branch_id-1:0]	iq_out_2_bid;
	logic	[immediate-1:0]	iq_out_2_ime;

	logic			iq_out_3_vld;
	logic	[des-1:0]	iq_out_3_des;
	logic	[source1-1:0]	iq_out_3_s1;
	logic	[source2-1:0]	iq_out_3_s2;
	logic	[3:0]		iq_out_3_op;
	logic	[branch_id-1:0]	iq_out_3_bid;
	logic	[immediate-1:0]	iq_out_3_ime;

	logic			iq_out_4_vld;
	logic	[des-1:0]	iq_out_4_des;
	logic	[source1-1:0]	iq_out_4_s1;
	logic	[source2-1:0]	iq_out_4_s2;
	logic	[3:0]		iq_out_4_op;
	logic	[branch_id-1:0]	iq_out_4_bid;
	logic	[immediate-1:0]	iq_out_4_ime;


//other internal inputs of register file
	logic	[register_width-1:0]	back_1_data;
	logic	[register_width-1:0]	back_2_data;
	logic	[register_width-1:0]	back_3_data;
	logic	[register_width-1:0]	back_4_data;


	logic			out_1_vld;
	logic	[des-1:0]	out_1_des;
	logic	[register_width-1:0]	out_1_s1_data;
	logic	[register_width-1:0]	out_1_s2_data;
	logic	[3:0]		out_1_op;
	logic	[branch_id-1:0]	out_1_branch;
	logic	[immediate-1:0]	out_1_ime;
	
	logic			out_2_vld;
	logic	[des-1:0]	out_2_des;
	logic	[register_width-1:0]	out_2_s1_data;
	logic	[register_width-1:0]	out_2_s2_data;
	logic	[3:0]		out_2_op;
	logic	[branch_id-1:0]	out_2_branch;
	logic	[immediate-1:0]	out_2_ime;

	logic			out_3_vld;
	logic	[des-1:0]	out_3_des;
	logic	[register_width-1:0]	out_3_s1_data;
	logic	[register_width-1:0]	out_3_s2_data;
	logic	[3:0]		out_3_op;
	logic	[branch_id-1:0]	out_3_branch;
	logic	[immediate-1:0]	out_3_ime;

	logic			out_4_vld;
	logic	[des-1:0]	out_4_des;
	logic	[register_width-1:0]	out_4_s1_data;
	logic	[register_width-1:0]	out_4_s2_data;
	logic	[3:0]		out_4_op;
	logic	[branch_id-1:0]	out_4_branch;
	logic	[immediate-1:0]	out_4_ime;

	logic	[3:0]			ins1_op;
	logic	[register_width-1:0]	ins1_data1;
	logic	[register_width-1:0]	ins1_data2;
	logic	[2:0]			ins1_bid;
	logic	[immediate-1:0]	ins1_addr;

	logic	[3:0]			ins2_op;
	logic	[register_width-1:0]	ins2_data1;
	logic	[register_width-1:0]	ins2_data2;
	logic	[2:0]			ins2_bid;
	logic	[immediate-1:0]	ins2_addr;


	logic	[3:0]			ins3_op;
	logic	[register_width-1:0]	ins3_data1;
	logic	[register_width-1:0]	ins3_data2;
	logic	[2:0]			ins3_bid;
	logic	[immediate-1:0]	ins3_addr;


	 logic	[3:0]			ins4_op;
	 logic	[register_width-1:0]	ins4_data1;
	 logic	[register_width-1:0]	ins4_data2;
	 logic	[2:0]			ins4_bid;
	 logic	[immediate-1:0]	ins4_addr;

	logic	buffer_flush_en;
	logic	[2:0]	buffer_flush_id;

	logic		buffer_full;
	logic		buffer_empty;


top_issue_stage stage1
(
	.clk,
	.rst,

	.new_instr1_in,
	.new_instr2_in,

	.ins_new_1_vld,
	.ins_new_2_vld,

	.flush_en,
	.flush_id,
	.flush_reg,
	
	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.iq_full,
	.iq_empty,
	.branch_full,

	.iq_out_1_vld,
	.iq_out_1_des,
	.iq_out_1_s1,
	.iq_out_1_s2,
	.iq_out_1_op,
	.iq_out_1_bid,
	.iq_out_1_ime,

	.iq_out_2_vld,
	.iq_out_2_des,
	.iq_out_2_s1,
	.iq_out_2_s2,
	.iq_out_2_op,
	.iq_out_2_bid,
	.iq_out_2_ime,

	.iq_out_3_vld,
	.iq_out_3_des,
	.iq_out_3_s1,
	.iq_out_3_s2,
	.iq_out_3_op,
	.iq_out_3_bid,
	.iq_out_3_ime,

	.iq_out_4_vld,
	.iq_out_4_des,
	.iq_out_4_s1,
	.iq_out_4_s2,
	.iq_out_4_op,
	.iq_out_4_bid,
	.iq_out_4_ime

);


register_file file1
(
	.rst,
	.clk,

	.in_1_vld(iq_out_1_vld),
	.in_1_des(iq_out_1_des),
	.in_1_s1(iq_out_1_s1),
	.in_1_s2(iq_out_1_s2),
	.in_1_op(iq_out_1_op),
	.in_1_branch(iq_out_1_bid),
	.in_1_ime(iq_out_1_ime),

	.in_2_vld(iq_out_2_vld),
	.in_2_des(iq_out_2_des),
	.in_2_s1(iq_out_2_s1),
	.in_2_s2(iq_out_2_s2),
	.in_2_op(iq_out_2_op),
	.in_2_branch(iq_out_2_bid),
	.in_2_ime(iq_out_2_ime),

	.in_3_vld(iq_out_3_vld),
	.in_3_des(iq_out_3_des),
	.in_3_s1(iq_out_3_s1),
	.in_3_s2(iq_out_3_s2),
	.in_3_op(iq_out_3_op),
	.in_3_branch(iq_out_3_bid),
	.in_3_ime(iq_out_3_ime),

	.in_4_vld(iq_out_4_vld),
	.in_4_des(iq_out_4_des),
	.in_4_s1(iq_out_4_s1),
	.in_4_s2(iq_out_4_s2),
	.in_4_op(iq_out_4_op),
	.in_4_branch(iq_out_4_bid),
	.in_4_ime(iq_out_4_ime),


	.back_1_vld(ins_back_1_vld),
	.back_2_vld(ins_back_2_vld),
	.back_3_vld(ins_back_3_vld),
	.back_4_vld(ins_back_4_vld),

	.back_1_des(ins_back_1_des),
	.back_2_des(ins_back_2_des),
	.back_3_des(ins_back_3_des),
	.back_4_des(ins_back_4_des),

	.back_1_data,
	.back_2_data,
	.back_3_data,
	.back_4_data,

	.out_1_vld,
	.out_1_des,
	.out_1_s1_data,
	.out_1_s2_data,
	.out_1_op,
	.out_1_branch,
	.out_1_ime,


	.out_2_vld,
	.out_2_des,
	.out_2_s1_data,
	.out_2_s2_data,
	.out_2_op,
	.out_2_branch,
	.out_2_ime,

	.out_3_vld,
	.out_3_des,
	.out_3_s1_data,
	.out_3_s2_data,
	.out_3_op,
	.out_3_branch,
	.out_3_ime,

	.out_4_vld,
	.out_4_des,
	.out_4_s1_data,
	.out_4_s2_data,
	.out_4_op,
	.out_4_branch,
	.out_4_ime,

	.ins1_op,	//outputs to the branch
	.ins1_data1,
	.ins1_data2,
	.ins1_bid,
	.ins1_addr,


	.ins2_op,	//outputs to the branch
	.ins2_data1,
	.ins2_data2,
	.ins2_bid,
	.ins2_addr,

	.ins3_op,	//outputs to the branch
	.ins3_data1,
	.ins3_data2,
	.ins3_bid,
	.ins3_addr,

	.ins4_op,	//outputs to the branch
	.ins4_data1,
	.ins4_data2,
	.ins4_bid,
	.ins4_addr

);






pc_ctrl pc1
(
	.clk,
	.rst,

	.vld_1(ins_new_1_vld),
	.vld_2(ins_new_2_vld),

	.iq_full,	//outputs of stage1
	.iq_empty,

	.buffer_full,	//outputs of buffer
	.buffer_empty,

	.bid_full(branch_full),	//output of stage1

	.flush(flush_en),	//output of branch_ctrl
	.addr(flush_addr),

	.pc

);

branch_ctrl bctrl
(


	.ins1_op,	
	.ins1_data1,
	.ins1_data2,
	.ins1_bid,
	.ins1_addr,


	.ins2_op,	
	.ins2_data1,
	.ins2_data2,
	.ins2_bid,
	.ins2_addr,

	.ins3_op,	
	.ins3_data1,
	.ins3_data2,
	.ins3_bid,
	.ins3_addr,

	.ins4_op,	
	.ins4_data1,
	.ins4_data2,
	.ins4_bid,
	.ins4_addr,

	
	.flush(flush_en),
	.bid(flush_id),
	.addr(flush_addr)

);



branch_delay bdelay
(

	.clk,
	.rst,

	.flush(flush_en),
	.bid(flush_id),

	.buffer_flush(buffer_flush_en),
	.buffer_bid(buffer_flush_id)
);

top_buffer_stage top_buffer_stage1
(
	.clk,
	.rst,

	.in_1_s1_data(out_1_s1_data),
	.in_1_s2_data(out_1_s2_data),
	.in_2_s1_data(out_2_s1_data),
	.in_2_s2_data(out_2_s2_data),
	.in_3_s1_data(out_3_s1_data),
	.in_3_s2_data(out_3_s2_data),
	.in_4_s1_data(out_4_s1_data),
	.in_4_s2_data(out_4_s2_data),

	.in_1_des(out_1_des),
	.in_2_des(out_2_des),
	.in_3_des(out_3_des),
	.in_4_des(out_4_des),

	.in_1_op(out_1_op),
	.in_2_op(out_2_op),
	.in_3_op(out_3_op),
	.in_4_op(out_4_op),

	.in_1_vld(out_1_vld),
	.in_2_vld(out_2_vld),
	.in_3_vld(out_3_vld),
	.in_4_vld(out_4_vld),

	.in_1_immediate(out_1_ime),

	.in_1_branch(out_1_branch),
	.in_2_branch(out_2_branch),
	.in_3_branch(out_3_branch),
	.in_4_branch(out_4_branch),

	.mem_in_done,
	.flush_en(buffer_flush_en),
	.flush_id(buffer_flush_id),

	.load_data,

	.out_1_des(ins_back_1_des),
	.out_2_des(ins_back_2_des),
	.out_3_des(ins_back_3_des),
	.out_4_des(ins_back_4_des),

	.out_1_data(back_1_data),
	.out_2_data(back_2_data),
	.out_3_data(back_3_data),
	.out_4_data(back_4_data),

	.out_1_vld(ins_back_1_vld),
	.out_2_vld(ins_back_2_vld),
	.out_3_vld(ins_back_3_vld),
	.out_4_vld(ins_back_4_vld),

	.out_1_mem_addr,
	.out_1_mem_data,

	.out_load_flag,
	.out_store_flag,

	.buffer_full,
	.buffer_empty,

	.reg_out_to_raw_history(flush_reg)
);






endmodule
