////////////////////////////////////////////////////////////////////////////////////////////
////	Module Name: branch_ctrl							////
////	Programmer: Shuying Fan								////
////	Date: 12/13									////
////	Function: branch control unit which consists of three modules: compare_equal,   ////
////			branch_priority, branch_mux					////
////////////////////////////////////////////////////////////////////////////////////////////


module branch_ctrl #(parameter data_width = 'd32, branch_addr = 'd5)
(
	input	[3:0]			ins1_op,
	input	[data_width-1:0]	ins1_data1,
	input	[data_width-1:0]	ins1_data2,
	input	[2:0]			ins1_bid,
	input	[branch_addr-1:0]	ins1_addr,

	input	[3:0]			ins2_op,
	input	[data_width-1:0]	ins2_data1,
	input	[data_width-1:0]	ins2_data2,
	input	[2:0]			ins2_bid,
	input	[branch_addr-1:0]	ins2_addr,


	input	[3:0]			ins3_op,
	input	[data_width-1:0]	ins3_data1,
	input	[data_width-1:0]	ins3_data2,
	input	[2:0]			ins3_bid,
	input	[branch_addr-1:0]	ins3_addr,


	input	[3:0]			ins4_op,
	input	[data_width-1:0]	ins4_data1,
	input	[data_width-1:0]	ins4_data2,
	input	[2:0]			ins4_bid,
	input	[branch_addr-1:0]	ins4_addr,


	output	logic				flush,
	output	logic	[2:0]			bid,
	output	logic	[branch_addr-1:0]	addr

);

	logic 		bne1;
	logic 		bne2;
	logic		bne3;
	logic		bne4;

	logic [1:0]	pick_branch;



compare_equal	#(32)	cmp
(
	.ins1_op,
	.ins1_data1,
	.ins1_data2,

	.ins2_op,
	.ins2_data1,
	.ins2_data2,

	.ins3_op,
	.ins3_data1,
	.ins3_data2,

	.ins4_op,
	.ins4_data1,
	.ins4_data2,

	.bne1,
	.bne2,
	.bne3,
	.bne4


);


branch_priority priority1
(


	.bne1,
	.bne2,
	.bne3,
	.bne4,

	.pick_branch,
	.flush


);


branch_mux #(5)	b_mux
(
	.ins1_bid,
	.ins2_bid,
	.ins3_bid,
	.ins4_bid,

	.ins1_addr,
	.ins2_addr,
	.ins3_addr,
	.ins4_addr,

	.pick_branch,

	.bid,
	.addr
);


endmodule

