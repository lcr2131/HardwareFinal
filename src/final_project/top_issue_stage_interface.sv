interface top_issue_stage_interface(input bit clk);

	//des = 'd4; source1 = 'd4; source2 = 'd4; immediate = 'd4;
		//		branch_id = 'd3; total_in = 4 + des + source1 + source2;
		//		total_out = total_in + branch_id + 'd1 + immediate; 
		//		reg_num = 'd16
	
	logic		rst;

	logic		ins_back_1;	
	logic		ins_back_2;	
	logic 		ins_back_3;	
	logic 		ins_back_4;
	logic	[3:0]	ins_back_1_des;
	logic	[3:0]	ins_back_2_des;
	logic	[3:0]	ins_back_3_des;
	logic	[3:0]	ins_back_4_des;

	logic 		ins_new_1_vld;
	logic 		ins_new_2_vld;

	logic		flush_en;
	logic	[2:0]	flush_id;
	logic		ins_new_en;
	logic	[15:0]	flush_reg;

	logic	[3:0]	ins_1_des;
	logic	[3:0]	ins_1_s1;
	logic	[3:0]	ins_1_s2;
	logic	[3:0]	ins_1_op;
	logic	[3:0]	ins_1_ime;

	logic	[3:0]	ins_2_des;
	logic	[3:0]	ins_2_s1;
	logic	[3:0]	ins_2_s2;
	logic	[3:0]	ins_2_op;
	logic	[3:0]	ins_2_ime;

	logic		entry_full;
	logic		entry_empty;
	logic		branch_full;

	logic		out_1_vld;
	logic	[3:0]	out_1_des;
	logic	[3:0]	out_1_s1;
	logic	[3:0]	out_1_s2;
	logic	[3:0]	out_1_op;
	logic	[2:0]	out_1_branch;
	logic	[3:0]	out_1_ime;

	logic		out_2_vld;
	logic	[3:0]	out_2_des;
	logic	[3:0]	out_2_s1;
	logic	[3:0]	out_2_s2;
	logic	[3:0]	out_2_op;
	logic	[2:0]	out_2_branch;
	logic	[3:0]	out_2_ime;

	logic		out_3_vld;
	logic	[3:0]	out_3_des;
	logic	[3:0]	out_3_s1;
	logic	[3:0]	out_3_s2;
	logic	[3:0]	out_3_op;
	logic	[2:0]	out_3_branch;
	logic	[3:0]	out_3_ime;

	logic		out_4_vld;
	logic	[3:0]	out_4_des;
	logic	[3:0]	out_4_s1;
	logic	[3:0]	out_4_s2;
	logic	[3:0]	out_4_op;
	logic	[2:0]	out_4_branch;
	logic	[3:0]	out_4_ime;


	clocking top_issue_stage_cb @(posedge clk);
		output	rst,

			ins_back_1,	
		 	ins_back_2,	
			ins_back_3,	
			ins_back_4,
			ins_back_1_des,
			ins_back_2_des,
			ins_back_3_des,
			ins_back_4_des,

			ins_new_1_vld,
			ins_new_2_vld,

			flush_en,
			flush_id,
			ins_new_en,
			flush_reg,

			ins_1_des,
			ins_1_s1,
			ins_1_s2,
			ins_1_op,
			ins_1_ime,

			ins_2_des,
			ins_2_s1,
			ins_2_s2,
			ins_2_op,
			ins_2_ime;
		
		input 	entry_full,
			entry_empty,
			branch_full,

			out_1_vld,
			out_1_des,
			out_1_s1,
			out_1_s2,
			out_1_op,
			out_1_branch,
			out_1_ime,

			out_2_vld,
			out_2_des,
			out_2_s1,
			out_2_s2,
			out_2_op,
			out_2_branch,
			out_2_ime,

			out_3_vld,
			out_3_des,
			out_3_s1,
			out_3_s2,
			out_3_op,
			out_3_branch,
			out_3_ime,

			out_4_vld,
			out_4_des,
			out_4_s1,
			out_4_s2,
			out_4_op,
			out_4_branch,
			out_4_ime;

	endclocking


	modport top_issue_stage_dut(
		input	clk,
		input	rst,

		input	ins_back_1,	
		input	ins_back_2,	
		input	ins_back_3,	
		input	ins_back_4,
		input	ins_back_1_des,
		input	ins_back_2_des,
		input	ins_back_3_des,
		input	ins_back_4_des,

		input	ins_new_1_vld,
		input	ins_new_2_vld,

		input	flush_en,
		input	flush_id,
		input	ins_new_en,
		input	flush_reg,

		input	ins_1_des,
		input	ins_1_s1,
		input	ins_1_s2,
		input	ins_1_op,
		input	ins_1_ime,

		input	ins_2_des,
		input	ins_2_s1,
		input	ins_2_s2,
		input	ins_2_op,
		input	ins_2_ime,
		
		output 	entry_full,
		output	entry_empty,
		output	branch_full,

		output	out_1_vld,
		output	out_1_des,
		output	out_1_s1,
		output	out_1_s2,
		output	out_1_op,
		output	out_1_branch,
		output	out_1_ime,

		output	out_2_vld,
		output	out_2_des,
		output	out_2_s1,
		output	out_2_s2,
		output	out_2_op,
		output	out_2_branch,
		output	out_2_ime,

		output	out_3_vld,
		output	out_3_des,
		output	out_3_s1,
		output	out_3_s2,
		output	out_3_op,
		output	out_3_branch,
		output	out_3_ime,

		output	out_4_vld,
		output	out_4_des,
		output	out_4_s1,
		output	out_4_s2,
		output	out_4_op,
		output	out_4_branch,
		output	out_4_ime
	);

modport top_issue_stage_bench(clocking top_issue_stage_cb);

endinterface
		


