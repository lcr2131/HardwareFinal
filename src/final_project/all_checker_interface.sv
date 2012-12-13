interface all_checker_interface(input bit clk);

	//des = 'd4, source1 = 'd4, source2 = 'd4, reg_num = 'd16
	logic		rst;

	logic		flush_en;
	logic [15:0]	flush_reg;

	logic		ins_in_1_vld;	 
   logic [3:0] 		ins_in_1_des;
	logic [3:0]	ins_in_1_source1;
	logic [3:0]	ins_in_1_source2;
	logic [3:0]	op1;

	logic		ins_in_2_vld;
	logic [3:0]	ins_in_2_des;
	logic [3:0]	ins_in_2_source1;
	logic [3:0]	ins_in_2_source2;
	logic [3:0]	op2;

	logic		ins_in_3_vld;
	logic [3:0]	ins_in_3_des;
	logic [3:0]	ins_in_3_source1;
	logic [3:0]	ins_in_3_source2;
	logic [3:0]	op3;

	logic		ins_in_4_vld;
	logic [3:0]	ins_in_4_des;
	logic [3:0]	ins_in_4_source1;
	logic [3:0]	ins_in_4_source2;
	logic [3:0]	op4;

	logic		ins_final_1_vld;
	logic		ins_final_2_vld;
	logic		ins_final_3_vld;
	logic		ins_final_4_vld;

	logic		ins_back_1_vld;
	logic [3:0]	ins_back_1_des;
	logic		ins_back_2_vld;
	logic [3:0]	ins_back_2_des;
	logic		ins_back_3_vld;
	logic [3:0]	ins_back_3_des;
	logic		ins_back_4_vld;
	logic [3:0]	ins_back_4_des;

	logic 		ins1_swap;
	logic		ins2_swap;
	logic		ins3_swap;
	logic		ins4_swap;

	logic		ins1_out;
	logic		ins2_out;
	logic		ins3_out;
	logic		ins4_out;

	 clocking all_checker_cb @(posedge clk);
		output	rst,
			flush_en,
			flush_reg,

			ins_in_1_vld,
			ins_in_1_des,
			ins_in_1_source1,
			ins_in_1_source2,
			op1,

			ins_in_2_vld,
			ins_in_2_des,
			ins_in_2_source1,
			ins_in_2_source2,
			op2,

			ins_in_3_vld,
			ins_in_3_des,
			ins_in_3_source1,
			ins_in_3_source2,
			op3,

			ins_in_4_vld,
			ins_in_4_des,
			ins_in_4_source1,
			ins_in_4_source2,
			op4,

			ins_final_1_vld,
			ins_final_2_vld,
			ins_final_3_vld,
			ins_final_4_vld,

			ins_back_1_vld,
			ins_back_1_des,
			ins_back_2_vld,
			ins_back_2_des,
			ins_back_3_vld,
			ins_back_3_des,
			ins_back_4_vld,
			ins_back_4_des;

		input	ins1_swap,
	 		ins2_swap,
			ins3_swap,
	 		ins4_swap,

	 		ins1_out,
	 		ins2_out,
	 		ins3_out,
	 		ins4_out;
	endclocking

	modport all_checker_dut(
		input 	clk,
		input 	rst,

		input 	flush_en,
		input	flush_reg,

		input	ins_in_1_vld,
		input	ins_in_1_des,
		input	ins_in_1_source1,
		input	ins_in_1_source2,
		input	op1,

		input 	ins_in_2_vld,
		input 	ins_in_2_des,
		input 	ins_in_2_source1,
		input 	ins_in_2_source2,
		input 	op2,

		input	ins_in_3_vld,
		input	ins_in_3_des,
		input	ins_in_3_source1,
		input	ins_in_3_source2,
		input	op3,

		input	ins_in_4_vld,
		input	ins_in_4_des,
		input	ins_in_4_source1,
		input	ins_in_4_source2,
		input	op4,

		input	ins_final_1_vld,
		input	ins_final_2_vld,
		input	ins_final_3_vld,
		input	ins_final_4_vld,

		input	ins_back_1_vld,
		input	ins_back_1_des,
		input	ins_back_2_vld,
		input	ins_back_2_des,
		input	ins_back_3_vld,
		input	ins_back_3_des,
		input	ins_back_4_vld,
		input	ins_back_4_des,

		output 	ins1_swap,
		output  ins2_swap,
		output 	ins3_swap,
		output 	ins4_swap,

		output 	ins1_out,
		output  ins2_out,
		output  ins3_out,
	 	output  ins4_out
	);

	modport all_checker_bench(clocking all_checker_cb);
endinterface


