interface top_buffer_stage_interface(input bit clk);
	input	rst;

	input	[31:0]	in_1_s1_data;
	input	[31:0]	in_1_s2_data;
	input	[31:0]	in_2_s1_data;
	input	[31:0]	in_2_s2_data;
	input	[31:0]	in_3_s1_data;
	input	[31:0]	in_3_s2_data;
	input	[31:0]	in_4_s1_data;
	input	[31:0]	in_4_s2_data;

	input	[3:0]	in_1_des;
	input	[3:0]	in_2_des;
	input	[3:0]	in_3_des;
	input	[3:0]	in_4_des;
	input	[3:0]	in_1_op;
	input	[3:0]	in_2_op;
	input	[3:0]	in_3_op;
	input	[3:0]	in_4_op;
	input		in_1_vld;
	input		in_2_vld;
	input		in_3_vld;
	input		in_4_vld;
	input	[4:0]	in_1_immediate;

	input	[2:0]	in_1_branch;
	input	[2:0]	in_2_branch;
	input	[2:0]	in_3_branch;
	input	[2:0]	in_4_branch;

	input		mem_in_done;
	input		flush_en;
	input	[2:0]	flush_id;

	reg	[3:0]	out_1_des;
	reg	[3:0]	out_2_des;
	reg	[3:0]	out_3_des;
	reg	[3:0]	out_4_des;

	reg 	[31:0]	out_1_data;
	reg 	[31:0]	out_2_data;
	reg 	[31:0]	out_3_data;
	reg 	[31:0]	out_4_data;
	
	reg		out_1_vld;
	reg		out_2_vld;
	reg		out_3_vld;
	reg		out_4_vld;

	reg 	[31:0]	out_1_mem_addr;

	reg		out_load_flag;
	reg		out_store_flag;

	reg		buffer_full;
	reg		buffer_empty;

	reg	[15:0]	reg_out_to_raw_history;

	clocking top_buffer_stage_cb @(posedge clk);
		output	rst,

			in_1_s1_data,
			in_1_s2_data,
			in_2_s1_data,
			in_2_s2_data,
			in_3_s1_data,
			in_3_s2_data,
			in_4_s1_data,
			in_4_s2_data,

			in_1_des,
			in_2_des,
			in_3_des,
			in_4_des,



			in_1_op,
			in_2_op,
			in_3_op,
			in_4_op,

			in_1_vld,
			in_2_vld,
			in_3_vld,
			in_4_vld,

	
			in_1_immediate,

			in_1_branch,
			in_2_branch,
			in_3_branch,
			in_4_branch,

			mem_in_done,
			flush_en,
			flush_id;

		input	out_1_des,
			out_2_des,
			out_3_des,
			out_4_des,

			out_1_data,
			out_2_data,
			out_3_data,
			out_4_data,
	
			out_1_vld,
			out_2_vld,
			out_3_vld,
			out_4_vld,

			out_1_mem_addr,

			out_load_flag,
			out_store_flag,

			buffer_full,
			buffer_empty,

			reg_out_to_raw_history;
	endclocking

	modport top_buffer_stage_dut(
		input	clk,
		input	rst,

		input	in_1_s1_data,
		input	in_1_s2_data,
		input	in_2_s1_data,
		input	in_2_s2_data,
		input	in_3_s1_data,
		input	in_3_s2_data,
		input	in_4_s1_data,
		input	in_4_s2_data,

		input	in_1_des,
		input	in_2_des,
		input	in_3_des,
		input	in_4_des,



		input	in_1_op,
		input	in_2_op,
		input	in_3_op,
		input	in_4_op,

		input	in_1_vld,
		input	in_2_vld,
		input	in_3_vld,
		input	in_4_vld,

	
		input	in_1_immediate,

		input	in_1_branch,
		input	in_2_branch,
		input	in_3_branch,
		input	in_4_branch,

		input	mem_in_done,
		input	flush_en,
		input	flush_id,

		output	out_1_des,
		output	out_2_des,
		output	out_3_des,
		output	out_4_des,

		output	out_1_data,
		output	out_2_data,
		output	out_3_data,
		output	out_4_data,
	
		output	out_1_vld,
		output	out_2_vld,
		output	out_3_vld,
		output	out_4_vld,

		output	out_1_mem_addr,

		output	out_load_flag,
		output	out_store_flag,

		output	buffer_full,
		output	buffer_empty,	
		output  reg_out_to_raw_history
	);

	modport top_buffer_stage_bench(clocking top_buffer_stage_cb);
endinterface

