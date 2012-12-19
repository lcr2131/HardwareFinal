///////////////////////////////////////////////////////////////////////////////////////////////////
//	Programmer:	Tong Zhang								//
//	Modification Date:	12/12/2012							//
//	Module function:	connect all four checkers together				//
//												//
//////////////////////////////////////////////////////////////////////////////////////////////////


module all_checker( all_checker_interface.all_checker_dut d);

	logic	ins1_raw_his_out;
	logic	ins2_raw_his_out;
	logic	ins3_raw_his_out;
	logic	ins4_raw_his_out;

	logic	ins1_load_out;
	logic	ins2_load_out;
	logic	ins3_load_out;
	logic	ins4_load_out;

	logic	ins1_raw_war_out;
	logic	ins2_raw_war_out;
	logic	ins3_raw_war_out;
	logic	ins4_raw_war_out;



raw_history_check	#(4,4,4,16)	raw_history
(
	.clk(d.clk),
	.rst(d.rst),

	.flush_en(d.flush_en),
	.flush_reg(d.flush_reg),

	.ins_in_1_vld(d.ins_in_1_vld),
	.ins_in_1_des(d.ins_in_1_des),
	.ins_in_1_source1(d.ins_in_1_source1),
	.ins_in_1_source2(d.ins_in_1_source2),

	.ins_in_2_vld(d.ins_in_2_vld),
	.ins_in_2_des(d.ins_in_2_des),
        .ins_in_2_source1(d.ins_in_2_source1),
	.ins_in_2_source2(d.ins_in_2_source2),

	.ins_in_3_vld(d.ins_in_3_vld),
	.ins_in_3_des(d.ins_in_3_des),
	.ins_in_3_source1(d.ins_in_3_source1),
	.ins_in_3_source2(d.ins_in_3_source2),

	.ins_in_4_vld(d.ins_in_4_vld),
	.ins_in_4_des(d.ins_in_4_des),
	.ins_in_4_source1(d.ins_in_4_source1),
	.ins_in_4_source2(d.ins_in_4_source2),

	.ins_final_1_vld(d.ins_final_1_vld),
	.ins_final_2_vld(d.ins_final_2_vld),
	.ins_final_3_vld(d.ins_final_3_vld),
	.ins_final_4_vld(d.ins_final_4_vld),

	.ins_back_1_vld(d.ins_back_1_vld),
	.ins_back_1_des(d.ins_back_1_des),
	.ins_back_2_vld(d.ins_back_2_vld),
	.ins_back_2_des(d.ins_back_2_des),
	.ins_back_3_vld(d.ins_back_3_vld),
	.ins_back_3_des(d.ins_back_3_des),
	.ins_back_4_vld(d.ins_back_4_vld),
	.ins_back_4_des(d.ins_back_4_des),

	.ins_out_1_vld(ins1_raw_his_out),
	.ins_out_2_vld(ins2_raw_his_out),
	.ins_out_3_vld(ins3_raw_his_out),
	.ins_out_4_vld(ins4_raw_his_out)	
);

load_store_check	load_store
(
	.op1(d.op1),
	.op2(d.op2),
	.op3(d.op3),
	.op4(d.op4),

	.ins1_history(ins1_raw_his_out),
	.ins2_history(ins2_raw_his_out),
	.ins3_history(ins3_raw_his_out),
	.ins4_history(ins4_raw_his_out),

	.ins1_out(ins1_load_out),
	.ins2_out(ins2_load_out),
	.ins3_out(ins3_load_out),
	.ins4_out(ins4_load_out),

	.ins1_swap(d.ins1_swap),
	.ins2_swap(d.ins2_swap),
	.ins3_swap(d.ins3_swap),
	.ins4_swap(d.ins4_swap)
);

raw_war_checker #(4,4,4)	raw_war
(
	.des1(d.ins_in_1_des),
	.des2(d.ins_in_2_des),
	.des3(d.ins_in_3_des),
	.des4(d.ins_in_4_des),
	.s11(d.ins_in_1_source1),
	.s12(d.ins_in_1_source2),
	.s21(d.ins_in_2_source1),
	.s22(d.ins_in_2_source2),
	.s31(d.ins_in_3_source1),
	.s32(d.ins_in_3_source2),
	.s41(d.ins_in_4_source1),
	.s42(d.ins_in_4_source2),

	.ins1_in_vld(ins1_load_out),
	.ins2_in_vld(ins2_load_out),
	.ins3_in_vld(ins3_load_out),
	.ins4_in_vld(ins4_load_out),

	.ins_flag_1(ins1_raw_war_out),
	.ins_flag_2(ins2_raw_war_out),
	.ins_flag_3(ins3_raw_war_out),
	.ins_flag_4(ins4_raw_war_out)
);


branch_check		branch
(
	.op1(d.op1),
	.op2(d.op2),
	.op3(d.op3),
	.op4(d.op4),

	.ins1_in_vld(ins1_raw_war_out),
	.ins2_in_vld(ins2_raw_war_out),
	.ins3_in_vld(ins3_raw_war_out),
	.ins4_in_vld(ins4_raw_war_out),

	.ins1_out(d.ins1_out),
	.ins2_out(d.ins2_out),
	.ins3_out(d.ins3_out),
	.ins4_out(d.ins4_out)
);



endmodule
