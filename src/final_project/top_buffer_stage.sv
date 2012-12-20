//Programmer:	Tong Zhang
//Date:		12/15/2012
//Purpose:	Connecting alu_and_buffer, entry_select, shift_amount and buffer_new_addr_calculation

module top_buffer_stage(top_buffer_stage_interface.top_buffer_stage_dut d); #(parameter des = 'd4, source1 = 'd4, source2 = 'd4, immediate = 'd5,
				branch_id = 'd3, total_in = 4 + des + source1 + source2,
				total_out = total_in + branch_id + 'd1 + immediate, 
				reg_num = 'd16, register_width = 'd32, op = 'd4)




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
	.ins_in_1(d.out_1_vld),		
	.ins_in_2(d.out_2_vld),	 
	.ins_in_3(d.out_3_vld),	
	.ins_in_4(d.out_4_vld),	
	
	.index_out_1,
	.index_out_2,
	.index_out_3,
	.index_out_4
);

shift_amount	shift_amount_buffer
(
	.ins_in_1(d.out_1_vld),		
	.ins_in_2(d.out_2_vld),	 
	.ins_in_3(d.out_3_vld),	
	.ins_in_4(d.out_4_vld),	

	.shift_entry1(shift_amount_1),	
	.shift_entry2(shift_amount_2),
	.shift_entry3(shift_amount_3),
	.shift_entry_rest(shift_amount_rest)
);


buffer_ins_addr_calculation	buffer_ins_addr_calculation1
(
	.clk(d.clk),
	.rst(d.rst),

	.ins_in_1(d.out_1_vld),		
	.ins_in_2(d.out_2_vld),	 
	.ins_in_3(d.out_3_vld),	
	.ins_in_4(d.out_4_vld),	

	.ins_new_1_vld(d.in_1_vld),
	.ins_new_2_vld(d.in_2_vld),
	.ins_new_3_vld(d.in_3_vld),
	.ins_new_4_vld(d.in_4_vld),

	.ins_new_1_addr,
	.ins_new_2_addr,
	.ins_new_3_addr,
	.ins_new_4_addr
);

alu_and_buffer	alu_and_buffer1
(
	.clk(d.clk),
	.rst(d.rst),

	.in_1_s1_data(d.in_1_s1_data),
	.in_1_s2_data(d.in_1_s2_data),
	.in_2_s1_data(d.in_2_s1_data),
	.in_2_s2_data(d.in_2_s2_data),
	.in_3_s1_data(d.in_3_s1_data),
	.in_3_s2_data(d.in_3_s2_data),
	.in_4_s1_data(d.in_4_s1_data),
	.in_4_s2_data(d.in_4_s2_data),

	.in_1_des(d.in_1_des),
	.in_2_des(d.in_2_des),
	.in_3_des(d.in_3_des),
	.in_4_des(d.in_4_des),

	.out_addr_1(index_out_1),
	.out_addr_2(index_out_2),
	.out_addr_3(index_out_3),
	.out_addr_4(index_out_4),

	.in_addr_1(ins_new_1_addr),
	.in_addr_2(ins_new_2_addr),
	.in_addr_3(ins_new_3_addr),
	.in_addr_4(ins_new_4_addr),

	.in_1_op(d.in_1_op),
	.in_2_op(d.in_2_op),
	.in_3_op(d.in_3_op),
	.in_4_op(d.in_4_op),

	.in_1_vld(d.in_1_vld),
	.in_2_vld(d.in_2_vld),
	.in_3_vld(d.in_3_vld),
	.in_4_vld(d.in_4_vld),

	.shift_amount_1,
	.shift_amount_2,
	.shift_amount_3,
	.shift_amount_rest,

	.in_1_immediate(d.in_1_immediate),

	.in_1_branch(d.in_1_branch),
	.in_2_branch(d.in_2_branch),
	.in_3_branch(d.in_3_branch),
	.in_4_branch(d.in_4_branch),

	.mem_in_done(d.mem_in_done),
	.flush_en(d.flush_en),
	.flush_id(d.flush_id),

	
	.out_1_des(d.out_1_des),
	.out_2_des(d.out_2_des),
	.out_3_des(d.out_3_des),
	.out_4_des(d.out_4_des),

	.out_1_data(d.out_1_data),
	.out_2_data(d.out_2_data),
	.out_3_data(d.out_3_data),
	.out_4_data(d.out_4_data),
	
	.out_1_vld(d.out_1_vld),
	.out_2_vld(d.out_2_vld),
	.out_3_vld(d.out_3_vld),
	.out_4_vld(d.out_4_vld),

	.out_1_mem_addr(d.out_1_mem_addr),

	.out_load_flag(d.out_load_flag),
	.out_store_flag(d.out_store_flag),

	.buffer_full(d.buffer_full),
	.buffer_empty(d.buffer_empty),

	.reg_out_to_raw_history(d.reg_out_to_raw_history)
	.load_data(d.load_data)
);





endmodule
