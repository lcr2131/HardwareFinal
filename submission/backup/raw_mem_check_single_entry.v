///////////////////////////////////////////////////////////////////////////////////////////////////
//	Programmer:	Tong Zhang								//
//	Modification Date:	12/09/2012							//
//	Module function:	single entry module, for check raw between new issue 		//
//				instruction and all current operaion ones			//			
//												//
//////////////////////////////////////////////////////////////////////////////////////////////////


module raw_mem_check_single_entry #(parameter entry_bit = 4, entry_num_bits = 4, entry_num = (1 << entry_num_bits)
						entry)
(
	input	rst,
	input	clk,

	input	ins_search_1_vld,
//	input	ins_search_2_vld,
	input	ins_search_3_vld,
	input	ins_search_4_vld,
	input 	[entry_num_bits - 1 : 0]	ins_search_1_num,
	input 	[entry_num_bits - 1 : 0]	ins_search_2_num,
	input 	[entry_num_bits - 1 : 0]	ins_search_3_num,
	input 	[entry_num_bits - 1 : 0]	ins_search_4_num,

	input	ins_add_1_vld,
//	input	ins_add_2_vld,
//	input	ins_add_3_vld,
//	input	ins_add_4_vld,
	input 	[entry_num_bits - 1 : 0]	ins_add_1_num,
//	input 	[entry_num_bits - 1 : 0]	ins_add_2_num,
//	input 	[entry_num_bits - 1 : 0]	ins_add_3_num,
//	input 	[entry_num_bits - 1 : 0]	ins_add_4_num,
	
	input	ins_minus_1_vld,
//	input	ins_minus_2_vld,
//	input	ins_minus_3_vld,
//	input	ins_minus_4_vld,
	input 	[entry_num_bits - 1 : 0]	ins_minus_1_num,
//	input 	[entry_num_bits - 1 : 0]	ins_minus_2_num,
//	input 	[entry_num_bits - 1 : 0]	ins_minus_3_num,
//	input 	[entry_num_bits - 1 : 0]	ins_minus_4_num,

	output	ins_1_out,
	output	ins_2_out,
	output	ins_3_out,
	output	ins_4_out
);




	reg [entry_bit - 1 : 0]	entry_data;


always_ff @ (posedge clk or posedge rst)
begin
	if (
	
end












endmodule
