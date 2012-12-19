//Programmer:	Tong Zhang
//Date:		12/13/2012
//Purpose:	Four ALU calculation and results send to Buffer


module alu_and_buffer	#(register_width = 'd32, des = 'd4,branch_id = 'd3, op = 'd4,immediate = 'd5,
				buffer_total = 1'd1 + 1'd1 + op + register_width + des + branch_id,
				reg_num = 'd16)
(
	input	clk,
	input	rst,

	input	[register_width-1:0]	in_1_s1_data,
	input	[register_width-1:0]	in_1_s2_data,
	input	[register_width-1:0]	in_2_s1_data,
	input	[register_width-1:0]	in_2_s2_data,
	input	[register_width-1:0]	in_3_s1_data,
	input	[register_width-1:0]	in_3_s2_data,
	input	[register_width-1:0]	in_4_s1_data,
	input	[register_width-1:0]	in_4_s2_data,

	input		[des-1:0]	in_1_des,
	input		[des-1:0]	in_2_des,
	input		[des-1:0]	in_3_des,
	input		[des-1:0]	in_4_des,

	input		[2:0]		out_addr_1,
	input		[2:0]		out_addr_2,
	input		[2:0]		out_addr_3,
	input		[2:0]		out_addr_4,

	input		[4:0]		in_addr_1,
	input		[4:0]		in_addr_2,
	input		[4:0]		in_addr_3,
	input		[4:0]		in_addr_4,

	input		[op-1:0]	in_1_op,
	input		[op-1:0]	in_2_op,
	input		[op-1:0]	in_3_op,
	input		[op-1:0]	in_4_op,

	input				in_1_vld,
	input				in_2_vld,
	input				in_3_vld,
	input				in_4_vld,

	input		[2:0]		shift_amount_1,
	input		[2:0]		shift_amount_2,
	input		[2:0]		shift_amount_3,
	input		[2:0]		shift_amount_rest,

	input		[immediate-1:0]	in_1_immediate,

	input		[branch_id-1:0]	in_1_branch,
	input		[branch_id-1:0]	in_2_branch,
	input		[branch_id-1:0]	in_3_branch,
	input		[branch_id-1:0]	in_4_branch,

	input				mem_in_done,
	input				flush_en,
	input		[2:0]		flush_id,

	
	output	reg	[des-1:0]	out_1_des,
	output	reg	[des-1:0]	out_2_des,
	output	reg	[des-1:0]	out_3_des,
	output	reg	[des-1:0]	out_4_des,

	output	reg [register_width-1:0]	out_1_data,
	output	reg [register_width-1:0]	out_2_data,
	output	reg [register_width-1:0]	out_3_data,
	output	reg [register_width-1:0]	out_4_data,
	
	output	reg			out_1_vld,
	output	reg			out_2_vld,
	output	reg			out_3_vld,
	output	reg			out_4_vld,

	output	reg	[register_width-1:0]	out_1_mem_addr,

	output	reg			out_load_flag,
	output	reg			out_store_flag,

	output	reg			buffer_full,
	output	reg			buffer_empty,

	output reg	[reg_num-1:0]	reg_out_to_raw_history
);

	logic [register_width-1:0]	alu_1_data;
	logic [register_width-1:0]	alu_2_data;
	logic [register_width-1:0]	alu_3_data;
	logic [register_width-1:0]	alu_4_data;

	reg	[buffer_total-1:0]	buf_0;
	reg	[buffer_total-1:0]	buf_1;
	reg	[buffer_total-1:0]	buf_2;
	reg	[buffer_total-1:0]	buf_3;
	reg	[buffer_total-1:0]	buf_4;
	reg	[buffer_total-1:0]	buf_5;
	reg	[buffer_total-1:0]	buf_6;
	reg	[buffer_total-1:0]	buf_7;
	reg	[buffer_total-1:0]	buf_8;
	reg	[buffer_total-1:0]	buf_9;
	reg	[buffer_total-1:0]	buf_10;
	reg	[buffer_total-1:0]	buf_11;
	reg	[buffer_total-1:0]	buf_12;
	reg	[buffer_total-1:0]	buf_13;
	reg	[buffer_total-1:0]	buf_14;
	reg	[buffer_total-1:0]	buf_15;
	reg	[buffer_total-1:0]	buf_16;
	reg	[buffer_total-1:0]	buf_17;
	reg	[buffer_total-1:0]	buf_18;
	reg	[buffer_total-1:0]	buf_19;
	reg	[buffer_total-1:0]	buf_20;
	reg	[buffer_total-1:0]	buf_21;
	reg	[buffer_total-1:0]	buf_22;
	reg	[buffer_total-1:0]	buf_23;
	reg	[buffer_total-1:0]	buf_24;
	reg	[buffer_total-1:0]	buf_25;
	reg	[buffer_total-1:0]	buf_26;
	reg	[buffer_total-1:0]	buf_27;
	reg	[buffer_total-1:0]	buf_28;
	reg	[buffer_total-1:0]	buf_29;
	reg	[buffer_total-1:0]	buf_30;
	reg	[buffer_total-1:0]	buf_31;

	reg	[5:0]	buf_write_pointer;

//	reg	[reg_num-1:0]	branch_0;
	reg	[reg_num-1:0]	branch_1;
	reg	[reg_num-1:0]	branch_2;
	reg	[reg_num-1:0]	branch_3;
	reg	[reg_num-1:0]	branch_4;
	reg	[reg_num-1:0]	branch_5;
	reg	[reg_num-1:0]	branch_6;
	reg	[reg_num-1:0]	branch_7;

	reg		ongoing_load_flag;
	reg		ongoing_store_flag;


assign alu_2_data = in_2_s1_data + in_2_s2_data;
assign alu_3_data = in_3_s1_data + in_3_s2_data;
assign alu_4_data = in_4_s1_data + in_4_s2_data;

always_comb
begin
	if (in_1_op == 'b1000)
		alu_1_data = in_1_s1_data + in_1_s2_data;
	else if (in_1_op == 'b0100 || in_1_op == 'b0010)
		alu_1_data = in_1_s1_data + in_1_immediate;
	else
		alu_1_data = 'd0;
end


/////////////////////////////////////////////////////////////
always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_out_to_raw_history <= 'd0;
	else if (flush_en && flush_id == 'd1)
		reg_out_to_raw_history <= branch_1;
	else if (flush_en && flush_id == 'd2)
		reg_out_to_raw_history <= branch_2;
	else if (flush_en && flush_id == 'd3)
		reg_out_to_raw_history <= branch_3;
	else if (flush_en && flush_id == 'd4)
		reg_out_to_raw_history <= branch_4;
	else if (flush_en && flush_id == 'd5)
		reg_out_to_raw_history <= branch_5;
	else if (flush_en && flush_id == 'd6)
		reg_out_to_raw_history <= branch_6;
	else if (flush_en && flush_id == 'd7)
		reg_out_to_raw_history <= branch_7;
	else if (~flush_en)
		reg_out_to_raw_history <= 'd0;
end

//////////////////////////////////////////////////////////////
always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		branch_1 <= 'd0;
	else if (flush_en && flush_id <= 'd1)
		branch_1 <= 'd0;
	else if (in_1_vld && in_1_branch >= 'd1 && in_1_des== 'd1)
		branch_1[1] <= 1;
	else if (in_1_vld && in_1_branch >= 'd1 && in_1_des== 'd2)
		branch_1[2] <= 1;
	else if (in_1_vld && in_1_branch >= 'd1 && in_1_des== 'd3)
		branch_1[3] <= 1;
	else if (in_1_vld && in_1_branch >= 'd1 && in_1_des== 'd4)
		branch_1[4] <= 1;
	else if (in_1_vld && in_1_branch >= 'd1 && in_1_des== 'd5)
		branch_1[5] <= 1;
	else if (in_1_vld && in_1_branch >= 'd1 && in_1_des== 'd6)
		branch_1[6] <= 1;
	else if (in_1_vld && in_1_branch >= 'd1 && in_1_des== 'd7)
		branch_1[7] <= 1;
	else if (in_1_vld && in_1_branch >= 'd1 && in_1_des== 'd8)
		branch_1[8] <= 1;
	else if (in_1_vld && in_1_branch >= 'd1 && in_1_des== 'd9)
		branch_1[9] <= 1;
	else if (in_1_vld && in_1_branch >= 'd1 && in_1_des== 'd10)
		branch_1[10] <= 1;
	else if (in_1_vld && in_1_branch >= 'd1 && in_1_des== 'd11)
		branch_1[11] <= 1;
	else if (in_1_vld && in_1_branch >= 'd1 && in_1_des== 'd12)
		branch_1[12] <= 1;
	else if (in_1_vld && in_1_branch >= 'd1 && in_1_des== 'd13)
		branch_1[13] <= 1;
	else if (in_1_vld && in_1_branch >= 'd1 && in_1_des== 'd14)
		branch_1[14] <= 1;
	else if (in_1_vld && in_1_branch >= 'd1 && in_1_des== 'd15)
		branch_1[15] <= 1;

	else if (in_2_vld && in_2_branch >= 'd1 && in_2_des== 'd1)
		branch_1[1] <= 1;
	else if (in_2_vld && in_2_branch >= 'd1 && in_2_des== 'd2)
		branch_1[2] <= 1;
	else if (in_2_vld && in_2_branch >= 'd1 && in_2_des== 'd3)
		branch_1[3] <= 1;
	else if (in_2_vld && in_2_branch >= 'd1 && in_2_des== 'd4)
		branch_1[4] <= 1;
	else if (in_2_vld && in_2_branch >= 'd1 && in_2_des== 'd5)
		branch_1[5] <= 1;
	else if (in_2_vld && in_2_branch >= 'd1 && in_2_des== 'd6)
		branch_1[6] <= 1;
	else if (in_2_vld && in_2_branch >= 'd1 && in_2_des== 'd7)
		branch_1[7] <= 1;
	else if (in_2_vld && in_2_branch >= 'd1 && in_2_des== 'd8)
		branch_1[8] <= 1;
	else if (in_2_vld && in_2_branch >= 'd1 && in_2_des== 'd9)
		branch_1[9] <= 1;
	else if (in_2_vld && in_2_branch >= 'd1 && in_2_des == 'd10)
		branch_1[10] <= 1;
	else if (in_2_vld && in_2_branch >= 'd1 && in_2_des == 'd11)
		branch_1[11] <= 1;
	else if (in_2_vld && in_2_branch >= 'd1 && in_2_des == 'd12)
		branch_1[12] <= 1;
	else if (in_2_vld && in_2_branch >= 'd1 && in_2_des == 'd13)
		branch_1[13] <= 1;
	else if (in_2_vld && in_2_branch >= 'd1 && in_2_des == 'd14)
		branch_1[14] <= 1;
	else if (in_2_vld && in_2_branch >= 'd1 && in_2_des == 'd15)
		branch_1[15] <= 1;

	else if (in_3_vld && in_3_branch >= 'd1 && in_3_des == 'd1)
		branch_1[1] <= 1;
	else if (in_3_vld && in_3_branch >= 'd1 && in_3_des == 'd2)
		branch_1[2] <= 1;
	else if (in_3_vld && in_3_branch >= 'd1 && in_3_des == 'd3)
		branch_1[3] <= 1;
	else if (in_3_vld && in_3_branch >= 'd1 && in_3_des == 'd4)
		branch_1[4] <= 1;
	else if (in_3_vld && in_3_branch >= 'd1 && in_3_des == 'd5)
		branch_1[5] <= 1;
	else if (in_3_vld && in_3_branch >= 'd1 && in_3_des == 'd6)
		branch_1[6] <= 1;
	else if (in_3_vld && in_3_branch >= 'd1 && in_3_des == 'd7)
		branch_1[7] <= 1;
	else if (in_3_vld && in_3_branch >= 'd1 && in_3_des == 'd8)
		branch_1[8] <= 1;
	else if (in_3_vld && in_3_branch >= 'd1 && in_3_des == 'd9)
		branch_1[9] <= 1;
	else if (in_3_vld && in_3_branch >= 'd1 && in_3_des == 'd10)
		branch_1[10] <= 1;
	else if (in_3_vld && in_3_branch >= 'd1 && in_3_des == 'd11)
		branch_1[11] <= 1;
	else if (in_3_vld && in_3_branch >= 'd1 && in_3_des == 'd12)
		branch_1[12] <= 1;
	else if (in_3_vld && in_3_branch >= 'd1 && in_3_des == 'd13)
		branch_1[13] <= 1;
	else if (in_3_vld && in_3_branch >= 'd1 && in_3_des == 'd14)
		branch_1[14] <= 1;
	else if (in_3_vld && in_3_branch >= 'd1 && in_3_des == 'd15)
		branch_1[15] <= 1;

	else if (in_4_vld && in_4_branch >= 'd1 && in_4_des == 'd1)
		branch_1[1] <= 1;
	else if (in_4_vld && in_4_branch >= 'd1 && in_4_des == 'd2)
		branch_1[2] <= 1;
	else if (in_4_vld && in_4_branch >= 'd1 && in_4_des == 'd3)
		branch_1[3] <= 1;
	else if (in_4_vld && in_4_branch >= 'd1 && in_4_des == 'd4)
		branch_1[4] <= 1;
	else if (in_4_vld && in_4_branch >= 'd1 && in_4_des == 'd5)
		branch_1[5] <= 1;
	else if (in_4_vld && in_4_branch >= 'd1 && in_4_des == 'd6)
		branch_1[6] <= 1;
	else if (in_4_vld && in_4_branch >= 'd1 && in_4_des == 'd7)
		branch_1[7] <= 1;
	else if (in_4_vld && in_4_branch >= 'd1 && in_4_des == 'd8)
		branch_1[8] <= 1;
	else if (in_4_vld && in_4_branch >= 'd1 && in_4_des == 'd9)
		branch_1[9] <= 1;
	else if (in_4_vld && in_4_branch >= 'd1 && in_4_des == 'd10)
		branch_1[10] <= 1;
	else if (in_4_vld && in_4_branch >= 'd1 && in_4_des == 'd11)
		branch_1[11] <= 1;
	else if (in_4_vld && in_4_branch >= 'd1 && in_4_des == 'd12)
		branch_1[12] <= 1;
	else if (in_4_vld && in_4_branch >= 'd1 && in_4_des == 'd13)
		branch_1[13] <= 1;
	else if (in_4_vld && in_4_branch >= 'd1 && in_4_des == 'd14)
		branch_1[14] <= 1;
	else if (in_4_vld && in_4_branch >= 'd1 && in_4_des == 'd15)
		branch_1[15] <= 1;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		branch_2 <= 'd0;
	else if (flush_en && flush_id <= 'd2)
		branch_2 <= 'd0;
	else if (in_1_vld && in_1_branch >= 'd2 && in_1_des == 'd1)
		branch_2[1] <= 1;
	else if (in_1_vld && in_1_branch >= 'd2 && in_1_des == 'd2)
		branch_2[2] <= 1;
	else if (in_1_vld && in_1_branch >= 'd2 && in_1_des == 'd3)
		branch_2[3] <= 1;
	else if (in_1_vld && in_1_branch >= 'd2 && in_1_des == 'd4)
		branch_2[4] <= 1;
	else if (in_1_vld && in_1_branch >= 'd2 && in_1_des == 'd5)
		branch_2[5] <= 1;
	else if (in_1_vld && in_1_branch >= 'd2 && in_1_des == 'd6)
		branch_2[6] <= 1;
	else if (in_1_vld && in_1_branch >= 'd2 && in_1_des == 'd7)
		branch_2[7] <= 1;
	else if (in_1_vld && in_1_branch >= 'd2 && in_1_des == 'd8)
		branch_2[8] <= 1;
	else if (in_1_vld && in_1_branch >= 'd2 && in_1_des == 'd9)
		branch_2[9] <= 1;
	else if (in_1_vld && in_1_branch >= 'd2 && in_1_des == 'd10)
		branch_2[10] <= 1;
	else if (in_1_vld && in_1_branch >= 'd2 && in_1_des == 'd11)
		branch_2[11] <= 1;
	else if (in_1_vld && in_1_branch >= 'd2 && in_1_des == 'd12)
		branch_2[12] <= 1;
	else if (in_1_vld && in_1_branch >= 'd2 && in_1_des == 'd13)
		branch_2[13] <= 1;
	else if (in_1_vld && in_1_branch >= 'd2 && in_1_des == 'd14)
		branch_2[14] <= 1;
	else if (in_1_vld && in_1_branch >= 'd2 && in_1_des == 'd15)
		branch_2[15] <= 1;

	else if (in_2_vld && in_2_branch >= 'd2 && in_2_des == 'd1)
		branch_2[1] <= 1;
	else if (in_2_vld && in_2_branch >= 'd2 && in_2_des == 'd2)
		branch_2[2] <= 1;
	else if (in_2_vld && in_2_branch >= 'd2 && in_2_des == 'd3)
		branch_2[3] <= 1;
	else if (in_2_vld && in_2_branch >= 'd2 && in_2_des == 'd4)
		branch_2[4] <= 1;
	else if (in_2_vld && in_2_branch >= 'd2 && in_2_des == 'd5)
		branch_2[5] <= 1;
	else if (in_2_vld && in_2_branch >= 'd2 && in_2_des == 'd6)
		branch_2[6] <= 1;
	else if (in_2_vld && in_2_branch >= 'd2 && in_2_des == 'd7)
		branch_2[7] <= 1;
	else if (in_2_vld && in_2_branch >= 'd2 && in_2_des == 'd8)
		branch_2[8] <= 1;
	else if (in_2_vld && in_2_branch >= 'd2 && in_2_des == 'd9)
		branch_2[9] <= 1;
	else if (in_2_vld && in_2_branch >= 'd2 && in_2_des == 'd10)
		branch_2[10] <= 1;
	else if (in_2_vld && in_2_branch >= 'd2 && in_2_des == 'd11)
		branch_2[11] <= 1;
	else if (in_2_vld && in_2_branch >= 'd2 && in_2_des == 'd12)
		branch_2[12] <= 1;
	else if (in_2_vld && in_2_branch >= 'd2 && in_2_des == 'd13)
		branch_2[13] <= 1;
	else if (in_2_vld && in_2_branch >= 'd2 && in_2_des == 'd14)
		branch_2[14] <= 1;
	else if (in_2_vld && in_2_branch >= 'd2 && in_2_des == 'd15)
		branch_2[15] <= 1;

	else if (in_3_vld && in_3_branch >= 'd2 && in_3_des == 'd1)
		branch_2[1] <= 1;
	else if (in_3_vld && in_3_branch >= 'd2 && in_3_des == 'd2)
		branch_2[2] <= 1;
	else if (in_3_vld && in_3_branch >= 'd2 && in_3_des == 'd3)
		branch_2[3] <= 1;
	else if (in_3_vld && in_3_branch >= 'd2 && in_3_des == 'd4)
		branch_2[4] <= 1;
	else if (in_3_vld && in_3_branch >= 'd2 && in_3_des == 'd5)
		branch_2[5] <= 1;
	else if (in_3_vld && in_3_branch >= 'd2 && in_3_des == 'd6)
		branch_2[6] <= 1;
	else if (in_3_vld && in_3_branch >= 'd2 && in_3_des == 'd7)
		branch_2[7] <= 1;
	else if (in_3_vld && in_3_branch >= 'd2 && in_3_des == 'd8)
		branch_2[8] <= 1;
	else if (in_3_vld && in_3_branch >= 'd2 && in_3_des == 'd9)
		branch_2[9] <= 1;
	else if (in_3_vld && in_3_branch >= 'd2 && in_3_des == 'd10)
		branch_2[10] <= 1;
	else if (in_3_vld && in_3_branch >= 'd2 && in_3_des == 'd11)
		branch_2[11] <= 1;
	else if (in_3_vld && in_3_branch >= 'd2 && in_3_des == 'd12)
		branch_2[12] <= 1;
	else if (in_3_vld && in_3_branch >= 'd2 && in_3_des == 'd13)
		branch_2[13] <= 1;
	else if (in_3_vld && in_3_branch >= 'd2 && in_3_des == 'd14)
		branch_2[14] <= 1;
	else if (in_3_vld && in_3_branch >= 'd2 && in_3_des == 'd15)
		branch_2[15] <= 1;

	else if (in_4_vld && in_4_branch >= 'd2 && in_4_des == 'd1)
		branch_2[1] <= 1;
	else if (in_4_vld && in_4_branch >= 'd2 && in_4_des == 'd2)
		branch_2[2] <= 1;
	else if (in_4_vld && in_4_branch >= 'd2 && in_4_des == 'd3)
		branch_2[3] <= 1;
	else if (in_4_vld && in_4_branch >= 'd2 && in_4_des == 'd4)
		branch_2[4] <= 1;
	else if (in_4_vld && in_4_branch >= 'd2 && in_4_des == 'd5)
		branch_2[5] <= 1;
	else if (in_4_vld && in_4_branch >= 'd2 && in_4_des == 'd6)
		branch_2[6] <= 1;
	else if (in_4_vld && in_4_branch >= 'd2 && in_4_des == 'd7)
		branch_2[7] <= 1;
	else if (in_4_vld && in_4_branch >= 'd2 && in_4_des == 'd8)
		branch_2[8] <= 1;
	else if (in_4_vld && in_4_branch >= 'd2 && in_4_des == 'd9)
		branch_2[9] <= 1;
	else if (in_4_vld && in_4_branch >= 'd2 && in_4_des == 'd10)
		branch_2[10] <= 1;
	else if (in_4_vld && in_4_branch >= 'd2 && in_4_des == 'd11)
		branch_2[11] <= 1;
	else if (in_4_vld && in_4_branch >= 'd2 && in_4_des == 'd12)
		branch_2[12] <= 1;
	else if (in_4_vld && in_4_branch >= 'd2 && in_4_des == 'd13)
		branch_2[13] <= 1;
	else if (in_4_vld && in_4_branch >= 'd2 && in_4_des == 'd14)
		branch_2[14] <= 1;
	else if (in_4_vld && in_4_branch >= 'd2 && in_4_des == 'd15)
		branch_2[15] <= 1;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		branch_3 <= 'd0;
	else if (flush_en && flush_id <= 'd3)
		branch_3 <= 'd0;
	else if (in_1_vld && in_1_branch >= 'd3 && in_1_des == 'd1)
		branch_3[1] <= 1;
	else if (in_1_vld && in_1_branch >= 'd3 && in_1_des == 'd2)
		branch_3[2] <= 1;
	else if (in_1_vld && in_1_branch >= 'd3 && in_1_des == 'd3)
		branch_3[3] <= 1;
	else if (in_1_vld && in_1_branch >= 'd3 && in_1_des == 'd4)
		branch_3[4] <= 1;
	else if (in_1_vld && in_1_branch >= 'd3 && in_1_des == 'd5)
		branch_3[5] <= 1;
	else if (in_1_vld && in_1_branch >= 'd3 && in_1_des == 'd6)
		branch_3[6] <= 1;
	else if (in_1_vld && in_1_branch >= 'd3 && in_1_des == 'd7)
		branch_3[7] <= 1;
	else if (in_1_vld && in_1_branch >= 'd3 && in_1_des == 'd8)
		branch_3[8] <= 1;
	else if (in_1_vld && in_1_branch >= 'd3 && in_1_des == 'd9)
		branch_3[9] <= 1;
	else if (in_1_vld && in_1_branch >= 'd3 && in_1_des == 'd10)
		branch_3[10] <= 1;
	else if (in_1_vld && in_1_branch >= 'd3 && in_1_des == 'd11)
		branch_3[11] <= 1;
	else if (in_1_vld && in_1_branch >= 'd3 && in_1_des == 'd12)
		branch_3[12] <= 1;
	else if (in_1_vld && in_1_branch >= 'd3 && in_1_des == 'd13)
		branch_3[13] <= 1;
	else if (in_1_vld && in_1_branch >= 'd3 && in_1_des == 'd14)
		branch_3[14] <= 1;
	else if (in_1_vld && in_1_branch >= 'd3 && in_1_des == 'd15)
		branch_3[15] <= 1;

	else if (in_2_vld && in_2_branch >= 'd3 && in_2_des == 'd1)
		branch_3[1] <= 1;
	else if (in_2_vld && in_2_branch >= 'd3 && in_2_des == 'd2)
		branch_3[2] <= 1;
	else if (in_2_vld && in_2_branch >= 'd3 && in_2_des == 'd3)
		branch_3[3] <= 1;
	else if (in_2_vld && in_2_branch >= 'd3 && in_2_des == 'd4)
		branch_3[4] <= 1;
	else if (in_2_vld && in_2_branch >= 'd3 && in_2_des == 'd5)
		branch_3[5] <= 1;
	else if (in_2_vld && in_2_branch >= 'd3 && in_2_des == 'd6)
		branch_3[6] <= 1;
	else if (in_2_vld && in_2_branch >= 'd3 && in_2_des == 'd7)
		branch_3[7] <= 1;
	else if (in_2_vld && in_2_branch >= 'd3 && in_2_des == 'd8)
		branch_3[8] <= 1;
	else if (in_2_vld && in_2_branch >= 'd3 && in_2_des == 'd9)
		branch_3[9] <= 1;
	else if (in_2_vld && in_2_branch >= 'd3 && in_2_des == 'd10)
		branch_3[10] <= 1;
	else if (in_2_vld && in_2_branch >= 'd3 && in_2_des == 'd11)
		branch_3[11] <= 1;
	else if (in_2_vld && in_2_branch >= 'd3 && in_2_des == 'd12)
		branch_3[12] <= 1;
	else if (in_2_vld && in_2_branch >= 'd3 && in_2_des == 'd13)
		branch_3[13] <= 1;
	else if (in_2_vld && in_2_branch >= 'd3 && in_2_des == 'd14)
		branch_3[14] <= 1;
	else if (in_2_vld && in_2_branch >= 'd3 && in_2_des == 'd15)
		branch_3[15] <= 1;

	else if (in_3_vld && in_3_branch >= 'd3 && in_3_des == 'd1)
		branch_3[1] <= 1;
	else if (in_3_vld && in_3_branch >= 'd3 && in_3_des == 'd2)
		branch_3[2] <= 1;
	else if (in_3_vld && in_3_branch >= 'd3 && in_3_des == 'd3)
		branch_3[3] <= 1;
	else if (in_3_vld && in_3_branch >= 'd3 && in_3_des == 'd4)
		branch_3[4] <= 1;
	else if (in_3_vld && in_3_branch >= 'd3 && in_3_des == 'd5)
		branch_3[5] <= 1;
	else if (in_3_vld && in_3_branch >= 'd3 && in_3_des == 'd6)
		branch_3[6] <= 1;
	else if (in_3_vld && in_3_branch >= 'd3 && in_3_des == 'd7)
		branch_3[7] <= 1;
	else if (in_3_vld && in_3_branch >= 'd3 && in_3_des == 'd8)
		branch_3[8] <= 1;
	else if (in_3_vld && in_3_branch >= 'd3 && in_3_des == 'd9)
		branch_3[9] <= 1;
	else if (in_3_vld && in_3_branch >= 'd3 && in_3_des == 'd10)
		branch_3[10] <= 1;
	else if (in_3_vld && in_3_branch >= 'd3 && in_3_des == 'd11)
		branch_3[11] <= 1;
	else if (in_3_vld && in_3_branch >= 'd3 && in_3_des == 'd12)
		branch_3[12] <= 1;
	else if (in_3_vld && in_3_branch >= 'd3 && in_3_des == 'd13)
		branch_3[13] <= 1;
	else if (in_3_vld && in_3_branch >= 'd3 && in_3_des == 'd14)
		branch_3[14] <= 1;
	else if (in_3_vld && in_3_branch >= 'd3 && in_3_des == 'd15)
		branch_3[15] <= 1;

	else if (in_4_vld && in_4_branch >= 'd3 && in_4_des == 'd1)
		branch_3[1] <= 1;
	else if (in_4_vld && in_4_branch >= 'd3 && in_4_des == 'd2)
		branch_3[2] <= 1;
	else if (in_4_vld && in_4_branch >= 'd3 && in_4_des == 'd3)
		branch_3[3] <= 1;
	else if (in_4_vld && in_4_branch >= 'd3 && in_4_des == 'd4)
		branch_3[4] <= 1;
	else if (in_4_vld && in_4_branch >= 'd3 && in_4_des == 'd5)
		branch_3[5] <= 1;
	else if (in_4_vld && in_4_branch >= 'd3 && in_4_des == 'd6)
		branch_3[6] <= 1;
	else if (in_4_vld && in_4_branch >= 'd3 && in_4_des == 'd7)
		branch_3[7] <= 1;
	else if (in_4_vld && in_4_branch >= 'd3 && in_4_des == 'd8)
		branch_3[8] <= 1;
	else if (in_4_vld && in_4_branch >= 'd3 && in_4_des == 'd9)
		branch_3[9] <= 1;
	else if (in_4_vld && in_4_branch >= 'd3 && in_4_des == 'd10)
		branch_3[10] <= 1;
	else if (in_4_vld && in_4_branch >= 'd3 && in_4_des == 'd11)
		branch_3[11] <= 1;
	else if (in_4_vld && in_4_branch >= 'd3 && in_4_des == 'd12)
		branch_3[12] <= 1;
	else if (in_4_vld && in_4_branch >= 'd3 && in_4_des == 'd13)
		branch_3[13] <= 1;
	else if (in_4_vld && in_4_branch >= 'd3 && in_4_des == 'd14)
		branch_3[14] <= 1;
	else if (in_4_vld && in_4_branch >= 'd3 && in_4_des == 'd15)
		branch_3[15] <= 1;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		branch_4 <= 'd0;
	else if (flush_en && flush_id <= 'd4)
		branch_4 <= 'd0;
	else if (in_1_vld && in_1_branch >= 'd4 && in_1_des == 'd1)
		branch_4[1] <= 1;
	else if (in_1_vld && in_1_branch >= 'd4 && in_1_des == 'd2)
		branch_4[2] <= 1;
	else if (in_1_vld && in_1_branch >= 'd4 && in_1_des == 'd3)
		branch_4[3] <= 1;
	else if (in_1_vld && in_1_branch >= 'd4 && in_1_des == 'd4)
		branch_4[4] <= 1;
	else if (in_1_vld && in_1_branch >= 'd4 && in_1_des == 'd5)
		branch_4[5] <= 1;
	else if (in_1_vld && in_1_branch >= 'd4 && in_1_des == 'd6)
		branch_4[6] <= 1;
	else if (in_1_vld && in_1_branch >= 'd4 && in_1_des == 'd7)
		branch_4[7] <= 1;
	else if (in_1_vld && in_1_branch >= 'd4 && in_1_des == 'd8)
		branch_4[8] <= 1;
	else if (in_1_vld && in_1_branch >= 'd4 && in_1_des == 'd9)
		branch_4[9] <= 1;
	else if (in_1_vld && in_1_branch >= 'd4 && in_1_des == 'd10)
		branch_4[10] <= 1;
	else if (in_1_vld && in_1_branch >= 'd4 && in_1_des == 'd11)
		branch_4[11] <= 1;
	else if (in_1_vld && in_1_branch >= 'd4 && in_1_des == 'd12)
		branch_4[12] <= 1;
	else if (in_1_vld && in_1_branch >= 'd4 && in_1_des == 'd13)
		branch_4[13] <= 1;
	else if (in_1_vld && in_1_branch >= 'd4 && in_1_des == 'd14)
		branch_4[14] <= 1;
	else if (in_1_vld && in_1_branch >= 'd4 && in_1_des == 'd15)
		branch_4[15] <= 1;

	else if (in_2_vld && in_2_branch >= 'd4 && in_2_des == 'd1)
		branch_4[1] <= 1;
	else if (in_2_vld && in_2_branch >= 'd4 && in_2_des == 'd2)
		branch_4[2] <= 1;
	else if (in_2_vld && in_2_branch >= 'd4 && in_2_des == 'd3)
		branch_4[3] <= 1;
	else if (in_2_vld && in_2_branch >= 'd4 && in_2_des == 'd4)
		branch_4[4] <= 1;
	else if (in_2_vld && in_2_branch >= 'd4 && in_2_des == 'd5)
		branch_4[5] <= 1;
	else if (in_2_vld && in_2_branch >= 'd4 && in_2_des == 'd6)
		branch_4[6] <= 1;
	else if (in_2_vld && in_2_branch >= 'd4 && in_2_des == 'd7)
		branch_4[7] <= 1;
	else if (in_2_vld && in_2_branch >= 'd4 && in_2_des == 'd8)
		branch_4[8] <= 1;
	else if (in_2_vld && in_2_branch >= 'd4 && in_2_des == 'd9)
		branch_4[9] <= 1;
	else if (in_2_vld && in_2_branch >= 'd4 && in_2_des == 'd10)
		branch_4[10] <= 1;
	else if (in_2_vld && in_2_branch >= 'd4 && in_2_des == 'd11)
		branch_4[11] <= 1;
	else if (in_2_vld && in_2_branch >= 'd4 && in_2_des == 'd12)
		branch_4[12] <= 1;
	else if (in_2_vld && in_2_branch >= 'd4 && in_2_des == 'd13)
		branch_4[13] <= 1;
	else if (in_2_vld && in_2_branch >= 'd4 && in_2_des == 'd14)
		branch_4[14] <= 1;
	else if (in_2_vld && in_2_branch >= 'd4 && in_2_des == 'd15)
		branch_4[15] <= 1;

	else if (in_3_vld && in_3_branch >= 'd4 && in_3_des == 'd1)
		branch_4[1] <= 1;
	else if (in_3_vld && in_3_branch >= 'd4 && in_3_des == 'd2)
		branch_4[2] <= 1;
	else if (in_3_vld && in_3_branch >= 'd4 && in_3_des == 'd3)
		branch_4[3] <= 1;
	else if (in_3_vld && in_3_branch >= 'd4 && in_3_des == 'd4)
		branch_4[4] <= 1;
	else if (in_3_vld && in_3_branch >= 'd4 && in_3_des == 'd5)
		branch_4[5] <= 1;
	else if (in_3_vld && in_3_branch >= 'd4 && in_3_des == 'd6)
		branch_4[6] <= 1;
	else if (in_3_vld && in_3_branch >= 'd4 && in_3_des == 'd7)
		branch_4[7] <= 1;
	else if (in_3_vld && in_3_branch >= 'd4 && in_3_des == 'd8)
		branch_4[8] <= 1;
	else if (in_3_vld && in_3_branch >= 'd4 && in_3_des == 'd9)
		branch_4[9] <= 1;
	else if (in_3_vld && in_3_branch >= 'd4 && in_3_des == 'd10)
		branch_4[10] <= 1;
	else if (in_3_vld && in_3_branch >= 'd4 && in_3_des == 'd11)
		branch_4[11] <= 1;
	else if (in_3_vld && in_3_branch >= 'd4 && in_3_des == 'd12)
		branch_4[12] <= 1;
	else if (in_3_vld && in_3_branch >= 'd4 && in_3_des == 'd13)
		branch_4[13] <= 1;
	else if (in_3_vld && in_3_branch >= 'd4 && in_3_des == 'd14)
		branch_4[14] <= 1;
	else if (in_3_vld && in_3_branch >= 'd4 && in_3_des == 'd15)
		branch_4[15] <= 1;

	else if (in_4_vld && in_4_branch >= 'd4 && in_4_des == 'd1)
		branch_4[1] <= 1;
	else if (in_4_vld && in_4_branch >= 'd4 && in_4_des == 'd2)
		branch_4[2] <= 1;
	else if (in_4_vld && in_4_branch >= 'd4 && in_4_des == 'd3)
		branch_4[3] <= 1;
	else if (in_4_vld && in_4_branch >= 'd4 && in_4_des == 'd4)
		branch_4[4] <= 1;
	else if (in_4_vld && in_4_branch >= 'd4 && in_4_des == 'd5)
		branch_4[5] <= 1;
	else if (in_4_vld && in_4_branch >= 'd4 && in_4_des == 'd6)
		branch_4[6] <= 1;
	else if (in_4_vld && in_4_branch >= 'd4 && in_4_des == 'd7)
		branch_4[7] <= 1;
	else if (in_4_vld && in_4_branch >= 'd4 && in_4_des == 'd8)
		branch_4[8] <= 1;
	else if (in_4_vld && in_4_branch >= 'd4 && in_4_des == 'd9)
		branch_4[9] <= 1;
	else if (in_4_vld && in_4_branch >= 'd4 && in_4_des == 'd10)
		branch_4[10] <= 1;
	else if (in_4_vld && in_4_branch >= 'd4 && in_4_des == 'd11)
		branch_4[11] <= 1;
	else if (in_4_vld && in_4_branch >= 'd4 && in_4_des == 'd12)
		branch_4[12] <= 1;
	else if (in_4_vld && in_4_branch >= 'd4 && in_4_des == 'd13)
		branch_4[13] <= 1;
	else if (in_4_vld && in_4_branch >= 'd4 && in_4_des == 'd14)
		branch_4[14] <= 1;
	else if (in_4_vld && in_4_branch >= 'd4 && in_4_des == 'd15)
		branch_4[15] <= 1;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		branch_5 <= 'd0;
	else if (flush_en && flush_id <= 'd5)
		branch_5 <= 'd0;
	else if (in_1_vld && in_1_branch >= 'd5 && in_1_des == 'd1)
		branch_5[1] <= 1;
	else if (in_1_vld && in_1_branch >= 'd5 && in_1_des == 'd2)
		branch_5[2] <= 1;
	else if (in_1_vld && in_1_branch >= 'd5 && in_1_des == 'd3)
		branch_5[3] <= 1;
	else if (in_1_vld && in_1_branch >= 'd5 && in_1_des == 'd4)
		branch_5[4] <= 1;
	else if (in_1_vld && in_1_branch >= 'd5 && in_1_des == 'd5)
		branch_5[5] <= 1;
	else if (in_1_vld && in_1_branch >= 'd5 && in_1_des == 'd6)
		branch_5[6] <= 1;
	else if (in_1_vld && in_1_branch >= 'd5 && in_1_des == 'd7)
		branch_5[7] <= 1;
	else if (in_1_vld && in_1_branch >= 'd5 && in_1_des == 'd8)
		branch_5[8] <= 1;
	else if (in_1_vld && in_1_branch >= 'd5 && in_1_des == 'd9)
		branch_5[9] <= 1;
	else if (in_1_vld && in_1_branch >= 'd5 && in_1_des == 'd10)
		branch_5[10] <= 1;
	else if (in_1_vld && in_1_branch >= 'd5 && in_1_des == 'd11)
		branch_5[11] <= 1;
	else if (in_1_vld && in_1_branch >= 'd5 && in_1_des == 'd12)
		branch_5[12] <= 1;
	else if (in_1_vld && in_1_branch >= 'd5 && in_1_des == 'd13)
		branch_5[13] <= 1;
	else if (in_1_vld && in_1_branch >= 'd5 && in_1_des == 'd14)
		branch_5[14] <= 1;
	else if (in_1_vld && in_1_branch >= 'd5 && in_1_des == 'd15)
		branch_5[15] <= 1;

	else if (in_2_vld && in_2_branch >= 'd5 && in_2_des == 'd1)
		branch_5[1] <= 1;
	else if (in_2_vld && in_2_branch >= 'd5 && in_2_des == 'd2)
		branch_5[2] <= 1;
	else if (in_2_vld && in_2_branch >= 'd5 && in_2_des == 'd3)
		branch_5[3] <= 1;
	else if (in_2_vld && in_2_branch >= 'd5 && in_2_des == 'd4)
		branch_5[4] <= 1;
	else if (in_2_vld && in_2_branch >= 'd5 && in_2_des == 'd5)
		branch_5[5] <= 1;
	else if (in_2_vld && in_2_branch >= 'd5 && in_2_des == 'd6)
		branch_5[6] <= 1;
	else if (in_2_vld && in_2_branch >= 'd5 && in_2_des == 'd7)
		branch_5[7] <= 1;
	else if (in_2_vld && in_2_branch >= 'd5 && in_2_des == 'd8)
		branch_5[8] <= 1;
	else if (in_2_vld && in_2_branch >= 'd5 && in_2_des == 'd9)
		branch_5[9] <= 1;
	else if (in_2_vld && in_2_branch >= 'd5 && in_2_des == 'd10)
		branch_5[10] <= 1;
	else if (in_2_vld && in_2_branch >= 'd5 && in_2_des == 'd11)
		branch_5[11] <= 1;
	else if (in_2_vld && in_2_branch >= 'd5 && in_2_des == 'd12)
		branch_5[12] <= 1;
	else if (in_2_vld && in_2_branch >= 'd5 && in_2_des == 'd13)
		branch_5[13] <= 1;
	else if (in_2_vld && in_2_branch >= 'd5 && in_2_des == 'd14)
		branch_5[14] <= 1;
	else if (in_2_vld && in_2_branch >= 'd5 && in_2_des == 'd15)
		branch_5[15] <= 1;

	else if (in_3_vld && in_3_branch >= 'd5 && in_3_des == 'd1)
		branch_5[1] <= 1;
	else if (in_3_vld && in_3_branch >= 'd5 && in_3_des == 'd2)
		branch_5[2] <= 1;
	else if (in_3_vld && in_3_branch >= 'd5 && in_3_des == 'd3)
		branch_5[3] <= 1;
	else if (in_3_vld && in_3_branch >= 'd5 && in_3_des == 'd4)
		branch_5[4] <= 1;
	else if (in_3_vld && in_3_branch >= 'd5 && in_3_des == 'd5)
		branch_5[5] <= 1;
	else if (in_3_vld && in_3_branch >= 'd5 && in_3_des == 'd6)
		branch_5[6] <= 1;
	else if (in_3_vld && in_3_branch >= 'd5 && in_3_des == 'd7)
		branch_5[7] <= 1;
	else if (in_3_vld && in_3_branch >= 'd5 && in_3_des == 'd8)
		branch_5[8] <= 1;
	else if (in_3_vld && in_3_branch >= 'd5 && in_3_des == 'd9)
		branch_5[9] <= 1;
	else if (in_3_vld && in_3_branch >= 'd5 && in_3_des == 'd10)
		branch_5[10] <= 1;
	else if (in_3_vld && in_3_branch >= 'd5 && in_3_des == 'd11)
		branch_5[11] <= 1;
	else if (in_3_vld && in_3_branch >= 'd5 && in_3_des == 'd12)
		branch_5[12] <= 1;
	else if (in_3_vld && in_3_branch >= 'd5 && in_3_des == 'd13)
		branch_5[13] <= 1;
	else if (in_3_vld && in_3_branch >= 'd5 && in_3_des == 'd14)
		branch_5[14] <= 1;
	else if (in_3_vld && in_3_branch >= 'd5 && in_3_des == 'd15)
		branch_5[15] <= 1;

	else if (in_4_vld && in_4_branch >= 'd5 && in_4_des == 'd1)
		branch_5[1] <= 1;
	else if (in_4_vld && in_4_branch >= 'd5 && in_4_des == 'd2)
		branch_5[2] <= 1;
	else if (in_4_vld && in_4_branch >= 'd5 && in_4_des == 'd3)
		branch_5[3] <= 1;
	else if (in_4_vld && in_4_branch >= 'd5 && in_4_des == 'd4)
		branch_5[4] <= 1;
	else if (in_4_vld && in_4_branch >= 'd5 && in_4_des == 'd5)
		branch_5[5] <= 1;
	else if (in_4_vld && in_4_branch >= 'd5 && in_4_des == 'd6)
		branch_5[6] <= 1;
	else if (in_4_vld && in_4_branch >= 'd5 && in_4_des == 'd7)
		branch_5[7] <= 1;
	else if (in_4_vld && in_4_branch >= 'd5 && in_4_des == 'd8)
		branch_5[8] <= 1;
	else if (in_4_vld && in_4_branch >= 'd5 && in_4_des == 'd9)
		branch_5[9] <= 1;
	else if (in_4_vld && in_4_branch >= 'd5 && in_4_des == 'd10)
		branch_5[10] <= 1;
	else if (in_4_vld && in_4_branch >= 'd5 && in_4_des == 'd11)
		branch_5[11] <= 1;
	else if (in_4_vld && in_4_branch >= 'd5 && in_4_des == 'd12)
		branch_5[12] <= 1;
	else if (in_4_vld && in_4_branch >= 'd5 && in_4_des == 'd13)
		branch_5[13] <= 1;
	else if (in_4_vld && in_4_branch >= 'd5 && in_4_des == 'd14)
		branch_5[14] <= 1;
	else if (in_4_vld && in_4_branch >= 'd5 && in_4_des == 'd15)
		branch_5[15] <= 1;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		branch_6 <= 'd0;
	else if (flush_en && flush_id <= 'd6)
		branch_6 <= 'd0;
	else if (in_1_vld && in_1_branch >= 'd6 && in_1_des == 'd1)
		branch_6[1] <= 1;
	else if (in_1_vld && in_1_branch >= 'd6 && in_1_des == 'd2)
		branch_6[2] <= 1;
	else if (in_1_vld && in_1_branch >= 'd6 && in_1_des == 'd3)
		branch_6[3] <= 1;
	else if (in_1_vld && in_1_branch >= 'd6 && in_1_des == 'd4)
		branch_6[4] <= 1;
	else if (in_1_vld && in_1_branch >= 'd6 && in_1_des == 'd5)
		branch_6[5] <= 1;
	else if (in_1_vld && in_1_branch >= 'd6 && in_1_des == 'd6)
		branch_6[6] <= 1;
	else if (in_1_vld && in_1_branch >= 'd6 && in_1_des == 'd7)
		branch_6[7] <= 1;
	else if (in_1_vld && in_1_branch >= 'd6 && in_1_des == 'd8)
		branch_6[8] <= 1;
	else if (in_1_vld && in_1_branch >= 'd6 && in_1_des == 'd9)
		branch_6[9] <= 1;
	else if (in_1_vld && in_1_branch >= 'd6 && in_1_des == 'd10)
		branch_6[10] <= 1;
	else if (in_1_vld && in_1_branch >= 'd6 && in_1_des == 'd11)
		branch_6[11] <= 1;
	else if (in_1_vld && in_1_branch >= 'd6 && in_1_des == 'd12)
		branch_6[12] <= 1;
	else if (in_1_vld && in_1_branch >= 'd6 && in_1_des == 'd13)
		branch_6[13] <= 1;
	else if (in_1_vld && in_1_branch >= 'd6 && in_1_des == 'd14)
		branch_6[14] <= 1;
	else if (in_1_vld && in_1_branch >= 'd6 && in_1_des == 'd15)
		branch_6[15] <= 1;

	else if (in_2_vld && in_2_branch >= 'd6 && in_2_des == 'd1)
		branch_6[1] <= 1;
	else if (in_2_vld && in_2_branch >= 'd6 && in_2_des == 'd2)
		branch_6[2] <= 1;
	else if (in_2_vld && in_2_branch >= 'd6 && in_2_des == 'd3)
		branch_6[3] <= 1;
	else if (in_2_vld && in_2_branch >= 'd6 && in_2_des == 'd4)
		branch_6[4] <= 1;
	else if (in_2_vld && in_2_branch >= 'd6 && in_2_des == 'd5)
		branch_6[5] <= 1;
	else if (in_2_vld && in_2_branch >= 'd6 && in_2_des == 'd6)
		branch_6[6] <= 1;
	else if (in_2_vld && in_2_branch >= 'd6 && in_2_des == 'd7)
		branch_6[7] <= 1;
	else if (in_2_vld && in_2_branch >= 'd6 && in_2_des == 'd8)
		branch_6[8] <= 1;
	else if (in_2_vld && in_2_branch >= 'd6 && in_2_des == 'd9)
		branch_6[9] <= 1;
	else if (in_2_vld && in_2_branch >= 'd6 && in_2_des == 'd10)
		branch_6[10] <= 1;
	else if (in_2_vld && in_2_branch >= 'd6 && in_2_des == 'd11)
		branch_6[11] <= 1;
	else if (in_2_vld && in_2_branch >= 'd6 && in_2_des == 'd12)
		branch_6[12] <= 1;
	else if (in_2_vld && in_2_branch >= 'd6 && in_2_des == 'd13)
		branch_6[13] <= 1;
	else if (in_2_vld && in_2_branch >= 'd6 && in_2_des == 'd14)
		branch_6[14] <= 1;
	else if (in_2_vld && in_2_branch >= 'd6 && in_2_des == 'd15)
		branch_6[15] <= 1;

	else if (in_3_vld && in_3_branch >= 'd6 && in_3_des == 'd1)
		branch_6[1] <= 1;
	else if (in_3_vld && in_3_branch >= 'd6 && in_3_des == 'd2)
		branch_6[2] <= 1;
	else if (in_3_vld && in_3_branch >= 'd6 && in_3_des == 'd3)
		branch_6[3] <= 1;
	else if (in_3_vld && in_3_branch >= 'd6 && in_3_des == 'd4)
		branch_6[4] <= 1;
	else if (in_3_vld && in_3_branch >= 'd6 && in_3_des == 'd5)
		branch_6[5] <= 1;
	else if (in_3_vld && in_3_branch >= 'd6 && in_3_des == 'd6)
		branch_6[6] <= 1;
	else if (in_3_vld && in_3_branch >= 'd6 && in_3_des == 'd7)
		branch_6[7] <= 1;
	else if (in_3_vld && in_3_branch >= 'd6 && in_3_des == 'd8)
		branch_6[8] <= 1;
	else if (in_3_vld && in_3_branch >= 'd6 && in_3_des == 'd9)
		branch_6[9] <= 1;
	else if (in_3_vld && in_3_branch >= 'd6 && in_3_des == 'd10)
		branch_6[10] <= 1;
	else if (in_3_vld && in_3_branch >= 'd6 && in_3_des == 'd11)
		branch_6[11] <= 1;
	else if (in_3_vld && in_3_branch >= 'd6 && in_3_des == 'd12)
		branch_6[12] <= 1;
	else if (in_3_vld && in_3_branch >= 'd6 && in_3_des == 'd13)
		branch_6[13] <= 1;
	else if (in_3_vld && in_3_branch >= 'd6 && in_3_des == 'd14)
		branch_6[14] <= 1;
	else if (in_3_vld && in_3_branch >= 'd6 && in_3_des == 'd15)
		branch_6[15] <= 1;

	else if (in_4_vld && in_4_branch >= 'd6 && in_4_des == 'd1)
		branch_6[1] <= 1;
	else if (in_4_vld && in_4_branch >= 'd6 && in_4_des == 'd2)
		branch_6[2] <= 1;
	else if (in_4_vld && in_4_branch >= 'd6 && in_4_des == 'd3)
		branch_6[3] <= 1;
	else if (in_4_vld && in_4_branch >= 'd6 && in_4_des == 'd4)
		branch_6[4] <= 1;
	else if (in_4_vld && in_4_branch >= 'd6 && in_4_des == 'd5)
		branch_6[5] <= 1;
	else if (in_4_vld && in_4_branch >= 'd6 && in_4_des == 'd6)
		branch_6[6] <= 1;
	else if (in_4_vld && in_4_branch >= 'd6 && in_4_des == 'd7)
		branch_6[7] <= 1;
	else if (in_4_vld && in_4_branch >= 'd6 && in_4_des == 'd8)
		branch_6[8] <= 1;
	else if (in_4_vld && in_4_branch >= 'd6 && in_4_des == 'd9)
		branch_6[9] <= 1;
	else if (in_4_vld && in_4_branch >= 'd6 && in_4_des == 'd10)
		branch_6[10] <= 1;
	else if (in_4_vld && in_4_branch >= 'd6 && in_4_des == 'd11)
		branch_6[11] <= 1;
	else if (in_4_vld && in_4_branch >= 'd6 && in_4_des == 'd12)
		branch_6[12] <= 1;
	else if (in_4_vld && in_4_branch >= 'd6 && in_4_des == 'd13)
		branch_6[13] <= 1;
	else if (in_4_vld && in_4_branch >= 'd6 && in_4_des == 'd14)
		branch_6[14] <= 1;
	else if (in_4_vld && in_4_branch >= 'd6 && in_4_des == 'd15)
		branch_6[15] <= 1;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		branch_7 <= 'd0;
	else if (flush_en && flush_id <= 'd7)
		branch_7 <= 'd0;
	else if (in_1_vld && in_1_branch >= 'd7 && in_1_des == 'd1)
		branch_7[1] <= 1;
	else if (in_1_vld && in_1_branch >= 'd7 && in_1_des == 'd2)
		branch_7[2] <= 1;
	else if (in_1_vld && in_1_branch >= 'd7 && in_1_des == 'd3)
		branch_7[3] <= 1;
	else if (in_1_vld && in_1_branch >= 'd7 && in_1_des == 'd4)
		branch_7[4] <= 1;
	else if (in_1_vld && in_1_branch >= 'd7 && in_1_des == 'd5)
		branch_7[5] <= 1;
	else if (in_1_vld && in_1_branch >= 'd7 && in_1_des == 'd6)
		branch_7[6] <= 1;
	else if (in_1_vld && in_1_branch >= 'd7 && in_1_des == 'd7)
		branch_7[7] <= 1;
	else if (in_1_vld && in_1_branch >= 'd7 && in_1_des == 'd8)
		branch_7[8] <= 1;
	else if (in_1_vld && in_1_branch >= 'd7 && in_1_des == 'd9)
		branch_7[9] <= 1;
	else if (in_1_vld && in_1_branch >= 'd7 && in_1_des == 'd10)
		branch_7[10] <= 1;
	else if (in_1_vld && in_1_branch >= 'd7 && in_1_des == 'd11)
		branch_7[11] <= 1;
	else if (in_1_vld && in_1_branch >= 'd7 && in_1_des == 'd12)
		branch_7[12] <= 1;
	else if (in_1_vld && in_1_branch >= 'd7 && in_1_des == 'd13)
		branch_7[13] <= 1;
	else if (in_1_vld && in_1_branch >= 'd7 && in_1_des == 'd14)
		branch_7[14] <= 1;
	else if (in_1_vld && in_1_branch >= 'd7 && in_1_des == 'd15)
		branch_7[15] <= 1;

	else if (in_2_vld && in_2_branch >= 'd7 && in_2_des == 'd1)
		branch_7[1] <= 1;
	else if (in_2_vld && in_2_branch >= 'd7 && in_2_des == 'd2)
		branch_7[2] <= 1;
	else if (in_2_vld && in_2_branch >= 'd7 && in_2_des == 'd3)
		branch_7[3] <= 1;
	else if (in_2_vld && in_2_branch >= 'd7 && in_2_des == 'd4)
		branch_7[4] <= 1;
	else if (in_2_vld && in_2_branch >= 'd7 && in_2_des == 'd5)
		branch_7[5] <= 1;
	else if (in_2_vld && in_2_branch >= 'd7 && in_2_des == 'd6)
		branch_7[6] <= 1;
	else if (in_2_vld && in_2_branch >= 'd7 && in_2_des == 'd7)
		branch_7[7] <= 1;
	else if (in_2_vld && in_2_branch >= 'd7 && in_2_des == 'd8)
		branch_7[8] <= 1;
	else if (in_2_vld && in_2_branch >= 'd7 && in_2_des == 'd9)
		branch_7[9] <= 1;
	else if (in_2_vld && in_2_branch >= 'd7 && in_2_des == 'd10)
		branch_7[10] <= 1;
	else if (in_2_vld && in_2_branch >= 'd7 && in_2_des == 'd11)
		branch_7[11] <= 1;
	else if (in_2_vld && in_2_branch >= 'd7 && in_2_des == 'd12)
		branch_7[12] <= 1;
	else if (in_2_vld && in_2_branch >= 'd7 && in_2_des == 'd13)
		branch_7[13] <= 1;
	else if (in_2_vld && in_2_branch >= 'd7 && in_2_des == 'd14)
		branch_7[14] <= 1;
	else if (in_2_vld && in_2_branch >= 'd7 && in_2_des == 'd15)
		branch_7[15] <= 1;

	else if (in_3_vld && in_3_branch >= 'd7 && in_3_des == 'd1)
		branch_7[1] <= 1;
	else if (in_3_vld && in_3_branch >= 'd7 && in_3_des == 'd2)
		branch_7[2] <= 1;
	else if (in_3_vld && in_3_branch >= 'd7 && in_3_des == 'd3)
		branch_7[3] <= 1;
	else if (in_3_vld && in_3_branch >= 'd7 && in_3_des == 'd4)
		branch_7[4] <= 1;
	else if (in_3_vld && in_3_branch >= 'd7 && in_3_des == 'd5)
		branch_7[5] <= 1;
	else if (in_3_vld && in_3_branch >= 'd7 && in_3_des == 'd6)
		branch_7[6] <= 1;
	else if (in_3_vld && in_3_branch >= 'd7 && in_3_des == 'd7)
		branch_7[7] <= 1;
	else if (in_3_vld && in_3_branch >= 'd7 && in_3_des == 'd8)
		branch_7[8] <= 1;
	else if (in_3_vld && in_3_branch >= 'd7 && in_3_des == 'd9)
		branch_7[9] <= 1;
	else if (in_3_vld && in_3_branch >= 'd7 && in_3_des == 'd10)
		branch_7[10] <= 1;
	else if (in_3_vld && in_3_branch >= 'd7 && in_3_des == 'd11)
		branch_7[11] <= 1;
	else if (in_3_vld && in_3_branch >= 'd7 && in_3_des == 'd12)
		branch_7[12] <= 1;
	else if (in_3_vld && in_3_branch >= 'd7 && in_3_des == 'd13)
		branch_7[13] <= 1;
	else if (in_3_vld && in_3_branch >= 'd7 && in_3_des == 'd14)
		branch_7[14] <= 1;
	else if (in_3_vld && in_3_branch >= 'd7 && in_3_des == 'd15)
		branch_7[15] <= 1;

	else if (in_4_vld && in_4_branch >= 'd7 && in_4_des == 'd1)
		branch_7[1] <= 1;
	else if (in_4_vld && in_4_branch >= 'd7 && in_4_des == 'd2)
		branch_7[2] <= 1;
	else if (in_4_vld && in_4_branch >= 'd7 && in_4_des == 'd3)
		branch_7[3] <= 1;
	else if (in_4_vld && in_4_branch >= 'd7 && in_4_des == 'd4)
		branch_7[4] <= 1;
	else if (in_4_vld && in_4_branch >= 'd7 && in_4_des == 'd5)
		branch_7[5] <= 1;
	else if (in_4_vld && in_4_branch >= 'd7 && in_4_des == 'd6)
		branch_7[6] <= 1;
	else if (in_4_vld && in_4_branch >= 'd7 && in_4_des == 'd7)
		branch_7[7] <= 1;
	else if (in_4_vld && in_4_branch >= 'd7 && in_4_des == 'd8)
		branch_7[8] <= 1;
	else if (in_4_vld && in_4_branch >= 'd7 && in_4_des == 'd9)
		branch_7[9] <= 1;
	else if (in_4_vld && in_4_branch >= 'd7 && in_4_des == 'd10)
		branch_7[10] <= 1;
	else if (in_4_vld && in_4_branch >= 'd7 && in_4_des == 'd11)
		branch_7[11] <= 1;
	else if (in_4_vld && in_4_branch >= 'd7 && in_4_des == 'd12)
		branch_7[12] <= 1;
	else if (in_4_vld && in_4_branch >= 'd7 && in_4_des == 'd13)
		branch_7[13] <= 1;
	else if (in_4_vld && in_4_branch >= 'd7 && in_4_des == 'd14)
		branch_7[14] <= 1;
	else if (in_4_vld && in_4_branch >= 'd7 && in_4_des == 'd15)
		branch_7[15] <= 1;
end

//////////////////////////////////////////////////////////////////

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_0 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd0)
	begin
		buf_0[buffer_total-1] <= 'd1;
		buf_0[buffer_total-2] <= 'd0;
		buf_0[branch_id-1:0] <= in_1_branch;
		buf_0[branch_id+des-1:branch_id] <= in_1_des;
		buf_0[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_0[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd0)
	begin
		buf_0[buffer_total-1] <= 'd1;
		buf_0[buffer_total-2] <= 'd0;
		buf_0[branch_id-1:0] <= in_2_branch;
		buf_0[branch_id+des-1:branch_id] <= in_2_des;
		buf_0[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_0[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd0)
	begin
		buf_0[buffer_total-1] <= 'd1;
		buf_0[buffer_total-2] <= 'd0;
		buf_0[branch_id-1:0] <= in_3_branch;
		buf_0[branch_id+des-1:branch_id] <= in_3_des;
		buf_0[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_0[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd0)
	begin
		buf_0[buffer_total-1] <= 'd1;
		buf_0[buffer_total-2] <= 'd0;
		buf_0[branch_id-1:0] <= in_4_branch;
		buf_0[branch_id+des-1:branch_id] <= in_4_des;
		buf_0[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_0[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_0[buffer_total-1])
	begin
		if (shift_amount_1 == 'd1)
			buf_0 <= buf_1;
		else if (shift_amount_2 == 'd2)
			buf_0 <= buf_2;
		else if (shift_amount_3 == 'd3)
			buf_0 <= buf_3;
		else if (shift_amount_rest == 'd4)
			buf_0 <= buf_4;
	end
	else if (flush_en && flush_id <= buf_0[branch_id-1:0])
		buf_0 <= 'd0;
end
/*
always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_0 <= 'd0;
	else if (buf_0[buffer_total-1])
	begin
		if (shift_amount_1 == 'd1)
			buf_0 <= buf_1;
		else if (shift_amount_2 == 'd2)
			buf_0 <= buf_2;
		else if (shift_amount_3 == 'd3)
			buf_0 <= buf_3;
		else if (shift_amount_rest == 'd4)
			buf_0 <= buf_4;
	end
	else if (~buf_0[buffer_total-1])
	begin
		if (in_1_vld && in_addr_1 == 'd0)
		begin
			buf_0[buffer_total-1] <= 'd1;
			buf_0[buffer_total-2] <= 'd0;
			buf_0[branch_id-1:0] <= in_1_branch;
			buf_0[branch_id+des-1:branch_id] <= in_1_des;
			buf_0[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
			buf_0[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
		end
		else if (in_2_vld && in_addr_2 == 'd0)
		begin
			buf_0[buffer_total-1] <= 'd1;
			buf_0[buffer_total-2] <= 'd0;
			buf_0[branch_id-1:0] <= in_2_branch;
			buf_0[branch_id+des-1:branch_id] <= in_2_des;
			buf_0[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
			buf_0[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
		end
		else if (in_3_vld && in_addr_3 == 'd0)
		begin
			buf_0[buffer_total-1] <= 'd1;
			buf_0[buffer_total-2] <= 'd0;
			buf_0[branch_id-1:0] <= in_3_branch;
			buf_0[branch_id+des-1:branch_id] <= in_3_des;
			buf_0[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
			buf_0[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
		end
		else if (in_4_vld && in_addr_4 == 'd0)
		begin
			buf_0[buffer_total-1] <= 'd1;
			buf_0[buffer_total-2] <= 'd0;
			buf_0[branch_id-1:0] <= in_4_branch;
			buf_0[branch_id+des-1:branch_id] <= in_4_des;
			buf_0[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
			buf_0[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
		end
	end
	else if (flush_en && flush_id <= buf_0[branch_id-1:0])
		buf_0 <= 'd0;
end
*/

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_1 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd1)
	begin
		buf_1[buffer_total-1] <= 'd1;
		buf_1[buffer_total-2] <= 'd0;
		buf_1[branch_id-1:0] <= in_1_branch;
		buf_1[branch_id+des-1:branch_id] <= in_1_des;
		buf_1[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_1[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd1)
	begin
		buf_1[buffer_total-1] <= 'd1;
		buf_1[buffer_total-2] <= 'd0;
		buf_1[branch_id-1:0] <= in_2_branch;
		buf_1[branch_id+des-1:branch_id] <= in_2_des;
		buf_1[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_1[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd1)
	begin
		buf_1[buffer_total-1] <= 'd1;
		buf_1[buffer_total-2] <= 'd0;
		buf_1[branch_id-1:0] <= in_3_branch;
		buf_1[branch_id+des-1:branch_id] <= in_3_des;
		buf_1[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_1[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd1)
	begin
		buf_1[buffer_total-1] <= 'd1;
		buf_1[buffer_total-2] <= 'd0;
		buf_1[branch_id-1:0] <= in_4_branch;
		buf_1[branch_id+des-1:branch_id] <= in_4_des;
		buf_1[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_1[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_1[buffer_total-1])
	begin
		if (shift_amount_2 == 'd1)
			buf_1 <= buf_2;
		else if (shift_amount_3 == 'd2)
			buf_1 <= buf_3;
		else if (shift_amount_rest == 'd3)
			buf_1 <= buf_4;
		else if (shift_amount_rest == 'd4)
			buf_1 <= buf_5;
	end
	else if (flush_en && flush_id <= buf_1[branch_id-1:0])
		buf_1 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_2 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd2)
	begin
		buf_2[buffer_total-1] <= 'd1;
		buf_2[buffer_total-2] <= 'd0;
		buf_2[branch_id-1:0] <= in_1_branch;
		buf_2[branch_id+des-1:branch_id] <= in_1_des;
		buf_2[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_2[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd2)
	begin
		buf_2[buffer_total-1] <= 'd1;
		buf_2[buffer_total-2] <= 'd0;
		buf_2[branch_id-1:0] <= in_2_branch;
		buf_2[branch_id+des-1:branch_id] <= in_2_des;
		buf_2[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_2[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd2)
	begin
		buf_2[buffer_total-1] <= 'd1;
		buf_2[buffer_total-2] <= 'd0;
		buf_2[branch_id-1:0] <= in_3_branch;
		buf_2[branch_id+des-1:branch_id] <= in_3_des;
		buf_2[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_2[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd2)
	begin
		buf_2[buffer_total-1] <= 'd1;
		buf_2[buffer_total-2] <= 'd0;
		buf_2[branch_id-1:0] <= in_4_branch;
		buf_2[branch_id+des-1:branch_id] <= in_4_des;
		buf_2[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_2[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_2[buffer_total-1])
	begin
		if (shift_amount_3 == 'd1)
			buf_2 <= buf_3;
		else if (shift_amount_rest == 'd2)
			buf_2 <= buf_4;
		else if (shift_amount_rest == 'd3)
			buf_2 <= buf_5;
		else if (shift_amount_rest == 'd4)
			buf_2 <= buf_6;
	end
	else if (flush_en && flush_id <= buf_2[branch_id-1:0])
		buf_2 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_3 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd3)
	begin
		buf_3[buffer_total-1] <= 'd1;
		buf_3[buffer_total-2] <= 'd0;
		buf_3[branch_id-1:0] <= in_1_branch;
		buf_3[branch_id+des-1:branch_id] <= in_1_des;
		buf_3[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_3[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd3)
	begin
		buf_3[buffer_total-1] <= 'd1;
		buf_3[buffer_total-2] <= 'd0;
		buf_3[branch_id-1:0] <= in_2_branch;
		buf_3[branch_id+des-1:branch_id] <= in_2_des;
		buf_3[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_3[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd3)
	begin
		buf_3[buffer_total-1] <= 'd1;
		buf_3[buffer_total-2] <= 'd0;
		buf_3[branch_id-1:0] <= in_3_branch;
		buf_3[branch_id+des-1:branch_id] <= in_3_des;
		buf_3[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_3[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd3)
	begin
		buf_3[buffer_total-1] <= 'd1;
		buf_3[buffer_total-2] <= 'd0;
		buf_3[branch_id-1:0] <= in_4_branch;
		buf_3[branch_id+des-1:branch_id] <= in_4_des;
		buf_3[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_3[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_3[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_3 <= buf_4;
		else if (shift_amount_rest == 'd2)
			buf_3 <= buf_5;
		else if (shift_amount_rest == 'd3)
			buf_3 <= buf_6;
		else if (shift_amount_rest == 'd4)
			buf_3 <= buf_7;
	end
	else if (flush_en && flush_id <= buf_3[branch_id-1:0])
		buf_3 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_4 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd4)
	begin
		buf_4[buffer_total-1] <= 'd1;
		buf_4[buffer_total-2] <= 'd0;
		buf_4[branch_id-1:0] <= in_1_branch;
		buf_4[branch_id+des-1:branch_id] <= in_1_des;
		buf_4[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_4[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd4)
	begin
		buf_4[buffer_total-1] <= 'd1;
		buf_4[buffer_total-2] <= 'd0;
		buf_4[branch_id-1:0] <= in_2_branch;
		buf_4[branch_id+des-1:branch_id] <= in_2_des;
		buf_4[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_4[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd4)
	begin
		buf_4[buffer_total-1] <= 'd1;
		buf_4[buffer_total-2] <= 'd0;
		buf_4[branch_id-1:0] <= in_3_branch;
		buf_4[branch_id+des-1:branch_id] <= in_3_des;
		buf_4[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_4[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd4)
	begin
		buf_4[buffer_total-1] <= 'd1;
		buf_4[buffer_total-2] <= 'd0;
		buf_4[branch_id-1:0] <= in_4_branch;
		buf_4[branch_id+des-1:branch_id] <= in_4_des;
		buf_4[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_4[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_4[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_4 <= buf_5;
		else if (shift_amount_rest == 'd2)
			buf_4 <= buf_6;
		else if (shift_amount_rest == 'd3)
			buf_4 <= buf_7;
		else if (shift_amount_rest == 'd4)
			buf_4 <= buf_8;
	end
	else if (flush_en && flush_id <= buf_4[branch_id-1:0])
		buf_4 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_5 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd5)
	begin
		buf_5[buffer_total-1] <= 'd1;
		buf_5[buffer_total-2] <= 'd0;
		buf_5[branch_id-1:0] <= in_1_branch;
		buf_5[branch_id+des-1:branch_id] <= in_1_des;
		buf_5[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_5[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd5)
	begin
		buf_5[buffer_total-1] <= 'd1;
		buf_5[buffer_total-2] <= 'd0;
		buf_5[branch_id-1:0] <= in_2_branch;
		buf_5[branch_id+des-1:branch_id] <= in_2_des;
		buf_5[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_5[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd5)
	begin
		buf_5[buffer_total-1] <= 'd1;
		buf_5[buffer_total-2] <= 'd0;
		buf_5[branch_id-1:0] <= in_3_branch;
		buf_5[branch_id+des-1:branch_id] <= in_3_des;
		buf_5[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_5[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd5)
	begin
		buf_5[buffer_total-1] <= 'd1;
		buf_5[buffer_total-2] <= 'd0;
		buf_5[branch_id-1:0] <= in_4_branch;
		buf_5[branch_id+des-1:branch_id] <= in_4_des;
		buf_5[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_5[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_5[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_5 <= buf_6;
		else if (shift_amount_rest == 'd2)
			buf_5 <= buf_7;
		else if (shift_amount_rest == 'd3)
			buf_5 <= buf_8;
		else if (shift_amount_rest == 'd4)
			buf_5 <= buf_9;
	end
	else if (flush_en && flush_id <= buf_5[branch_id-1:0])
		buf_5 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_6 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd6)
	begin
		buf_6[buffer_total-1] <= 'd1;
		buf_6[buffer_total-2] <= 'd0;
		buf_6[branch_id-1:0] <= in_1_branch;
		buf_6[branch_id+des-1:branch_id] <= in_1_des;
		buf_6[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_6[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd6)
	begin
		buf_6[buffer_total-1] <= 'd1;
		buf_6[buffer_total-2] <= 'd0;
		buf_6[branch_id-1:0] <= in_2_branch;
		buf_6[branch_id+des-1:branch_id] <= in_2_des;
		buf_6[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_6[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd6)
	begin
		buf_6[buffer_total-1] <= 'd1;
		buf_6[buffer_total-2] <= 'd0;
		buf_6[branch_id-1:0] <= in_3_branch;
		buf_6[branch_id+des-1:branch_id] <= in_3_des;
		buf_6[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_6[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd6)
	begin
		buf_6[buffer_total-1] <= 'd1;
		buf_6[buffer_total-2] <= 'd0;
		buf_6[branch_id-1:0] <= in_4_branch;
		buf_6[branch_id+des-1:branch_id] <= in_4_des;
		buf_6[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_6[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_6[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_6 <= buf_7;
		else if (shift_amount_rest == 'd2)
			buf_6 <= buf_8;
		else if (shift_amount_rest == 'd3)
			buf_6 <= buf_9;
		else if (shift_amount_rest == 'd4)
			buf_6 <= buf_10;
	end
	else if (flush_en && flush_id <= buf_6[branch_id-1:0])
		buf_6 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_7 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd7)
	begin
		buf_7[buffer_total-1] <= 'd1;
		buf_7[buffer_total-2] <= 'd0;
		buf_7[branch_id-1:0] <= in_1_branch;
		buf_7[branch_id+des-1:branch_id] <= in_1_des;
		buf_7[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_7[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd7)
	begin
		buf_7[buffer_total-1] <= 'd1;
		buf_7[buffer_total-2] <= 'd0;
		buf_7[branch_id-1:0] <= in_2_branch;
		buf_7[branch_id+des-1:branch_id] <= in_2_des;
		buf_7[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_7[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd7)
	begin
		buf_7[buffer_total-1] <= 'd1;
		buf_7[buffer_total-2] <= 'd0;
		buf_7[branch_id-1:0] <= in_3_branch;
		buf_7[branch_id+des-1:branch_id] <= in_3_des;
		buf_7[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_7[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd7)
	begin
		buf_7[buffer_total-1] <= 'd1;
		buf_7[buffer_total-2] <= 'd0;
		buf_7[branch_id-1:0] <= in_4_branch;
		buf_7[branch_id+des-1:branch_id] <= in_4_des;
		buf_7[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_7[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_7[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_7 <= buf_8;
		else if (shift_amount_rest == 'd2)
			buf_7 <= buf_9;
		else if (shift_amount_rest == 'd3)
			buf_7 <= buf_10;
		else if (shift_amount_rest == 'd4)
			buf_7 <= buf_11;
	end
	else if (flush_en && flush_id <= buf_7[branch_id-1:0])
		buf_7 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_8 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd8)
	begin
		buf_8[buffer_total-1] <= 'd1;
		buf_8[buffer_total-2] <= 'd0;
		buf_8[branch_id-1:0] <= in_1_branch;
		buf_8[branch_id+des-1:branch_id] <= in_1_des;
		buf_8[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_8[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd8)
	begin
		buf_8[buffer_total-1] <= 'd1;
		buf_8[buffer_total-2] <= 'd0;
		buf_8[branch_id-1:0] <= in_2_branch;
		buf_8[branch_id+des-1:branch_id] <= in_2_des;
		buf_8[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_8[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd8)
	begin
		buf_8[buffer_total-1] <= 'd1;
		buf_8[buffer_total-2] <= 'd0;
		buf_8[branch_id-1:0] <= in_3_branch;
		buf_8[branch_id+des-1:branch_id] <= in_3_des;
		buf_8[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_8[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd8)
	begin
		buf_8[buffer_total-1] <= 'd1;
		buf_8[buffer_total-2] <= 'd0;
		buf_8[branch_id-1:0] <= in_4_branch;
		buf_8[branch_id+des-1:branch_id] <= in_4_des;
		buf_8[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_8[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_8[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_8 <= buf_9;
		else if (shift_amount_rest == 'd2)
			buf_8 <= buf_10;
		else if (shift_amount_rest == 'd3)
			buf_8 <= buf_11;
		else if (shift_amount_rest == 'd4)
			buf_8 <= buf_12;
	end
	else if (flush_en && flush_id <= buf_8[branch_id-1:0])
		buf_8 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_9 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd9)
	begin
		buf_9[buffer_total-1] <= 'd1;
		buf_9[buffer_total-2] <= 'd0;
		buf_9[branch_id-1:0] <= in_1_branch;
		buf_9[branch_id+des-1:branch_id] <= in_1_des;
		buf_9[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_9[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd9)
	begin
		buf_9[buffer_total-1] <= 'd1;
		buf_9[buffer_total-2] <= 'd0;
		buf_9[branch_id-1:0] <= in_2_branch;
		buf_9[branch_id+des-1:branch_id] <= in_2_des;
		buf_9[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_9[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd9)
	begin
		buf_9[buffer_total-1] <= 'd1;
		buf_9[buffer_total-2] <= 'd0;
		buf_9[branch_id-1:0] <= in_3_branch;
		buf_9[branch_id+des-1:branch_id] <= in_3_des;
		buf_9[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_9[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd9)
	begin
		buf_9[buffer_total-1] <= 'd1;
		buf_9[buffer_total-2] <= 'd0;
		buf_9[branch_id-1:0] <= in_4_branch;
		buf_9[branch_id+des-1:branch_id] <= in_4_des;
		buf_9[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_9[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_9[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_9 <= buf_10;
		else if (shift_amount_rest == 'd2)
			buf_9 <= buf_11;
		else if (shift_amount_rest == 'd3)
			buf_9 <= buf_12;
		else if (shift_amount_rest == 'd4)
			buf_9 <= buf_13;
	end
	else if (flush_en && flush_id <= buf_9[branch_id-1:0])
		buf_9 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_10 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd10)
	begin
		buf_10[buffer_total-1] <= 'd1;
		buf_10[buffer_total-2] <= 'd0;
		buf_10[branch_id-1:0] <= in_1_branch;
		buf_10[branch_id+des-1:branch_id] <= in_1_des;
		buf_10[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_10[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd10)
	begin
		buf_10[buffer_total-1] <= 'd1;
		buf_10[buffer_total-2] <= 'd0;
		buf_10[branch_id-1:0] <= in_2_branch;
		buf_10[branch_id+des-1:branch_id] <= in_2_des;
		buf_10[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_10[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd10)
	begin
		buf_10[buffer_total-1] <= 'd1;
		buf_10[buffer_total-2] <= 'd0;
		buf_10[branch_id-1:0] <= in_3_branch;
		buf_10[branch_id+des-1:branch_id] <= in_3_des;
		buf_10[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_10[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd10)
	begin
		buf_10[buffer_total-1] <= 'd1;
		buf_10[buffer_total-2] <= 'd0;
		buf_10[branch_id-1:0] <= in_4_branch;
		buf_10[branch_id+des-1:branch_id] <= in_4_des;
		buf_10[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_10[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_10[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_10 <= buf_11;
		else if (shift_amount_rest == 'd2)
			buf_10 <= buf_12;
		else if (shift_amount_rest == 'd3)
			buf_10 <= buf_13;
		else if (shift_amount_rest == 'd4)
			buf_10 <= buf_14;
	end
	else if (flush_en && flush_id <= buf_10[branch_id-1:0])
		buf_10 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_11 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd11)
	begin
		buf_11[buffer_total-1] <= 'd1;
		buf_11[buffer_total-2] <= 'd0;
		buf_11[branch_id-1:0] <= in_1_branch;
		buf_11[branch_id+des-1:branch_id] <= in_1_des;
		buf_11[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_11[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd11)
	begin
		buf_11[buffer_total-1] <= 'd1;
		buf_11[buffer_total-2] <= 'd0;
		buf_11[branch_id-1:0] <= in_2_branch;
		buf_11[branch_id+des-1:branch_id] <= in_2_des;
		buf_11[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_11[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd11)
	begin
		buf_11[buffer_total-1] <= 'd1;
		buf_11[buffer_total-2] <= 'd0;
		buf_11[branch_id-1:0] <= in_3_branch;
		buf_11[branch_id+des-1:branch_id] <= in_3_des;
		buf_11[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_11[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd11)
	begin
		buf_11[buffer_total-1] <= 'd1;
		buf_11[buffer_total-2] <= 'd0;
		buf_11[branch_id-1:0] <= in_4_branch;
		buf_11[branch_id+des-1:branch_id] <= in_4_des;
		buf_11[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_11[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_11[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_11 <= buf_12;
		else if (shift_amount_rest == 'd2)
			buf_11 <= buf_13;
		else if (shift_amount_rest == 'd3)
			buf_11 <= buf_14;
		else if (shift_amount_rest == 'd4)
			buf_11 <= buf_15;
	end
	else if (flush_en && flush_id <= buf_11[branch_id-1:0])
		buf_11 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_12 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd12)
	begin
		buf_12[buffer_total-1] <= 'd1;
		buf_12[buffer_total-2] <= 'd0;
		buf_12[branch_id-1:0] <= in_1_branch;
		buf_12[branch_id+des-1:branch_id] <= in_1_des;
		buf_12[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_12[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd12)
	begin
		buf_12[buffer_total-1] <= 'd1;
		buf_12[buffer_total-2] <= 'd0;
		buf_12[branch_id-1:0] <= in_2_branch;
		buf_12[branch_id+des-1:branch_id] <= in_2_des;
		buf_12[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_12[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd12)
	begin
		buf_12[buffer_total-1] <= 'd1;
		buf_12[buffer_total-2] <= 'd0;
		buf_12[branch_id-1:0] <= in_3_branch;
		buf_12[branch_id+des-1:branch_id] <= in_3_des;
		buf_12[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_12[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd12)
	begin
		buf_12[buffer_total-1] <= 'd1;
		buf_12[buffer_total-2] <= 'd0;
		buf_12[branch_id-1:0] <= in_4_branch;
		buf_12[branch_id+des-1:branch_id] <= in_4_des;
		buf_12[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_12[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_12[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_12 <= buf_13;
		else if (shift_amount_rest == 'd2)
			buf_12 <= buf_14;
		else if (shift_amount_rest == 'd3)
			buf_12 <= buf_15;
		else if (shift_amount_rest == 'd4)
			buf_12 <= buf_16;
	end
	else if (flush_en && flush_id <= buf_12[branch_id-1:0])
		buf_12 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_13 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd13)
	begin
		buf_13[buffer_total-1] <= 'd1;
		buf_13[buffer_total-2] <= 'd0;
		buf_13[branch_id-1:0] <= in_1_branch;
		buf_13[branch_id+des-1:branch_id] <= in_1_des;
		buf_13[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_13[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd13)
	begin
		buf_13[buffer_total-1] <= 'd1;
		buf_13[buffer_total-2] <= 'd0;
		buf_13[branch_id-1:0] <= in_2_branch;
		buf_13[branch_id+des-1:branch_id] <= in_2_des;
		buf_13[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_13[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd13)
	begin
		buf_13[buffer_total-1] <= 'd1;
		buf_13[buffer_total-2] <= 'd0;
		buf_13[branch_id-1:0] <= in_3_branch;
		buf_13[branch_id+des-1:branch_id] <= in_3_des;
		buf_13[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_13[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd13)
	begin
		buf_13[buffer_total-1] <= 'd1;
		buf_13[buffer_total-2] <= 'd0;
		buf_13[branch_id-1:0] <= in_4_branch;
		buf_13[branch_id+des-1:branch_id] <= in_4_des;
		buf_13[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_13[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_13[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_13 <= buf_14;
		else if (shift_amount_rest == 'd2)
			buf_13 <= buf_15;
		else if (shift_amount_rest == 'd3)
			buf_13 <= buf_16;
		else if (shift_amount_rest == 'd4)
			buf_13 <= buf_17;
	end
	else if (flush_en && flush_id <= buf_13[branch_id-1:0])
		buf_13 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_14 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd14)
	begin
		buf_14[buffer_total-1] <= 'd1;
		buf_14[buffer_total-2] <= 'd0;
		buf_14[branch_id-1:0] <= in_1_branch;
		buf_14[branch_id+des-1:branch_id] <= in_1_des;
		buf_14[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_14[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd14)
	begin
		buf_14[buffer_total-1] <= 'd1;
		buf_14[buffer_total-2] <= 'd0;
		buf_14[branch_id-1:0] <= in_2_branch;
		buf_14[branch_id+des-1:branch_id] <= in_2_des;
		buf_14[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_14[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd14)
	begin
		buf_14[buffer_total-1] <= 'd1;
		buf_14[buffer_total-2] <= 'd0;
		buf_14[branch_id-1:0] <= in_3_branch;
		buf_14[branch_id+des-1:branch_id] <= in_3_des;
		buf_14[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_14[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd14)
	begin
		buf_14[buffer_total-1] <= 'd1;
		buf_14[buffer_total-2] <= 'd0;
		buf_14[branch_id-1:0] <= in_4_branch;
		buf_14[branch_id+des-1:branch_id] <= in_4_des;
		buf_14[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_14[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_14[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_14 <= buf_15;
		else if (shift_amount_rest == 'd2)
			buf_14 <= buf_16;
		else if (shift_amount_rest == 'd3)
			buf_14 <= buf_17;
		else if (shift_amount_rest == 'd4)
			buf_14 <= buf_18;
	end
	else if (flush_en && flush_id <= buf_14[branch_id-1:0])
		buf_14 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_15 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd15)
	begin
		buf_15[buffer_total-1] <= 'd1;
		buf_15[buffer_total-2] <= 'd0;
		buf_15[branch_id-1:0] <= in_1_branch;
		buf_15[branch_id+des-1:branch_id] <= in_1_des;
		buf_15[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_15[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd15)
	begin
		buf_15[buffer_total-1] <= 'd1;
		buf_15[buffer_total-2] <= 'd0;
		buf_15[branch_id-1:0] <= in_2_branch;
		buf_15[branch_id+des-1:branch_id] <= in_2_des;
		buf_15[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_15[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd15)
	begin
		buf_15[buffer_total-1] <= 'd1;
		buf_15[buffer_total-2] <= 'd0;
		buf_15[branch_id-1:0] <= in_3_branch;
		buf_15[branch_id+des-1:branch_id] <= in_3_des;
		buf_15[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_15[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd15)
	begin
		buf_15[buffer_total-1] <= 'd1;
		buf_15[buffer_total-2] <= 'd0;
		buf_15[branch_id-1:0] <= in_4_branch;
		buf_15[branch_id+des-1:branch_id] <= in_4_des;
		buf_15[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_15[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_15[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_15 <= buf_16;
		else if (shift_amount_rest == 'd2)
			buf_15 <= buf_17;
		else if (shift_amount_rest == 'd3)
			buf_15 <= buf_18;
		else if (shift_amount_rest == 'd4)
			buf_15 <= buf_19;
	end
	else if (flush_en && flush_id <= buf_15[branch_id-1:0])
		buf_15 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_16 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd16)
	begin
		buf_16[buffer_total-1] <= 'd1;
		buf_16[buffer_total-2] <= 'd0;
		buf_16[branch_id-1:0] <= in_1_branch;
		buf_16[branch_id+des-1:branch_id] <= in_1_des;
		buf_16[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_16[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd16)
	begin
		buf_16[buffer_total-1] <= 'd1;
		buf_16[buffer_total-2] <= 'd0;
		buf_16[branch_id-1:0] <= in_2_branch;
		buf_16[branch_id+des-1:branch_id] <= in_2_des;
		buf_16[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_16[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd16)
	begin
		buf_16[buffer_total-1] <= 'd1;
		buf_16[buffer_total-2] <= 'd0;
		buf_16[branch_id-1:0] <= in_3_branch;
		buf_16[branch_id+des-1:branch_id] <= in_3_des;
		buf_16[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_16[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd16)
	begin
		buf_16[buffer_total-1] <= 'd1;
		buf_16[buffer_total-2] <= 'd0;
		buf_16[branch_id-1:0] <= in_4_branch;
		buf_16[branch_id+des-1:branch_id] <= in_4_des;
		buf_16[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_16[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_16[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_16 <= buf_17;
		else if (shift_amount_rest == 'd2)
			buf_16 <= buf_18;
		else if (shift_amount_rest == 'd3)
			buf_16 <= buf_19;
		else if (shift_amount_rest == 'd4)
			buf_16 <= buf_20;
	end
	else if (flush_en && flush_id <= buf_16[branch_id-1:0])
		buf_16 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_17 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd17)
	begin
		buf_17[buffer_total-1] <= 'd1;
		buf_17[buffer_total-2] <= 'd0;
		buf_17[branch_id-1:0] <= in_1_branch;
		buf_17[branch_id+des-1:branch_id] <= in_1_des;
		buf_17[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_17[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd17)
	begin
		buf_17[buffer_total-1] <= 'd1;
		buf_17[buffer_total-2] <= 'd0;
		buf_17[branch_id-1:0] <= in_2_branch;
		buf_17[branch_id+des-1:branch_id] <= in_2_des;
		buf_17[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_17[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd17)
	begin
		buf_17[buffer_total-1] <= 'd1;
		buf_17[buffer_total-2] <= 'd0;
		buf_17[branch_id-1:0] <= in_3_branch;
		buf_17[branch_id+des-1:branch_id] <= in_3_des;
		buf_17[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_17[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd17)
	begin
		buf_17[buffer_total-1] <= 'd1;
		buf_17[buffer_total-2] <= 'd0;
		buf_17[branch_id-1:0] <= in_4_branch;
		buf_17[branch_id+des-1:branch_id] <= in_4_des;
		buf_17[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_17[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_17[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_17 <= buf_18;
		else if (shift_amount_rest == 'd2)
			buf_17 <= buf_19;
		else if (shift_amount_rest == 'd3)
			buf_17 <= buf_20;
		else if (shift_amount_rest == 'd4)
			buf_17 <= buf_21;
	end
	else if (flush_en && flush_id <= buf_17[branch_id-1:0])
		buf_17 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_18 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd18)
	begin
		buf_18[buffer_total-1] <= 'd1;
		buf_18[buffer_total-2] <= 'd0;
		buf_18[branch_id-1:0] <= in_1_branch;
		buf_18[branch_id+des-1:branch_id] <= in_1_des;
		buf_18[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_18[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd18)
	begin
		buf_18[buffer_total-1] <= 'd1;
		buf_18[buffer_total-2] <= 'd0;
		buf_18[branch_id-1:0] <= in_2_branch;
		buf_18[branch_id+des-1:branch_id] <= in_2_des;
		buf_18[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_18[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd18)
	begin
		buf_18[buffer_total-1] <= 'd1;
		buf_18[buffer_total-2] <= 'd0;
		buf_18[branch_id-1:0] <= in_3_branch;
		buf_18[branch_id+des-1:branch_id] <= in_3_des;
		buf_18[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_18[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd18)
	begin
		buf_18[buffer_total-1] <= 'd1;
		buf_18[buffer_total-2] <= 'd0;
		buf_18[branch_id-1:0] <= in_4_branch;
		buf_18[branch_id+des-1:branch_id] <= in_4_des;
		buf_18[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_18[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_18[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_18 <= buf_19;
		else if (shift_amount_rest == 'd2)
			buf_18 <= buf_20;
		else if (shift_amount_rest == 'd3)
			buf_18 <= buf_21;
		else if (shift_amount_rest == 'd4)
			buf_18 <= buf_22;
	end
	else if (flush_en && flush_id <= buf_18[branch_id-1:0])
		buf_18 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_19 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd19)
	begin
		buf_19[buffer_total-1] <= 'd1;
		buf_19[buffer_total-2] <= 'd0;
		buf_19[branch_id-1:0] <= in_1_branch;
		buf_19[branch_id+des-1:branch_id] <= in_1_des;
		buf_19[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_19[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd19)
	begin
		buf_19[buffer_total-1] <= 'd1;
		buf_19[buffer_total-2] <= 'd0;
		buf_19[branch_id-1:0] <= in_2_branch;
		buf_19[branch_id+des-1:branch_id] <= in_2_des;
		buf_19[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_19[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd19)
	begin
		buf_19[buffer_total-1] <= 'd1;
		buf_19[buffer_total-2] <= 'd0;
		buf_19[branch_id-1:0] <= in_3_branch;
		buf_19[branch_id+des-1:branch_id] <= in_3_des;
		buf_19[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_19[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd19)
	begin
		buf_19[buffer_total-1] <= 'd1;
		buf_19[buffer_total-2] <= 'd0;
		buf_19[branch_id-1:0] <= in_4_branch;
		buf_19[branch_id+des-1:branch_id] <= in_4_des;
		buf_19[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_19[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_19[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_19 <= buf_20;
		else if (shift_amount_rest == 'd2)
			buf_19 <= buf_21;
		else if (shift_amount_rest == 'd3)
			buf_19 <= buf_22;
		else if (shift_amount_rest == 'd4)
			buf_19 <= buf_23;
	end
	else if (flush_en && flush_id <= buf_19[branch_id-1:0])
		buf_19 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_20 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd20)
	begin
		buf_20[buffer_total-1] <= 'd1;
		buf_20[buffer_total-2] <= 'd0;
		buf_20[branch_id-1:0] <= in_1_branch;
		buf_20[branch_id+des-1:branch_id] <= in_1_des;
		buf_20[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_20[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd20)
	begin
		buf_20[buffer_total-1] <= 'd1;
		buf_20[buffer_total-2] <= 'd0;
		buf_20[branch_id-1:0] <= in_2_branch;
		buf_20[branch_id+des-1:branch_id] <= in_2_des;
		buf_20[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_20[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd20)
	begin
		buf_20[buffer_total-1] <= 'd1;
		buf_20[buffer_total-2] <= 'd0;
		buf_20[branch_id-1:0] <= in_3_branch;
		buf_20[branch_id+des-1:branch_id] <= in_3_des;
		buf_20[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_20[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd20)
	begin
		buf_20[buffer_total-1] <= 'd1;
		buf_20[buffer_total-2] <= 'd0;
		buf_20[branch_id-1:0] <= in_4_branch;
		buf_20[branch_id+des-1:branch_id] <= in_4_des;
		buf_20[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_20[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_20[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_20 <= buf_21;
		else if (shift_amount_rest == 'd2)
			buf_20 <= buf_22;
		else if (shift_amount_rest == 'd3)
			buf_20 <= buf_23;
		else if (shift_amount_rest == 'd4)
			buf_20 <= buf_24;
	end
	else if (flush_en && flush_id <= buf_20[branch_id-1:0])
		buf_20 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_21 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd21)
	begin
		buf_21[buffer_total-1] <= 'd1;
		buf_21[buffer_total-2] <= 'd0;
		buf_21[branch_id-1:0] <= in_1_branch;
		buf_21[branch_id+des-1:branch_id] <= in_1_des;
		buf_21[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_21[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd21)
	begin
		buf_21[buffer_total-1] <= 'd1;
		buf_21[buffer_total-2] <= 'd0;
		buf_21[branch_id-1:0] <= in_2_branch;
		buf_21[branch_id+des-1:branch_id] <= in_2_des;
		buf_21[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_21[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd21)
	begin
		buf_21[buffer_total-1] <= 'd1;
		buf_21[buffer_total-2] <= 'd0;
		buf_21[branch_id-1:0] <= in_3_branch;
		buf_21[branch_id+des-1:branch_id] <= in_3_des;
		buf_21[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_21[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd21)
	begin
		buf_21[buffer_total-1] <= 'd1;
		buf_21[buffer_total-2] <= 'd0;
		buf_21[branch_id-1:0] <= in_4_branch;
		buf_21[branch_id+des-1:branch_id] <= in_4_des;
		buf_21[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_21[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_21[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_21 <= buf_22;
		else if (shift_amount_rest == 'd2)
			buf_21 <= buf_23;
		else if (shift_amount_rest == 'd3)
			buf_21 <= buf_24;
		else if (shift_amount_rest == 'd4)
			buf_21 <= buf_25;
	end
	else if (flush_en && flush_id <= buf_21[branch_id-1:0])
		buf_21 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_22 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd22)
	begin
		buf_22[buffer_total-1] <= 'd1;
		buf_22[buffer_total-2] <= 'd0;
		buf_22[branch_id-1:0] <= in_1_branch;
		buf_22[branch_id+des-1:branch_id] <= in_1_des;
		buf_22[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_22[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd22)
	begin
		buf_22[buffer_total-1] <= 'd1;
		buf_22[buffer_total-2] <= 'd0;
		buf_22[branch_id-1:0] <= in_2_branch;
		buf_22[branch_id+des-1:branch_id] <= in_2_des;
		buf_22[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_22[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd22)
	begin
		buf_22[buffer_total-1] <= 'd1;
		buf_22[buffer_total-2] <= 'd0;
		buf_22[branch_id-1:0] <= in_3_branch;
		buf_22[branch_id+des-1:branch_id] <= in_3_des;
		buf_22[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_22[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd22)
	begin
		buf_22[buffer_total-1] <= 'd1;
		buf_22[buffer_total-2] <= 'd0;
		buf_22[branch_id-1:0] <= in_4_branch;
		buf_22[branch_id+des-1:branch_id] <= in_4_des;
		buf_22[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_22[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_22[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_22 <= buf_23;
		else if (shift_amount_rest == 'd2)
			buf_22 <= buf_24;
		else if (shift_amount_rest == 'd3)
			buf_22 <= buf_25;
		else if (shift_amount_rest == 'd4)
			buf_22 <= buf_26;
	end
	else if (flush_en && flush_id <= buf_22[branch_id-1:0])
		buf_22 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_23 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd23)
	begin
		buf_23[buffer_total-1] <= 'd1;
		buf_23[buffer_total-2] <= 'd0;
		buf_23[branch_id-1:0] <= in_1_branch;
		buf_23[branch_id+des-1:branch_id] <= in_1_des;
		buf_23[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_23[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd23)
	begin
		buf_23[buffer_total-1] <= 'd1;
		buf_23[buffer_total-2] <= 'd0;
		buf_23[branch_id-1:0] <= in_2_branch;
		buf_23[branch_id+des-1:branch_id] <= in_2_des;
		buf_23[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_23[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd23)
	begin
		buf_23[buffer_total-1] <= 'd1;
		buf_23[buffer_total-2] <= 'd0;
		buf_23[branch_id-1:0] <= in_3_branch;
		buf_23[branch_id+des-1:branch_id] <= in_3_des;
		buf_23[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_23[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd23)
	begin
		buf_23[buffer_total-1] <= 'd1;
		buf_23[buffer_total-2] <= 'd0;
		buf_23[branch_id-1:0] <= in_4_branch;
		buf_23[branch_id+des-1:branch_id] <= in_4_des;
		buf_23[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_23[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_23[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_23 <= buf_24;
		else if (shift_amount_rest == 'd2)
			buf_23 <= buf_25;
		else if (shift_amount_rest == 'd3)
			buf_23 <= buf_26;
		else if (shift_amount_rest == 'd4)
			buf_23 <= buf_27;
	end
	else if (flush_en && flush_id <= buf_23[branch_id-1:0])
		buf_23 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_24 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd24)
	begin
		buf_24[buffer_total-1] <= 'd1;
		buf_24[buffer_total-2] <= 'd0;
		buf_24[branch_id-1:0] <= in_1_branch;
		buf_24[branch_id+des-1:branch_id] <= in_1_des;
		buf_24[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_24[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd24)
	begin
		buf_24[buffer_total-1] <= 'd1;
		buf_24[buffer_total-2] <= 'd0;
		buf_24[branch_id-1:0] <= in_2_branch;
		buf_24[branch_id+des-1:branch_id] <= in_2_des;
		buf_24[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_24[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd24)
	begin
		buf_24[buffer_total-1] <= 'd1;
		buf_24[buffer_total-2] <= 'd0;
		buf_24[branch_id-1:0] <= in_3_branch;
		buf_24[branch_id+des-1:branch_id] <= in_3_des;
		buf_24[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_24[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd24)
	begin
		buf_24[buffer_total-1] <= 'd1;
		buf_24[buffer_total-2] <= 'd0;
		buf_24[branch_id-1:0] <= in_4_branch;
		buf_24[branch_id+des-1:branch_id] <= in_4_des;
		buf_24[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_24[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_24[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_24 <= buf_25;
		else if (shift_amount_rest == 'd2)
			buf_24 <= buf_26;
		else if (shift_amount_rest == 'd3)
			buf_24 <= buf_27;
		else if (shift_amount_rest == 'd4)
			buf_24 <= buf_28;
	end
	else if (flush_en && flush_id <= buf_24[branch_id-1:0])
		buf_24 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_25 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd25)
	begin
		buf_25[buffer_total-1] <= 'd1;
		buf_25[buffer_total-2] <= 'd0;
		buf_25[branch_id-1:0] <= in_1_branch;
		buf_25[branch_id+des-1:branch_id] <= in_1_des;
		buf_25[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_25[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd25)
	begin
		buf_25[buffer_total-1] <= 'd1;
		buf_25[buffer_total-2] <= 'd0;
		buf_25[branch_id-1:0] <= in_2_branch;
		buf_25[branch_id+des-1:branch_id] <= in_2_des;
		buf_25[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_25[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd25)
	begin
		buf_25[buffer_total-1] <= 'd1;
		buf_25[buffer_total-2] <= 'd0;
		buf_25[branch_id-1:0] <= in_3_branch;
		buf_25[branch_id+des-1:branch_id] <= in_3_des;
		buf_25[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_25[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd25)
	begin
		buf_25[buffer_total-1] <= 'd1;
		buf_25[buffer_total-2] <= 'd0;
		buf_25[branch_id-1:0] <= in_4_branch;
		buf_25[branch_id+des-1:branch_id] <= in_4_des;
		buf_25[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_25[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_25[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_25 <= buf_26;
		else if (shift_amount_rest == 'd2)
			buf_25 <= buf_27;
		else if (shift_amount_rest == 'd3)
			buf_25 <= buf_28;
		else if (shift_amount_rest == 'd4)
			buf_25 <= buf_29;
	end
	else if (flush_en && flush_id <= buf_25[branch_id-1:0])
		buf_25 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_26 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd26)
	begin
		buf_26[buffer_total-1] <= 'd1;
		buf_26[buffer_total-2] <= 'd0;
		buf_26[branch_id-1:0] <= in_1_branch;
		buf_26[branch_id+des-1:branch_id] <= in_1_des;
		buf_26[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_26[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd26)
	begin
		buf_26[buffer_total-1] <= 'd1;
		buf_26[buffer_total-2] <= 'd0;
		buf_26[branch_id-1:0] <= in_2_branch;
		buf_26[branch_id+des-1:branch_id] <= in_2_des;
		buf_26[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_26[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd26)
	begin
		buf_26[buffer_total-1] <= 'd1;
		buf_26[buffer_total-2] <= 'd0;
		buf_26[branch_id-1:0] <= in_3_branch;
		buf_26[branch_id+des-1:branch_id] <= in_3_des;
		buf_26[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_26[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd26)
	begin
		buf_26[buffer_total-1] <= 'd1;
		buf_26[buffer_total-2] <= 'd0;
		buf_26[branch_id-1:0] <= in_4_branch;
		buf_26[branch_id+des-1:branch_id] <= in_4_des;
		buf_26[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_26[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_26[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_26 <= buf_27;
		else if (shift_amount_rest == 'd2)
			buf_26 <= buf_28;
		else if (shift_amount_rest == 'd3)
			buf_26 <= buf_29;
		else if (shift_amount_rest == 'd4)
			buf_26 <= buf_30;
	end
	else if (flush_en && flush_id <= buf_26[branch_id-1:0])
		buf_26 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_27 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd27)
	begin
		buf_27[buffer_total-1] <= 'd1;
		buf_27[buffer_total-2] <= 'd0;
		buf_27[branch_id-1:0] <= in_1_branch;
		buf_27[branch_id+des-1:branch_id] <= in_1_des;
		buf_27[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_27[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd27)
	begin
		buf_27[buffer_total-1] <= 'd1;
		buf_27[buffer_total-2] <= 'd0;
		buf_27[branch_id-1:0] <= in_2_branch;
		buf_27[branch_id+des-1:branch_id] <= in_2_des;
		buf_27[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_27[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd27)
	begin
		buf_27[buffer_total-1] <= 'd1;
		buf_27[buffer_total-2] <= 'd0;
		buf_27[branch_id-1:0] <= in_3_branch;
		buf_27[branch_id+des-1:branch_id] <= in_3_des;
		buf_27[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_27[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd27)
	begin
		buf_27[buffer_total-1] <= 'd1;
		buf_27[buffer_total-2] <= 'd0;
		buf_27[branch_id-1:0] <= in_4_branch;
		buf_27[branch_id+des-1:branch_id] <= in_4_des;
		buf_27[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_27[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_27[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_27 <= buf_28;
		else if (shift_amount_rest == 'd2)
			buf_27 <= buf_29;
		else if (shift_amount_rest == 'd3)
			buf_27 <= buf_30;
		else if (shift_amount_rest == 'd4)
			buf_27 <= buf_31;
	end
	else if (flush_en && flush_id <= buf_27[branch_id-1:0])
		buf_27 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_28 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd28)
	begin
		buf_28[buffer_total-1] <= 'd1;
		buf_28[buffer_total-2] <= 'd0;
		buf_28[branch_id-1:0] <= in_1_branch;
		buf_28[branch_id+des-1:branch_id] <= in_1_des;
		buf_28[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_28[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd28)
	begin
		buf_28[buffer_total-1] <= 'd1;
		buf_28[buffer_total-2] <= 'd0;
		buf_28[branch_id-1:0] <= in_2_branch;
		buf_28[branch_id+des-1:branch_id] <= in_2_des;
		buf_28[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_28[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd28)
	begin
		buf_28[buffer_total-1] <= 'd1;
		buf_28[buffer_total-2] <= 'd0;
		buf_28[branch_id-1:0] <= in_3_branch;
		buf_28[branch_id+des-1:branch_id] <= in_3_des;
		buf_28[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_28[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd28)
	begin
		buf_28[buffer_total-1] <= 'd1;
		buf_28[buffer_total-2] <= 'd0;
		buf_28[branch_id-1:0] <= in_4_branch;
		buf_28[branch_id+des-1:branch_id] <= in_4_des;
		buf_28[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_28[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_28[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_28 <= buf_29;
		else if (shift_amount_rest == 'd2)
			buf_28 <= buf_30;
		else if (shift_amount_rest == 'd3)
			buf_28 <= buf_31;
		else if (shift_amount_rest == 'd4)
			buf_28 <= 'd0;
	end
	else if (flush_en && flush_id <= buf_28[branch_id-1:0])
		buf_28 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_29 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd29)
	begin
		buf_29[buffer_total-1] <= 'd1;
		buf_29[buffer_total-2] <= 'd0;
		buf_29[branch_id-1:0] <= in_1_branch;
		buf_29[branch_id+des-1:branch_id] <= in_1_des;
		buf_29[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_29[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd29)
	begin
		buf_29[buffer_total-1] <= 'd1;
		buf_29[buffer_total-2] <= 'd0;
		buf_29[branch_id-1:0] <= in_2_branch;
		buf_29[branch_id+des-1:branch_id] <= in_2_des;
		buf_29[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_29[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd29)
	begin
		buf_29[buffer_total-1] <= 'd1;
		buf_29[buffer_total-2] <= 'd0;
		buf_29[branch_id-1:0] <= in_3_branch;
		buf_29[branch_id+des-1:branch_id] <= in_3_des;
		buf_29[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_29[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd29)
	begin
		buf_29[buffer_total-1] <= 'd1;
		buf_29[buffer_total-2] <= 'd0;
		buf_29[branch_id-1:0] <= in_4_branch;
		buf_29[branch_id+des-1:branch_id] <= in_4_des;
		buf_29[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_29[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_29[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_29 <= buf_30;
		else if (shift_amount_rest == 'd2)
			buf_29 <= buf_31;
		else if (shift_amount_rest == 'd3)
			buf_29 <= 'd0;
		else if (shift_amount_rest == 'd4)
			buf_29 <= 'd0;
	end
	else if (flush_en && flush_id <= buf_29[branch_id-1:0])
		buf_29 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_30 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd30)
	begin
		buf_30[buffer_total-1] <= 'd1;
		buf_30[buffer_total-2] <= 'd0;
		buf_30[branch_id-1:0] <= in_1_branch;
		buf_30[branch_id+des-1:branch_id] <= in_1_des;
		buf_30[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_30[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd30)
	begin
		buf_30[buffer_total-1] <= 'd1;
		buf_30[buffer_total-2] <= 'd0;
		buf_30[branch_id-1:0] <= in_2_branch;
		buf_30[branch_id+des-1:branch_id] <= in_2_des;
		buf_30[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_30[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd30)
	begin
		buf_30[buffer_total-1] <= 'd1;
		buf_30[buffer_total-2] <= 'd0;
		buf_30[branch_id-1:0] <= in_3_branch;
		buf_30[branch_id+des-1:branch_id] <= in_3_des;
		buf_30[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_30[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd30)
	begin
		buf_30[buffer_total-1] <= 'd1;
		buf_30[buffer_total-2] <= 'd0;
		buf_30[branch_id-1:0] <= in_4_branch;
		buf_30[branch_id+des-1:branch_id] <= in_4_des;
		buf_30[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_30[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_30[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_30 <= buf_31;
		else if (shift_amount_rest == 'd2)
			buf_30 <= 'd0;
		else if (shift_amount_rest == 'd3)
			buf_30 <= 'd0;
		else if (shift_amount_rest == 'd4)
			buf_30 <= 'd0;
	end
	else if (flush_en && flush_id <= buf_30[branch_id-1:0])
		buf_30 <= 'd0;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buf_31 <= 'd0;
	else if (~flush_en && in_1_vld && in_addr_1 == 'd31)
	begin
		buf_31[buffer_total-1] <= 'd1;
		buf_31[buffer_total-2] <= 'd0;
		buf_31[branch_id-1:0] <= in_1_branch;
		buf_31[branch_id+des-1:branch_id] <= in_1_des;
		buf_31[branch_id+des+register_width-1:des+branch_id] <= alu_1_data;
		buf_31[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_1_op;
	end
	else if (~flush_en && in_2_vld && in_addr_2 == 'd31)
	begin
		buf_31[buffer_total-1] <= 'd1;
		buf_31[buffer_total-2] <= 'd0;
		buf_31[branch_id-1:0] <= in_2_branch;
		buf_31[branch_id+des-1:branch_id] <= in_2_des;
		buf_31[branch_id+des+register_width-1:des+branch_id] <= alu_2_data;
		buf_31[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_2_op;
	end
	else if (~flush_en && in_3_vld && in_addr_3 == 'd31)
	begin
		buf_31[buffer_total-1] <= 'd1;
		buf_31[buffer_total-2] <= 'd0;
		buf_31[branch_id-1:0] <= in_3_branch;
		buf_31[branch_id+des-1:branch_id] <= in_3_des;
		buf_31[branch_id+des+register_width-1:des+branch_id] <= alu_3_data;
		buf_31[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_3_op;
	end
	else if (~flush_en && in_4_vld && in_addr_4 == 'd31)
	begin
		buf_31[buffer_total-1] <= 'd1;
		buf_31[buffer_total-2] <= 'd0;
		buf_31[branch_id-1:0] <= in_4_branch;
		buf_31[branch_id+des-1:branch_id] <= in_4_des;
		buf_31[branch_id+des+register_width-1:des+branch_id] <= alu_4_data;
		buf_31[branch_id+des+register_width+op-1:des+register_width+branch_id] <= in_4_op;
	end
	else if (~flush_en && buf_31[buffer_total-1])
	begin
		if (shift_amount_rest == 'd1)
			buf_31 <= 'd0;
		else if (shift_amount_rest == 'd2)
			buf_31 <= 'd0;
		else if (shift_amount_rest == 'd3)
			buf_31 <= 'd0;
		else if (shift_amount_rest == 'd4)
			buf_31 <= 'd0;
	end
	else if (flush_en && flush_id <= buf_31[branch_id-1:0])
		buf_31 <= 'd0;
end

///////////////////////////////////////////////////////////////////////////////////////////////////

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
	begin
		out_1_des <= 'd0;
		out_1_data <= 'd0;
		out_1_vld <= 'd0;
		ongoing_load_flag <= 'd0;
		out_load_flag <= 'd0;
	end
	else if (out_addr_1 == 'd0)
	begin
		if (~buf_0[buffer_total-1])
		begin
			out_1_des <= 'd0;
			out_1_data <= 'd0;
			out_1_vld <= 'd0;
		end
		else
		begin
			if (buf_0[branch_id-1:0] <= flush_id && buf_0[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b0100 && ~ongoing_load_flag)
			begin
				out_load_flag <= 'd1;
				out_1_mem_addr <= buf_0[branch_id+des+register_width-1:des+branch_id];
				out_1_des <= buf_0[branch_id+des-1:branch_id];
				ongoing_load_flag <= 'd1;	
			end
			else if (buf_0[branch_id-1:0] <= flush_id && ongoing_load_flag && mem_in_done && out_load_flag)
			begin
				out_load_flag <= 'd0;
				out_1_des <= buf_0[branch_id+des-1:branch_id];
				ongoing_load_flag <= 'd0;	
				out_1_vld <= 'd1;
			end
			else if (buf_0[branch_id-1:0] <= flush_id && buf_0[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b0010 && ~ongoing_store_flag)
			begin
				out_store_flag <= 'd1;
				out_1_mem_addr <= buf_0[branch_id+des+register_width-1:des+branch_id];
				out_1_des <= buf_0[branch_id+des-1:branch_id];
				ongoing_store_flag <= 'd1;		
			end
			else if (buf_0[branch_id-1:0] <= flush_id && ongoing_store_flag && mem_in_done && out_store_flag)
			begin
				out_store_flag <= 'd0;
				out_1_des <= 'd0;
				ongoing_store_flag <= 'd0;	
				out_1_vld <= 'd1;
			end
		end
	end
	else if (out_addr_1 == 'd1)
	begin
		if (~buf_1[buffer_total-1])
		begin
			out_1_des <= 'd0;
			out_1_data <= 'd0;
			out_1_vld <= 'd0;
		end
		else
		begin
			if (buf_1[branch_id-1:0] <= flush_id && buf_1[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b1000)
			begin
				out_1_des <= buf_1[branch_id+des-1:branch_id];
				out_1_data <= buf_1[branch_id+des+register_width-1:des+branch_id];
				out_1_vld <= 'd1;
			end
		end
	end
	else if (out_addr_1 == 'd2)
	begin
		if (~buf_2[buffer_total-1])
		begin
			out_1_des <= 'd0;
			out_1_data <= 'd0;
			out_1_vld <= 'd0;
		end
		else
		begin
			if (buf_2[branch_id-1:0] <= flush_id && buf_2[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b1000)
			begin
				out_1_des <= buf_2[branch_id+des-1:branch_id];
				out_1_data <= buf_2[branch_id+des+register_width-1:des+branch_id];
				out_1_vld <= 'd1;
			end
		end
	end
	else if (out_addr_1 == 'd3)
	begin
		if (~buf_3[buffer_total-1])
		begin
			out_1_des <= 'd0;
			out_1_data <= 'd0;
			out_1_vld <= 'd0;
		end
		else
		begin
			if (buf_3[branch_id-1:0] <= flush_id && buf_3[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b1000)
			begin
				out_1_des <= buf_3[branch_id+des-1:branch_id];
				out_1_data <= buf_3[branch_id+des+register_width-1:des+branch_id];
				out_1_vld <= 'd1;
			end
		end
	end
end


always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
	begin
		out_2_des <= 'd0;
		out_2_data <= 'd0;
		out_2_vld <= 'd0;
	end
	else if (out_addr_2 == 'd1)
	begin
		if (~buf_1[buffer_total-1])
		begin
			out_2_des <= 'd0;
			out_2_data <= 'd0;
			out_2_vld <= 'd0;
		end
		else
		begin
			if (buf_1[branch_id-1:0] <= flush_id && buf_1[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b1000)
			begin
				out_2_des <= buf_1[branch_id+des-1:branch_id];
				out_2_data <= buf_1[branch_id+des+register_width-1:des+branch_id];
				out_2_vld <= 'd1;
			end
		end
	end
	else if (out_addr_2 == 'd2)
	begin
		if (~buf_2[buffer_total-1])
		begin
			out_2_des <= 'd0;
			out_2_data <= 'd0;
			out_2_vld <= 'd0;
		end
		else
		begin
			if (buf_2[branch_id-1:0] <= flush_id && buf_2[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b1000)
			begin
				out_2_des <= buf_2[branch_id+des-1:branch_id];
				out_2_data <= buf_2[branch_id+des+register_width-1:des+branch_id];
				out_2_vld <= 'd1;
			end
		end
	end
	else if (out_addr_2 == 'd3)
	begin
		if (~buf_3[buffer_total-1])
		begin
			out_2_des <= 'd0;
			out_2_data <= 'd0;
			out_2_vld <= 'd0;
		end
		else
		begin
			if (buf_3[branch_id-1:0] <= flush_id && buf_3[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b1000)
			begin
				out_2_des <= buf_3[branch_id+des-1:branch_id];
				out_2_data <= buf_3[branch_id+des+register_width-1:des+branch_id];
				out_2_vld <= 'd1;
			end
		end
	end
	else if (out_addr_2 == 'd4)
	begin
		if (~buf_4[buffer_total-1])
		begin
			out_2_des <= 'd0;
			out_2_data <= 'd0;
			out_2_vld <= 'd0;
		end
		else
		begin
			if (buf_4[branch_id-1:0] <= flush_id && buf_4[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b1000)
			begin
				out_2_des <= buf_4[branch_id+des-1:branch_id];
				out_2_data <= buf_4[branch_id+des+register_width-1:des+branch_id];
				out_2_vld <= 'd1;
			end
		end
	end
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
	begin
		out_3_des <= 'd0;
		out_3_data <= 'd0;
		out_3_vld <= 'd0;
	end
	else if (out_addr_3 == 'd2)
	begin
		if (~buf_2[buffer_total-1])
		begin
			out_3_des <= 'd0;
			out_3_data <= 'd0;
			out_3_vld <= 'd0;
		end
		else
		begin
			if (buf_2[branch_id-1:0] <= flush_id && buf_2[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b1000)
			begin
				out_3_des <= buf_2[branch_id+des-1:branch_id];
				out_3_data <= buf_2[branch_id+des+register_width-1:des+branch_id];
				out_3_vld <= 'd1;
			end
		end
	end
	else if (out_addr_3 == 'd3)
	begin
		if (~buf_3[buffer_total-1])
		begin
			out_3_des <= 'd0;
			out_3_data <= 'd0;
			out_3_vld <= 'd0;
		end
		else
		begin
			if (buf_3[branch_id-1:0] <= flush_id && buf_3[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b1000)
			begin
				out_3_des <= buf_3[branch_id+des-1:branch_id];
				out_3_data <= buf_3[branch_id+des+register_width-1:des+branch_id];
				out_3_vld <= 'd1;
			end
		end
	end
	else if (out_addr_3 == 'd4)
	begin
		if (~buf_4[buffer_total-1])
		begin
			out_3_des <= 'd0;
			out_3_data <= 'd0;
			out_3_vld <= 'd0;
		end
		else
		begin
			if (buf_4[branch_id-1:0] <= flush_id && buf_4[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b1000)
			begin
				out_3_des <= buf_4[branch_id+des-1:branch_id];
				out_3_data <= buf_4[branch_id+des+register_width-1:des+branch_id];
				out_3_vld <= 'd1;
			end
		end
	end
	else if (out_addr_3 == 'd5)
	begin
		if (~buf_5[buffer_total-1])
		begin
			out_3_des <= 'd0;
			out_3_data <= 'd0;
			out_3_vld <= 'd0;
		end
		else
		begin
			if (buf_5[branch_id-1:0] <= flush_id && buf_5[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b1000)
			begin
				out_3_des <= buf_5[branch_id+des-1:branch_id];
				out_3_data <= buf_5[branch_id+des+register_width-1:des+branch_id];
				out_3_vld <= 'd1;
			end
		end
	end
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
	begin
		out_4_des <= 'd0;
		out_4_data <= 'd0;
		out_4_vld <= 'd0;
	end
	else if (out_addr_4 == 'd3)
	begin
		if (~buf_3[buffer_total-1])
		begin
			out_4_des <= 'd0;
			out_4_data <= 'd0;
			out_4_vld <= 'd0;
		end
		else
		begin
			if (buf_3[branch_id-1:0] <= flush_id && buf_3[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b1000)
			begin
				out_4_des <= buf_3[branch_id+des-1:branch_id];
				out_4_data <= buf_3[branch_id+des+register_width-1:des+branch_id];
				out_4_vld <= 'd1;
			end
		end
	end
	else if (out_addr_4 == 'd4)
	begin
		if (~buf_4[buffer_total-1])
		begin
			out_4_des <= 'd0;
			out_4_data <= 'd0;
			out_4_vld <= 'd0;
		end
		else
		begin
			if (buf_4[branch_id-1:0] <= flush_id && buf_4[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b1000)
			begin
				out_4_des <= buf_4[branch_id+des-1:branch_id];
				out_4_data <= buf_4[branch_id+des+register_width-1:des+branch_id];
				out_4_vld <= 'd1;
			end
		end
	end
	else if (out_addr_4 == 'd5)
	begin
		if (~buf_5[buffer_total-1])
		begin
			out_4_des <= 'd0;
			out_4_data <= 'd0;
			out_4_vld <= 'd0;
		end
		else
		begin
			if (buf_5[branch_id-1:0] <= flush_id && buf_5[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b1000)
			begin
				out_4_des <= buf_5[branch_id+des-1:branch_id];
				out_4_data <= buf_5[branch_id+des+register_width-1:des+branch_id];
				out_4_vld <= 'd1;
			end
		end
	end
	else if (out_addr_4 == 'd6)
	begin
		if (~buf_6[buffer_total-1])
		begin
			out_4_des <= 'd0;
			out_4_data <= 'd0;
			out_4_vld <= 'd0;
		end
		else
		begin
			if (buf_6[branch_id-1:0] <= flush_id && buf_6[branch_id+des+register_width+op-1:des+register_width+branch_id] == 'b1000)
			begin
				out_4_des <= buf_6[branch_id+des-1:branch_id];
				out_4_data <= buf_6[branch_id+des+register_width-1:des+branch_id];
				out_4_vld <= 'd1;
			end
		end
	end
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buffer_full <= 'd0;
	else if (buf_16[buffer_total-1] == 'd1)
		buffer_full <= 'd1;
	else if (buf_0[buffer_total-1] == 'd1)
		buffer_full <= 'd0;
end


always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		buffer_empty <= 'd0;
	else if (buf_0[buffer_total-1] == 'd0)
		buffer_empty <= 'd1;
	else
		buffer_empty <= 'd0;
end


endmodule
