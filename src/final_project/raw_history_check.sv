///////////////////////////////////////////////////////////////////////////////////////////////////
//	Programmer:	Tong Zhang								//
//	Modification Date:	12/11/2012							//
//	Module function:	check raw between new issue instruction and all current		//
//				operaion ones							//
//												//
//////////////////////////////////////////////////////////////////////////////////////////////////

module raw_history_check#(parameter des = 'd4, source1 = 'd4, source2 = 'd4, reg_num = 'd16)
(
	input clk,
	input rst,

	input 	flush_en,
	input	[reg_num-1:0]	flush_reg,

	input	ins_in_1_vld,
	input	[des-1 : 0]	ins_in_1_des,
	input	[source1-1 : 0]	ins_in_1_source1,
	input	[source2-1 : 0]	ins_in_1_source2,

	input	ins_in_2_vld,
	input	[des-1 : 0]	ins_in_2_des,
	input	[source1-1 : 0]	ins_in_2_source1,
	input	[source2-1 : 0]	ins_in_2_source2,

	input	ins_in_3_vld,
	input	[des-1 : 0]	ins_in_3_des,
	input	[source1-1 : 0]	ins_in_3_source1,
	input	[source2-1 : 0]	ins_in_3_source2,

	input	ins_in_4_vld,
	input	[des-1 : 0]	ins_in_4_des,
	input	[source1-1 : 0]	ins_in_4_source1,
	input	[source2-1 : 0]	ins_in_4_source2,

	input	ins_final_1_vld,
	input	ins_final_2_vld,
	input	ins_final_3_vld,
	input	ins_final_4_vld,

	input	ins_back_1_vld,
	input	[des-1 : 0]	ins_back_1_des,
	input	ins_back_2_vld,
	input	[des-1 : 0]	ins_back_2_des,
	input	ins_back_3_vld,
	input	[des-1 : 0]	ins_back_3_des,
	input	ins_back_4_vld,
	input	[des-1 : 0]	ins_back_4_des,

	output	logic ins_out_1_vld,
	output	logic ins_out_2_vld,
	output	logic ins_out_3_vld,
	output	logic ins_out_4_vld	
);

	reg	[reg_num-1:0]	reg_lut;
//	reg	reg_1;
//	reg	reg_2;
//	reg	reg_3;
//	reg	reg_4;
//	reg	reg_5;
//	reg	reg_6;
//	reg	reg_7;
//	reg	reg_8;
///	reg	reg_9;
//	reg	reg_10;
//	reg	reg_11;
//	reg	reg_12;
//	reg	reg_13;
//	reg	reg_14;
//	reg	reg_15;


always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_lut[1] <= 'd0;
	else if ((ins_in_1_vld && ins_in_1_des == 'd1)||
			(ins_in_2_vld && ins_in_2_des == 'd1)||
			(ins_in_3_vld && ins_in_3_des == 'd1)||
			(ins_in_4_vld && ins_in_4_des == 'd1))
		reg_lut[1] <= 'd1;
	else if ((ins_back_1_vld && ins_back_1_des == 'd1)||
			(ins_back_2_vld && ins_back_2_des == 'd1)||
			(ins_back_3_vld && ins_back_3_des == 'd1)||
			(ins_back_4_vld && ins_back_4_des == 'd1))
		reg_lut[1] <= 'd0;
	else if (flush_en)
		reg_lut[1] <= flush_reg[1];
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_lut[2] <= 'd0;
	else if ((ins_in_1_vld && ins_in_1_des == 'd2)||
			(ins_in_2_vld && ins_in_2_des == 'd2)||
			(ins_in_3_vld && ins_in_3_des == 'd2)||
			(ins_in_4_vld && ins_in_4_des == 'd2))
		reg_lut[2] <= 'd1;
	else if ((ins_back_1_vld && ins_back_1_des == 'd2)||
			(ins_back_2_vld && ins_back_2_des == 'd2)||
			(ins_back_3_vld && ins_back_3_des == 'd2)||
			(ins_back_4_vld && ins_back_4_des == 'd2))
		reg_lut[2] <= 'd0;
	else if (flush_en)
		reg_lut[2] <= flush_reg[2];
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_lut[3] <= 'd0;
	else if ((ins_in_1_vld && ins_in_1_des == 'd3)||
			(ins_in_2_vld && ins_in_2_des == 'd3)||
			(ins_in_3_vld && ins_in_3_des == 'd3)||
			(ins_in_4_vld && ins_in_4_des == 'd3))
		reg_lut[3] <= 'd1;
	else if ((ins_back_1_vld && ins_back_1_des == 'd3)||
			(ins_back_2_vld && ins_back_2_des == 'd3)||
			(ins_back_3_vld && ins_back_3_des == 'd3)||
			(ins_back_4_vld && ins_back_4_des == 'd3))
		reg_lut[3] <= 'd0;
	else if (flush_en)
		reg_lut[3] <= flush_reg[3];
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_lut[4] <= 'd0;
	else if ((ins_in_1_vld && ins_in_1_des == 'd4)||
			(ins_in_2_vld && ins_in_2_des == 'd4)||
			(ins_in_3_vld && ins_in_3_des == 'd4)||
			(ins_in_4_vld && ins_in_4_des == 'd4))
		reg_lut[4] <= 'd1;
	else if ((ins_back_1_vld && ins_back_1_des == 'd4)||
			(ins_back_2_vld && ins_back_2_des == 'd4)||
			(ins_back_3_vld && ins_back_3_des == 'd4)||
			(ins_back_4_vld && ins_back_4_des == 'd4))
		reg_lut[4] <= 'd0;
	else if (flush_en)
		reg_lut[4] <= flush_reg[4];
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_lut[5] <= 'd0;
	else if ((ins_in_1_vld && ins_in_1_des == 'd5)||
			(ins_in_2_vld && ins_in_2_des == 'd5)||
			(ins_in_3_vld && ins_in_3_des == 'd5)||
			(ins_in_4_vld && ins_in_4_des == 'd5))
		reg_lut[5] <= 'd1;
	else if ((ins_back_1_vld && ins_back_1_des == 'd5)||
			(ins_back_2_vld && ins_back_2_des == 'd5)||
			(ins_back_3_vld && ins_back_3_des == 'd5)||
			(ins_back_4_vld && ins_back_4_des == 'd5))
		reg_lut[5] <= 'd0;
	else if (flush_en)
		reg_lut[5] <= flush_reg[5];
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_lut[6] <= 'd0;
	else if ((ins_in_1_vld && ins_in_1_des == 'd6)||
			(ins_in_2_vld && ins_in_2_des == 'd6)||
			(ins_in_3_vld && ins_in_3_des == 'd6)||
			(ins_in_4_vld && ins_in_4_des == 'd6))
		reg_lut[6] <= 'd1;
	else if ((ins_back_1_vld && ins_back_1_des == 'd6)||
			(ins_back_2_vld && ins_back_2_des == 'd6)||
			(ins_back_3_vld && ins_back_3_des == 'd6)||
			(ins_back_4_vld && ins_back_4_des == 'd6))
		reg_lut[6] <= 'd0;
	else if (flush_en)
		reg_lut[6] <= flush_reg[6];
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_lut[7] <= 'd0;
	else if ((ins_in_1_vld && ins_in_1_des == 'd7)||
			(ins_in_2_vld && ins_in_2_des == 'd7)||
			(ins_in_3_vld && ins_in_3_des == 'd7)||
			(ins_in_4_vld && ins_in_4_des == 'd7))
		reg_lut[7] <= 'd1;
	else if ((ins_back_1_vld && ins_back_1_des == 'd7)||
			(ins_back_2_vld && ins_back_2_des == 'd7)||
			(ins_back_3_vld && ins_back_3_des == 'd7)||
			(ins_back_4_vld && ins_back_4_des == 'd7))
		reg_lut[7] <= 'd0;
	else if (flush_en)
		reg_lut[7] <= flush_reg[7];
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_lut[8] <= 'd0;
	else if ((ins_in_1_vld && ins_in_1_des == 'd8)||
			(ins_in_2_vld && ins_in_2_des == 'd8)||
			(ins_in_3_vld && ins_in_3_des == 'd8)||
			(ins_in_4_vld && ins_in_4_des == 'd8))
		reg_lut[8] <= 'd1;
	else if ((ins_back_1_vld && ins_back_1_des == 'd8)||
			(ins_back_2_vld && ins_back_2_des == 'd8)||
			(ins_back_3_vld && ins_back_3_des == 'd8)||
			(ins_back_4_vld && ins_back_4_des == 'd8))
		reg_lut[8] <= 'd0;
	else if (flush_en)
		reg_lut[8] <= flush_reg[8];
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_lut[9] <= 'd0;
	else if ((ins_in_1_vld && ins_in_1_des == 'd9)||
			(ins_in_2_vld && ins_in_2_des == 'd9)||
			(ins_in_3_vld && ins_in_3_des == 'd9)||
			(ins_in_4_vld && ins_in_4_des == 'd9))
		reg_lut[9] <= 'd1;
	else if ((ins_back_1_vld && ins_back_1_des == 'd9)||
			(ins_back_2_vld && ins_back_2_des == 'd9)||
			(ins_back_3_vld && ins_back_3_des == 'd9)||
			(ins_back_4_vld && ins_back_4_des == 'd9))
		reg_lut[9] <= 'd0;
	else if (flush_en)
		reg_lut[9] <= flush_reg[9];
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_lut[10] <= 'd0;
	else if ((ins_in_1_vld && ins_in_1_des == 'd10)||
			(ins_in_2_vld && ins_in_2_des == 'd10)||
			(ins_in_3_vld && ins_in_3_des == 'd10)||
			(ins_in_4_vld && ins_in_4_des == 'd10))
		reg_lut[10] <= 'd1;
	else if ((ins_back_1_vld && ins_back_1_des == 'd10)||
			(ins_back_2_vld && ins_back_2_des == 'd10)||
			(ins_back_3_vld && ins_back_3_des == 'd10)||
			(ins_back_4_vld && ins_back_4_des == 'd10))
		reg_lut[10] <= 'd0;
	else if (flush_en)
		reg_lut[10] <= flush_reg[10];
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_lut[11] <= 'd0;
	else if ((ins_in_1_vld && ins_in_1_des == 'd11)||
			(ins_in_2_vld && ins_in_2_des == 'd11)||
			(ins_in_3_vld && ins_in_3_des == 'd11)||
			(ins_in_4_vld && ins_in_4_des == 'd11))
		reg_lut[11] <= 'd1;
	else if ((ins_back_1_vld && ins_back_1_des == 'd11)||
			(ins_back_2_vld && ins_back_2_des == 'd11)||
			(ins_back_3_vld && ins_back_3_des == 'd11)||
			(ins_back_4_vld && ins_back_4_des == 'd11))
		reg_lut[11] <= 'd0;
	else if (flush_en)
		reg_lut[11] <= flush_reg[11];
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_lut[12] <= 'd0;
	else if ((ins_in_1_vld && ins_in_1_des == 'd12)||
			(ins_in_2_vld && ins_in_2_des == 'd12)||
			(ins_in_3_vld && ins_in_3_des == 'd12)||
			(ins_in_4_vld && ins_in_4_des == 'd12))
		reg_lut[12] <= 'd1;
	else if ((ins_back_1_vld && ins_back_1_des == 'd12)||
			(ins_back_2_vld && ins_back_2_des == 'd12)||
			(ins_back_3_vld && ins_back_3_des == 'd12)||
			(ins_back_4_vld && ins_back_4_des == 'd12))
		reg_lut[12] <= 'd0;
	else if (flush_en)
		reg_lut[12] <= flush_reg[12];
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_lut[13] <= 'd0;
	else if ((ins_in_1_vld && ins_in_1_des == 'd13)||
			(ins_in_2_vld && ins_in_2_des == 'd13)||
			(ins_in_3_vld && ins_in_3_des == 'd13)||
			(ins_in_4_vld && ins_in_4_des == 'd13))
		reg_lut[13] <= 'd1;
	else if ((ins_back_1_vld && ins_back_1_des == 'd13)||
			(ins_back_2_vld && ins_back_2_des == 'd13)||
			(ins_back_3_vld && ins_back_3_des == 'd13)||
			(ins_back_4_vld && ins_back_4_des == 'd13))
		reg_lut[13] <= 'd0;
	else if (flush_en)
		reg_lut[13] <= flush_reg[13];
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_lut[14] <= 'd0;
	else if ((ins_in_1_vld && ins_in_1_des == 'd14)||
			(ins_in_2_vld && ins_in_2_des == 'd14)||
			(ins_in_3_vld && ins_in_3_des == 'd14)||
			(ins_in_4_vld && ins_in_4_des == 'd14))
		reg_lut[14] <= 'd1;
	else if ((ins_back_1_vld && ins_back_1_des == 'd14)||
			(ins_back_2_vld && ins_back_2_des == 'd14)||
			(ins_back_3_vld && ins_back_3_des == 'd14)||
			(ins_back_4_vld && ins_back_4_des == 'd14))
		reg_lut[14] <= 'd0;
	else if (flush_en)
		reg_lut[14] <= flush_reg[14];
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg_lut[15] <= 'd0;
	else if ((ins_in_1_vld && ins_in_1_des == 'd15)||
			(ins_in_2_vld && ins_in_2_des == 'd15)||
			(ins_in_3_vld && ins_in_3_des == 'd15)||
			(ins_in_4_vld && ins_in_4_des == 'd15))
		reg_lut[15] <= 'd1;
	else if ((ins_back_1_vld && ins_back_1_des == 'd15)||
			(ins_back_2_vld && ins_back_2_des == 'd15)||
			(ins_back_3_vld && ins_back_3_des == 'd15)||
			(ins_back_4_vld && ins_back_4_des == 'd15))
		reg_lut[15] <= 'd0;
	else if (flush_en)
		reg_lut[15] <= flush_reg[15];
end

////////////////////////////////////////////////////////////////////////////////
always_comb
begin
	if (~ins_in_1_vld)
		ins_out_1_vld = 'd0;
	else
	begin
		if (ins_in_1_des == 'd1 && reg_lut[1])
			ins_out_1_vld = 'd0;
		else if (ins_in_1_des == 'd2 && reg_lut[2])
			ins_out_1_vld = 'd0;
		else if (ins_in_1_des == 'd3 && reg_lut[3])
			ins_out_1_vld = 'd0;
		else if (ins_in_1_des == 'd4 && reg_lut[4])
			ins_out_1_vld = 'd0;
		else if (ins_in_1_des == 'd5 && reg_lut[5])
			ins_out_1_vld = 'd0;
		else if (ins_in_1_des == 'd6 && reg_lut[6])
			ins_out_1_vld = 'd0;
		else if (ins_in_1_des == 'd7 && reg_lut[7])
			ins_out_1_vld = 'd0;
		else if (ins_in_1_des == 'd8 && reg_lut[8])
			ins_out_1_vld = 'd0;
		else if (ins_in_1_des == 'd9 && reg_lut[9])
			ins_out_1_vld = 'd0;
		else if (ins_in_1_des == 'd10 && reg_lut[10])
			ins_out_1_vld = 'd0;
		else if (ins_in_1_des == 'd11 && reg_lut[11])
			ins_out_1_vld = 'd0;
		else if (ins_in_1_des == 'd12 && reg_lut[12])
			ins_out_1_vld = 'd0;
		else if (ins_in_1_des == 'd13 && reg_lut[13])
			ins_out_1_vld = 'd0;
		else if (ins_in_1_des == 'd14 && reg_lut[14])
			ins_out_1_vld = 'd0;
		else if (ins_in_1_des == 'd15 && reg_lut[15])
			ins_out_1_vld = 'd0;
		else if (ins_in_1_des == 'd0)
			ins_out_1_vld = 'd0;
		else
			ins_out_1_vld = 'd1;
	end
end

always_comb
begin
	if (~ins_in_2_vld)
		ins_out_2_vld = 'd0;
	else
	begin
		if (ins_in_2_des == 'd1 && reg_lut[1])
			ins_out_2_vld = 'd0;
		else if (ins_in_2_des == 'd2 && reg_lut[2])
			ins_out_2_vld = 'd0;
		else if (ins_in_2_des == 'd3 && reg_lut[3])
			ins_out_2_vld = 'd0;
		else if (ins_in_2_des == 'd4 && reg_lut[4])
			ins_out_2_vld = 'd0;
		else if (ins_in_2_des == 'd5 && reg_lut[5])
			ins_out_2_vld = 'd0;
		else if (ins_in_2_des == 'd6 && reg_lut[6])
			ins_out_2_vld = 'd0;
		else if (ins_in_2_des == 'd7 && reg_lut[7])
			ins_out_2_vld = 'd0;
		else if (ins_in_2_des == 'd8 && reg_lut[8])
			ins_out_2_vld = 'd0;
		else if (ins_in_2_des == 'd9 && reg_lut[9])
			ins_out_2_vld = 'd0;
		else if (ins_in_2_des == 'd10 && reg_lut[10])
			ins_out_2_vld = 'd0;
		else if (ins_in_2_des == 'd11 && reg_lut[11])
			ins_out_2_vld = 'd0;
		else if (ins_in_2_des == 'd12 && reg_lut[12])
			ins_out_2_vld = 'd0;
		else if (ins_in_2_des == 'd13 && reg_lut[13])
			ins_out_2_vld = 'd0;
		else if (ins_in_2_des == 'd14 && reg_lut[14])
			ins_out_2_vld = 'd0;
		else if (ins_in_2_des == 'd15 && reg_lut[15])
			ins_out_2_vld = 'd0;
		else if (ins_in_2_des == 'd0)
			ins_out_2_vld = 'd0;
		else
			ins_out_2_vld = 'd1;
	end
end

always_comb
begin
	if (~ins_in_3_vld)
		ins_out_3_vld = 'd0;
	else
	begin
		if (ins_in_3_des == 'd1 && reg_lut[1])
			ins_out_3_vld = 'd0;
		else if (ins_in_3_des == 'd2 && reg_lut[2])
			ins_out_3_vld = 'd0;
		else if (ins_in_3_des == 'd3 && reg_lut[3])
			ins_out_3_vld = 'd0;
		else if (ins_in_3_des == 'd4 && reg_lut[4])
			ins_out_3_vld = 'd0;
		else if (ins_in_3_des == 'd5 && reg_lut[5])
			ins_out_3_vld = 'd0;
		else if (ins_in_3_des == 'd6 && reg_lut[6])
			ins_out_3_vld = 'd0;
		else if (ins_in_3_des == 'd7 && reg_lut[7])
			ins_out_3_vld = 'd0;
		else if (ins_in_3_des == 'd8 && reg_lut[8])
			ins_out_3_vld = 'd0;
		else if (ins_in_3_des == 'd9 && reg_lut[9])
			ins_out_3_vld = 'd0;
		else if (ins_in_3_des == 'd10 && reg_lut[10])
			ins_out_3_vld = 'd0;
		else if (ins_in_3_des == 'd11 && reg_lut[11])
			ins_out_3_vld = 'd0;
		else if (ins_in_3_des == 'd12 && reg_lut[12])
			ins_out_3_vld = 'd0;
		else if (ins_in_3_des == 'd13 && reg_lut[13])
			ins_out_3_vld = 'd0;
		else if (ins_in_3_des == 'd14 && reg_lut[14])
			ins_out_3_vld = 'd0;
		else if (ins_in_3_des == 'd15 && reg_lut[15])
			ins_out_3_vld = 'd0;
		else if (ins_in_3_des == 'd0)
			ins_out_3_vld = 'd0;
		else
			ins_out_3_vld = 'd1;
	end
end

always_comb
begin
	if (~ins_in_4_vld)
		ins_out_4_vld = 'd0;
	else
	begin
		if (ins_in_4_des == 'd1 && reg_lut[1])
			ins_out_4_vld = 'd0;
		else if (ins_in_4_des == 'd2 && reg_lut[2])
			ins_out_4_vld = 'd0;
		else if (ins_in_4_des == 'd3 && reg_lut[3])
			ins_out_4_vld = 'd0;
		else if (ins_in_4_des == 'd4 && reg_lut[4])
			ins_out_4_vld = 'd0;
		else if (ins_in_4_des == 'd5 && reg_lut[5])
			ins_out_4_vld = 'd0;
		else if (ins_in_4_des == 'd6 && reg_lut[6])
			ins_out_4_vld = 'd0;
		else if (ins_in_4_des == 'd7 && reg_lut[7])
			ins_out_4_vld = 'd0;
		else if (ins_in_4_des == 'd8 && reg_lut[8])
			ins_out_4_vld = 'd0;
		else if (ins_in_4_des == 'd9 && reg_lut[9])
			ins_out_4_vld = 'd0;
		else if (ins_in_4_des == 'd10 && reg_lut[10])
			ins_out_4_vld = 'd0;
		else if (ins_in_4_des == 'd11 && reg_lut[11])
			ins_out_4_vld = 'd0;
		else if (ins_in_4_des == 'd12 && reg_lut[12])
			ins_out_4_vld = 'd0;
		else if (ins_in_4_des == 'd13 && reg_lut[13])
			ins_out_4_vld = 'd0;
		else if (ins_in_4_des == 'd14 && reg_lut[14])
			ins_out_4_vld = 'd0;
		else if (ins_in_4_des == 'd15 && reg_lut[15])
			ins_out_4_vld = 'd0;
		else if (ins_in_4_des == 'd0)
			ins_out_4_vld = 'd0;
		else
			ins_out_4_vld = 'd1;
	end
end



endmodule
