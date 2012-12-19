//Programmer:	Tong Zhang
//Date:		12/11/2012
//Purpose:	Check if multiple branch instructions in the four

module branch_check
(
	input [3:0]	op1,
	input [3:0]	op2,
	input [3:0]	op3,
	input [3:0]	op4,

	input	ins1_in_vld,
	input	ins2_in_vld,
	input	ins3_in_vld,
	input	ins4_in_vld,

	output logic	ins1_out,
	output logic	ins2_out,
	output logic	ins3_out,
	output logic	ins4_out
);


always_comb
begin
	if (~ins1_in_vld && op1 == 'b0001)
	begin
		ins1_out = 'd0;
		if (op2 == 'b0001)
		begin
			ins2_out = 'd0;
			ins3_out = 'd0;
			ins4_out = 'd0;
		end
		else	//ins1 is an invalid branch and ins2 is not a branch
		begin
			if (op3 == 'b0001)
			begin
				if (ins2_in_vld)
				begin
					ins2_out = 'd1;
					ins3_out = 'd0;
					ins4_out = 'd0;
				end
				else
				begin
					ins2_out = 'd0;
					ins3_out = 'd0;
					ins4_out = 'd0;
				end
			end
			else	//ins1 is an invalid branch and ins2, 3 are not branch
			begin
				if (op4 == 'b0001)
				begin
					if (ins2_in_vld && ins3_in_vld)
					begin
						ins2_out = 'd1;
						ins3_out = 'd1;
						ins4_out = 'd0;
					end
					else if (ins2_in_vld && ~ins3_in_vld)
					begin
						ins2_out = 'd1;
						ins3_out = 'd0;
						ins4_out = 'd0;
					end
					else if (~ins2_in_vld && ins3_in_vld)
					begin
						ins2_out = 'd0;
						ins3_out = 'd1;
						ins4_out = 'd0;
					end
					else
					begin
						ins2_out = 'd0;
						ins3_out = 'd0;
						ins4_out = 'd0;
					end
				end
				else	//ins1 is an invalid branch and ins2,3,4 are not branch
				begin
					if (ins2_in_vld)
						ins2_out = 'd1;
					else
						ins2_out = 'd0;
					if (ins3_in_vld)
						ins3_out = 'd1;
					else
						ins3_out = 'd0;
					if (ins4_in_vld)
						ins4_out = 'd1;
					else
						ins4_out = 'd0;
				end
			end
		end
	end
	else	
	begin
		if (ins1_in_vld)
			ins1_out = 'd1;		
		else
			ins1_out = 'd0;

		if (~ins2_in_vld && op2 == 'b0001)
		begin
			ins2_out = 'd0;
			if (op3 == 'b0001)
			begin
				ins3_out = 'd0;
				ins4_out = 'd0;				
			end
			else
			begin
				if (op4 == 'b0001)
				begin
					ins4_out = 'd0;
					if (ins3_in_vld)
						ins3_out = 'd1;
					else
						ins3_out = 'd0;
				end
				else
				begin
					if (ins3_in_vld)
						ins3_out = 'd1;
					else
						ins3_out = 'd0;
					if (ins4_in_vld)
						ins4_out = 'd1;
					else
						ins4_out = 'd0;
				end
			end
		end
		else
		begin
			if (ins2_in_vld)
				ins2_out = 'd1;
			else
				ins2_out = 'd0;		
			
			if (~ins3_in_vld && op3 == 'b0001)
			begin
				ins3_out = 'd0;
				if (op4 == 'b0001)
					ins4_out = 'd0;
				else
				begin
					if (ins4_in_vld)
						ins4_out = 'd1;
					else
						ins4_out = 'd0;
				end
			end
			else
			begin
				if (ins3_in_vld)
					ins3_out = 'd1;
				else
					ins3_out = 'd0;
				if (ins4_in_vld)
					ins4_out = 'd1;
				else
					ins4_out = 'd0;
			end
		end
	end
end



















endmodule
