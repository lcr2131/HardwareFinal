//Programmer:	Tong Zhang
//Date:		12/02/2012
//Purpose:	For checker after issue queue, checking for war and raw hazards for all four instructions

module raw_war_checker #(parameter des = 'd4, source1 = 'd4, source2 = 'd4)
(
	input [des-1 : 0] des1,
	input [des-1 : 0] des2,
	input [des-1 : 0] des3,
	input [des-1 : 0] des4,
	input [source1-1 : 0] s11,
	input [source2-1 : 0] s12,
	input [source1-1 : 0] s21,
	input [source2-1 : 0] s22,
	input [source1-1 : 0] s31,
	input [source2-1 : 0] s32,
	input [source1-1 : 0] s41,
	input [source2-1 : 0] s42,

	input	ins2_in,
	input	ins3_in,
	input	ins4_in,

	output logic ins_flag_2,
	output logic ins_flag_3,
	output logic ins_flag_4
);

logic flag12,flag13,flag23,flag14,flag24,flag34;

raw_war_checker_part check_12	(
				 .des1,
				 .des2,
				 .s11,
				 .s12,
				 .s21,
				 .s22,
				 .hazard_flag(flag12)
				);

raw_war_checker_part check_13	(
				 .des1,
				 .des2(des3),
				 .s11,
				 .s12,
				 .s21(s31),
				 .s22(s32),
				 .hazard_flag(flag13)
				);

raw_war_checker_part check_23	(
				 .des1(des2),
				 .des2(des3),
				 .s11(s21),
				 .s12(s22),
				 .s21(s31),
				 .s22(s32),
				 .hazard_flag(flag23)
				);

raw_war_checker_part check_14	(
				 .des1,
				 .des2(des4),
				 .s11,
				 .s12,
				 .s21(s41),
				 .s22(s42),
				 .hazard_flag(flag14)
				);

raw_war_checker_part check_24	(
				 .des1(des2),
				 .des2(des4),
				 .s11(s21),
				 .s12(s22),
				 .s21(s41),
				 .s22(s42),
				 .hazard_flag(flag24)
				);

raw_war_checker_part check_34	(
				 .des1(des3),
				 .des2(des4),
				 .s11(s31),
				 .s12(s32),
				 .s21(s41),
				 .s22(s42),
				 .hazard_flag(flag34)
				);

//assign ins_flag_2 = ~flag12;
//assign ins_flag_3 = ~(flag13 || flag23);
//assign ins_flag_4 = ~(flag14 || flag24 || flag34);

always_comb
begin
	if (ins2_in)
		ins_flag_2 = ~flag12;
	else
		ins_flag_2 = 'd0;
end

always_comb
begin
	if (ins3_in)
		ins_flag_3 = ~(flag13 || flag23);
	else
		ins_flag_3 = 'd0;
end

always_comb
begin
	if (ins4_in)
		ins_flag_4 = ~(flag14 || flag24 || flag34);
	else
		ins_flag_4 = 'd0;
end

endmodule
