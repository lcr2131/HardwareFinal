//Programmer:	Tong Zhang
//Date:		12/15/2012
//Purpose:	for allocation of four new instruction in the buffer


module buffer_ins_addr_calculation
(
	input clk,
	input rst,

	input ins_in_1,	
	input ins_in_2,	
	input ins_in_3,	
	input ins_in_4,

//	input ins_back_1,	
//	input ins_back_2,	
//	input ins_back_3,	
//	input ins_back_4,

	input ins_new_1_vld,
	input ins_new_2_vld,
	input ins_new_3_vld,
	input ins_new_4_vld,

	output reg	[4:0] ins_new_1_addr,
	output reg	[4:0] ins_new_2_addr,
	output reg	[4:0] ins_new_3_addr,
	output reg	[4:0] ins_new_4_addr
);

	reg [3:0] write_pointer;	//16-entry queue, 4-bit pointer

	logic [2:0] ins_in_sum;
//	logic [2:0] ins_back_sum;
//	logic [2:0] ins_sum;
//	logic	    ins_sum_sign;

	logic [2:0] ins_new_vld_sum;

	assign ins_sum = ins_in_1 + ins_in_2 + ins_in_3 + ins_in_4;
//	assign ins_back_sum = ins_back_1 + ins_back_2 + ins_back_3 + ins_back_4;

//	assign ins_sum_sign = (ins_in_sum > ins_back_sum) ? 'd1 : 'd0;
//	assign ins_sum = (ins_in_sum > ins_back_sum) ? (ins_in_sum - ins_back_sum) : (ins_back_sum - ins_in_sum);

assign ins_new_vld_sum = ins_new_1_vld + ins_new_2_vld + ins_new_3_vld + ins_new_4_vld;

always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		write_pointer <= 'd0;
//	else if (ins_sum_sign)
//		write_pointer <= write_pointer + ins_sum + ins_new_vld_sum;
//	else if (~ins_sum_sign)
//		write_pointer <= write_pointer - ins_sum + ins_new_vld_sum;
	else
		write_pointer <= write_pointer - ins_sum + ins_new_vld_sum;
		
end

always_comb
begin
	if (ins_new_1_vld)
	begin
		ins_new_1_addr = write_pointer - ins_sum;
		if (ins_new_2_vld)
		begin
			ins_new_2_addr = write_pointer - ins_sum + 'd1;
			if (ins_new_3_vld)
			begin
				ins_new_3_addr = write_pointer - ins_sum + 'd2;
				if (ins_new_4_vld)
					ins_new_4_addr = write_pointer - ins_sum + 'd3;
				else
					ins_new_4_addr = 'd31;
			end
			else
			begin
				ins_new_3_addr = 'd31;
				if (ins_new_4_vld)
					ins_new_4_addr = write_pointer - ins_sum + 'd2;
				else
					ins_new_4_addr = 'd31;
			end
		end
		else
		begin
			ins_new_2_addr = 'd15;
			if (ins_new_3_vld)
			begin
				ins_new_3_addr = write_pointer - ins_sum + 'd1;
				if (ins_new_4_vld)
					ins_new_4_addr = write_pointer - ins_sum + 'd2;
				else
					ins_new_4_addr = 'd31;
			end
			else
			begin
				ins_new_3_addr = 'd31;
				if (ins_new_4_vld)
					ins_new_4_addr = write_pointer - ins_sum + 'd1;
				else
					ins_new_4_addr = 'd31;
			end
		end
	end
	else
	begin
		ins_new_1_addr = 'd31;
		if (ins_new_2_vld)
		begin
			ins_new_2_addr = write_pointer - ins_sum;
			if (ins_new_3_vld)
			begin
				ins_new_3_addr = write_pointer - ins_sum + 'd1;
				if (ins_new_4_vld)
					ins_new_4_addr = write_pointer - ins_sum + 'd2;
				else
					ins_new_4_addr = 'd31;
			end
			else
			begin
				ins_new_3_addr = 'd31;
				if (ins_new_4_vld)
					ins_new_4_addr = write_pointer - ins_sum + 'd1;
				else
					ins_new_4_addr = 'd31;
			end
		end
		else
		begin
			ins_new_2_addr = 'd31;
			if (ins_new_3_vld)
			begin
				ins_new_3_addr = write_pointer - ins_sum;
				if (ins_new_4_vld)
					ins_new_4_addr = write_pointer - ins_sum + 'd1;
				else
					ins_new_4_addr = 'd31;
			end
			else
			begin
				ins_new_3_addr = 'd31;
				if (ins_new_4_vld)
					ins_new_4_addr = write_pointer - ins_sum;
				else
					ins_new_4_addr = 'd31;
			end
		end
	end
end








endmodule

