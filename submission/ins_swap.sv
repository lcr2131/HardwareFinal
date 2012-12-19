//Programmer:	Tong Zhang
//Date:		12/11/2012
//Purpose:	switch the sequence of the four instructions to place the load/store instruction to the fourth thread

module ins_swap(ins_swap_interface.ins_swap_dut d);

always_comb
begin
	case({ins1_swap(d.ins1_swap),ins2_swap(d.ins2_swap),ins3_swap(d.ins3_swap),ins4_swap(d.ins4_swap)})
		4'b1001:
		begin
			d.out_1_vld = d.in_4_vld;
			d.out_1_des = d.in_4_des;
			d.out_1_s1 = d.in_4_s1;
			d.out_1_s2 = d.in_4_s2;
			d.out_1_op = d.in_4_op;
			d.out_1_ime = d.in_4_ime;
			d.out_1_branch = d.in_4_branch;

			d.out_2_vld = d.in_2_vld;
			d.out_2_des = d.in_2_des;
			d.out_2_s1 = d.in_2_s1;
			d.out_2_s2 = d.in_2_s2;
			d.out_2_op = d.in_2_op;
			d.out_2_ime = d.in_2_ime;
			d.out_2_branch = d.in_2_branch;

			d.out_3_vld = d.in_3_vld;
			d.out_3_des = d.in_3_des;
			d.out_3_s1 = d.in_3_s1;
			d.out_3_s2 = d.in_3_s2;
			d.out_3_op = d.in_3_op;
			d.out_3_ime = d.in_3_ime;
			d.out_3_branch = d.in_3_branch;

			d.out_4_vld = d.in_1_vld;
			d.out_4_des = d.in_1_des;
			d.out_4_s1 = d.in_1_s1;
			d.out_4_s2 = d.in_1_s2;
			d.out_4_op =d.in_1_op;
			d.out_4_ime = d.in_1_ime;
			d.out_4_branch = d.in_1_branch;
		end
/*		4'b0101:
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
*/
		4'b1100:
		begin
			d.out_1_vld = d.in_2_vld;
			d.out_1_des = d.in_2_des;
			d.out_1_s1 = d.in_2_s1;
			d.out_1_s2 = d.in_2_s2;
			d.out_1_op = d.in_2_op;
			d.out_1_ime = d.in_2_ime;
			d.out_1_branch = d.in_2_branch;

			d.out_2_vld = d.in_1_vld;
			d.out_2_des = d.in_1_des;
			d.out_2_s1 = d.in_1_s1;
			d.out_2_s2 = d.in_1_s2;
			d.out_2_op = d.in_1_op;
			d.out_2_ime = d.in_1_ime;
			d.out_2_branch = d.in_1_branch;

			d.out_3_vld = d.in_3_vld;
			d.out_3_des = d.in_3_des;
			d.out_3_s1 = d.in_3_s1;
			d.out_3_s2 = d.in_3_s2;
			d.out_3_op = d.in_3_op;
			d.out_3_ime = d.in_3_ime;
			d.out_3_branch = d.in_3_branch;

			d.out_4_vld = d.in_4_vld;
			d.out_4_des = d.in_4_des;
			d.out_4_s1 = d.in_4_s1;
			d.out_4_s2 = d.in_4_s2;
			d.out_4_op = d.in_4_op;
			d.out_4_ime = d.in_4_ime;
			d.out_4_branch = d.in_4_branch;

		end
		4'b1010:
		begin
			d.out_1_vld = d.in_3_vld;
			d.out_1_des = d.in_3_des;
			d.out_1_s1 = d.in_3_s1;
			d.out_1_s2 = d.in_3_s2;
			d.out_1_op = d.in_3_op;
			d.out_1_ime = d.in_3_ime;
			d.out_1_branch = d.in_3_branch;

			d.out_2_vld = d.in_2_vld;
			d.out_2_des = d.in_2_des;
			d.out_2_s1 = d.in_2_s1;
			d.out_2_s2 = d.in_2_s2;
			d.out_2_op = d.in_2_op;
			d.out_2_ime = d.in_2_ime;
			d.out_2_branch = d.in_2_branch;

			d.out_3_vld = d.in_1_vld;
			d.out_3_des = d.in_1_des;
			d.out_3_s1 = d.in_1_s1;
			d.out_3_s2 = d.in_1_s2;
			d.out_3_op = d.in_1_op;
			d.out_3_ime = d.in_1_ime;
			d.out_3_branch = d.in_1_branch;

			d.out_4_vld = d.in_4_vld;
			d.out_4_des = d.in_4_des;
			d.out_4_s1 = d.in_4_s1;
			d.out_4_s2 = d.in_4_s2;
			d.out_4_op = d.in_4_op;
			d.out_4_ime = d.in_4_ime;
			d.out_4_branch = d.in_4_branch;

		end
/*
		4'b0110:
		begin
			out_1_vld = in_1_vld;
			out_1_des = in_1_des;
			out_1_s1 = in_1_s1;
			out_1_s2 = in_1_s2;
			out_1_op = in_1_op;
			out_1_ime = in_1_ime;

			out_2_vld = in_3_vld;
			out_2_des = in_3_des;
			out_2_s1 = in_3_s1;
			out_2_s2 = in_3_s2;
			out_2_op = in_3_op;
			out_2_ime = in_3_ime;

			out_3_vld = in_2_vld;
			out_3_des = in_2_des;
			out_3_s1 = in_2_s1;
			out_3_s2 = in_2_s2;
			out_3_op = in_2_op;
			out_3_ime = in_2_ime;

			out_4_vld = in_4_vld;
			out_4_des = in_4_des;
			out_4_s1 = in_4_s1;
			out_4_s2 = in_4_s2;
			out_4_op = in_4_op;
			out_4_ime = in_4_ime;

		end
*/
		default
		begin
			d.out_1_vld = d.in_1_vld;
			d.out_1_des = d.in_1_des;
			d.out_1_s1 = d.in_1_s1;
			d.out_1_s2 = d.in_1_s2;
			d.out_1_op = d.in_1_op;
			d.out_1_ime = d.in_1_ime;
			d.out_1_branch = d.in_1_branch;

			d.out_2_vld = d.in_2_vld;
			d.out_2_des = d.in_2_des;
			d.out_2_s1 = d.in_2_s1;
			d.out_2_s2 = d.in_2_s2;
			d.out_2_op = d.in_2_op;
			d.out_2_ime = d.in_2_ime;
			d.out_2_branch = d.in_2_branch;

			d.out_3_vld = d.in_3_vld;
			d.out_3_des = d.in_3_des;
			d.out_3_s1 = d.in_3_s1;
			d.out_3_s2 = d.in_3_s2;
			d.out_3_op = d.in_3_op;
			d.out_3_ime = d.in_3_ime;
			d.out_3_branch = d.in_3_branch;

			d.out_4_vld = d.in_4_vld;
			d.out_4_des = d.in_4_des;
			d.out_4_s1 = d.in_4_s1;
			d.out_4_s2 = d.in_4_s2;
			d.out_4_op = d.in_4_op;
			d.out_4_ime = d.in_4_ime;
			d.out_4_branch = d.in_4_branch;
		end
	endcase
end



















endmodule

