//Programmer:	Tong Zhang
//Date:		12/12/2012
//Purpose:	Register file, read data for up to eight source registers, and write back up to four register back

module register_file #(parameter des = 'd4, source1 = 'd4, source2 = 'd4, immediate = 'd4,
				branch_id = 'd3, total_in = 4 + des + source1 + source2,
				total_out = total_in + branch_id + 'd1 + immediate, reg_num = 'd16,
				register_width = 'd32)		//why the register_width is 8?
(
	input rst,
	input clk,


	input				in_1_vld,	//In the issue stage, the function "swap" make sure that the load/store instruction can only be 
							//placed at the first "channel" of execution. 
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
	input		[branch_id-1:0]	in_2_branch,	//I think we need immediate for every "channel". branch ins has an imm which indicates 
							//the address it needs to jump to when misprediction occurs.
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

	input		back_1_vld,
	input		back_2_vld,
	input		back_3_vld,
	input		back_4_vld,

	input 		[des-1:0]	back_1_des,
	input 		[des-1:0]	back_2_des,
	input 		[des-1:0]	back_3_des,
	input 		[des-1:0]	back_4_des,

	input		[register_width-1:0]	back_1_data,
	input		[register_width-1:0]	back_2_data,
	input		[register_width-1:0]	back_3_data,
	input		[register_width-1:0]	back_4_data,


	output	reg			out_1_vld,
	output	reg	[des-1:0]	out_1_des,
	output	reg	[register_width-1:0]	out_1_s1_data,
	output	reg	[register_width-1:0]	out_1_s2_data,
	output	reg	[3:0]		out_1_op,
	output	reg	[branch_id-1:0]	out_1_branch,
	output	reg	[immediate-1:0]	out_1_ime,

	output	reg			out_2_vld,
	output	reg	[des-1:0]	out_2_des,
	output	reg	[register_width-1:0]	out_2_s1_data,
	output	reg	[register_width-1:0]	out_2_s2_data,
	output	reg	[3:0]		out_2_op,
	output	reg	[branch_id-1:0]	out_2_branch,
	output	reg	[immediate-1:0]	out_2_ime,

	output	reg			out_3_vld,
	output	reg	[des-1:0]	out_3_des,
	output	reg	[register_width-1:0]	out_3_s1_data,
	output	reg	[register_width-1:0]	out_3_s2_data,
	output	reg	[3:0]		out_3_op,
	output	reg	[branch_id-1:0]	out_3_branch,
	output	reg	[immediate-1:0]	out_3_ime,

	output	reg			out_4_vld,
	output	reg	[des-1:0]	out_4_des,
	output	reg	[register_width-1:0]	out_4_s1_data,
	output	reg	[register_width-1:0]	out_4_s2_data,
	output	reg	[3:0]		out_4_op,
	output	reg	[branch_id-1:0]	out_4_branch,
	output	reg	[immediate-1:0]	out_4_ime,

	output logic	[3:0]			ins1_op,
	output logic	[register_width-1:0]	ins1_data1,
	output logic	[register_width-1:0]	ins1_data2,
	output logic	[2:0]			ins1_bid,
	output logic	[immediate-1:0]	ins1_addr,

	output logic	[3:0]			ins2_op,
	output logic	[register_width-1:0]	ins2_data1,
	output logic	[register_width-1:0]	ins2_data2,
	output logic	[2:0]			ins2_bid,
	output logic	[immediate-1:0]	ins2_addr,


	output logic	[3:0]			ins3_op,
	output logic	[register_width-1:0]	ins3_data1,
	output logic	[register_width-1:0]	ins3_data2,
	output logic	[2:0]			ins3_bid,
	output logic	[immediate-1:0]	ins3_addr,


	output logic	[3:0]			ins4_op,
	output logic	[register_width-1:0]	ins4_data1,
	output logic	[register_width-1:0]	ins4_data2,
	output logic	[2:0]			ins4_bid,
	output logic	[immediate-1:0]	ins4_addr
);

	//reg0 is always 0. It can appear in the source part of an instruction. therefore reading from reg0 should be allowed
	reg	[register_width-1:0] reg1;
	reg	[register_width-1:0] reg2;
	reg	[register_width-1:0] reg3;
	reg	[register_width-1:0] reg4;
	reg	[register_width-1:0] reg5;
	reg	[register_width-1:0] reg6;
	reg	[register_width-1:0] reg7;
	reg	[register_width-1:0] reg8;
	reg	[register_width-1:0] reg9;
	reg	[register_width-1:0] reg10;
	reg	[register_width-1:0] reg11;
	reg	[register_width-1:0] reg12;
	reg	[register_width-1:0] reg13;
	reg	[register_width-1:0] reg14;
	reg	[register_width-1:0] reg15;

	logic	[register_width-1:0] temp11;
	logic	[register_width-1:0] temp12;
	logic	[register_width-1:0] temp21;
	logic	[register_width-1:0] temp22;
	logic	[register_width-1:0] temp31;
	logic	[register_width-1:0] temp32;
	logic	[register_width-1:0] temp41;
	logic	[register_width-1:0] temp42;


assign ins1_op = in_1_op;
assign ins2_op = in_2_op;
assign ins3_op = in_3_op;
assign ins4_op = in_4_op;
assign ins1_bid = in_1_branch;
assign ins2_bid = in_2_branch;
assign ins3_bid = in_3_branch;
assign ins4_bid = in_4_branch;
assign ins1_addr = in_1_ime;
assign ins2_addr = in_2_ime;
assign ins3_addr = in_3_ime;
assign ins4_addr = in_4_ime;
assign ins1_data1 = temp11;
assign ins1_data2 = temp12;
assign ins2_data1 = temp21;
assign ins2_data2 = temp22;
assign ins3_data1 = temp31;
assign ins3_data2 = temp32;
assign ins4_data1 = temp41;
assign ins4_data2 = temp42;

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)		//what does this rst mean? why don't we reset the output data?
	begin
		out_1_vld <= 'd0;
		out_2_vld <= 'd0;
		out_3_vld <= 'd0;
		out_4_vld <= 'd0;
		out_1_des <= 'd0;
		out_2_des <= 'd0;
		out_3_des <= 'd0;
		out_4_des <= 'd0;
		out_1_op  <= 'd0;
		out_2_op  <= 'd0;
		out_3_op  <= 'd0;
		out_4_op  <= 'd0;
		out_1_branch <= 'd0;
		out_2_branch <= 'd0;
		out_3_branch <= 'd0;
		out_4_branch <= 'd0;
		out_1_ime <= 'd0;
		out_2_ime <= 'd0;
		out_3_ime <= 'd0;
		out_4_ime <= 'd0;
	end
	else 
	begin
		out_1_vld <= in_1_vld;
		out_2_vld <= in_2_vld;
		out_3_vld <= in_3_vld;
		out_4_vld <= in_4_vld;
		out_1_des <= in_1_des;	//for a branch ins which has no des, what should the out_des be?
		out_2_des <= in_2_des;
		out_3_des <= in_3_des;
		out_4_des <= in_4_des;
		out_1_op  <= in_1_op;
		out_2_op  <= in_2_op;
		out_3_op  <= in_3_op;
		out_4_op  <= in_4_op;
		out_1_branch <= in_1_branch;
		out_2_branch <= in_2_branch;
		out_3_branch <= in_3_branch;
		out_4_branch <= in_4_branch;
		out_1_ime <= in_1_ime;
		out_2_ime <= in_2_ime;
		out_3_ime <= in_3_ime;
		out_4_ime <= in_4_ime;
	end
end


always_comb
begin
	case(in_1_s1)
		'd1:	temp11 = reg1;
		'd2:	temp11 = reg2;
		'd3:	temp11 = reg3;
		'd4:	temp11 = reg4;
		'd5:	temp11 = reg5;
		'd6:	temp11 = reg6;
		'd7:	temp11 = reg7;
		'd8:	temp11 = reg8;
		'd9:	temp11 = reg9;
		'd10:	temp11 = reg10;
		'd11:	temp11 = reg11;
		'd12:	temp11 = reg12;
		'd13:	temp11 = reg13;
		'd14:	temp11 = reg14;
		'd15:	temp11 = reg15;
		default temp11 = 'd0;
	endcase
end

always_comb
begin
	case(in_1_s2)
		'd1:	temp12 = reg1;
		'd2:	temp12 = reg2;
		'd3:	temp12 = reg3;
		'd4:	temp12 = reg4;
		'd5:	temp12 = reg5;
		'd6:	temp12 = reg6;
		'd7:	temp12 = reg7;
		'd8:	temp12 = reg8;
		'd9:	temp12 = reg9;
		'd10:	temp12 = reg10;
		'd11:	temp12 = reg11;
		'd12:	temp12 = reg12;
		'd13:	temp12 = reg13;
		'd14:	temp12 = reg14;
		'd15:	temp12 = reg15;
		default temp12 = 'd0;
	endcase
end

always_comb
begin
	case(in_2_s1)
		'd1:	temp21 = reg1;
		'd2:	temp21 = reg2;
		'd3:	temp21 = reg3;
		'd4:	temp21 = reg4;
		'd5:	temp21 = reg5;
		'd6:	temp21 = reg6;
		'd7:	temp21 = reg7;
		'd8:	temp21 = reg8;
		'd9:	temp21 = reg9;
		'd10:	temp21 = reg10;
		'd11:	temp21 = reg11;
		'd12:	temp21 = reg12;
		'd13:	temp21 = reg13;
		'd14:	temp21 = reg14;
		'd15:	temp21 = reg15;
		default temp21 = 'd0;
	endcase
end

always_comb
begin
	case(in_2_s2)
		'd1:	temp22 = reg1;
		'd2:	temp22 = reg2;
		'd3:	temp22 = reg3;
		'd4:	temp22 = reg4;
		'd5:	temp22 = reg5;
		'd6:	temp22 = reg6;
		'd7:	temp22 = reg7;
		'd8:	temp22 = reg8;
		'd9:	temp22 = reg9;
		'd10:	temp22 = reg10;
		'd11:	temp22 = reg11;
		'd12:	temp22 = reg12;
		'd13:	temp22 = reg13;
		'd14:	temp22 = reg14;
		'd15:	temp22 = reg15;
		default temp22 = 'd0;
	endcase
end

always_comb
begin
	case(in_3_s1)
		'd1:	temp31 = reg1;
		'd2:	temp31 = reg2;
		'd3:	temp31 = reg3;
		'd4:	temp31 = reg4;
		'd5:	temp31 = reg5;
		'd6:	temp31 = reg6;
		'd7:	temp31 = reg7;
		'd8:	temp31 = reg8;
		'd9:	temp31 = reg9;
		'd10:	temp31 = reg10;
		'd11:	temp31 = reg11;
		'd12:	temp31 = reg12;
		'd13:	temp31 = reg13;
		'd14:	temp31 = reg14;
		'd15:	temp31 = reg15;
		default temp31 = 'd0;
	endcase
end

always_comb
begin
	case(in_3_s2)
		'd1:	temp32 = reg1;
		'd2:	temp32 = reg2;
		'd3:	temp32 = reg3;
		'd4:	temp32 = reg4;
		'd5:	temp32 = reg5;
		'd6:	temp32 = reg6;
		'd7:	temp32 = reg7;
		'd8:	temp32 = reg8;
		'd9:	temp32 = reg9;
		'd10:	temp32 = reg10;
		'd11:	temp32 = reg11;
		'd12:	temp32 = reg12;
		'd13:	temp32 = reg13;
		'd14:	temp32 = reg14;
		'd15:	temp32 = reg15;
		default temp32 = 'd0;
	endcase
end

always_comb
begin
	case(in_4_s1)
		'd1:	temp41 = reg1;
		'd2:	temp41 = reg2;
		'd3:	temp41 = reg3;
		'd4:	temp41 = reg4;
		'd5:	temp41 = reg5;
		'd6:	temp41 = reg6;
		'd7:	temp41 = reg7;
		'd8:	temp41 = reg8;
		'd9:	temp41 = reg9;
		'd10:	temp41 = reg10;
		'd11:	temp41 = reg11;
		'd12:	temp41 = reg12;
		'd13:	temp41 = reg13;
		'd14:	temp41 = reg14;
		'd15:	temp41 = reg15;
		default temp41 = 'd0;
	endcase
end

always_comb
begin
	case(in_4_s2)
		'd1:	temp42 = reg1;
		'd2:	temp42 = reg2;
		'd3:	temp42 = reg3;
		'd4:	temp42 = reg4;
		'd5:	temp42 = reg5;
		'd6:	temp42 = reg6;
		'd7:	temp42 = reg7;
		'd8:	temp42 = reg8;
		'd9:	temp42 = reg9;
		'd10:	temp42 = reg10;
		'd11:	temp42 = reg11;
		'd12:	temp42 = reg12;
		'd13:	temp42 = reg13;
		'd14:	temp42 = reg14;
		'd15:	temp42 = reg15;
		default temp42 = 'd0;
	endcase
end


always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
	begin
		out_1_s1_data <= 'd0;
		out_1_s2_data <= 'd0;
	end
	else if (in_1_op == 'b0100 || in_1_op == 'b0010)
	begin
		out_1_s1_data <= temp11;
		out_1_s2_data <= 'd0;
	end
	else
	begin
		out_1_s1_data <= temp11;
		out_1_s2_data <= temp12;
	end
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
	begin
		out_2_s1_data <= 'd0;
		out_2_s2_data <= 'd0;
	end
	else
	begin
		out_2_s1_data <= temp21;
		out_2_s2_data <= temp22;
	end
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
	begin
		out_3_s1_data <= 'd0;
		out_3_s2_data <= 'd0;
	end
	else
	begin
		out_3_s1_data <= temp31;
		out_3_s2_data <= temp32;
	end
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
	begin
		out_4_s1_data <= 'd0;
		out_4_s2_data <= 'd0;
	end
	else
	begin
		out_4_s1_data <= temp41;
		out_4_s2_data <= temp42;
	end
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg1 <= 'd0;
	else if (back_1_vld && back_1_des == 'd1)
		reg1 <= back_1_data;
	else if (back_2_vld && back_2_des == 'd1)
		reg1 <= back_2_data;
	else if (back_3_vld && back_3_des == 'd1)
		reg1 <= back_3_data;
	else if (back_4_vld && back_4_des == 'd1)
		reg1 <= back_4_data;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg2 <= 'd0;
	else if (back_1_vld && back_1_des == 'd2)
		reg2 <= back_1_data;
	else if (back_2_vld && back_2_des == 'd2)
		reg2 <= back_2_data;
	else if (back_3_vld && back_3_des == 'd2)
		reg2 <= back_3_data;
	else if (back_4_vld && back_4_des == 'd2)
		reg2 <= back_4_data;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg3 <= 'd0;
	else if (back_1_vld && back_1_des == 'd3)
		reg3 <= back_1_data;
	else if (back_2_vld && back_2_des == 'd3)
		reg3 <= back_2_data;
	else if (back_3_vld && back_3_des == 'd3)
		reg3 <= back_3_data;
	else if (back_4_vld && back_4_des == 'd3)
		reg3 <= back_4_data;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg4 <= 'd0;
	else if (back_1_vld && back_1_des == 'd4)
		reg4 <= back_1_data;
	else if (back_2_vld && back_2_des == 'd4)
		reg4 <= back_2_data;
	else if (back_3_vld && back_3_des == 'd4)
		reg4 <= back_3_data;
	else if (back_4_vld && back_4_des == 'd4)
		reg4 <= back_4_data;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg5 <= 'd0;
	else if (back_1_vld && back_1_des == 'd5)
		reg5 <= back_1_data;
	else if (back_2_vld && back_2_des == 'd5)
		reg5 <= back_2_data;
	else if (back_3_vld && back_3_des == 'd5)
		reg5 <= back_3_data;
	else if (back_4_vld && back_4_des == 'd5)
		reg5 <= back_4_data;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg6 <= 'd0;
	else if (back_1_vld && back_1_des == 'd6)
		reg6 <= back_1_data;
	else if (back_2_vld && back_2_des == 'd6)
		reg6 <= back_2_data;
	else if (back_3_vld && back_3_des == 'd6)
		reg6 <= back_3_data;
	else if (back_4_vld && back_4_des == 'd6)
		reg6 <= back_4_data;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg7 <= 'd0;
	else if (back_1_vld && back_1_des == 'd7)
		reg7 <= back_1_data;
	else if (back_2_vld && back_2_des == 'd7)
		reg7 <= back_2_data;
	else if (back_3_vld && back_3_des == 'd7)
		reg7 <= back_3_data;
	else if (back_4_vld && back_4_des == 'd7)
		reg7 <= back_4_data;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg8 <= 'd0;
	else if (back_1_vld && back_1_des == 'd8)
		reg8 <= back_1_data;
	else if (back_2_vld && back_2_des == 'd8)
		reg8 <= back_2_data;
	else if (back_3_vld && back_3_des == 'd8)
		reg8 <= back_3_data;
	else if (back_4_vld && back_4_des == 'd8)
		reg8 <= back_4_data;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg9 <= 'd0;
	else if (back_1_vld && back_1_des == 'd9)
		reg9 <= back_1_data;
	else if (back_2_vld && back_2_des == 'd9)
		reg9 <= back_2_data;
	else if (back_3_vld && back_3_des == 'd9)
		reg9 <= back_3_data;
	else if (back_4_vld && back_4_des == 'd9)
		reg9 <= back_4_data;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg10 <= 'd0;
	else if (back_1_vld && back_1_des == 'd10)
		reg10 <= back_1_data;
	else if (back_2_vld && back_2_des == 'd10)
		reg10 <= back_2_data;
	else if (back_3_vld && back_3_des == 'd10)
		reg10 <= back_3_data;
	else if (back_4_vld && back_4_des == 'd10)
		reg10 <= back_4_data;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg11 <= 'd0;
	else if (back_1_vld && back_1_des == 'd11)
		reg11 <= back_1_data;
	else if (back_2_vld && back_2_des == 'd11)
		reg11 <= back_2_data;
	else if (back_3_vld && back_3_des == 'd11)
		reg11 <= back_3_data;
	else if (back_4_vld && back_4_des == 'd11)
		reg11 <= back_4_data;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg12 <= 'd0;
	else if (back_1_vld && back_1_des == 'd12)
		reg12 <= back_1_data;
	else if (back_2_vld && back_2_des == 'd12)
		reg12 <= back_2_data;
	else if (back_3_vld && back_3_des == 'd12)
		reg12 <= back_3_data;
	else if (back_4_vld && back_4_des == 'd12)
		reg12 <= back_4_data;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg13 <= 'd0;
	else if (back_1_vld && back_1_des == 'd13)
		reg13 <= back_1_data;
	else if (back_2_vld && back_2_des == 'd13)
		reg13 <= back_2_data;
	else if (back_3_vld && back_3_des == 'd13)
		reg13 <= back_3_data;
	else if (back_4_vld && back_4_des == 'd13)
		reg13 <= back_4_data;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg14 <= 'd0;
	else if (back_1_vld && back_1_des == 'd14)
		reg14 <= back_1_data;
	else if (back_2_vld && back_2_des == 'd14)
		reg14 <= back_2_data;
	else if (back_3_vld && back_3_des == 'd14)
		reg14 <= back_3_data;
	else if (back_4_vld && back_4_des == 'd14)
		reg14 <= back_4_data;
end

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		reg15 <= 'd0;
	else if (back_1_vld && back_1_des == 'd15)
		reg15 <= back_1_data;
	else if (back_2_vld && back_2_des == 'd15)
		reg15 <= back_2_data;
	else if (back_3_vld && back_3_des == 'd15)
		reg15 <= back_3_data;
	else if (back_4_vld && back_4_des == 'd15)
		reg15 <= back_4_data;
end



endmodule

