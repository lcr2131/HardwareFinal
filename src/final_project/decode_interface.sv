interface decode_interface(input bit clk);
	logic [31:0]	new_instr1_in;
	logic [31:0]	new_instr2_in;

	logic [3:0]	ins_1_op;
	logic [3:0]	ins_1_des;
	logic [3:0]	ins_1_s1;
	logic [3:0]	ins_1_s2;
	logic [4:0]	ins_1_ime;

	logic [3:0]	ins_2_op;
	logic [3:0]	ins_2_des;
	logic [3:0]	ins_2_s1;
	logic [3:0]	ins_2_s2;
	logic [4:0]	ins_2_ime;
	
	clocking decode_cb @(posedge clk);
		output	new_instr1_in,
			new_instr2_in;

		input	ins_1_op,
			ins_1_des,
			ins_1_s1,
			ins_1_s2,
			ins_1_ime,

			ins_2_op,
			ins_2_des,
			ins_2_s1,
			ins_2_s2,
			ins_2_ime;
	endclocking

	modport decode_dut(
		output	new_instr1_in,
		output	new_instr2_in,

		input	ins_1_op,
		input	ins_1_des,
		input	ins_1_s1,
		input	ins_1_s2,
		input	ins_1_ime,

		input	ins_2_op,
		input	ins_2_des,
		input	ins_2_s1,
		input	ins_2_s2,
		input	ins_2_ime
	);

	modport decode_bench(clocking decode_cb);
endinterface

