//Programmer:	Tong Zhang
//Date:		12/11/2012
//Purpose:	Connection of module instructionqueue, shift_amount, entry_select and new_ins_addr_calculation

module pre_calculation_and_queue(pre_calculation_and_queue_interface.pre_calculation_and_queue_dut d);


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
	.ins_in_1(d.ins_in_1),		
	.ins_in_2(d.ins_in_2),	 
	.ins_in_3(d.ins_in_3),	
	.ins_in_4(d.ins_in_4),	
	
	.index_out_1,
	.index_out_2,
	.index_out_3,
	.index_out_4
);


shift_amount	shift_amount1
(
	.ins_in_1(d.ins_in_1),		
	.ins_in_2(d.ins_in_2),	 
	.ins_in_3(d.ins_in_3),	
	.ins_in_4(d.ins_in_4),	

	.shift_entry1,	
	.shift_entry2,
	.shift_entry3,
	.shift_entry_rest
);

new_ins_addr_calculation	new_ins_addr_calculation1
(
	.clk(d.clk),
	.rst(d.rst),

	.ins_in_1(d.ins_in_1),		
	.ins_in_2(d.ins_in_2),	 
	.ins_in_3(d.ins_in_3),	
	.ins_in_4(d.ins_in_4),	

//	.ins_back_1,	
//	.ins_back_2,	
//	.ins_back_3,	
//	.ins_back_4,

	.ins_new_1_vld(d.ins_new_1_vld),
	.ins_new_2_vld(d.ins_new_2_vld),

	.ins_new_1_addr,
	.ins_new_2_addr
);

instruction_queue 	instruction_queue1
(
	.clk(d.clk),
	.rst(d.rst),
	
	.entry_in_1(index_out_1),
	.entry_in_2(index_out_2),
	.entry_in_3(index_out_3),
	.entry_in_4(index_out_4),
	
	.shift_entry1,
	.shift_entry2,
	.shift_entry3,
	.shift_entry_rest,	

//	.ins_new_en,
	.ins_new_1_vld(d.ins_new_1_vld),
	.ins_new_2_vld(d.ins_new_2_vld),
	.ins_new_1_addr,
	.ins_new_2_addr,

	.flush_en(d.flush_en),
	.flush_id(d.flush_id),

	.ins_1_des(d.ins_1_des),
	.ins_1_s1(d.ins_1_s1),
	.ins_1_s2(d.ins_1_s2),
	.ins_1_op(d.ins_1_op),
	.ins_1_ime(d.ins_1_ime),

	.ins_2_des(d.ins_2_des),
	.ins_2_s1(d.ins_2_s1),
	.ins_2_s2(d.ins_2_s2),
	.ins_2_op(d.ins_2_op),
	.ins_2_ime(d.ins_2_ime),

	.entry_full(d.entry_full),
	.entry_empty(d.entry_empty),
	.branch_full(d.branch_full),

	.out_1_vld(d.out_1_vld),
	.out_1_des(d.out_1_des),
	.out_1_s1(d.out_1_s1),
	.out_1_s2(d.out_1_s2),
	.out_1_op(d.out_1_op),
	.out_1_branch(d.out_1_branch),
	.out_1_ime(d.out_1_ime),

	.out_2_vld(d.out_2_vld),
	.out_2_des(d.out_2_des),
	.out_2_s1(d.out_2_s1),
	.out_2_s2(d.out_2_s2),
	.out_2_op(d.out_2_op),
	.out_2_branch(d.out_2_branch),
	.out_2_ime(d.out_2_ime),

	.out_3_vld(d.out_3_vld),
	.out_3_des(d.out_3_des),
	.out_3_s1(d.out_3_s1),
	.out_3_s2(d.out_3_s2),
	.out_3_op(d.out_3_op),
	.out_3_branch(d.out_3_branch),
	.out_3_ime(d.out_3_ime),

	.out_4_vld(d.out_4_vld),
	.out_4_des(d.out_4_des),
	.out_4_s1(d.out_4_s1),
	.out_4_s2(d.out_4_s2),
	.out_4_op(d.out_4_op),
	.out_4_branch(d.out_4_branch),
	.out_4_ime(d.out_4_ime)

);





endmodule
