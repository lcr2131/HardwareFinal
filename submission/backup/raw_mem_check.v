///////////////////////////////////////////////////////////////////////////////////////////////////
//	Programmer:	Tong Zhang								//
//	Modification Date:	12/10/2012							//
//	Module function:	check raw between new issue instruction and all current		//
//				operaion ones							//
//												//
//////////////////////////////////////////////////////////////////////////////////////////////////


module raw_mem_check#(parameter des = 'd4, source1 = 'd4, source2 = 'd4,
					entry_width = 'd4)
(
	input	rst,
	input	clk,

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

	logic	[15:0] ins_1_vld;
	logic	[15:0] ins_2_vld;
	logic	[15:0] ins_3_vld;
	logic	[15:0] ins_4_vld;



raw_mem_check_single_entry	#(4,4,4,4,1)	entry1
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,vld[
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[0]),
	.ins_out_2_vld(ins_2_vld[0]),
	.ins_out_3_vld(ins_3_vld[0]),
	.ins_out_4_vld(ins_4_vld[0])	
);

raw_mem_check_single_entry	#(4,4,4,4,2)	entry2
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[1]),
	.ins_out_2_vld(ins_2_vld[1]),
	.ins_out_3_vld(ins_3_vld[1]),
	.ins_out_4_vld(ins_4_vld[1])	
);

raw_mem_check_single_entry	#(4,4,4,4,3)	entry3
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[2]),
	.ins_out_2_vld(ins_2_vld[2]),
	.ins_out_3_vld(ins_3_vld[2]),
	.ins_out_4_vld(ins_4_vld[2])	
);

raw_mem_check_single_entry	#(4,4,4,4,4)	entry4
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[3]),
	.ins_out_2_vld(ins_2_vld[3]),
	.ins_out_3_vld(ins_3_vld[3]),
	.ins_out_4_vld(ins_4_vld[3])	
);

raw_mem_check_single_entry	#(4,4,4,4,5)	entry5
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[4]),
	.ins_out_2_vld(ins_2_vld[4]),
	.ins_out_3_vld(ins_3_vld[4]),
	.ins_out_4_vld(ins_4_vld[4])	
);

raw_mem_check_single_entry	#(4,4,4,4,6)	entry6
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[5]),
	.ins_out_2_vld(ins_2_vld[5]),
	.ins_out_3_vld(ins_3_vld[5]),
	.ins_out_4_vld(ins_4_vld[5])	
);

raw_mem_check_single_entry	#(4,4,4,4,7)	entry7
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[6]),
	.ins_out_2_vld(ins_2_vld[6]),
	.ins_out_3_vld(ins_3_vld[6]),
	.ins_out_4_vld(ins_4_vld[6])	
);

raw_mem_check_single_entry	#(4,4,4,4,8)	entry8
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[7]),
	.ins_out_2_vld(ins_2_vld[7]),
	.ins_out_3_vld(ins_3_vld[7]),
	.ins_out_4_vld(ins_4_vld[7])	
);

raw_mem_check_single_entry	#(4,4,4,4,9)	entry9
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[8]),
	.ins_out_2_vld(ins_2_vld[8]),
	.ins_out_3_vld(ins_3_vld[8]),
	.ins_out_4_vld(ins_4_vld[8])	
);

raw_mem_check_single_entry	#(4,4,4,4,10)	entry10
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[9]),
	.ins_out_2_vld(ins_2_vld[9]),
	.ins_out_3_vld(ins_3_vld[9]),
	.ins_out_4_vld(ins_4_vld[9])	
);

raw_mem_check_single_entry	#(4,4,4,4,11)	entry11
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[10]),
	.ins_out_2_vld(ins_2_vld[10]),
	.ins_out_3_vld(ins_3_vld[10]),
	.ins_out_4_vld(ins_4_vld[10])	
);

raw_mem_check_single_entry	#(4,4,4,4,12)	entry12
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[11]),
	.ins_out_2_vld(ins_2_vld[11]),
	.ins_out_3_vld(ins_3_vld[11]),
	.ins_out_4_vld(ins_4_vld[11])	
);

raw_mem_check_single_entry	#(4,4,4,4,13)	entry13
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[12]),
	.ins_out_2_vld(ins_2_vld[12]),
	.ins_out_3_vld(ins_3_vld[12]),
	.ins_out_4_vld(ins_4_vld[12])	
);

raw_mem_check_single_entry	#(4,4,4,4,14)	entry14
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[13]),
	.ins_out_2_vld(ins_2_vld[13]),
	.ins_out_3_vld(ins_3_vld[13]),
	.ins_out_4_vld(ins_4_vld[13])	
);

raw_mem_check_single_entry	#(4,4,4,4,15)	entry15
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[14]),
	.ins_out_2_vld(ins_2_vld[14]),
	.ins_out_3_vld(ins_3_vld[14]),
	.ins_out_4_vld(ins_4_vld[14])	
);



raw_mem_check_single_entry	#(4,4,4,4,16)	entry16
(
	.rst,
	.clk,

	.ins_in_1_vld,
	.ins_in_1_des,
	.ins_in_1_source1,
	.ins_in_1_source2,

	.ins_in_2_vld,
	.ins_in_2_des,
	.ins_in_2_source1,
	.ins_in_2_source2,

	.ins_in_3_vld,
	.ins_in_3_des,
	.ins_in_3_source1,
	.ins_in_3_source2,

	.ins_in_4_vld,
	.ins_in_4_des,
	.ins_in_4_source1,
	.ins_in_4_source2,

	.ins_final_1_vld,
	.ins_final_2_vld,
	.ins_final_3_vld,
	.ins_final_4_vld,

	.ins_back_1_vld,
	.ins_back_1_des,
	.ins_back_2_vld,
	.ins_back_2_des,
	.ins_back_3_vld,
	.ins_back_3_des,
	.ins_back_4_vld,
	.ins_back_4_des,

	.ins_out_1_vld(ins_1_vld[15]),
	.ins_out_2_vld(ins_2_vld[15),
	.ins_out_3_vld(ins_3_vld[15]),
	.ins_out_4_vld(ins_4_vld[15])	
);


assign ins_out_1_vld = |ins_1_vld[15:0];
assign ins_out_2_vld = |ins_2_vld[15:0];
assign ins_out_3_vld = |ins_3_vld[15:0];
assign ins_out_4_vld = |ins_4_vld[15:0];


endmodule
