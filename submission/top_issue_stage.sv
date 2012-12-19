//Programmer:	Tong Zhang
//Date:		12/11/2012
//Purpose:	Top module for stage 1, connecting pre_calculation_and_queue, all_checker and ins_swap
//

module top_issue_stage(top_issue_stage_interface.top_issue_stage_dut d);

   logic	[3:0]	ins_1_des;
   logic [3:0] 		ins_1_s1;
   logic [3:0] 		ins_1_s2;
   logic [3:0] 		ins_1_op;
   logic [4:0] 		ins_1_ime;

   logic [3:0] 		ins_2_des;
   logic [3:0] 		ins_2_s1;
   logic [3:0] 		ins_2_s2;
   logic [3:0] 		ins_2_op;
   logic [4:0] 		ins_2_ime;




   logic 		ins_in_1;
   logic 		ins_in_2;	
   logic 		ins_in_3;	
   logic 		ins_in_4;

   logic 		in_1_vld;
   logic [3:0] 		in_1_des;
   logic [3:0] 		in_1_s1;
   logic [3:0] 		in_1_s2;
   logic [3:0] 		in_1_op;
   logic [2:0] 		in_1_branch;
   logic [4:0] 		in_1_ime;

   logic 		in_2_vld;
   logic [3:0] 		in_2_des;
   logic [3:0] 		in_2_s1;
   logic [3:0] 		in_2_s2;
   logic [3:0] 		in_2_op;
   logic [2:0] 		in_2_branch;
   logic [4:0] 		in_2_ime;

   logic 		in_3_vld;
   logic [3:0] 		in_3_des;
   logic [3:0] 		in_3_s1;
   logic [3:0] 		in_3_s2;
   logic [3:0] 		in_3_op;
   logic [2:0] 		in_3_branch;
   logic [4:0] 		in_3_ime;

   logic 		in_4_vld;
   logic [3:0] 		in_4_des;
   logic [3:0] 		in_4_s1;
   logic [3:0] 		in_4_s2;
   logic [3:0] 		in_4_op;
   logic [2:0] 		in_4_branch;
   logic [4:0] 		in_4_ime;


   //internal signals: outputs of all_checker and inputs of ins_swap
   logic 		ins1_swap;
   logic 		ins2_swap;
   logic 		ins3_swap;
   logic 		ins4_swap;

   logic 		entry_full;
   logic 		entry_empty;
   //	logic	branch_full;

   decode_interface decode_IFC(clk);
   decode decode1(decode_IFC.decode_dut);
   
   
   pre_calculation_and_queue_interface pre_calculation_and_queue_IFC(clk);   
   pre_calculation_and_queue	pre_calculation_and_queue1(pre_calculation_and_queue_IFC.pre_calculation_and_queue_dut
							   );

   all_checker_interface all_checker_IFC(clk);
   all_checker all_checker1(all_checker_IFC.all_checker_dut);
   
   ins_swap_interface ins_swap_IFC(clk);
   ins_swap ins_swap1(ins_swap_IFC.ins_swap_dut);
   
endmodule
