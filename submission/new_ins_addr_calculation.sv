//Programmer:	Tong Zhang
//Date:		12/10/2012
//Purpose:	for allocation of two new instruction in the queue


module new_ins_addr_calculation
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

	output logic	[3:0] ins_new_1_addr,
	output logic	[3:0] ins_new_2_addr
);

	reg [3:0] write_pointer;	//16-entry queue, 4-bit pointer

//	logic [2:0] ins_in_sum;
//	logic [2:0] ins_back_sum;
	logic [2:0] ins_sum;
//	logic	    ins_sum_sign;

assign ins_sum = ins_in_1 + ins_in_2 + ins_in_3 + ins_in_4;
//assign ins_back_sum = ins_back_1 + ins_back_2 + ins_back_3 + ins_back_4;

//assign ins_sum_sign = (ins_in_sum > ins_back_sum) ? 'd1 : 'd0;
//assign ins_sum = (ins_in_sum > ins_back_sum) ? (ins_in_sum - ins_back_sum) : (ins_back_sum - ins_in_sum);


always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
		write_pointer <= 'd0;
	else if (ins_new_1_vld && ins_new_2_vld)
		write_pointer <= write_pointer - ins_sum + 'd2;
	else if (ins_new_1_vld && ~ins_new_2_vld)
		write_pointer <= write_pointer - ins_sum + 'd1;
	else if (~ins_new_1_vld && ~ins_new_2_vld)
		write_pointer <= write_pointer - ins_sum;
end

/*
always_ff @ (posedge clk or posedge rst)
begin
	if (rst)
	begin
		write_pointer <= 'd0;
//		ins_new_1_addr <= 'd0;
//		ins_new_2_addr <= 'd0;
	end
	else if (ins_new_1_vld && ins_new_2_vld)
	begin
		if (ins_sum_sign)
		begin
			write_pointer <= write_pointer + ins_sum + 'd2;
//			ins_new_1_addr <= write_pointer + ins_sum;
//			ins_new_2_addr <= write_pointer + ins_sum + 'd1;
		end
		else
		begin
			write_pointer <= write_pointer - ins_sum + 'd2;
//			ins_new_1_addr <= write_pointer - ins_sum;
//			ins_new_2_addr <= write_pointer - ins_sum + 'd1;
		end
	end
	else if (ins_new_1_vld && ~ins_new_2_vld)
	begin
		if (ins_sum_sign)
		begin
			write_pointer <= write_pointer + ins_sum + 'd1;
//			ins_new_1_addr <= write_pointer + ins_sum;
//			ins_new_2_addr <= 'd15;
		end
		else
		begin
			write_pointer <= write_pointer - ins_sum + 'd1;
//			ins_new_1_addr <= write_pointer - ins_sum;
//			ins_new_2_addr <= 'd15;
		end		
	end
	else if (~ins_new_1_vld && ~ins_new_2_vld)
	begin
		if (ins_sum_sign)
		begin
			write_pointer <= write_pointer + ins_sum;
//			ins_new_1_addr <= 'd15;
//			ins_new_2_addr <= 'd15;			
		end
		else
		begin
			write_pointer <= write_pointer - ins_sum;
//			ins_new_1_addr <= 'd15;
//			ins_new_2_addr <= 'd15;
		end	
	end
end
*/

always_comb
begin
	if (ins_new_1_vld && ins_new_2_vld)
	begin
		ins_new_1_addr = write_pointer - ins_sum;
		ins_new_2_addr = write_pointer - ins_sum + 'd1;	
	end
	else if (ins_new_1_vld && ~ins_new_2_vld)
	begin
		ins_new_1_addr = write_pointer - ins_sum;
		ins_new_2_addr = 'd15;		
	end
	else
	begin
		ins_new_1_addr = 'd15;
		ins_new_2_addr = 'd15;
	end
end
/*
always_comb
begin
	if (ins_new_1_vld && ins_new_2_vld)
	begin
		if (ins_sum_sign)
		begin
			ins_new_1_addr = write_pointer + ins_sum;
			ins_new_2_addr = write_pointer + ins_sum + 'd1;	
		end
		else
		begin
			ins_new_1_addr = write_pointer - ins_sum;
			ins_new_2_addr = write_pointer - ins_sum + 'd1;
		end
	end
	else if (ins_new_1_vld && ~ins_new_2_vld)
	begin
		if (ins_sum_sign)
		begin
			ins_new_1_addr = write_pointer + ins_sum;
			ins_new_2_addr = 'd15;
		end
		else
		begin
			ins_new_1_addr = write_pointer - ins_sum;
			ins_new_2_addr = 'd15;
		end
	end
	else
	begin
			ins_new_1_addr = 'd15;
			ins_new_2_addr = 'd15;
	end
end

*/







endmodule
