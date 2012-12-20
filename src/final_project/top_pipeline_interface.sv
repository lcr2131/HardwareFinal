interface top_pipeline_interface(logic bit clk);
	
	logic 		rst;
	logic 	[31:0] 	new_instr1_in;
	logic 	[31:0] 	new_instr2_in;

	logic		mem_in_done;

	logic 		ins_new_1_vld;
	logic 		ins_new_2_vld;

	reg   	[31:0]	out_1_mem_addr;
	reg		out_load_flag;
	reg		out_store_flag;
	reg 	[4:0]	pc;


	clocking top_pipeline_cb @(posedge clk);
		output 	rst,

			new_instr1_in,
			new_instr2_in,

			mem_in_done,

			ins_new_1_vld,
			ins_new_2_vld;

		input	out_1_mem_addr,
			out_load_flag,
			out_store_flag,
			pc;
	endclocking

	modport top_pipeline_dut(
		input  	clk,
		input	rst,
		
		input	new_instr1_in,
		input	new_instr2_in,

		input	mem_in_done,

		input	ins_new_1_vld,
		input	ins_new_2_vld,

		output	out_1_mem_addr,
		output	out_load_flag,
		output	out_store_flag,
		output	pc
	);

	modport top_pipeline_bench(clocking top_pipeline_cb);
endinterface


