interface ins_swap_interface(input bit clk);
	//des = 'd4; source1 = 'd4; source2 = 'd4; immediate = 'd4;
	//			branch_id = 'd3; total_in = 4 + des + source1 + source2;
	//			total_out = total_in + branch_id + 'd1 + immediate

	logic		ins1_swap;
	logic		ins2_swap;
	logic		ins3_swap;
	logic		ins4_swap;

	logic		in_1_vld;
	logic [3:0]	in_1_des;
	logic [3:0]	in_1_s1;
	logic [3:0]	in_1_s2;
	logic [3:0]	in_1_op;
	logic [2:0]	in_1_branch;
	logic [3:0]	in_1_ime;

	logic		in_2_vld;
	logic [3:0]	in_2_des;
	logic [3:0]	in_2_s1;
	logic [3:0]	in_2_s2;
	logic [3:0]	in_2_op;
	logic [2:0]	in_2_branch;
	logic [3:0]	in_2_ime;

	logic		in_3_vld;
	logic [3:0]	in_3_des;
	logic [3:0]	in_3_s1;
	logic [3:0]	in_3_s2;
	logic [3:0]	in_3_op;
	logic [2:0]	in_3_branch;
	logic [3:0]	in_3_ime;

	logic		in_4_vld;
	logic [3:0]	in_4_des;
	logic [3:0]	in_4_s1;
	logic [3:0]	in_4_s2;
	logic [3:0]	in_4_op;
	logic [2:0]	in_4_branch;
	logic [3:0]	in_4_ime;

	logic		out_1_vld;
	logic [3:0]	out_1_des;
	logic [3:0]	out_1_s1;
	logic [3:0]	out_1_s2;
	logic [3:0]	out_1_op;
	logic [2:0]	out_1_branch;
	logic [3:0]	out_1_ime;

	logic		out_2_vld;
	logic [3:0]	out_2_des;
	logic [3:0]	out_2_s1;
	logic [3:0]	out_2_s2;
	logic [3:0]	out_2_op;
	logic [2:0]	out_2_branch;
	logic [3:0]	out_2_ime;

	logic		out_3_vld;
	logic [3:0]	out_3_des;
	logic [3:0]	out_3_s1;
	logic [3:0]	out_3_s2;
	logic [3:0]	out_3_op;
	logic [2:0]	out_3_branch;
	logic [3:0]	out_3_ime;

	logic		out_4_vld;
	logic [3:0]	out_4_des;
	logic [3:0]	out_4_s1;
	logic [3:0]	out_4_s2;
	logic [3:0]	out_4_op;
	logic [2:0]	out_4_branch;
	logic [3:0]	out_4_ime;

	clocking ins_swap_cb @(posedge clk);
		output 	ins1_swap,
		 	ins2_swap,
			ins3_swap,
			ins4_swap,

			in_1_vld,
			in_1_des,
			in_1_s1,
			in_1_s2,
			in_1_op,
			in_1_branch,
			in_1_ime,

			in_2_vld,
			in_2_des,
			in_2_s1,
			in_2_s2,
			in_2_op,
			in_2_branch,
			in_2_ime,

			in_3_vld,
			in_3_des,
			in_3_s1,
			in_3_s2,
			in_3_op,
			in_3_branch,
			in_3_ime,

			in_4_vld,
			in_4_des,
			in_4_s1,
			in_4_s2,
			in_4_op,
			in_4_branch,
			in_4_ime;

		input	out_1_vld,
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

	modport ins_swap_dut(
		input 	ins1_swap,
		input 	ins2_swap,
		input	ins3_swap,
		input	ins4_swap,

		input	in_1_vld,
		input	in_1_des,
		input	in_1_s1,
		input	in_1_s2,
		input	in_1_op,
		input	in_1_branch,
		input	in_1_ime,

		input	in_2_vld,
		input	in_2_des,
		input	in_2_s1,
		input	in_2_s2,
		input	in_2_op,
		input	in_2_branch,
		input	in_2_ime,

		input	in_3_vld,
		input	in_3_des,
		input	in_3_s1,
		input	in_3_s2,
		input	in_3_op,
		input	in_3_branch,
		input	in_3_ime,

		input	in_4_vld,
		input	in_4_des,
		input	in_4_s1,
		input	in_4_s2,
		input	in_4_op,
		input	in_4_branch,
		input	in_4_ime,

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

	modport ins_swap_bench(clocking ins_swap_cb);
endinterface
