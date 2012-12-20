//Programmer:	Tong Zhang
//Date:		12/15/2012
//Purpose:	Connecting alu_and_buffer, entry_select, shift_amount and buffer_new_addr_calculation

module top_buffer_stage #(parameter des = 'd4, source1 = 'd4, source2 = 'd4, immediate = 'd5,
				branch_id = 'd3, total_in = 4 + des + source1 + source2,
				total_out = total_in + branch_id + 'd1 + immediate, 
				reg_num = 'd16, register_width = 'd32, op = 'd4)
(
	input	clk,
	input	rst,

	input	[register_width-1:0]	in_1_s1_data,
	input	[register_width-1:0]	in_1_s2_data,
	input	[register_width-1:0]	in_2_s1_data,
	input	[register_width-1:0]	in_2_s2_data,
	input	[register_width-1:0]	in_3_s1_data,
	input	[register_width-1:0]	in_3_s2_data,
	input	[register_width-1:0]	in_4_s1_data,
	input	[register_width-1:0]	in_4_s2_data,

	input		[des-1:0]	in_1_des,
	input		[des-1:0]	in_2_des,
	input		[des-1:0]	in_3_des,
	input		[des-1:0]	in_4_des,

//	input		[2:0]		out_addr_1,
//	input		[2:0]		out_addr_2,
//	input		[2:0]		out_addr_3,
//	input		[2:0]		out_addr_4,

//	input		[4:0]		in_addr_1,
//	input		[4:0]		in_addr_2,
//	input		[4:0]		in_addr_3,
//	input		[4:0]		in_addr_4,

	input		[op-1:0]	in_1_op,
	input		[op-1:0]	in_2_op,
	input		[op-1:0]	in_3_op,
	input		[op-1:0]	in_4_op,

	input				in_1_vld,
	input				in_2_vld,
	input				in_3_vld,
	input				in_4_vld,

//	input		[2:0]		shift_amount_1,
//	input		[2:0]		shift_amount_2,
//	input		[2:0]		shift_amount_3,
//	input		[2:0]		shift_amount_rest,

	input		[immediate-1:0]	in_1_immediate,

	input		[branch_id-1:0]	in_1_branch,
	input		[branch_id-1:0]	in_2_branch,
	input		[branch_id-1:0]	in_3_branch,
	input		[branch_id-1:0]	in_4_branch,

	input				mem_in_done,
	input				flush_en,
	input		[2:0]		flush_id,

	input	[register_width-1:0]	load_data,

	output	reg	[des-1:0]	out_1_des,
	output	reg	[des-1:0]	out_2_des,
	output	reg	[des-1:0]	out_3_des,
	output	reg	[des-1:0]	out_4_des,

	output	reg [register_width-1:0]	out_1_data,
	output	reg [register_width-1:0]	out_2_data,
	output	reg [register_width-1:0]	out_3_data,
	output	reg [register_width-1:0]	out_4_data,
	
	output	reg			out_1_vld,
	output	reg			out_2_vld,
	output	reg			out_3_vld,
	output	reg			out_4_vld,

	output	reg	[register_width-1:0]	out_1_mem_addr,
	output	reg	[register_width-1:0]	out_1_mem_data,

	output	reg			out_load_flag,
	output	reg			out_store_flag,

	output	reg			buffer_full,
	output	reg			buffer_empty,

	output reg	[reg_num-1:0]	reg_out_to_raw_history
);

//	logic   ins_back_1;	
//	logic   ins_back_2;	
//	logic   ins_back_3;	
//	logic   ins_back_4;

	logic [2:0]	index_out_1;
	logic [2:0]	index_out_2;
	logic [2:0]	index_out_3;
	logic [2:0]	index_out_4;

	logic [2:0]	shift_amount_1;
	logic [2:0]	shift_amount_2;
	logic [2:0]	shift_amount_3;
	logic [2:0]	shift_amount_rest;

	logic	[4:0] ins_new_1_addr;
	logic	[4:0] ins_new_2_addr;
	logic	[4:0] ins_new_3_addr;
	logic	[4:0] ins_new_4_addr;


entry_select	entry_select_buffer
(
	.ins_in_1(out_1_vld),		
	.ins_in_2(out_2_vld),	 
	.ins_in_3(out_3_vld),	
	.ins_in_4(out_4_vld),	
	
	.index_out_1,
	.index_out_2,
	.index_out_3,
	.index_out_4
);

shift_amount	shift_amount_buffer
(
	.ins_in_1(out_1_vld),		
	.ins_in_2(out_2_vld),	 
	.ins_in_3(out_3_vld),	
	.ins_in_4(out_4_vld),	

	.shift_entry1(shift_amount_1),	
	.shift_entry2(shift_amount_2),
	.shift_entry3(shift_amount_3),
	.shift_entry_rest(shift_amount_rest)
);


buffer_ins_addr_calculation	buffer_ins_addr_calculation1
(
	.clk,
	.rst,

	.ins_in_1(out_1_vld),		
	.ins_in_2(out_2_vld),	 
	.ins_in_3(out_3_vld),	
	.ins_in_4(out_4_vld),	

	.ins_new_1_vld(in_1_vld),
	.ins_new_2_vld(in_2_vld),
	.ins_new_3_vld(in_3_vld),
	.ins_new_4_vld(in_4_vld),

	.ins_new_1_addr,
	.ins_new_2_addr,
	.ins_new_3_addr,
	.ins_new_4_addr
);

alu_and_buffer	alu_and_buffer1
(
	.clk,
	.rst,

	.in_1_s1_data,
	.in_1_s2_data,
	.in_2_s1_data,
	.in_2_s2_data,
	.in_3_s1_data,
	.in_3_s2_data,
	.in_4_s1_data,
	.in_4_s2_data,

	.in_1_des,
	.in_2_des,
	.in_3_des,
	.in_4_des,

	.out_addr_1(index_out_1),
	.out_addr_2(index_out_2),
	.out_addr_3(index_out_3),
	.out_addr_4(index_out_4),

	.in_addr_1(ins_new_1_addr),
	.in_addr_2(ins_new_2_addr),
	.in_addr_3(ins_new_3_addr),
	.in_addr_4(ins_new_4_addr),

	.in_1_op,
	.in_2_op,
	.in_3_op,
	.in_4_op,

	.in_1_vld,
	.in_2_vld,
	.in_3_vld,
	.in_4_vld,

	.shift_amount_1,
	.shift_amount_2,
	.shift_amount_3,
	.shift_amount_rest,

	.in_1_immediate,

	.in_1_branch,
	.in_2_branch,
	.in_3_branch,
	.in_4_branch,

	.mem_in_done,
	.flush_en,
	.flush_id,
	.load_data,
	
	.out_1_des,
	.out_2_des,
	.out_3_des,
	.out_4_des,

	.out_1_data,
	.out_2_data,
	.out_3_data,
	.out_4_data,
	
	.out_1_vld,
	.out_2_vld,
	.out_3_vld,
	.out_4_vld,

	.out_1_mem_addr,
	.out_1_mem_data,

	.out_load_flag,
	.out_store_flag,

	.buffer_full,
	.buffer_empty,

	.reg_out_to_raw_history
);





endmodule
