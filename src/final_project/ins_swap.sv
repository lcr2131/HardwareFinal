//Programmer:	Tong Zhang
//Date:		12/11/2012
//Purpose:	switch the sequence of the four instructions to place the load/store instruction to the fourth thread

module ins_swap#(parameter des = 'd4, source1 = 'd4, source2 = 'd4, immediate = 'd4,
				branch_id = 'd3, total_in = 4 + des + source1 + source2,
				total_out = total_in + branch_id + 'd1 + immediate )
(
	input 	ins1_swap,
	input	ins2_swap,
	input	ins3_swap,
	input	ins4_swap,

	input				in_1_vld,
	input		[des-1:0]	in_1_des,
	input		[source1-1:0]	in_1_s1,
	input		[source2-1:0]	in_1_s2,
	input		[3:0]		in_1_op,
	input		[branch_id-1:0]	in_1_branch,
	input		[immediate-1:0]	in_1_ime,

	input				in_2_vld,
	input		[des-1:0]	in_2_des,
	input		[source1-1:0]	in_2_s1,
	input		[source2-1:0]	in_2_s2,
	input		[3:0]		in_2_op,
	input		[branch_id-1:0]	in_2_branch,
	input		[immediate-1:0]	in_2_ime,

	input				in_3_vld,
	input		[des-1:0]	in_3_des,
	input		[source1-1:0]	in_3_s1,
	input		[source2-1:0]	in_3_s2,
	input		[3:0]		in_3_op,
	input		[branch_id-1:0]	in_3_branch,
	input		[immediate-1:0]	in_3_ime,

	input				in_4_vld,
	input		[des-1:0]	in_4_des,
	input		[source1-1:0]	in_4_s1,
	input		[source2-1:0]	in_4_s2,
	input		[3:0]		in_4_op,
	input		[branch_id-1:0]	in_4_branch,
	input		[immediate-1:0]	in_4_ime,

	output	logic			out_1_vld,
	output	logic	[des-1:0]	out_1_des,
	output	logic	[source1-1:0]	out_1_s1,
	output	logic	[source2-1:0]	out_1_s2,
	output	logic	[3:0]		out_1_op,
	output	logic	[branch_id-1:0]	out_1_branch,
	output	logic	[immediate-1:0]	out_1_ime,

	output	logic			out_2_vld,
	output	logic	[des-1:0]	out_2_des,
	output	logic	[source1-1:0]	out_2_s1,
	output	logic	[source2-1:0]	out_2_s2,
	output	logic	[3:0]		out_2_op,
	output	logic	[branch_id-1:0]	out_2_branch,
	output	logic	[immediate-1:0]	out_2_ime,

	output	logic			out_3_vld,
	output	logic	[des-1:0]	out_3_des,
	output	logic	[source1-1:0]	out_3_s1,
	output	logic	[source2-1:0]	out_3_s2,
	output	logic	[3:0]		out_3_op,
	output	logic	[branch_id-1:0]	out_3_branch,
	output	logic	[immediate-1:0]	out_3_ime,

	output	logic			out_4_vld,
	output	logic	[des-1:0]	out_4_des,
	output	logic	[source1-1:0]	out_4_s1,
	output	logic	[source2-1:0]	out_4_s2,
	output	logic	[3:0]		out_4_op,
	output	logic	[branch_id-1:0]	out_4_branch,
	output	logic	[immediate-1:0]	out_4_ime
);

always_comb
begin
	case({ins1_swap,ins2_swap,ins3_swap,ins4_swap})
		4'b1001:
		begin
			out_1_vld = in_4_vld;
			out_1_des = in_4_des;
			out_1_s1 = in_4_s1;
			out_1_s2 = in_4_s2;
			out_1_op = in_4_op;
			out_1_ime = in_4_ime;

			out_2_vld = in_2_vld;
			out_2_des = in_2_des;
			out_2_s1 = in_2_s1;
			out_2_s2 = in_2_s2;
			out_2_op = in_2_op;
			out_2_ime = in_2_ime;

			out_3_vld = in_3_vld;
			out_3_des = in_3_des;
			out_3_s1 = in_3_s1;
			out_3_s2 = in_3_s2;
			out_3_op = in_3_op;
			out_3_ime = in_3_ime;

			out_4_vld = in_1_vld;
			out_4_des = in_1_des;
			out_4_s1 = in_1_s1;
			out_4_s2 = in_1_s2;
			out_4_op = in_1_op;
			out_4_ime = in_1_ime;
		end
		4'b0101:
		begin
			out_1_vld = in_1_vld;
			out_1_des = in_1_des;
			out_1_s1 = in_1_s1;
			out_1_s2 = in_1_s2;
			out_1_op = in_1_op;
			out_1_ime = in_1_ime;

			out_2_vld = in_4_vld;
			out_2_des = in_4_des;
			out_2_s1 = in_4_s1;
			out_2_s2 = in_4_s2;
			out_2_op = in_4_op;
			out_2_ime = in_4_ime;

			out_3_vld = in_3_vld;
			out_3_des = in_3_des;
			out_3_s1 = in_3_s1;
			out_3_s2 = in_3_s2;
			out_3_op = in_3_op;
			out_3_ime = in_3_ime;

			out_4_vld = in_2_vld;
			out_4_des = in_2_des;
			out_4_s1 = in_2_s1;
			out_4_s2 = in_2_s2;
			out_4_op = in_2_op;
			out_4_ime = in_2_ime;
		end
		4'b0011:
		begin
			out_1_vld = in_1_vld;
			out_1_des = in_1_des;
			out_1_s1 = in_1_s1;
			out_1_s2 = in_1_s2;
			out_1_op = in_1_op;
			out_1_ime = in_1_ime;

			out_2_vld = in_2_vld;
			out_2_des = in_2_des;
			out_2_s1 = in_2_s1;
			out_2_s2 = in_2_s2;
			out_2_op = in_2_op;
			out_2_ime = in_2_ime;

			out_3_vld = in_4_vld;
			out_3_des = in_4_des;
			out_3_s1 = in_4_s1;
			out_3_s2 = in_4_s2;
			out_3_op = in_4_op;
			out_3_ime = in_4_ime;

			out_4_vld = in_3_vld;
			out_4_des = in_3_des;
			out_4_s1 = in_3_s1;
			out_4_s2 = in_3_s2;
			out_4_op = in_3_op;
			out_4_ime = in_3_ime;
		end
		default
		begin
			out_1_vld = in_1_vld;
			out_1_des = in_1_des;
			out_1_s1 = in_1_s1;
			out_1_s2 = in_1_s2;
			out_1_op = in_1_op;
			out_1_ime = in_1_ime;

			out_2_vld = in_2_vld;
			out_2_des = in_2_des;
			out_2_s1 = in_2_s1;
			out_2_s2 = in_2_s2;
			out_2_op = in_2_op;
			out_2_ime = in_2_ime;

			out_3_vld = in_3_vld;
			out_3_des = in_3_des;
			out_3_s1 = in_3_s1;
			out_3_s2 = in_3_s2;
			out_3_op = in_3_op;
			out_3_ime = in_3_ime;

			out_4_vld = in_4_vld;
			out_4_des = in_4_des;
			out_4_s1 = in_4_s1;
			out_4_s2 = in_4_s2;
			out_4_op = in_4_op;
			out_4_ime = in_4_ime;
		end
	endcase
end



















endmodule
