//Programmer:	Tong Zhang
//Date:		12/02/2012
//Purpose:	Check if multiple load/store instructions in the four

module load_store_check
(
	input [3:0]	op1,
	input [3:0]	op2,
	input [3:0]	op3,
	input [3:0]	op4,

	output logic	ins2_out,
	output logic	ins3_out,
	output logic	ins4_out
);

always_comb
begin
	if (op1 == 4'b0010 || op1 == 4'b0100)
	begin
		if (op2 == 4'b0010 || op2 == 4'b0100)
		begin
			ins2_out = 'd0;
			ins3_out = 'd0;
			ins4_out = 'd0;
		end
		else
		begin
			if (op3 == 4'b0010 || op3 == 4'b0100)
			begin
				ins2_out = 'd1;
				ins3_out = 'd0;
				ins4_out = 'd0;
			end
			else
			begin
				if (op4 == 4'b0010 || op4 == 4'b0100)
				begin
					ins2_out = 'd1;
					ins3_out = 'd1;
					ins4_out = 'd0;
				end
				else
				begin
					ins2_out = 'd1;
					ins3_out = 'd1;
					ins4_out = 'd1;
				end
			end
		end
	end
	else
	begin
		if (op2 == 4'b0010 || op2 == 4'b0100)
		begin
			if (op3 == 4'b0010 || op3 == 4'b0100)
			begin
				ins2_out = 'd1;
				ins3_out = 'd0;
				ins4_out = 'd0;
			end
			else
			begin
				if (op4 == 4'b0010 || op4 == 4'b0100)
				begin
					ins2_out = 'd1;
					ins3_out = 'd1;
					ins4_out = 'd0;
				end
				else
				begin
					ins2_out = 'd1;
					ins3_out = 'd1;
					ins4_out = 'd1;
				end
			end
		end
		else
		begin
			if (op3 == 4'b0010 || op3 == 4'b0100)
			begin
				if (op4 == 4'b0010 || op4 == 4'b0100)
				begin
					ins2_out = 'd1;
					ins3_out = 'd1;
					ins4_out = 'd0;
				end
				else
				begin
					ins2_out = 'd1;
					ins3_out = 'd1;
					ins4_out = 'd1;
				end
			end
			else
			begin
				ins2_out = 'd1;
				ins3_out = 'd1;
				ins4_out = 'd1;
			end
		end
	end
end

endmodule
