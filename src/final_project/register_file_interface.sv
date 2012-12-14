interface register_file_interface(input bit clk);

//des = 'd4; source1 = 'd4; source2 = 'd4; immediate = 'd4;
//				branch_id = 'd3; total_in = 4 + des + //source1 + source2;
//				total_out = total_in + branch_id + 'd1 //+ immediate; reg_num = 'd16;
//				register_width = 'd32

	logic		rst;
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

	logic		back_1_vld;
	logic		back_2_vld;
	logic		back_3_vld;
	logic		back_4_vld;

	logic [3:0]	back_1_des;
	logic [3:0]	back_2_des;
	logic [3:0]	back_3_des;
	logic [3:0]	back_4_des;

	logic [31:0]	back_1_data;
	logic [31:0]	back_2_data;
	logic [31:0]	back_3_data;
	logic [31:0]	back_4_data;


	reg		out_1_vld;
	reg [3:0]	out_1_des;
	reg [31:0]	out_1_s1_data;
	reg [31:0]	out_1_s2_data;
	reg [3:0]	out_1_op;
	reg [2:0]	out_1_branch;
	reg [3:0]	out_1_ime;

	reg		out_2_vld;
	reg [3:0]	out_2_des;
	reg [31:0]	out_2_s1_data;
	reg [31:0]	out_2_s2_data;
	reg [3:0]	out_2_op;
	reg [2:0]	out_2_branch;
	reg [3:0]	out_2_ime;

	reg		out_3_vld;
	reg [3:0]	out_3_des;
	reg [31:0]	out_3_s1_data;
	reg [31:0]	out_3_s2_data;
	reg [3:0]	out_3_op;
	reg [2:0]	out_3_branch;
	reg [3:0]	out_3_ime;

	reg		out_4_vld;
	reg [3:0]	out_4_des;
	reg [31:0]	out_4_s1_data;
	reg [31:0]	out_4_s2_data;
	reg [3:0]	out_4_op;
	reg [2:0]	out_4_branch;
	reg [3:0]	out_4_ime;

	logic [3:0]	ins1_op;
	logic [31:0]	ins1_data1;
	logic [31:0]	ins1_data2;
	logic [2:0]	ins1_bid;
	logic [3:0]	ins1_addr;

	logic [3:0]	ins2_op;
	logic [31:0]	ins2_data1;
	logic [31:0]	ins2_data2;
	logic [2:0]	ins2_bid;
	logic [3:0]	ins2_addr;


	logic [3:0]	ins3_op;
	logic [31:0]	ins3_data1;
	logic [31:0]	ins3_data2;
	logic [2:0]	ins3_bid;
	logic [3:0]	ins3_addr;


	logic [3:0]	ins4_op;
	logic [31:0]	ins4_data1;
	logic [31:0]	ins4_data2;
	logic [2:0]	ins4_bid;
	logic [3:0]	ins4_addr;

	 clocking register_file_cb @(posedge clk);
		output 	rst,
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
			in_4_ime,

			back_1_vld,
			back_2_vld,
			back_3_vld,
			back_4_vld,

			back_1_des,
			back_2_des,
			back_3_des,
			back_4_des,

			back_1_data,
			back_2_data,
			back_3_data,
			back_4_data;


		input	out_1_vld,
			out_1_des,
			out_1_s1_data,
			out_1_s2_data,
			out_1_op,
			out_1_branch,
			out_1_ime,

			out_2_vld,
			out_2_des,
			out_2_s1_data,
			out_2_s2_data,
			out_2_op,
			out_2_branch,
			out_2_ime,

			out_3_vld,
			out_3_des,
			out_3_s1_data,
			out_3_s2_data,
			out_3_op,
			out_3_branch,
			out_3_ime,

			out_4_vld,
			out_4_des,
			out_4_s1_data,
			out_4_s2_data,
			out_4_op,
			out_4_branch,
			out_4_ime,

			ins1_op,
			ins1_data1,
			ins1_data2,
			ins1_bid,
			ins1_addr,

			ins2_op,
			ins2_data1,
			ins2_data2,
			ins2_bid,
			ins2_addr,


			ins3_op,
			ins3_data1,
			ins3_data2,
			ins3_bid,
			ins3_addr,


			ins4_op,
			ins4_data1,
			ins4_data2,
			ins4_bid,
			ins4_addr;
	endclocking

	modport register_file_dut(
		input 	rst,
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

		input	back_1_vld,
		input	back_2_vld,
		input	back_3_vld,
		input	back_4_vld,

		input	back_1_des,
		input	back_2_des,
		input	back_3_des,
		input	back_4_des,

		input	back_1_data,
		input	back_2_data,
		input	back_3_data,
		input	back_4_data,


		output	out_1_vld,
		output	out_1_des,
		output	out_1_s1_data,
		output	out_1_s2_data,
		output	out_1_op,
		output	out_1_branch,
		output	out_1_ime,

		output	out_2_vld,
		output	out_2_des,
		output	out_2_s1_data,
		output	out_2_s2_data,
		output	out_2_op,
		output	out_2_branch,
		output	out_2_ime,

		output	out_3_vld,
		output	out_3_des,
		output	out_3_s1_data,
		output	out_3_s2_data,
		output	out_3_op,
		output	out_3_branch,
		output	out_3_ime,

		output	out_4_vld,
		output	out_4_des,
		output	out_4_s1_data,
		output	out_4_s2_data,
		output	out_4_op,
		output	out_4_branch,
		output	out_4_ime,

		output	ins1_op,
		output	ins1_data1,
		output	ins1_data2,
		output	ins1_bid,
		output	ins1_addr,

		output	ins2_op,
		output	ins2_data1,
		output	ins2_data2,
		output	ins2_bid,
		output	ins2_addr,


		output	ins3_op,
		output	ins3_data1,
		output	ins3_data2,
		output	ins3_bid,
		output	ins3_addr,


		output	ins4_op,
		output	ins4_data1,
		output	ins4_data2,
		output	ins4_bid,
		output	ins4_addr
	);

	modport register_file_bench(clocking register_file_cb);
endinterface

		
